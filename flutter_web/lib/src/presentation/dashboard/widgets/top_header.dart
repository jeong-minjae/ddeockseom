import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/theme/dashboard_palette.dart';
import '../../app/controllers/app_theme_controller.dart';

class TopHeader extends GetView<AppThemeController> {
  const TopHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 22, 24, 10),
      child: Row(
        children: [
          Expanded(child: _buildSearchField(context)),
          const SizedBox(width: 16),
          Obx(() => _buildThemeToggleArea(context)),
          const SizedBox(width: 12),
          _HeaderActionButton(
            icon: Icons.account_circle_outlined,
            onTap: () {},
            tooltip: '\uC5B4\uCE74\uC6B4\uD2B8 \uC815\uBCF4',
          ),
        ],
      ),
    );
  }

  Widget _buildThemeToggleArea(BuildContext context) {
    final palette = context.palette;
    final isDarkMode = controller.isDarkMode;

    return Row(
      children: [
        _HeaderActionButton(
          icon: isDarkMode
              ? Icons.light_mode_rounded
              : Icons.notifications_none_rounded,
          onTap: controller.toggleThemeMode,
          isActive: isDarkMode,
          tooltip: '\uD14C\uB9C8 \uC804\uD658',
        ),
        const SizedBox(width: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: palette.iconBackground,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isDarkMode ? palette.accentCyan : palette.iconBorder,
            ),
            boxShadow: [
              BoxShadow(
                color: isDarkMode ? palette.glowColor : Colors.transparent,
                blurRadius: 18,
                spreadRadius: 1,
              ),
            ],
          ),
          child: Text(
            isDarkMode ? 'NIGHT MODE' : 'DAY MODE',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: isDarkMode ? palette.accentCyan : palette.accentBlue,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.6,
            ),
          ),
        ),
      ],
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

class _HeaderActionButton extends StatelessWidget {
  const _HeaderActionButton({
    required this.icon,
    required this.onTap,
    required this.tooltip,
    this.isActive = false,
  });

  final IconData icon;
  final VoidCallback onTap;
  final String tooltip;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return Tooltip(
      message: tooltip,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Ink(
            decoration: BoxDecoration(
              color: isActive
                  ? palette.selectedItemBackground
                  : palette.iconBackground,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isActive ? palette.accentCyan : palette.iconBorder,
              ),
              boxShadow: [
                BoxShadow(
                  color: isActive ? palette.glowColor : Colors.transparent,
                  blurRadius: 18,
                  spreadRadius: 1,
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Icon(
                icon,
                color: isActive ? palette.accentCyan : palette.accentBlue,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
