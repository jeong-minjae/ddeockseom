//
//  ConvenienceMapView.swift
//  hangangpark
//

import MapKit
import SwiftUI

struct ConvenienceMapView: View {
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 37.5298, longitude: 127.0718),
        span: MKCoordinateSpan(latitudeDelta: 0.018, longitudeDelta: 0.018)
    )
    @State private var places: [ConveniencePlace] = ConveniencePlace.parkingLots
    @State private var message = "편의점 위치를 불러오는 중입니다."
    @State private var isLoading = false

    var body: some View {
        ZStack {
            Color(red: 0.95, green: 0.97, blue: 0.99)
                .ignoresSafeArea()

            VStack(spacing: 16) {
                header
                mapView
                placeList
            }
            .padding(18)
        }
        .navigationTitle("편의점 지도")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await loadConvenienceStores()
        }
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("주변 편의점 찾아보기")
                .font(.title.weight(.bold))
                .foregroundStyle(.white)

            Text("뚝섬 한강공원 주차장 주변 편의점 위치를 지도에 표시합니다.")
                .font(.subheadline)
                .foregroundStyle(.white.opacity(0.86))
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(red: 0.11, green: 0.34, blue: 0.72))
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }

    private var mapView: some View {
        Map(coordinateRegion: $region, annotationItems: places) { place in
            MapAnnotation(coordinate: place.coordinate) {
                VStack(spacing: 4) {
                    Image(systemName: place.kind == .parkingLot ? "parkingsign.circle.fill" : "cart.fill")
                        .font(.system(size: 17, weight: .bold))
                        .foregroundStyle(.white)
                        .frame(width: 34, height: 34)
                        .background(place.kind.color)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                        .shadow(color: .black.opacity(0.18), radius: 6, x: 0, y: 3)

                    Text(place.shortName)
                        .font(.caption2.weight(.bold))
                        .foregroundStyle(Color(red: 0.12, green: 0.16, blue: 0.22))
                        .padding(.horizontal, 6)
                        .padding(.vertical, 3)
                        .background(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 6))
                }
            }
        }
        .frame(height: 360)
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .overlay {
            if isLoading {
                ProgressView("검색 중...")
                    .padding(14)
                    .background(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
            }
        }
    }

    private var placeList: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("검색 결과")
                    .font(.headline)
                    .foregroundStyle(Color(red: 0.12, green: 0.16, blue: 0.22))

                Spacer()

                Text("편의점 \(convenienceStores.count)곳")
                    .font(.caption.weight(.bold))
                    .foregroundStyle(Color(red: 0.06, green: 0.52, blue: 0.48))
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .background(Color(red: 0.89, green: 0.97, blue: 0.96))
                    .clipShape(RoundedRectangle(cornerRadius: 8))
            }

            if convenienceStores.isEmpty {
                Text(message)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            } else {
                ForEach(convenienceStores) { place in
                    HStack(spacing: 12) {
                        Image(systemName: "cart.fill")
                            .font(.subheadline.weight(.bold))
                            .foregroundStyle(.white)
                            .frame(width: 34, height: 34)
                            .background(ConveniencePlace.Kind.store.color)
                            .clipShape(RoundedRectangle(cornerRadius: 8))

                        VStack(alignment: .leading, spacing: 4) {
                            Text(place.name)
                                .font(.subheadline.weight(.semibold))
                                .foregroundStyle(Color(red: 0.12, green: 0.16, blue: 0.22))
                            Text(place.address)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                                .lineLimit(1)
                        }

                        Spacer()
                    }
                    .padding(12)
                    .background(Color(red: 0.97, green: 0.98, blue: 1.0))
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                }
            }
        }
        .padding(18)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .shadow(color: .black.opacity(0.06), radius: 16, x: 0, y: 8)
    }

    private var convenienceStores: [ConveniencePlace] {
        places.filter { $0.kind == .store }
    }

    private func loadConvenienceStores() async {
        guard !isLoading else { return }

        isLoading = true
        message = "편의점 위치를 불러오는 중입니다."

        do {
            let stores = try await searchConvenienceStores()
            places = ConveniencePlace.parkingLots + stores
            message = stores.isEmpty ? "주변 편의점을 찾지 못했습니다." : ""
        } catch {
            places = ConveniencePlace.parkingLots + ConveniencePlace.fallbackStores
            message = "검색 연결 실패로 기본 편의점 위치를 표시합니다."
        }

        isLoading = false
    }

    private func searchConvenienceStores() async throws -> [ConveniencePlace] {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = "편의점"
        request.region = region
        request.resultTypes = .pointOfInterest

        return try await withCheckedThrowingContinuation { continuation in
            MKLocalSearch(request: request).start { response, error in
                if let error {
                    continuation.resume(throwing: error)
                    return
                }

                let stores = response?.mapItems.prefix(10).map { item in
                    ConveniencePlace(
                        name: item.name ?? "편의점",
                        address: item.placemark.title ?? "주소 정보 없음",
                        coordinate: item.placemark.coordinate,
                        kind: .store
                    )
                } ?? []

                continuation.resume(returning: stores)
            }
        }
    }
}

private struct ConveniencePlace: Identifiable {
    enum Kind {
        case parkingLot
        case store

        var color: Color {
            switch self {
            case .parkingLot:
                return Color(red: 0.16, green: 0.38, blue: 0.83)
            case .store:
                return Color(red: 0.06, green: 0.52, blue: 0.48)
            }
        }
    }

    let id = UUID()
    let name: String
    let address: String
    let coordinate: CLLocationCoordinate2D
    let kind: Kind

    var shortName: String {
        if name.contains("뚝섬") {
            return name.replacingOccurrences(of: "주차장", with: "")
        }
        return "편의점"
    }

    static let parkingLots: [ConveniencePlace] = [
        ConveniencePlace(
            name: "뚝섬1주차장",
            address: "서울 광진구 자양동 409",
            coordinate: CLLocationCoordinate2D(latitude: 37.5276908, longitude: 127.0781632),
            kind: .parkingLot
        ),
        ConveniencePlace(
            name: "뚝섬2주차장",
            address: "서울 광진구 자양동 427-1",
            coordinate: CLLocationCoordinate2D(latitude: 37.5290757, longitude: 127.0735242),
            kind: .parkingLot
        ),
        ConveniencePlace(
            name: "뚝섬3주차장",
            address: "서울 광진구 자양동 97-5",
            coordinate: CLLocationCoordinate2D(latitude: 37.5306712, longitude: 127.0673524),
            kind: .parkingLot
        ),
        ConveniencePlace(
            name: "뚝섬4주차장",
            address: "서울 광진구 자양동 97-5",
            coordinate: CLLocationCoordinate2D(latitude: 37.5314716, longitude: 127.0644017),
            kind: .parkingLot
        )
    ]

    static let fallbackStores: [ConveniencePlace] = [
        ConveniencePlace(
            name: "뚝섬유원지역 주변 편의점",
            address: "뚝섬유원지역 인근",
            coordinate: CLLocationCoordinate2D(latitude: 37.5314, longitude: 127.0665),
            kind: .store
        ),
        ConveniencePlace(
            name: "자양동 주변 편의점",
            address: "자양동 주차장 인근",
            coordinate: CLLocationCoordinate2D(latitude: 37.5293, longitude: 127.0742),
            kind: .store
        ),
        ConveniencePlace(
            name: "한강공원 입구 주변 편의점",
            address: "뚝섬 한강공원 입구 인근",
            coordinate: CLLocationCoordinate2D(latitude: 37.5279, longitude: 127.0775),
            kind: .store
        )
    ]
}

#Preview {
    NavigationStack {
        ConvenienceMapView()
    }
}
