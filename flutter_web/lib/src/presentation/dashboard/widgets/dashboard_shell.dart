import 'package:flutter/material.dart';

import '../../../core/theme/dashboard_palette.dart';
import 'sidebar_navigation.dart';
import 'top_header.dart';

class DashboardShell extends StatelessWidget {
  const DashboardShell({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            palette.shellGradientStart,
            palette.shellGradientEnd,
          ],
        ),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isCompactLayout = constraints.maxWidth < 1100;

          return Row(
            children: [
              if (!isCompactLayout) const SidebarNavigation(),
              Expanded(
                child: Column(
                  children: [
                    const TopHeader(),
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
                        child: child,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
