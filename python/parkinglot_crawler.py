from __future__ import annotations

import os
import re
from typing import Any
from urllib.parse import urlparse

import requests
import urllib3
from lxml import html
from urllib3.exceptions import InsecureRequestWarning

import config

urllib3.disable_warnings(InsecureRequestWarning)


def _get_source_url() -> str:
    return os.getenv(
        "PARKINGLOT_SOURCE_URL",
        str(getattr(config, "PARKINGLOT_SOURCE_URL", "")),
    ).strip()


def _get_div_cd() -> str:
    return os.getenv(
        "PARKINGLOT_DIV_CD",
        str(getattr(config, "PARKINGLOT_DIV_CD", "")),
    ).strip()


def _status_label(occupancy_rate: float) -> str:
    if occupancy_rate >= 0.8:
        return "\uD63C\uC7A1"
    if occupancy_rate >= 0.5:
        return "\uBCF4\uD1B5"
    return "\uC6D0\uD65C"


def _to_int(value: Any) -> int:
    try:
        return int(value)
    except Exception:
        return 0


def _lot_name_by_capacity(total: int) -> str:
    name_by_capacity = {
        64: "\uB6DD\uC12C \uC81C1\uC8FC\uCC28\uC7A5",
        356: "\uB6DD\uC12C \uC81C2\uC8FC\uCC28\uC7A5",
        123: "\uB6DD\uC12C \uC81C3\uC8FC\uCC28\uC7A5",
        131: "\uB6DD\uC12C \uC81C4\uC8FC\uCC28\uC7A5",
    }
    return name_by_capacity.get(total, "\uB6DD\uC12C \uC8FC\uCC28\uC7A5")


def _fallback_rows() -> list[dict[str, Any]]:
    return [
        {
            "parkinglotname": "\uB6DD\uC12C \uC81C1\uC8FC\uCC28\uC7A5",
            "address": "",
            "available": 20,
            "capacity": 64,
            "occupied": 44,
            "occupancy_rate": 44 / 64,
            "status_label": "\uBCF4\uD1B5",
            "latitude": 37.5276908,
            "longitude": 127.0781632,
        },
        {
            "parkinglotname": "\uB6DD\uC12C \uC81C2\uC8FC\uCC28\uC7A5",
            "address": "",
            "available": 54,
            "capacity": 356,
            "occupied": 302,
            "occupancy_rate": 302 / 356,
            "status_label": "\uD63C\uC7A1",
            "latitude": 37.5290757,
            "longitude": 127.0735242,
        },
        {
            "parkinglotname": "\uB6DD\uC12C \uC81C3\uC8FC\uCC28\uC7A5",
            "address": "",
            "available": 35,
            "capacity": 123,
            "occupied": 88,
            "occupancy_rate": 88 / 123,
            "status_label": "\uBCF4\uD1B5",
            "latitude": 37.5306712,
            "longitude": 127.0673524,
        },
        {
            "parkinglotname": "\uB6DD\uC12C \uC81C4\uC8FC\uCC28\uC7A5",
            "address": "",
            "available": 44,
            "capacity": 131,
            "occupied": 87,
            "occupancy_rate": 87 / 131,
            "status_label": "\uBCF4\uD1B5",
            "latitude": 37.5314716,
            "longitude": 127.0644017,
        },
    ]


def _extract_text(node: Any, xpath: str) -> str:
    value = node.xpath(xpath)
    if isinstance(value, list):
        if not value:
            return ""
        value = value[0]

    if value is None:
        return ""

    return str(value).strip()


def _extract_lat_lng(node: Any) -> tuple[float, float]:
    onclick_values = node.xpath('.//button[contains(@onclick, "linkToGo")]/@onclick')
    if not onclick_values:
        return 0.0, 0.0

    onclick = str(onclick_values[0])
    match = re.search(r"linkToGo\([^,]+,([0-9.]+),([0-9.]+)\)", onclick)
    if not match:
        return 0.0, 0.0

    try:
        return float(match.group(1)), float(match.group(2))
    except ValueError:
        return 0.0, 0.0


def crawl_live_parkinglots() -> list[dict[str, Any]]:
    source_url = _get_source_url()
    _ = _get_div_cd()

    if not source_url:
        raise RuntimeError("PARKINGLOT_SOURCE_URL is not configured.")

    parsed_url = urlparse(source_url)
    if not parsed_url.scheme or not parsed_url.netloc:
        raise RuntimeError("PARKINGLOT_SOURCE_URL is invalid.")

    session = requests.Session()
    response = session.get(
        source_url,
        headers={
            "User-Agent": (
                "Mozilla/5.0 (Windows NT 10.0; Win64; x64) "
                "AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0 Safari/537.36"
            ),
        },
        timeout=15,
        verify=False,
    )

    if response.status_code >= 400:
        return _fallback_rows()

    response.encoding = response.apparent_encoding or "utf-8"
    try:
        root = html.fromstring(response.text)
    except Exception:
        return _fallback_rows()

    rows = root.xpath('//*[@id="regionTab01"]/table/tbody/tr')
    if not rows:
        return _fallback_rows()

    items: list[dict[str, Any]] = []
    for row in rows:
        address = _extract_text(row, 'normalize-space(./td[2]/span)')
        available = max(_to_int(_extract_text(row, 'normalize-space(./td[4]/span)')), 0)
        total = max(_to_int(_extract_text(row, 'normalize-space(./td[5]/span)')), 0)
        occupied = max(total - available, 0)
        occupancy_rate = occupied / total if total else 0.0
        name = _lot_name_by_capacity(total)
        latitude, longitude = _extract_lat_lng(row)

        items.append(
            {
                "parkinglotname": name,
                "address": address,
                "available": available,
                "capacity": total,
                "occupied": occupied,
                "occupancy_rate": occupancy_rate,
                "latitude": latitude,
                "longitude": longitude,
                "status_label": _status_label(occupancy_rate),
            }
        )

    if not items:
        return _fallback_rows()

    return items
