import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import '../../../../core/utils/responsive_utils.dart';

class TabSettingsDialog extends StatefulWidget {
  final Map<String, dynamic>? initialSettings;

  const TabSettingsDialog({super.key, this.initialSettings});

  @override
  State<TabSettingsDialog> createState() => _TabSettingsDialogState();
}

class _TabSettingsDialogState extends State<TabSettingsDialog> {
  late TextEditingController _bgColorController;
  late TextEditingController _fontColorController;
  String? _selectedTabType;
  String _fontSize = '18px';

  final List<String> _tabTypes = [
    '標準タブ',
    '装飾タブ',
    'アイコン付き',
  ];

  final List<String> _fontSizes = ['14px', '16px', '18px', '20px', '24px'];

  @override
  void initState() {
    super.initState();
    _bgColorController = TextEditingController(text: widget.initialSettings?['backgroundColor'] ?? '#F2F1ED');
    _fontColorController = TextEditingController(text: widget.initialSettings?['fontColor'] ?? '#4680FF');
    _selectedTabType = widget.initialSettings?['tabType'];
    _fontSize = widget.initialSettings?['fontSize'] ?? '18px';
  }

  @override
  void dispose() {
    _bgColorController.dispose();
    _fontColorController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.w)),
      child: Container(
        width: 600.w,
        padding: EdgeInsets.zero,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.w),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context),
            const Divider(height: 1),
            Padding(
              padding: EdgeInsets.all(24.w),
              child: Column(
                children: [
                  _buildFormRow(
                    'タブタイプ',
                    _buildDropdown(
                      value: _selectedTabType,
                      items: _tabTypes,
                      hint: '選択してください',
                      onChanged: (v) => setState(() => _selectedTabType = v),
                    ),
                  ),
                  SizedBox(height: 16.h),
                  Row(
                    children: [
                      Expanded(
                        child: _buildFormRow(
                          '背景色',
                          _buildColorInput(_bgColorController),
                        ),
                      ),
                      SizedBox(width: 16.w),
                      Expanded(
                        child: _buildFormRow(
                          'フォント色',
                          _buildColorInput(_fontColorController),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.h),
                  _buildFormRow(
                    '文字サイズ',
                    _buildDropdown(
                      value: _fontSize,
                      items: _fontSizes,
                      onChanged: (v) => setState(() => _fontSize = v!),
                    ),
                  ),
                ],
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
          Text(
            'タブ設定',
            style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold, color: const Color(0xFF111827)),
          ),
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.close),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }

  Widget _buildFormRow(String label, Widget child) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 120.w,
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          decoration: BoxDecoration(
            color: const Color(0xFFF3F4F6),
            borderRadius: BorderRadius.horizontal(left: Radius.circular(4.w)),
          ),
          child: Text(
            label,
            style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold, color: const Color(0xFF374151)),
          ),
        ),
        Expanded(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
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

  Widget _buildDropdown({
    String? value,
    required List<String> items,
    String? hint,
    required void Function(String?) onChanged,
  }) {
    return DropdownButtonHideUnderline(
      child: DropdownButton<String>(
        value: value,
        isExpanded: true,
        hint: hint != null ? Text(hint, style: TextStyle(fontSize: 14.sp, color: const Color(0xFF9CA3AF))) : null,
        items: items.map((e) => DropdownMenuItem(value: e, child: Text(e, style: TextStyle(fontSize: 14.sp)))).toList(),
        onChanged: onChanged,
        icon: const Icon(Icons.keyboard_arrow_down),
      ),
    );
  }

  Widget _buildColorInput(TextEditingController controller) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: controller,
            decoration: const InputDecoration(
              isDense: true,
              border: InputBorder.none,
              contentPadding: EdgeInsets.zero,
            ),
            style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold),
          ),
        ),
        GestureDetector(
          onTap: () => _showColorPicker(controller),
          child: Container(
            width: 20.w,
            height: 20.w,
            decoration: BoxDecoration(
              color: _getColorFromHex(controller.text),
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFFE5E7EB)),
            ),
          ),
        ),
      ],
    );
  }

  void _showColorPicker(TextEditingController controller) {
    Color pickerColor = _getColorFromHex(controller.text);
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('色を選択'),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: pickerColor,
              onColorChanged: (color) => pickerColor = color,
            ),
          ),
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
        );
      },
    );
  }

  Color _getColorFromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    try {
      return Color(int.parse(buffer.toString(), radix: 16));
    } catch (_) {
      return Colors.white;
    }
  }

  Widget _buildFooter(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          OutlinedButton(
            onPressed: () => Navigator.of(context).pop(),
            style: OutlinedButton.styleFrom(
              foregroundColor: const Color(0xFF374151),
              side: const BorderSide(color: Color(0xFFD1D5DB)),
              padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 12.h),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.w)),
            ),
            child: Text('戻る', style: TextStyle(fontSize: 14.sp)),
          ),
          SizedBox(width: 12.w),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop({
                'tabType': _selectedTabType,
                'backgroundColor': _bgColorController.text,
                'fontColor': _fontColorController.text,
                'fontSize': _fontSize,
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4680FF),
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 48.w, vertical: 12.h),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.w)),
              elevation: 0,
            ),
            child: Text('保存', style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}
