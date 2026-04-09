import 'package:flutter/material.dart';

import '../../../domain/models/dashboard_snapshot.dart';
import 'widgets.dart';

class DashboardContent extends StatelessWidget {
  const DashboardContent({
    super.key,
    required this.snapshot,
  });

  final DashboardSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTopSection(),
        const SizedBox(height: 20),
        _buildBottomSection(),
      ],
    );
  }

  Widget _buildTopSection() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWideScreen = constraints.maxWidth >= 1120;

        if (isWideScreen) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 3,
                child: ParkingOverviewCard(
                  parkingLots: snapshot.parkingLots,
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                flex: 2,
                child: UsageChartCard(
                  weekdayStats: snapshot.weekdayStats,
                ),
              ),
            ],
          );
        }

        return Column(
          children: [
            ParkingOverviewCard(parkingLots: snapshot.parkingLots),
            const SizedBox(height: 18),
            UsageChartCard(weekdayStats: snapshot.weekdayStats),
          ],
        );
      },
    );
  }

  Widget _buildBottomSection() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWideScreen = constraints.maxWidth >= 1120;

        if (isWideScreen) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 3,
                child: ActivityLogCard(
                  logs: snapshot.activityLogs,
                  lastUpdatedLabel: snapshot.lastUpdatedLabel,
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: SystemStatusCard(
                  statuses: snapshot.systemStatuses,
                ),
              ),
            ],
          );
        }

        return Column(
          children: [
            ActivityLogCard(
              logs: snapshot.activityLogs,
              lastUpdatedLabel: snapshot.lastUpdatedLabel,
            ),
            const SizedBox(height: 18),
            SystemStatusCard(statuses: snapshot.systemStatuses),
          ],
        );
      },
    );
  }
}
