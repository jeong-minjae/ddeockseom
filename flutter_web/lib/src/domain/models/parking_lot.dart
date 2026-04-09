import 'package:flutter/material.dart';

class ParkingLot {
  const ParkingLot({
    required this.name,
    required this.occupied,
    required this.capacity,
    required this.statusLabel,
    required this.statusColor,
    required this.progressColor,
  });

  final String name;
  final int occupied;
  final int capacity;
  final String statusLabel;
  final Color statusColor;
  final Color progressColor;

  double get occupancyRate => capacity == 0 ? 0 : occupied / capacity;
  int get remaining => capacity - occupied;
}
