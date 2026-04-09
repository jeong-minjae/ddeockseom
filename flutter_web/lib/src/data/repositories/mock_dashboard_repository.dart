import 'package:flutter/material.dart';

import '../../domain/models/activity_log.dart';
import '../../domain/models/dashboard_snapshot.dart';
import '../../domain/models/parking_lot.dart';
import '../../domain/models/system_status.dart';
import '../../domain/models/weekday_stat.dart';
import '../../domain/repositories/dashboard_repository.dart';

class MockDashboardRepository implements DashboardRepository {
  @override
  Future<DashboardSnapshot> fetchDashboardSnapshot() async {
    await Future<void>.delayed(const Duration(milliseconds: 250));

    return DashboardSnapshot(
      lastUpdatedLabel: '2026-04-09 17:40 기준',
      parkingLots: const [
        ParkingLot(
          name: '뚝섬 공영주차장 1',
          occupied: 124,
          capacity: 150,
          statusLabel: '혼잡',
          statusColor: Color(0xFFFFE3E0),
          progressColor: Color(0xFFFF5A52),
        ),
        ParkingLot(
          name: '뚝섬 공영주차장 2',
          occupied: 45,
          capacity: 120,
          statusLabel: '여유',
          statusColor: Color(0xFFE4F8ED),
          progressColor: Color(0xFF2F6BFF),
        ),
        ParkingLot(
          name: '뚝섬 공영주차장 3',
          occupied: 88,
          capacity: 100,
          statusLabel: '보통',
          statusColor: Color(0xFFFFF3D8),
          progressColor: Color(0xFF3559D9),
        ),
        ParkingLot(
          name: '뚝섬 공영주차장 4',
          occupied: 12,
          capacity: 80,
          statusLabel: '여유',
          statusColor: Color(0xFFE4F8ED),
          progressColor: Color(0xFF2F6BFF),
        ),
      ],
      activityLogs: const [
        ActivityLog(
          vehicleNumber: '12가 3456',
          type: '입차',
          location: '제1주차장 A구역',
          time: '14:22:15',
          status: '완료',
        ),
        ActivityLog(
          vehicleNumber: '98하 7654',
          type: '출차',
          location: '제3주차장 B구역',
          time: '14:20:02',
          status: '완료',
        ),
        ActivityLog(
          vehicleNumber: '55부 1212',
          type: '입차',
          location: '제4주차장 D구역',
          time: '14:18:45',
          status: '완료',
        ),
        ActivityLog(
          vehicleNumber: '77소 9021',
          type: '입차',
          location: '제2주차장 입구',
          time: '14:15:09',
          status: '대기',
        ),
      ],
      systemStatuses: const [
        SystemStatus(
          name: 'IoT 센서',
          description: '전체 64개 센서 연결',
          icon: Icons.sensors_rounded,
          isHealthy: true,
        ),
        SystemStatus(
          name: 'CCTV 관제',
          description: '8개 스트림 수신 중',
          icon: Icons.videocam_rounded,
          isHealthy: true,
        ),
        SystemStatus(
          name: '네트워크',
          description: '지연 12ms / 안정',
          icon: Icons.wifi_rounded,
          isHealthy: true,
        ),
      ],
      weekdayStats: const [
        WeekdayStat(label: '월', value: 42),
        WeekdayStat(label: '화', value: 56),
        WeekdayStat(label: '수', value: 61),
        WeekdayStat(label: '목', value: 48),
        WeekdayStat(label: '금', value: 71),
        WeekdayStat(label: '토', value: 92),
        WeekdayStat(label: '일', value: 84),
      ],
    );
  }
}
