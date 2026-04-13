import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'view_models/dashboard_view_model.dart';
import 'widgets/dashboard_content.dart';
import 'widgets/dashboard_shell.dart';

class DashboardPage extends GetView<DashboardViewModel> {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Obx(() {
          if (controller.isLoading.value || controller.dashboardSnapshot.value == null) {
            return const Center(child: CircularProgressIndicator());
          }

          return DashboardShell(
            childBuilder: (scrollOffset) => DashboardContent(
              controller: controller,
              scrollOffset: scrollOffset,
            ),
          );
        }),
      ),
    );
  }
}
