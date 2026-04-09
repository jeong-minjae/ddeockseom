import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'core/theme/app_theme.dart';
import 'presentation/app/bindings/app_binding.dart';
import 'presentation/dashboard/dashboard_page.dart';

void bootstrap() {
  runApp(const ParkFlowApp());
}

class ParkFlowApp extends StatelessWidget {
  const ParkFlowApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ParkFlow Admin',
      initialBinding: AppBinding(),
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: ThemeMode.light,
      home: const DashboardPage(),
    );
  }
}
