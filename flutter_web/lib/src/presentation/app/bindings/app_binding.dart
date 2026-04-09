import 'package:get/get.dart';

import '../../../data/repositories/mock_dashboard_repository.dart';
import '../../../domain/repositories/dashboard_repository.dart';
import '../../dashboard/view_models/dashboard_view_model.dart';
import '../controllers/app_theme_controller.dart';

class AppBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(AppThemeController(), permanent: true);
    Get.lazyPut<DashboardRepository>(
      MockDashboardRepository.new,
      fenix: true,
    );
    Get.lazyPut<DashboardViewModel>(
      () => DashboardViewModel(Get.find<DashboardRepository>()),
      fenix: true,
    );
  }
}
