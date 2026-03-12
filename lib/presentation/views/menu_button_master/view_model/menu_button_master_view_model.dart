import '../../../../core/viewmodel/base_view_model.dart';

class MenuButtonItem {
  final int no;
  final String name;
  final String image;
  final String size;
  final String type;

  MenuButtonItem({
    required this.no,
    required this.name,
    required this.image,
    required this.size,
    required this.type,
  });
}

class MenuButtonMasterViewModel extends BaseViewModel {
  final String _currentFileName = 'master_ticket_layout.dat';
  String get currentFileName => _currentFileName;

  final List<MenuButtonItem> _menuItems = [
    MenuButtonItem(
      no: 1,
      name: 'メニューボタン小・画像なし',
      image: 'なし',
      size: '112×168',
      type: 'メニューボタン小',
    ),
    MenuButtonItem(
      no: 2,
      name: 'メニューボタン中（横）・画像なし',
      image: 'なし',
      size: '364×112',
      type: 'メニューボタン(横)',
    ),
    MenuButtonItem(
      no: 3,
      name: 'メニューボタン大・画像なし',
      image: 'なし',
      size: '252×364',
      type: 'メニューボタン大',
    ),
    MenuButtonItem(
      no: 4,
      name: 'メニューボタン2連横・画像なし',
      image: 'なし',
      size: '392×560',
      type: 'メニューボタン2連横',
    ),
    MenuButtonItem(
      no: 5,
      name: 'メニューボタン3連横・画像あり',
      image: 'あり',
      size: '392×560',
      type: 'メニューボタン3連横',
    ),
  ];

  List<MenuButtonItem> get menuItems => _menuItems;

  void addMenuItem(MenuButtonItem item) {
    _menuItems.add(item);
    notifyListeners();
  }

  void updateMenuItem(MenuButtonItem updatedItem) {
    final index = _menuItems.indexWhere((item) => item.no == updatedItem.no);
    if (index != -1) {
      _menuItems[index] = updatedItem;
      notifyListeners();
    }
  }

  void onImportFile() {
    // Implement file import logic
    notifyListeners();
  }

  void onDelete(int no) {
    _menuItems.removeWhere((item) => item.no == no);
    notifyListeners();
  }

  void onView(int no) {
    // Implement view logic
    notifyListeners();
  }

  void onAddToFavorites() {
    // Implement add to favorites logic
    notifyListeners();
  }

  void onSave() {
    // Implement save logic
    notifyListeners();
  }
}
