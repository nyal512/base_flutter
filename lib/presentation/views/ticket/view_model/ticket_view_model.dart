import '../../../../core/viewmodel/base_view_model.dart';

class TicketViewModel extends BaseViewModel {
  String _serialNumber = '';
  int _clearCondition = 0; // 0: 無し, 1: 日計クリア, 2: 累計クリア
  int _menuClearCondition = 1; // 0: 無し, 1: 日計クリア, 2: 累計クリア

  String get serialNumber => _serialNumber;
  int get clearCondition => _clearCondition;
  int get menuClearCondition => _menuClearCondition;

  void setSerialNumber(String value) {
    _serialNumber = value;
    notifyListeners();
  }

  void setClearCondition(int value) {
    _clearCondition = value;
    notifyListeners();
  }

  void setMenuClearCondition(int value) {
    _menuClearCondition = value;
    notifyListeners();
  }

  @override
  void init() {
    super.init();
  }

  void onSave() {
    setLoading(true);
    Future.delayed(const Duration(milliseconds: 500), () {
      setLoading(false);
    });
  }
}
