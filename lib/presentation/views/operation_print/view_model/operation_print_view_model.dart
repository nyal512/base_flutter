import 'package:flutter/foundation.dart';
import '../../../../core/viewmodel/base_view_model.dart';

class OperationPrintViewModel extends BaseViewModel {
  bool _isTotalOperationPrintEnabled = false;

  bool get isTotalOperationPrintEnabled => _isTotalOperationPrintEnabled;

  void setTotalOperationPrint(bool value) {
    if (_isTotalOperationPrintEnabled != value) {
      _isTotalOperationPrintEnabled = value;
      notifyListeners();
    }
  }

  void init() {
    // Initialize data if needed
  }

  void onSave() {
    debugPrint('Saving Operation Print Data: TotalOperationPrint=$_isTotalOperationPrintEnabled');
  }
}
