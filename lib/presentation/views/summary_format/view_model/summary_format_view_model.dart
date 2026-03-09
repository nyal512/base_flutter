import '../../../../core/viewmodel/base_view_model.dart';

class SummaryFormatViewModel extends BaseViewModel {
  // Print Format: 0: メニュー別, 1: グループ別メニュー, 2: 売れ筋
  int _printFormat = 1;

  // Options
  bool _groupSummary = true;
  bool _timeSlotSummary = true;
  bool _timeSlotGroupSummary = true;
  bool _depositWithdrawalInfo = true;
  bool _collectionInfo = true;
  bool _changeReplenishment = true;
  bool _changeWithdrawal = true;

  // Getters
  int get printFormat => _printFormat;
  bool get groupSummary => _groupSummary;
  bool get timeSlotSummary => _timeSlotSummary;
  bool get timeSlotGroupSummary => _timeSlotGroupSummary;
  bool get depositWithdrawalInfo => _depositWithdrawalInfo;
  bool get collectionInfo => _collectionInfo;
  bool get changeReplenishment => _changeReplenishment;
  bool get changeWithdrawal => _changeWithdrawal;

  // Setters
  void setPrintFormat(int value) {
    _printFormat = value;
    notifyListeners();
  }

  void setGroupSummary(bool value) {
    _groupSummary = value;
    notifyListeners();
  }

  void setTimeSlotSummary(bool value) {
    _timeSlotSummary = value;
    notifyListeners();
  }

  void setTimeSlotGroupSummary(bool value) {
    _timeSlotGroupSummary = value;
    notifyListeners();
  }

  void setDepositWithdrawalInfo(bool value) {
    _depositWithdrawalInfo = value;
    notifyListeners();
  }

  void setCollectionInfo(bool value) {
    _collectionInfo = value;
    notifyListeners();
  }

  void setChangeReplenishment(bool value) {
    _changeReplenishment = value;
    notifyListeners();
  }

  void setChangeWithdrawal(bool value) {
    _changeWithdrawal = value;
    notifyListeners();
  }

  void onSave() {
    setLoading(true);
    Future.delayed(const Duration(milliseconds: 500), () {
      setLoading(false);
    });
  }
}
