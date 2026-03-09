import '../../../../core/viewmodel/base_view_model.dart';

class ChildConnectionModel {
  bool isConnected;
  String address;
  String port;

  ChildConnectionModel({
    this.isConnected = false,
    this.address = '',
    this.port = '9100',
  });
}

class ParentChildViewModel extends BaseViewModel {
  final List<ChildConnectionModel> _connections = List.generate(
    7,
    (index) => ChildConnectionModel(),
  );

  List<ChildConnectionModel> get connections => _connections;

  void updateConnection(int index, {bool? isConnected, String? address, String? port}) {
    if (index >= 0 && index < _connections.length) {
      if (isConnected != null) _connections[index].isConnected = isConnected;
      if (address != null) _connections[index].address = address;
      if (port != null) _connections[index].port = port;
      notifyListeners();
    }
  }

  void onSave() {
    setLoading(true);
    // Simulate save logic
    Future.delayed(const Duration(milliseconds: 500), () {
      setLoading(false);
    });
  }

  @override
  void init() {
    super.init();
    // Initialize with data if available
  }
}
