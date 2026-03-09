import '../../../../core/viewmodel/base_view_model.dart';

class OptionItem {
  final int id;
  final String title;
  bool isEnabled;
  final bool isSwitchable; // If false, no switch is shown (e.g. some reserved items)

  OptionItem({
    required this.id,
    required this.title,
    this.isEnabled = false,
    this.isSwitchable = true,
  });
}

class Option1ViewModel extends BaseViewModel {
  // Initialize 64 items based on the design
  final List<OptionItem> _options = List.generate(64, (index) {
    int id = index + 1;
    String idString = id.toString().padLeft(2, '0');
    String title = '$idString. (予備)';
    bool isEnabled = false;
    bool isSwitchable = false;

    // Apply specific labels and default states based on the mockups
    switch (id) {
      case 2:
        title = '02. 紙幣ユニット接続';
        isSwitchable = true;
        isEnabled = true;
        break;
      case 3:
        title = '03. 払戻';
        isSwitchable = true;
        isEnabled = true;
        break;
      case 4:
        title = '04. 払戻発券';
        isSwitchable = true;
        isEnabled = true;
        break;
      case 5:
        title = '05. 払戻出金 (予約)';
        isSwitchable = true;
        isEnabled = false;
        break;
      case 10:
        title = '10. 売上有設定変更';
        isSwitchable = true;
        isEnabled = false;
        break;
      case 11:
        title = '11. 硬貨エスクロ機能';
        isSwitchable = true;
        isEnabled = true;
        break;
      case 13:
        title = '13. 500円ホッパ縮退';
        isSwitchable = true;
        isEnabled = false;
        break;
      case 14:
        title = '14. 50円ホッパ縮退';
        isSwitchable = true;
        isEnabled = false;
        break;
      case 16:
        title = '16. レシートプリンタ接続';
        isSwitchable = true;
        isEnabled = false;
        break;
      case 21:
        title = '21. 親子機能 (予約)';
        isSwitchable = true;
        isEnabled = false;
        break;
      case 22:
        title = '22. 集計データ保存';
        isSwitchable = true;
        isEnabled = true;
        break;
      case 23:
        title = '23. トランザクションデータ保存';
        isSwitchable = true;
        isEnabled = true;
        break;
      case 24:
        title = '24. FTP機能';
        isSwitchable = true;
        isEnabled = false;
        break;
      case 29:
        title = '29. (予備)';
        isSwitchable = true;
        break;
      case 30:
        title = '30. キャッシュレス端末';
        isSwitchable = true;
        break;
      case 32:
        title = '32. コードリーダ接続';
        isSwitchable = true;
        break;
      case 33:
        title = '33. コードリーダ決済機能';
        isSwitchable = true;
        break;
      case 63:
        title = '63. FTP機能';
        isSwitchable = false;
        break;
      default:
        // Already set up as '(予備)' with no switch
        break;
    }

    return OptionItem(
      id: id,
      title: title,
      isEnabled: isEnabled,
      isSwitchable: isSwitchable,
    );
  });

  List<OptionItem> get options => _options;

  void toggleOption(int index, bool value) {
    if (index >= 0 && index < _options.length) {
      if (_options[index].isSwitchable) {
        _options[index].isEnabled = value;
        notifyListeners();
      }
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
    // Fetch data if needed
  }
}
