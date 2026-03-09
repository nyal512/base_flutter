import '../../../../core/viewmodel/base_view_model.dart';
import 'package:flutter/foundation.dart';

enum PrintOption {
  print,
  doNotPrint,
  doNotPrintIfZeroYen,
}

class PrintSettingItem {
  final String label;
  PrintOption selectedOption;

  PrintSettingItem({required this.label, this.selectedOption = PrintOption.doNotPrint});
}

class DetailsViewModel extends BaseViewModel {
  // 1. Switch States (8 items)
  // [0] 商品コードの印字
  // [1] 区分内訳クレジット決済の印字
  // [2] セット券枚数の印字
  // [3] 入店数、客単価の印字
  // [4] 取扱件数、取引単価、取消件数
  // [5] 領収書枚数、領収書（再）枚数
  // [6] 日計クリア履歴
  // [7] 単価の本体額、本体分売上額
  final List<bool> switchFlags = [
    false, false, false, false,
    false, false, true, false,
  ];

  final List<String> switchLabels = [
    '商品コードの印字',
    '区分内訳クレジット決済の印字',
    'セット券枚数の印字',
    '入店数、客単価の印字',
    '取扱件数、取引単価、取消件数',
    '領収書枚数、領収書（再）枚数',
    '日計クリア履歴',
    '単価の本体額、本体分売上額',
  ];

  // 2. Radio Button States (6 items)
  final List<PrintSettingItem> printSettings = [
    PrintSettingItem(label: '区分内訳コード決済', selectedOption: PrintOption.doNotPrint),
    PrintSettingItem(label: '単価の内税額、内税分売上額', selectedOption: PrintOption.doNotPrint),
    PrintSettingItem(label: '販売枚数、販売額', selectedOption: PrintOption.doNotPrintIfZeroYen),
    PrintSettingItem(label: '払戻枚数、払戻額', selectedOption: PrintOption.doNotPrint),
    PrintSettingItem(label: '区分内訳現金決済', selectedOption: PrintOption.doNotPrint),
    PrintSettingItem(label: '区分内訳電子マネー決済', selectedOption: PrintOption.doNotPrint),
  ];

  void toggleSwitch(int index, bool value) {
    if (index >= 0 && index < switchFlags.length) {
      switchFlags[index] = value;
      notifyListeners();
    }
  }

  void updatePrintSetting(int index, PrintOption option) {
    if (index >= 0 && index < printSettings.length) {
      printSettings[index].selectedOption = option;
      notifyListeners();
    }
  }

  void onSave() {
    setLoading(true);
    // Simulate API call or local storage save
    Future.delayed(const Duration(milliseconds: 500), () {
      if (kDebugMode) {
        print('Saved Details: Switches: $switchFlags');
        print('Saved Details: Radios: ${printSettings.map((e) => e.selectedOption.toString()).toList()}');
      }
      setLoading(false);
    });
  }

  @override
  void init() {
    super.init();
    // Fetch stored settings here if needed
  }
}
