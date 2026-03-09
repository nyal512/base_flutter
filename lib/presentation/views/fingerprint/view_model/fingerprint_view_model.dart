import '../../../../core/viewmodel/base_view_model.dart';

class FingerprintViewModel extends BaseViewModel {
  String _machineNumber = '';

  String get machineNumber => _machineNumber;

  void setMachineNumber(String value) {
    _machineNumber = value;
    notifyListeners();
  }

  @override
  void init() {
    super.init();
    // Initialize if needed
  }

  void onSave() {
    setLoading(true);
    // Simulate save logic
    Future.delayed(const Duration(milliseconds: 500), () {
      setLoading(false);
    });
  }
}
