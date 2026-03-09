import 'package:flutter/foundation.dart';
import '../../../../core/viewmodel/base_view_model.dart';

class NetworkViewModel extends BaseViewModel {
  // --- 券売機 (Ticket Machine) State ---
  String _ipAddress = '';
  String _subnetMask = '';
  String _portNumber1 = '';
  String _portNumber2 = '';

  String get ipAddress => _ipAddress;
  String get subnetMask => _subnetMask;
  String get portNumber1 => _portNumber1;
  String get portNumber2 => _portNumber2;

  void setIpAddress(String value) {
    if (_ipAddress != value) {
      _ipAddress = value;
      notifyListeners();
    }
  }

  void setSubnetMask(String value) {
    if (_subnetMask != value) {
      _subnetMask = value;
      notifyListeners();
    }
  }

  void setPortNumber1(String value) {
    if (_portNumber1 != value) {
      _portNumber1 = value;
      notifyListeners();
    }
  }

  void setPortNumber2(String value) {
    if (_portNumber2 != value) {
      _portNumber2 = value;
      notifyListeners();
    }
  }

  // --- 上位端末 (Upper Terminal) State ---
  bool _isUpperTerminalConnected = false;
  String _upperTerminalIpAddress = '';
  String _upperTerminalPortNumber = '';

  bool get isUpperTerminalConnected => _isUpperTerminalConnected;
  String get upperTerminalIpAddress => _upperTerminalIpAddress;
  String get upperTerminalPortNumber => _upperTerminalPortNumber;

  void setUpperTerminalConnected(bool value) {
    if (_isUpperTerminalConnected != value) {
      _isUpperTerminalConnected = value;
      notifyListeners();
    }
  }

  void setUpperTerminalIpAddress(String value) {
    if (_upperTerminalIpAddress != value) {
      _upperTerminalIpAddress = value;
      notifyListeners();
    }
  }

  void setUpperTerminalPortNumber(String value) {
    if (_upperTerminalPortNumber != value) {
      _upperTerminalPortNumber = value;
      notifyListeners();
    }
  }

  @override
  void init() {
    // Initialize with default or mocked data if necessary
    _ipAddress = '';
    _subnetMask = '';
    _portNumber1 = '60000';
    _portNumber2 = '60001';
    
    _isUpperTerminalConnected = true;
    _upperTerminalIpAddress = '';
    _upperTerminalPortNumber = '51000';
  }

  void onSave() {
    debugPrint('Saving Network Data:');
    debugPrint('Ticket Machine: IP=$_ipAddress, Subnet=$_subnetMask, Port1=$_portNumber1, Port2=$_portNumber2');
    debugPrint('Upper Terminal: Connected=$_isUpperTerminalConnected, IP=$_upperTerminalIpAddress, Port=$_upperTerminalPortNumber');
  }
}
