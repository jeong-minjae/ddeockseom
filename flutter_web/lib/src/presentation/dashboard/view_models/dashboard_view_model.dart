import 'package:get/get.dart';

import '../../../domain/models/dashboard_snapshot.dart';
import '../../../domain/repositories/dashboard_repository.dart';

class DashboardViewModel extends GetxController {
  DashboardViewModel(this._dashboardRepository);

  final DashboardRepository _dashboardRepository;

  final RxBool isLoading = true.obs;
  final Rxn<DashboardSnapshot> dashboardSnapshot = Rxn<DashboardSnapshot>();
  final RxInt selectedParkingLotIndex = 0.obs;

  DashboardSnapshot? get snapshot => dashboardSnapshot.value;

  int get selectedIndex {
    final lots = snapshot?.parkingLots ?? const [];
    if (lots.isEmpty) {
      return 0;
    }

    final current = selectedParkingLotIndex.value;
    if (current < 0 || current >= lots.length) {
      return 0;
    }

    return current;
  }

  void selectParkingLot(int index) {
    final lots = snapshot?.parkingLots ?? const [];
    if (index < 0 || index >= lots.length) {
      return;
    }

    selectedParkingLotIndex.value = index;
  }

  @override
  void onInit() {
    super.onInit();
    loadDashboard();
  }

  Future<void> loadDashboard() async {
    isLoading.value = true;
    dashboardSnapshot.value = await _dashboardRepository.fetchDashboardSnapshot();
    selectedParkingLotIndex.value = 0;
    isLoading.value = false;
  }
}
