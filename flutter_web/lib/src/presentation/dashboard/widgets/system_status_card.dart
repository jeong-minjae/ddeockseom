import 'package:flutter/material.dart';

import '../../../core/theme/dashboard_palette.dart';
import '../../../domain/models/system_status.dart';

class SystemStatusCard extends StatelessWidget {
  const SystemStatusCard({
    super.key,
    required this.statuses,
  });

  final List<SystemStatus> statuses;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '시스템 상태',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 4),
            Text(
              '센서와 장비의 연결 상태를 확인합니다.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: palette.mutedText,
                  ),
            ),
            const SizedBox(height: 20),
            ...statuses.map((status) => _SystemStatusTile(status: status)),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () {},
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Text('시스템 점검 실행'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SystemStatusTile extends StatelessWidget {
  const _SystemStatusTile({required this.status});

  final SystemStatus status;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: palette.panelBackground,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: palette.cardBorder),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: palette.selectedItemBackground,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              status.icon,
              color: palette.accentCyan,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  status.name,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                ),
                Text(
                  status.description,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: palette.mutedText,
                      ),
                ),
              ],
            ),
          ),
          Text(
            status.isHealthy ? '정상' : '점검 필요',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: status.isHealthy ? palette.accentGreen : palette.accentRed,
                  fontWeight: FontWeight.w800,
                ),
          ),
        ],
      ),
    );
  }
}
