import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../view_models/dashboard_view_model.dart';
import 'parking_location_map_card.dart';
import 'widgets.dart';

class DashboardContent extends StatelessWidget {
  const DashboardContent({
    super.key,
    required this.controller,
  });

  final DashboardViewModel controller;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final snapshot = controller.snapshot;
      if (snapshot == null) {
        return const SizedBox.shrink();
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTopSection(),
        ],
      );
    });
  }

  Widget _buildTopSection() {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Obx(() {
          final isWideScreen = constraints.maxWidth >= 1120;
          final parkingLots = controller.filteredParkingLots;
          final selectedIndex = controller.selectedIndex;
          final selectedLot =
              parkingLots.isEmpty ? null : parkingLots[selectedIndex];

          final parkingCard = ParkingOverviewCard(
            parkingLots: parkingLots,
            selectedIndex: selectedIndex,
            onParkingLotSelected: controller.selectParkingLot,
          );

          final mapCard = ParkingLocationMapCard(
            parkingLots: parkingLots,
            selectedIndex: selectedIndex,
            onParkingLotSelected: controller.selectParkingLot,
            selectedLot: selectedLot,
          );

          if (isWideScreen) {
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 3,
                  child: parkingCard,
                ),
                const SizedBox(width: 20),
                Expanded(
                  flex: 2,
                  child: mapCard,
                ),
              ],
            );
          }

          return Column(
            children: [
              parkingCard,
              const SizedBox(height: 18),
              mapCard,
            ],
          );
        });
      },
    );
  }
}
