import 'package:flutter/foundation.dart';
import '../../../../core/viewmodel/base_view_model.dart';

class OutputDestination {
  bool isConnected;
  String ipAddress;
  String portNumber;

  OutputDestination({
    this.isConnected = false,
    this.ipAddress = '',
    this.portNumber = '',
  });
}

class OrderingViewModel extends BaseViewModel {
  final List<OutputDestination> _destinations = List.generate(7, (_) => OutputDestination());
  
  List<OutputDestination> get destinations => _destinations;

  void toggleConnection(int index, bool value) {
    if (_destinations[index].isConnected != value) {
      _destinations[index].isConnected = value;
      notifyListeners();
    }
  }

  void setIpAddress(int index, String value) {
    if (_destinations[index].ipAddress != value) {
      _destinations[index].ipAddress = value;
      notifyListeners();
    }
  }

  void setPortNumber(int index, String value) {
    if (_destinations[index].portNumber != value) {
      _destinations[index].portNumber = value;
      notifyListeners();
    }
  }

  // --- 詳細 (Details) State ---
  int _printFormat = 1; // 0 = 一括, 1 = 個別
  int _serialNumberType = 1; // 0 = メニュー別連番, 1 = 発券連番
  int _menuNameFontSize = 1; // 0 = 大, 1 = 標準
  int _serialNumberFontSize = 1; // 0 = 大, 1 = 標準
  int _addSerialNumberMachine = 1; // 0 = あり, 1 = なし
  String _serialNumberDigits = '2';

  int get printFormat => _printFormat;
  int get serialNumberType => _serialNumberType;
  int get menuNameFontSize => _menuNameFontSize;
  int get serialNumberFontSize => _serialNumberFontSize;
  int get addSerialNumberMachine => _addSerialNumberMachine;
  String get serialNumberDigits => _serialNumberDigits;

  final List<String> serialNumberDigitsOptions = ['2', '3', '4', '5'];

  void setPrintFormat(int value) {
    if (_printFormat != value) {
      _printFormat = value;
      notifyListeners();
    }
  }

  void setSerialNumberType(int value) {
    if (_serialNumberType != value) {
      _serialNumberType = value;
      notifyListeners();
    }
  }

  void setMenuNameFontSize(int value) {
    if (_menuNameFontSize != value) {
      _menuNameFontSize = value;
      notifyListeners();
    }
  }

  void setSerialNumberFontSize(int value) {
    if (_serialNumberFontSize != value) {
      _serialNumberFontSize = value;
      notifyListeners();
    }
  }

  void setAddSerialNumberMachine(int value) {
    if (_addSerialNumberMachine != value) {
      _addSerialNumberMachine = value;
      notifyListeners();
    }
  }

  void setSerialNumberDigits(String value) {
    if (_serialNumberDigits != value) {
      _serialNumberDigits = value;
      notifyListeners();
    }
  }

  @override
  void init() {
    // Basic defaults
    _destinations[0].isConnected = true; 
    _destinations[1].isConnected = true; 
    _destinations[2].isConnected = true; 
    // The rest are disconnected in the mockup representation by default (all false init except first 3 matching mockup vaguely)
  }

  void onSave() {
    debugPrint('Saving Ordering Data:');
    for (int i = 0; i < _destinations.length; i++) {
        debugPrint('Destination ${i+1}: connected=${_destinations[i].isConnected}, ip=${_destinations[i].ipAddress}, port=${_destinations[i].portNumber}');
    }
    debugPrint('Print Format: $_printFormat');
    debugPrint('Serial Number Type: $_serialNumberType');
    debugPrint('Menu Name Font Size: $_menuNameFontSize');
    debugPrint('Serial Number Font Size: $_serialNumberFontSize');
    debugPrint('Add Serial Number Machine: $_addSerialNumberMachine');
    debugPrint('Serial Number Digits: $_serialNumberDigits');
  }
}
