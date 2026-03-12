import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import '../../../../core/utils/responsive_utils.dart';
import '../../../widgets/form_widgets.dart';
import '../view_model/menu_button_master_view_model.dart';

class MenuButtonMasterSettingsDialog extends StatefulWidget {
  final MenuButtonItem? initialItem;

  const MenuButtonMasterSettingsDialog({super.key, this.initialItem});

  @override
  State<MenuButtonMasterSettingsDialog> createState() => _MenuButtonMasterSettingsDialogState();
}

class _MenuButtonMasterSettingsDialogState extends State<MenuButtonMasterSettingsDialog> {
  late TextEditingController _nameController;
  late TextEditingController _widthController;
  late TextEditingController _heightController;
  late TextEditingController _bgColorController;
  late TextEditingController _fontColorController;

  String _selectedType = 'メニューボタン小';
  String _nameDisplaySetting = '名称（正）';
  String _imageDisplaySetting = 'なし';
  String _fontSize = '18px';
  String _transitionDestination = '注文確認画面';

  final List<String> _types = [
    'カテゴリボタン大',
    'カテゴリボタン小',
    'メニューボタン小',
    'メニューボタン(横)',
    'メニューボタン大',
    'メニューボタン2連横',
    'メニューボタン3連横',
    'メニューボタン4連横',
    'タブ',
  ];

  final List<String> _fontSizes = ['14px', '16px', '18px', '20px', '24px'];
  final List<String> _destinations = ['注文確認画面', '商品詳細画面'];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialItem?.name ?? '');
    
    // Parse size. Assuming format like "112×168" or default values
    String height = '112';
    String width = '168';
    if (widget.initialItem != null && widget.initialItem!.size.contains('×')) {
       final parts = widget.initialItem!.size.split('×');
       height = parts[0].trim();
       if (parts.length > 1) {
         width = parts[1].trim();
       }
    }

    _heightController = TextEditingController(text: height);
    _widthController = TextEditingController(text: width);
    _bgColorController = TextEditingController(text: '#F2F1ED');
    _fontColorController = TextEditingController(text: '#4680FF');

    _selectedType = widget.initialItem?.type ?? 'メニューボタン小';
    if (!_types.contains(_selectedType)) {
      _selectedType = _types.first;
    }
    
    // Default image setting from item if possible, else default to 'なし'
    if (widget.initialItem != null) {
      if (widget.initialItem!.image == 'あり') {
        _imageDisplaySetting = '全体'; // Assuming '全体' or '一部' for 'あり'
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _widthController.dispose();
    _heightController.dispose();
    _bgColorController.dispose();
    _fontColorController.dispose();
    super.dispose();
  }

  void _onSave() {
    final newItem = MenuButtonItem(
      no: widget.initialItem?.no ?? DateTime.now().millisecondsSinceEpoch,
      name: _nameController.text.trim(),
      image: _imageDisplaySetting != 'なし' ? 'あり' : 'なし',
      size: '${_heightController.text.trim()}×${_widthController.text.trim()}',
      type: _selectedType,
    );
    Navigator.of(context).pop(newItem);
  }

  void _showColorPicker(TextEditingController controller) {
    Color pickerColor = _getColorFromHex(controller.text);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('色を選択'),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: pickerColor,
              onColorChanged: (Color color) {
                pickerColor = color;
              },
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
              child: const Text('選択'),
              onPressed: () {
                setState(() {
                  controller.text = '#${pickerColor.value.toRadixString(16).substring(2).toUpperCase()}';
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Color _getColorFromHex(String hex) {
    if (!hex.startsWith('#')) return Colors.blue;
    try {
      return Color(int.parse(hex.replaceFirst('#', '0xFF')));
    } catch (e) {
      return Colors.blue;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.w)),
      child: Container(
        width: 1300.w,
        height: 750.h,
        padding: EdgeInsets.zero,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.w),
        ),
        child: Column(
          children: [
            _buildHeader(context),
            const Divider(height: 1, color: Color(0xFFE5E7EB)),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(24.w),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 6,
                      child: _buildFormSection(),
                    ),
                    SizedBox(width: 24.w),
                    Expanded(
                      flex: 4,
                      child: _buildPreviewSection(),
                    ),
                  ],
                ),
              ),
            ),
            const Divider(height: 1, color: Color(0xFFE5E7EB)),
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
            'ボタンマスター設定',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF111827),
            ),
          ),
          InkWell(
            onTap: () => Navigator.of(context).pop(),
            child: Icon(Icons.close, size: 24.sp, color: const Color(0xFF6B7280)),
          ),
        ],
      ),
    );
  }

  Widget _buildFormSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                width: 166.w,
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                decoration: BoxDecoration(
                  color: const Color(0xFFF3F4F6),
                  borderRadius: BorderRadius.circular(4.w),
                ),
                child: Center(
                  child: Text(
                    '設定対象のサイズを選択\n(タイプ)',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 13.sp, color: const Color(0xFF374151), fontWeight: FontWeight.w500),
                  ),
                ),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: Container(
                  height: 48.h,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: const Color(0xFFD1D5DB)),
                    borderRadius: BorderRadius.circular(4.w),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _selectedType,
                      isExpanded: true,
                      dropdownColor: Colors.white,
                      padding: EdgeInsets.symmetric(horizontal: 12.w),
                      icon: Icon(Icons.keyboard_arrow_down, color: const Color(0xFF6B7280)),
                      items: _types.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value, style: TextStyle(fontSize: 14.sp, color: Colors.black87)),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        if (newValue != null) {
                          setState(() => _selectedType = newValue);
                        }
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 24.h),
        if (_selectedType == 'タブ')
          _buildTabSettings()
        else if (_selectedType.startsWith('メニューボタン') && _selectedType.contains('連横'))
          _buildMultiMenuSettings()
        else
          _buildIndividualSettings(),
      ],
    );
  }

  Widget _buildIndividualSettings() {
    return FormCard(
      title: '個別設定',
      child: Column(
        children: [
          _buildFormRow(
            label: '名称',
            content: TextField(
              controller: _nameController,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                border: OutlineInputBorder(borderSide: const BorderSide(color: Color(0xFFD1D5DB)), borderRadius: BorderRadius.circular(4.w)),
                enabledBorder: OutlineInputBorder(borderSide: const BorderSide(color: Color(0xFFD1D5DB)), borderRadius: BorderRadius.circular(4.w)),
              ),
              style: TextStyle(fontSize: 14.sp),
            ),
          ),
          _buildFormRow(
            label: 'サイズ (縦 x 横)',
            content: Row(
              children: [
                Text('縦 ', style: TextStyle(fontSize: 14.sp, color: const Color(0xFF374151))),
                _buildNumberInput(_heightController),
                SizedBox(width: 16.w),
                Text(' x ', style: TextStyle(fontSize: 14.sp, color: const Color(0xFF374151))),
                SizedBox(width: 16.w),
                Text('横 ', style: TextStyle(fontSize: 14.sp, color: const Color(0xFF374151))),
                _buildNumberInput(_widthController),
              ],
            ),
          ),
          _buildFormRow(
            label: '名称表示設定 *',
            content: Row(
              children: [
                _buildRadioSetting('名称（正）', _nameDisplaySetting, (v) => setState(() => _nameDisplaySetting = v!)),
                SizedBox(width: 24.w),
                _buildRadioSetting('略称', _nameDisplaySetting, (v) => setState(() => _nameDisplaySetting = v!)),
              ],
            ),
            isMandatory: true,
          ),
          _buildFormRow(
            label: '背景色',
            content: _buildColorInput(_bgColorController),
          ),
          _buildFormRow(
            label: 'フォント色',
            content: _buildColorInput(_fontColorController),
          ),
          _buildFormRow(
            label: '文字サイズ',
            content: _buildDropdownInput(_fontSize, _fontSizes, (v) => setState(() => _fontSize = v!)),
          ),
          if (_selectedType == 'メニューボタン(横)')
            _buildFormRow(
              label: '画面遷移先設定',
              content: _buildDropdownInput(_transitionDestination, _destinations, (v) => setState(() => _transitionDestination = v!)),
            ),
          if (_selectedType == 'メニューボタン小' || _selectedType == 'メニューボタン大' || _selectedType.startsWith('カテゴリボタン'))
            _buildFormRow(
              label: '画像表示指定',
              content: Row(
                children: [
                  _buildRadioSetting('なし', _imageDisplaySetting, (v) => setState(() => _imageDisplaySetting = v!)),
                  SizedBox(width: 16.w),
                  _buildRadioSetting('全体', _imageDisplaySetting, (v) => setState(() => _imageDisplaySetting = v!)),
                  if (!_selectedType.startsWith('カテゴリボタン')) ...[
                    SizedBox(width: 16.w),
                    _buildRadioSetting('一部', _imageDisplaySetting, (v) => setState(() => _imageDisplaySetting = v!)),
                  ],
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildMultiMenuSettings() {
    return Column(
      children: [
        FormCard(
          title: '個別設定',
          child: Column(
            children: [
              _buildFormRow(
                label: '名称',
                content: TextField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                    border: OutlineInputBorder(borderSide: const BorderSide(color: Color(0xFFD1D5DB)), borderRadius: BorderRadius.circular(4.w)),
                    enabledBorder: OutlineInputBorder(borderSide: const BorderSide(color: Color(0xFFD1D5DB)), borderRadius: BorderRadius.circular(4.w)),
                  ),
                  style: TextStyle(fontSize: 14.sp),
                ),
              ),
              _buildFormRow(
                label: 'サイズ (縦 x 横)',
                content: Row(
                  children: [
                    Text('縦 ', style: TextStyle(fontSize: 14.sp, color: const Color(0xFF374151))),
                    _buildNumberInput(_heightController),
                    SizedBox(width: 16.w),
                    Text(' x ', style: TextStyle(fontSize: 14.sp, color: const Color(0xFF374151))),
                    SizedBox(width: 16.w),
                    Text('横 ', style: TextStyle(fontSize: 14.sp, color: const Color(0xFF374151))),
                    _buildNumberInput(_widthController),
                  ],
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 16.h),
        FormCard(
          title: 'カテゴリ設定',
          child: Column(
            children: [
              _buildFormRow(
                label: '画像表示指定',
                content: Row(
                  children: [
                    _buildRadioSetting('なし', _imageDisplaySetting, (v) => setState(() => _imageDisplaySetting = v!)),
                    SizedBox(width: 16.w),
                    _buildRadioSetting('全体', _imageDisplaySetting, (v) => setState(() => _imageDisplaySetting = v!)),
                  ],
                ),
              ),
              _buildFormRow(
                label: '背景色',
                content: _buildColorInput(_bgColorController),
              ),
              _buildFormRow(
                label: 'フォント色',
                content: _buildColorInput(_fontColorController),
              ),
              _buildFormRow(
                label: '文字サイズ',
                content: _buildDropdownInput(_fontSize, _fontSizes, (v) => setState(() => _fontSize = v!)),
              ),
            ],
          ),
        ),
        SizedBox(height: 16.h),
        FormCard(
          title: 'メニュー設定',
          child: Column(
            children: [
              _buildFormRow(
                label: '名称表示設定',
                content: Row(
                  children: [
                    _buildRadioSetting('名称（正）', _nameDisplaySetting, (v) => setState(() => _nameDisplaySetting = v!)),
                    SizedBox(width: 24.w),
                    _buildRadioSetting('略称', _nameDisplaySetting, (v) => setState(() => _nameDisplaySetting = v!)),
                  ],
                ),
              ),
              _buildFormRow(
                label: '背景色',
                content: _buildColorInput(_bgColorController),
              ),
              _buildFormRow(
                label: 'フォント色',
                content: _buildColorInput(_fontColorController),
              ),
              _buildFormRow(
                label: '文字サイズ',
                content: _buildDropdownInput(_fontSize, _fontSizes, (v) => setState(() => _fontSize = v!)),
              ),
              _buildFormRow(
                label: 'サイズ (縦 x 横)',
                content: Row(
                  children: [
                    Text('縦 ', style: TextStyle(fontSize: 14.sp, color: const Color(0xFF374151))),
                    _buildNumberInput(_heightController),
                    SizedBox(width: 16.w),
                    Text(' x ', style: TextStyle(fontSize: 14.sp, color: const Color(0xFF374151))),
                    SizedBox(width: 16.w),
                    Text('横 ', style: TextStyle(fontSize: 14.sp, color: const Color(0xFF374151))),
                    _buildNumberInput(_widthController),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTabSettings() {
    return FormCard(
      title: 'タブ設定',
      child: Column(
        children: [
          _buildFormRow(
            label: '名称',
            content: TextField(
              controller: _nameController,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                border: OutlineInputBorder(borderSide: const BorderSide(color: Color(0xFFD1D5DB)), borderRadius: BorderRadius.circular(4.w)),
                enabledBorder: OutlineInputBorder(borderSide: const BorderSide(color: Color(0xFFD1D5DB)), borderRadius: BorderRadius.circular(4.w)),
              ),
              style: TextStyle(fontSize: 14.sp),
            ),
          ),
          _buildFormRow(
            label: 'サイズ (縦 x 横)',
            content: Row(
              children: [
                Text('縦 ', style: TextStyle(fontSize: 14.sp, color: const Color(0xFF374151))),
                _buildNumberInput(_heightController),
                SizedBox(width: 16.w),
                Text(' x ', style: TextStyle(fontSize: 14.sp, color: const Color(0xFF374151))),
                SizedBox(width: 16.w),
                Text('横 ', style: TextStyle(fontSize: 14.sp, color: const Color(0xFF374151))),
                _buildNumberInput(_widthController),
              ],
            ),
          ),
          _buildFormRow(
            label: '背景色',
            content: _buildColorInput(_bgColorController),
          ),
          _buildFormRow(
            label: 'フォント色',
            content: _buildColorInput(_fontColorController),
          ),
          _buildFormRow(
            label: '文字サイズ',
            content: _buildDropdownInput(_fontSize, _fontSizes, (v) => setState(() => _fontSize = v!)),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownInput(String value, List<String> items, ValueChanged<String?> onChanged) {
    return Container(
      height: 40.h,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFD1D5DB)),
        borderRadius: BorderRadius.circular(4.w),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          dropdownColor: Colors.white,
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          icon: Icon(Icons.keyboard_arrow_down, color: const Color(0xFF6B7280)),
          items: items.map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value, style: TextStyle(fontSize: 14.sp, color: Colors.black87)),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _buildFormRow({required String label, required Widget content, bool isMandatory = false}) {
    return Container(
      margin: EdgeInsets.only(bottom: 8.h),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              width: 150.w,
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              decoration: const BoxDecoration(
                color: Color(0xFFF3F4F6),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      label.replaceAll(' *', ''),
                      style: TextStyle(fontSize: 13.sp, color: const Color(0xFF374151), fontWeight: FontWeight.w500),
                    ),
                  ),
                  if (isMandatory)
                    Text(' *', style: TextStyle(fontSize: 13.sp, color: Colors.red)),
                ],
              ),
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                alignment: Alignment.centerLeft,
                child: content,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNumberInput(TextEditingController controller) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        InkWell(
          onTap: () {
            int val = int.tryParse(controller.text) ?? 0;
            if (val > 0) val--;
            controller.text = val.toString();
          },
          child: Container(
            width: 32.w,
            height: 38.h,
            decoration: BoxDecoration(
              color: const Color(0xFFE5E7EB),
              border: Border.all(color: const Color(0xFFD1D5DB)),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(4.w),
                bottomLeft: Radius.circular(4.w),
              ),
            ),
            child: const Icon(Icons.remove, size: 16, color: Color(0xFF374151)),
          ),
        ),
        Container(
          width: 50.w,
          height: 38.h,
          decoration: const BoxDecoration(
            color: Colors.white,
            border: Border.symmetric(
              horizontal: BorderSide(color: Color(0xFFD1D5DB)),
            ),
          ),
          child: Center(
            child: TextField(
              controller: controller,
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.zero,
                isDense: true,
              ),
              style: TextStyle(fontSize: 14.sp, color: const Color(0xFF374151), fontWeight: FontWeight.bold),
            ),
          ),
        ),
        InkWell(
          onTap: () {
            int val = int.tryParse(controller.text) ?? 0;
            val++;
            controller.text = val.toString();
          },
          child: Container(
            width: 32.w,
            height: 38.h,
            decoration: BoxDecoration(
              color: const Color(0xFFE5E7EB),
              border: Border.all(color: const Color(0xFFD1D5DB)),
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(4.w),
                bottomRight: Radius.circular(4.w),
              ),
            ),
            child: const Icon(Icons.add, size: 16, color: Color(0xFF374151)),
          ),
        ),
      ],
    );
  }

  Widget _buildRadioSetting(String title, String groupValue, ValueChanged<String?> onChanged) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Radio<String>(
          value: title,
          groupValue: groupValue,
          onChanged: onChanged,
          activeColor: const Color(0xFF1D4ED8),
          visualDensity: VisualDensity.compact,
        ),
        Text(title, style: TextStyle(fontSize: 14.sp, color: const Color(0xFF374151))),
      ],
    );
  }

  Widget _buildColorInput(TextEditingController controller) {
    return InkWell(
      onTap: () => _showColorPicker(controller),
      child: Container(
        height: 40.h,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: const Color(0xFFD1D5DB)),
          borderRadius: BorderRadius.circular(4.w),
        ),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                enabled: false,
                controller: controller,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(horizontal: 12.w),
                  border: InputBorder.none,
                ),
                style: TextStyle(fontSize: 14.sp, color: const Color(0xFF374151)),
              ),
            ),
            Container(
              width: 24.w,
              height: 24.w,
              margin: EdgeInsets.only(right: 8.w),
              decoration: BoxDecoration(
                color: _getColorFromHex(controller.text),
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFFE5E7EB)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPreviewSection() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(8.w),
      ),
      padding: EdgeInsets.all(24.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 4.w,
                height: 14.h,
                decoration: BoxDecoration(
                  color: const Color(0xFF059669),
                  borderRadius: BorderRadius.circular(2.w),
                ),
              ),
              SizedBox(width: 8.w),
              Text(
                'プレビュー用',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF111827),
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          const Divider(height: 1, color: Color(0xFFE5E7EB)),
          SizedBox(height: 16.h),
          AspectRatio(
            aspectRatio: 1.5,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: const Color(0xFFD1D5DB), width: 2),
                borderRadius: BorderRadius.circular(16.w),
              ),
              child: Center(
                child: Icon(
                  Icons.image_outlined,
                  size: 64.sp,
                  color: const Color(0xFFD1D5DB),
                ),
              ),
            ),
          ),
        ],
      ),
    );
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
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 14.h),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.w)),
            ),
            child: Text('キャンセル', style: TextStyle(fontSize: 14.sp)),
          ),
          SizedBox(width: 12.w),
          ElevatedButton(
            onPressed: _onSave,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1D4ED8),
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 40.w, vertical: 14.h),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.w)),
            ),
            child: Text('保存', style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}
