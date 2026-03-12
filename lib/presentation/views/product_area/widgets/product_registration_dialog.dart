import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import '../view_model/product_area_view_model.dart';
import '../../../../core/utils/responsive_utils.dart';

class MenuSlot {
  String number;
  String name;
  String price;
  String groupCount;
  String insertInfoNo;

  MenuSlot({
    this.number = '',
    this.name = '',
    this.price = '',
    this.groupCount = '1',
    this.insertInfoNo = '1',
  });
}

class ProductRegistrationDialog extends StatefulWidget {
  final String categoryName;
  final Map<String, dynamic>? initialData;

  const ProductRegistrationDialog({
    super.key,
    required this.categoryName,
    this.initialData,
  });

  @override
  State<ProductRegistrationDialog> createState() => _ProductRegistrationDialogState();
}

class _ProductRegistrationDialogState extends State<ProductRegistrationDialog> {
  String? _selectedButtonType;
  final List<MenuSlot> _menuSlots = [MenuSlot()];

  // Appearance Controllers
  late TextEditingController _catBgColorController;
  late TextEditingController _catFontColorController;
  String _catFontSize = '18px';

  late TextEditingController _menuBgColorController;
  late TextEditingController _menuFontColorController;
  String _menuFontSize = '18px';

  final List<String> _buttonTypes = [
    '通常ボタン',
    '装飾ボタン',
    'アイコン付き',
  ];

  final List<String> _groupCounts = ['1', '2', '3', '4', '5'];
  final List<String> _insertInfoNos = ['1', '2', '3', '4', '5'];
  final List<String> _fontSizes = ['14px', '16px', '18px', '20px', '24px'];

  @override
  void initState() {
    super.initState();
    _catBgColorController = TextEditingController(text: '#F2F1ED');
    _catFontColorController = TextEditingController(text: '#4680FF');
    _menuBgColorController = TextEditingController(text: '#F2F1ED');
    _menuFontColorController = TextEditingController(text: '#4680FF');
  }

  @override
  void dispose() {
    _catBgColorController.dispose();
    _catFontColorController.dispose();
    _menuBgColorController.dispose();
    _menuFontColorController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.w)),
      child: Container(
        width: 700.w,
        height: 800.h,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.w),
        ),
        child: Column(
          children: [
            _buildHeader(context),
            const Divider(height: 1),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(24.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionHeader('基本情報'),
                    _buildFormRow('カテゴリ名', Text(widget.categoryName, style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold))),
                    SizedBox(height: 8.h),
                    _buildFormRow(
                      'ボタンタイプ',
                      _buildDropdown(
                        value: _selectedButtonType,
                        items: _buttonTypes,
                        hint: '選択してください',
                        onChanged: (v) => setState(() => _selectedButtonType = v),
                      ),
                    ),
                    SizedBox(height: 24.h),
                    _buildMenuList(),
                    SizedBox(height: 16.h),
                    Align(
                      alignment: Alignment.centerRight,
                      child: OutlinedButton.icon(
                        onPressed: () => setState(() => _menuSlots.add(MenuSlot())),
                        icon: const Icon(Icons.add, size: 16),
                        label: Text('新規登録', style: TextStyle(fontSize: 12.sp)),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: const Color(0xFF374151),
                          side: const BorderSide(color: Color(0xFFD1D5DB)),
                        ),
                      ),
                    ),
                    SizedBox(height: 24.h),
                    _buildAppearanceSection('カテゴリ設定', _catBgColorController, _catFontColorController, _catFontSize, (v) => setState(() => _catFontSize = v!)),
                    SizedBox(height: 16.h),
                    _buildAppearanceSection('メニュー設定', _menuBgColorController, _menuFontColorController, _menuFontSize, (v) => setState(() => _menuFontSize = v!)),
                  ],
                ),
              ),
            ),
            const Divider(height: 1),
            _buildFooter(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('商品登録', style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold)),
          IconButton(onPressed: () => Navigator.of(context).pop(), icon: const Icon(Icons.close)),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Text(title, style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold, color: const Color(0xFF374151))),
    );
  }

  Widget _buildMenuList() {
    return Column(
      children: _menuSlots.asMap().entries.map((entry) {
        int idx = entry.key;
        MenuSlot slot = entry.value;
        return Container(
          margin: EdgeInsets.only(bottom: 16.h),
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFFE5E7EB)),
            borderRadius: BorderRadius.circular(8.w),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(flex: 3, child: _buildFormRow('メニュー番号', _buildSearchInput(slot))),
                  SizedBox(width: 8.w),
                  if (_menuSlots.length > 1)
                    IconButton(
                      onPressed: () => setState(() => _menuSlots.removeAt(idx)),
                      icon: const Icon(Icons.delete_outline, color: Colors.red, size: 20),
                    ),
                ],
              ),
              SizedBox(height: 8.h),
              _buildFormRow('メニュー名称', Container(height: 40.h, color: const Color(0xFFF9FAFB))),
              SizedBox(height: 8.h),
              _buildFormRow('価格', Container(height: 40.h, color: const Color(0xFFF9FAFB))),
              SizedBox(height: 8.h),
              Row(
                children: [
                  Expanded(
                    child: _buildFormRow(
                      'まとめ枚数',
                      _buildDropdown(
                        value: slot.groupCount,
                        items: _groupCounts,
                        onChanged: (v) => setState(() => slot.groupCount = v!),
                      ),
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: _buildFormRow(
                      '差込情報番号',
                      _buildDropdown(
                        value: slot.insertInfoNo,
                        items: _insertInfoNos,
                        onChanged: (v) => setState(() => slot.insertInfoNo = v!),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildAppearanceSection(String title, TextEditingController bg, TextEditingController font, String size, void Function(String?) onSizeChange) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(title),
        Row(
          children: [
            Expanded(child: _buildFormRow('背景色', _buildColorInput(bg))),
            SizedBox(width: 16.w),
            Expanded(child: _buildFormRow('フォント色', _buildColorInput(font))),
          ],
        ),
        SizedBox(height: 8.h),
        _buildFormRow('文字サイズ', _buildDropdown(value: size, items: _fontSizes, onChanged: onSizeChange)),
      ],
    );
  }

  Widget _buildFormRow(String label, Widget child) {
    return Row(
      children: [
        Container(
          width: 120.w,
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          decoration: BoxDecoration(
            color: const Color(0xFFF3F4F6),
            borderRadius: BorderRadius.horizontal(left: Radius.circular(4.w)),
          ),
          child: Text(label, style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.bold)),
        ),
        Expanded(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            height: 40.h,
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFFE5E7EB)),
              borderRadius: BorderRadius.horizontal(right: Radius.circular(4.w)),
            ),
            child: child,
          ),
        ),
      ],
    );
  }

  Widget _buildSearchInput(MenuSlot slot) {
    return Row(
      children: [
        Expanded(child: TextField(decoration: const InputDecoration(isDense: true, border: InputBorder.none))),
        const Icon(Icons.search, size: 18, color: Colors.grey),
        SizedBox(width: 8.w),
        ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            elevation: 0,
            side: const BorderSide(color: Color(0xFFD1D5DB)),
            padding: EdgeInsets.symmetric(horizontal: 16.w),
          ),
          child: Text('検索', style: TextStyle(fontSize: 12.sp)),
        ),
      ],
    );
  }

  Widget _buildDropdown({String? value, required List<String> items, String? hint, required void Function(String?) onChanged}) {
    return DropdownButtonHideUnderline(
      child: DropdownButton<String>(
        value: value,
        isExpanded: true,
        hint: hint != null ? Text(hint, style: TextStyle(fontSize: 12.sp)) : null,
        items: items.map((e) => DropdownMenuItem(value: e, child: Text(e, style: TextStyle(fontSize: 12.sp)))).toList(),
        onChanged: onChanged,
        icon: const Icon(Icons.keyboard_arrow_down),
      ),
    );
  }

  Widget _buildColorInput(TextEditingController controller) {
    return Row(
      children: [
        Expanded(child: TextField(controller: controller, decoration: const InputDecoration(isDense: true, border: InputBorder.none))),
        GestureDetector(
          onTap: () => _showColorPicker(controller),
          child: Container(
            width: 18.w,
            height: 18.w,
            decoration: BoxDecoration(color: _getColorFromHex(controller.text), shape: BoxShape.circle, border: Border.all(color: Colors.grey.shade300)),
          ),
        ),
      ],
    );
  }

  void _showColorPicker(TextEditingController controller) {
    Color pickerColor = _getColorFromHex(controller.text);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('色を選択'),
        content: SingleChildScrollView(child: ColorPicker(pickerColor: pickerColor, onColorChanged: (c) => pickerColor = c)),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                controller.text = '#${pickerColor.value.toRadixString(16).substring(2).toUpperCase()}';
              });
              Navigator.of(context).pop();
            },
            child: const Text('決定'),
          ),
        ],
      ),
    );
  }

  Color _getColorFromHex(String hex) {
    try {
      return Color(int.parse(hex.replaceFirst('#', '0xFF')));
    } catch (_) {
      return Colors.white;
    }
  }

  Widget _buildFooter(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          OutlinedButton(
            onPressed: () => Navigator.of(context).pop(),
            style: OutlinedButton.styleFrom(
              foregroundColor: const Color(0xFF374151),
              side: const BorderSide(color: Color(0xFFD1D5DB)),
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
            ),
            child: Text('戻る', style: TextStyle(fontSize: 14.sp)),
          ),
          Row(
            children: [
              OutlinedButton(
                onPressed: () {
                  if (_menuSlots.isEmpty) return;
                  final slot = _menuSlots.first;
                  final product = ProductItem(
                    id: DateTime.now().millisecondsSinceEpoch,
                    name: slot.name.isEmpty ? '新規商品' : slot.name,
                    categoryNo: 0, // Should be set by caller or managed better
                    buttonType: _selectedButtonType,
                    price: slot.price,
                    backgroundColor: _menuBgColorController.text,
                    fontColor: _menuFontColorController.text,
                    fontSize: _menuFontSize,
                  );
                  Navigator.of(context).pop(product);
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFF4680FF),
                  side: const BorderSide(color: Color(0xFF4680FF)),
                  padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
                ),
                child: Text('保存', style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold)),
              ),
              SizedBox(width: 12.w),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4680FF),
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
                  elevation: 0,
                ),
                child: Text('商品コピー', style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
