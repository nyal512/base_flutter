import '../../../../core/viewmodel/base_view_model.dart';

class WalletViewModel extends BaseViewModel {
  // Banknote limits (枚)
  final Map<int, String> _banknoteLimits = {
    10000: '',
    5000: '',
    2000: '',
    1000: '',
  };

  // Coin limits (枚)
  final Map<int, String> _coinLimits = {
    500: '',
    100: '',
    50: '',
    10: '',
  };

  String _totalCoinLimit = '';
  String _maxDepositAmount = '';
  String _invalidEntryAmount = '';
  int _invalidEntryAction = 0; // 0: 取消無効, 1: 取消エラー

  // Getters
  Map<int, String> get banknoteLimits => Map.unmodifiable(_banknoteLimits);
  Map<int, String> get coinLimits => Map.unmodifiable(_coinLimits);
  String get totalCoinLimit => _totalCoinLimit;
  String get maxDepositAmount => _maxDepositAmount;
  String get invalidEntryAmount => _invalidEntryAmount;
  int get invalidEntryAction => _invalidEntryAction;

  // Setters
  void setBanknoteLimit(int denomination, String value) {
    if (_banknoteLimits.containsKey(denomination)) {
      _banknoteLimits[denomination] = value;
      notifyListeners();
    }
  }

  void setCoinLimit(int denomination, String value) {
    if (_coinLimits.containsKey(denomination)) {
      _coinLimits[denomination] = value;
      notifyListeners();
    }
  }

  void setTotalCoinLimit(String value) {
    _totalCoinLimit = value;
    notifyListeners();
  }

  void setMaxDepositAmount(String value) {
    _maxDepositAmount = value;
    notifyListeners();
  }

  void setInvalidEntryAmount(String value) {
    _invalidEntryAmount = value;
    notifyListeners();
  }

  void setInvalidEntryAction(int value) {
    _invalidEntryAction = value;
    notifyListeners();
  }

  void onSave() {
    setLoading(true);
    // Simulate save
    Future.delayed(const Duration(milliseconds: 500), () {
      setLoading(false);
    });
  }
}
