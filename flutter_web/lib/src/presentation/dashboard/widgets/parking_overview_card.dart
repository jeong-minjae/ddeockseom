import 'package:flutter/material.dart';

import '../../../core/theme/dashboard_palette.dart';
import '../../../domain/models/parking_lot.dart';

class ParkingOverviewCard extends StatelessWidget {
  const ParkingOverviewCard({
    super.key,
    required this.parkingLots,
  });

  final List<ParkingLot> parkingLots;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCardHeader(context),
            const SizedBox(height: 20),
            _buildParkingLotGrid(),
          ],
        ),
      ),
    );
  }

  Widget _buildCardHeader(BuildContext context) {
    final palette = context.palette;

    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '실시간 통합 현황',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 4),
              Text(
                '주차장별 점유율과 잔여 공간을 빠르게 확인하세요.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: palette.mutedText,
                    ),
              ),
            ],
          ),
        ),
        TextButton(
          onPressed: () {},
          child: const Text('상세보기'),
        ),
      ],
    );
  }

  Widget _buildParkingLotGrid() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isCompactWidth = constraints.maxWidth < 700;

        return GridView.builder(
          shrinkWrap: true,
          itemCount: parkingLots.length,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: isCompactWidth ? 1 : 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: isCompactWidth ? 2.4 : 1.65,
          ),
          itemBuilder: (context, index) {
            final parkingLot = parkingLots[index];
            return _ParkingLotTile(lot: parkingLot);
          },
        );
      },
    );
  }
}

class _ParkingLotTile extends StatelessWidget {
  const _ParkingLotTile({required this.lot});

  final ParkingLot lot;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final occupancyPercent = '${(lot.occupancyRate * 100).round()}% 점유';

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: palette.panelBackground,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: palette.cardBorder),
        boxShadow: [
          BoxShadow(
            color: palette.glowColor,
            blurRadius: 18,
            spreadRadius: 0.5,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildLotHeader(context),
          const Spacer(),
          Text(
            '${lot.occupied} / ${lot.capacity}',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
          ),
          const SizedBox(height: 4),
          Text(
            '잔여 ${lot.remaining}면',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: palette.mutedText,
                ),
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              minHeight: 8,
              value: lot.occupancyRate,
              backgroundColor: palette.progressTrack,
              valueColor: AlwaysStoppedAnimation<Color>(lot.progressColor),
            ),
          ),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              occupancyPercent,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: palette.secondaryText,
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLotHeader(BuildContext context) {
    final palette = context.palette;

    return Row(
      children: [
        Expanded(
          child: Text(
            lot.name,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: palette.secondaryText,
                  fontWeight: FontWeight.w700,
                ),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: lot.statusColor.withOpacity(0.18),
            borderRadius: BorderRadius.circular(999),
            border: Border.all(
              color: lot.progressColor.withOpacity(0.45),
            ),
          ),
          child: Text(
            lot.statusLabel,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: palette.primaryText,
                  fontWeight: FontWeight.w700,
                ),
          ),
        ),
      ],
    );
  }
}
