import '../../../../core/viewmodel/base_view_model.dart';

class PaymentViewModel extends BaseViewModel {
  // Banknotes state (true = 可, false = 否)
  final Map<int, bool> _banknotes = {
    10000: true,
    5000: true,
    2000: true,
    1000: true,
  };

  // Coins state (true = 可, false = 否)
  final Map<int, bool> _coins = {
    500: true,
    100: true,
    50: true,
    10: true,
  };

  // Getters
  Map<int, bool> get banknotes => Map.unmodifiable(_banknotes);
  Map<int, bool> get coins => Map.unmodifiable(_coins);

  // Setters
  void setBanknoteStatus(int denomination, bool value) {
    if (_banknotes.containsKey(denomination)) {
      _banknotes[denomination] = value;
      notifyListeners();
    }
  }

  void setCoinStatus(int denomination, bool value) {
    if (_coins.containsKey(denomination)) {
      _coins[denomination] = value;
      notifyListeners();
    }
  }

  void onSave() {
    // Implement save logic for payment settings
    setLoading(true);
    // Simulate API call or local storage save
    Future.delayed(const Duration(milliseconds: 500), () {
      setLoading(false);
      // Success logic
    });
  }

}
