import 'package:get/get.dart';

import '../../../domain/models/dashboard_snapshot.dart';
import '../../../domain/repositories/dashboard_repository.dart';

class DashboardViewModel extends GetxController {
  DashboardViewModel(this._dashboardRepository);

  final DashboardRepository _dashboardRepository;

  final RxBool isLoading = true.obs;
  final Rxn<DashboardSnapshot> dashboardSnapshot = Rxn<DashboardSnapshot>();

  @override
  void onInit() {
    super.onInit();
    loadDashboard();
  }

  Future<void> loadDashboard() async {
    isLoading.value = true;
    dashboardSnapshot.value = await _dashboardRepository.fetchDashboardSnapshot();
    isLoading.value = false;
  }
}
