import 'package:flutter/material.dart';

import '../../../core/theme/dashboard_palette.dart';

class TopHeader extends StatelessWidget {
  const TopHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 22, 24, 10),
      child: Row(
        children: [
          Expanded(child: _buildSearchField(context)),
        ],
      ),
    );
  }

  Widget _buildSearchField(BuildContext context) {
    final palette = context.palette;

    return TextField(
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.search_rounded),
        hintText: '\uC8FC\uCC28\uC7A5\uACFC \uC774\uB984\uC744 \uAC80\uC0C9\uD558\uC138\uC694.',
        constraints: const BoxConstraints(maxWidth: 380),
        suffixIcon: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: palette.panelBackground,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(Icons.tune_rounded, size: 20, color: palette.mutedText),
        ),
      ),
    );
  }
}
