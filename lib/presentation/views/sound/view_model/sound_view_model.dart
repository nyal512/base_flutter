import '../../../../core/viewmodel/base_view_model.dart';

class SoundViewModel extends BaseViewModel {
  // Buzzer State
  bool _isClosingBuzzer = true;
  bool _isWithdrawalBuzzer = true;
  bool _isIssuanceBuzzer = true;
  bool _isErrorBuzzer = true;

  // Voice State
  bool _isTicketCountVoice = true;
  bool _isChangePayoutVoice = true;
  bool _isCustomerReceiptVoice = true;

  // Getters - Buzzer
  bool get isClosingBuzzer => _isClosingBuzzer;
  bool get isWithdrawalBuzzer => _isWithdrawalBuzzer;
  bool get isIssuanceBuzzer => _isIssuanceBuzzer;
  bool get isErrorBuzzer => _isErrorBuzzer;

  // Getters - Voice
  bool get isTicketCountVoice => _isTicketCountVoice;
  bool get isChangePayoutVoice => _isChangePayoutVoice;
  bool get isCustomerReceiptVoice => _isCustomerReceiptVoice;

  // Setters - Buzzer
  void setClosingBuzzer(bool value) {
    _isClosingBuzzer = value;
    notifyListeners();
  }

  void setWithdrawalBuzzer(bool value) {
    _isWithdrawalBuzzer = value;
    notifyListeners();
  }

  void setIssuanceBuzzer(bool value) {
    _isIssuanceBuzzer = value;
    notifyListeners();
  }

  void setErrorBuzzer(bool value) {
    _isErrorBuzzer = value;
    notifyListeners();
  }

  // Setters - Voice
  void setTicketCountVoice(bool value) {
    _isTicketCountVoice = value;
    notifyListeners();
  }

  void setChangePayoutVoice(bool value) {
    _isChangePayoutVoice = value;
    notifyListeners();
  }

  void setCustomerReceiptVoice(bool value) {
    _isCustomerReceiptVoice = value;
    notifyListeners();
  }

  void onSave() {
    // Implement save logic for sound settings
  }
}
