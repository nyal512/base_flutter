import 'package:flutter/foundation.dart';
import '../../../../core/viewmodel/base_view_model.dart';

class FtpViewModel extends BaseViewModel {
  // --- Upper PC (上位PC) 1 State ---
  bool _isUpperPcConnected = false;
  String _ipAddress = '';
  String _userId1 = '';
  String _password1 = '';
  String _saveFolder = '';

  bool get isUpperPcConnected => _isUpperPcConnected;
  String get ipAddress => _ipAddress;
  String get userId1 => _userId1;
  String get password1 => _password1;
  String get saveFolder => _saveFolder;

  void setUpperPcConnected(bool value) {
    if (_isUpperPcConnected != value) {
      _isUpperPcConnected = value;
      notifyListeners();
    }
  }

  void setIpAddress(String value) {
    if (_ipAddress != value) {
      _ipAddress = value;
      notifyListeners();
    }
  }

  void setUserId1(String value) {
    if (_userId1 != value) {
      _userId1 = value;
      notifyListeners();
    }
  }

  void setPassword1(String value) {
    if (_password1 != value) {
      _password1 = value;
      notifyListeners();
    }
  }

  void setSaveFolder(String value) {
    if (_saveFolder != value) {
      _saveFolder = value;
      notifyListeners();
    }
  }

  // --- Upper PC (上位PC) 2 State ---
  String _userId2 = '';
  String _password2 = '';

  String get userId2 => _userId2;
  String get password2 => _password2;

  void setUserId2(String value) {
    if (_userId2 != value) {
      _userId2 = value;
      notifyListeners();
    }
  }

  void setPassword2(String value) {
    if (_password2 != value) {
      _password2 = value;
      notifyListeners();
    }
  }

  // --- Transmission File (送信ファイル) State ---
  bool _sendFileDaily = true; // 日計
  bool _sendFileCumulative = true; // 累計
  bool _sendFileTransaction = true; // トランザクション
  bool _isTransactionRegularTransmission = false;
  String _transactionTransmissionInterval = '';
  bool _isSizeCheck = true;

  bool get sendFileDaily => _sendFileDaily;
  bool get sendFileCumulative => _sendFileCumulative;
  bool get sendFileTransaction => _sendFileTransaction;
  bool get isTransactionRegularTransmission => _isTransactionRegularTransmission;
  String get transactionTransmissionInterval => _transactionTransmissionInterval;
  bool get isSizeCheck => _isSizeCheck;

  void setSendFileDaily(bool value) {
    if (_sendFileDaily != value) {
      _sendFileDaily = value;
      notifyListeners();
    }
  }

  void setSendFileCumulative(bool value) {
    if (_sendFileCumulative != value) {
      _sendFileCumulative = value;
      notifyListeners();
    }
  }

  void setSendFileTransaction(bool value) {
    if (_sendFileTransaction != value) {
      _sendFileTransaction = value;
      notifyListeners();
    }
  }

  void setTransactionRegularTransmission(bool value) {
    if (_isTransactionRegularTransmission != value) {
      _isTransactionRegularTransmission = value;
      notifyListeners();
    }
  }

  void setTransactionTransmissionInterval(String value) {
    if (_transactionTransmissionInterval != value) {
      _transactionTransmissionInterval = value;
      notifyListeners();
    }
  }

  void setSizeCheck(bool value) {
    if (_isSizeCheck != value) {
      _isSizeCheck = value;
      notifyListeners();
    }
  }

  @override
  void init() {
    _isUpperPcConnected = true;
    _ipAddress = '';
    _userId1 = '';
    _password1 = '';
    _saveFolder = '';

    _userId2 = '';
    _password2 = '';

    _sendFileDaily = true;
    _sendFileCumulative = true;
    _sendFileTransaction = true;
    _isTransactionRegularTransmission = true;
    _transactionTransmissionInterval = '';
    _isSizeCheck = true;
  }

  void onSave() {
    debugPrint('Saving FTP Data:');
    debugPrint('Upper PC 1: Connected=$_isUpperPcConnected, IP=$_ipAddress, User=$_userId1, Pass=$_password1, Folder=$_saveFolder');
    debugPrint('Upper PC 2: User=$_userId2, Pass=$_password2');
    debugPrint('Transmission: Daily=$_sendFileDaily, Cumulative=$_sendFileCumulative, Transaction=$_sendFileTransaction');
    debugPrint('Transaction Regular: $_isTransactionRegularTransmission, Interval: $_transactionTransmissionInterval');
    debugPrint('Size Check: $_isSizeCheck');
  }
}
