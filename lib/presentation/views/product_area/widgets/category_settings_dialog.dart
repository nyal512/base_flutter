import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/utils/responsive_utils.dart';
import '../view_model/product_area_view_model.dart';
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;

class CategorySettingsDialog extends StatefulWidget {
  final CategoryItem? initialItem;

  const CategorySettingsDialog({super.key, this.initialItem});

  @override
  State<CategorySettingsDialog> createState() => _CategorySettingsDialogState();
}

class _CategorySettingsDialogState extends State<CategorySettingsDialog> {
  late TextEditingController _bgColorController;
  late TextEditingController _fontColorController;

  String? _selectedCategoryName;
  String? _selectedButtonType;
  String _selectedTransition = '商品選択画面';
  String _fontSize = '18px';

  String? _imageUrlJp;
  String? _imageUrlEn;
  String? _imageUrlCn;
  String? _imageUrlKr;

  final List<String> _categoryNames = [
    'おにぎり',
    '弁当',
    '丼もの',
    '定食',
    '中華単品',
    '麺類',
    'カレー',
    '冷凍食品',
    '和菓子',
  ];

  final List<String> _buttonTypes = [
    'カテゴリボタン大',
    'カテゴリボタン横(長)',
    'カテゴリボタン縦(長)',
    'カテゴリボタン特大',
  ];

  final List<String> _transitions = [
    '商品選択画面',
    '注文確認画面',
  ];

  final List<String> _fontSizes = ['14px', '16px', '18px', '20px', '24px'];

  @override
  void initState() {
    super.initState();
    _bgColorController = TextEditingController(text: widget.initialItem?.backgroundColor ?? '#FFFFFF');
    _fontColorController = TextEditingController(text: widget.initialItem?.fontColor ?? '#000000');
    _fontSize = widget.initialItem?.fontSize ?? '18px';

    if (widget.initialItem != null) {
      _selectedCategoryName = widget.initialItem!.category;
      _selectedButtonType = widget.initialItem!.buttonType;
      _selectedTransition = widget.initialItem!.targetScreen;
      _imageUrlJp = widget.initialItem!.imageUrlJp;
      _imageUrlEn = widget.initialItem!.imageUrlEn;
      _imageUrlCn = widget.initialItem!.imageUrlCn;
      _imageUrlKr = widget.initialItem!.imageUrlKr;
    }
  }

  @override
  void dispose() {
    _bgColorController.dispose();
    _fontColorController.dispose();
    super.dispose();
  }

  void _onSave() {
    if (_selectedCategoryName == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('カテゴリ名を選択してください')),
      );
      return;
    }

    int widthSpan = 1;
    int heightSpan = 1;

    switch (_selectedButtonType) {
      case 'カテゴリボタン大':
        widthSpan = 1;
        heightSpan = 1;
        break;
      case 'カテゴリボタン横(長)':
        widthSpan = 2;
        heightSpan = 1;
        break;
      case 'カテゴリボタン縦(長)':
        widthSpan = 1;
        heightSpan = 2;
        break;
      case 'カテゴリボタン特大':
        widthSpan = 2;
        heightSpan = 2;
        break;
      default:
        widthSpan = 1;
        heightSpan = 1;
    }

    final newItem = CategoryItem(
      no: widget.initialItem?.no ?? DateTime.now().millisecondsSinceEpoch,
      image: '', // To be derived or removed if not needed anymore
      category: _selectedCategoryName!,
      buttonType: _selectedButtonType ?? 'カテゴリボタン大',
      status: widget.initialItem?.status ?? true,
      imageUrl: _imageUrlJp,
      imageUrlJp: _imageUrlJp,
      imageUrlEn: _imageUrlEn,
      imageUrlCn: _imageUrlCn,
      imageUrlKr: _imageUrlKr,
      fontSize: _fontSize,
      backgroundColor: _bgColorController.text,
      fontColor: _fontColorController.text,
      widthSpan: widthSpan,
      heightSpan: heightSpan,
      targetScreen: _selectedTransition,
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
        width: 1000.w, // Increased width to fit the grid better
        padding: EdgeInsets.zero,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.w),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildHeader(context),
            const Divider(height: 1, color: Color(0xFFE5E7EB)),
            Padding(
              padding: EdgeInsets.all(24.w),
              child: Column(
                children: [
                  // Section 1: Top Group
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: const Color(0xFFE5E7EB)),
                      borderRadius: BorderRadius.circular(4.w),
                    ),
                    child: IntrinsicHeight(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _buildLabelColumn(
                            labels: [
                              _LabelItem('カテゴリ名', isMandatory: true),
                              _LabelItem('ボタンタイプ'),
                              _LabelItem('画面遷移先画面'),
                            ],
                            width: 180.w,
                          ),
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.all(12.w),
                              child: Column(
                                children: [
                                  _buildDropdownInput(_selectedCategoryName, _categoryNames, (v) => setState(() => _selectedCategoryName = v!)),
                                  SizedBox(height: 12.h),
                                  _buildDropdownInput(_selectedButtonType, _buttonTypes, (v) => setState(() => _selectedButtonType = v!)),
                                  SizedBox(height: 12.h),
                                  _buildDropdownInput(_selectedTransition, _transitions, (v) => setState(() => _selectedTransition = v!)),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 24.h),
                  // Section 2: Bottom Group
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: const Color(0xFFE5E7EB)),
                      borderRadius: BorderRadius.circular(4.w),
                    ),
                    child: IntrinsicHeight(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _buildLabelColumn(
                            labels: [
                              _LabelItem('背景色'),
                              _LabelItem('文字サイズ'),
                              _LabelItem('画像'),
                            ],
                            width: 180.w,
                            // Last item (Image) needs more space
                            flexValues: [1, 1, 3],
                          ),
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.all(12.w),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Expanded(child: _buildColorInput(_bgColorController)),
                                      SizedBox(width: 12.w),
                                      Container(
                                        width: 120.w,
                                        height: 48.h,
                                        padding: EdgeInsets.symmetric(horizontal: 12.w),
                                        alignment: Alignment.centerLeft,
                                        decoration: const BoxDecoration(color: Color(0xFFF3F4F6)),
                                        child: Text('フォント色', style: TextStyle(fontSize: 13.sp, color: const Color(0xFF374151))),
                                      ),
                                      Expanded(child: _buildColorInput(_fontColorController)),
                                    ],
                                  ),
                                  SizedBox(height: 12.h),
                                  _buildDropdownInput(_fontSize, _fontSizes, (v) => setState(() => _fontSize = v!)),
                                  SizedBox(height: 12.h),
                                  Row(
                                    children: [
                                      _buildImagePickerItem('画像JP', _imageUrlJp, (url) => setState(() => _imageUrlJp = url), isMandatory: true),
                                      SizedBox(width: 8.w),
                                      _buildImagePickerItem('画像EN', _imageUrlEn, (url) => setState(() => _imageUrlEn = url)),
                                      SizedBox(width: 8.w),
                                      _buildImagePickerItem('画像CN', _imageUrlCn, (url) => setState(() => _imageUrlCn = url)),
                                      SizedBox(width: 8.w),
                                      _buildImagePickerItem('画像KR', _imageUrlKr, (url) => setState(() => _imageUrlKr = url)),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1, color: Color(0xFFE5E7EB)),
            _buildFooter(context),
          ],
        ),
      ),
    );
  }

  Widget _buildLabelColumn({required List<_LabelItem> labels, required double width, List<int>? flexValues}) {
    return Container(
      width: width,
      decoration: const BoxDecoration(
        color: Color(0xFFF3F4F6),
        border: Border(right: BorderSide(color: Color(0xFFE5E7EB))),
      ),
      child: Column(
        children: List.generate(labels.length, (index) {
          final item = labels[index];
          final flex = flexValues != null ? flexValues[index] : 1;
          return Expanded(
            flex: flex,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              alignment: Alignment.centerLeft,
              child: Row(
                children: [
                  Text(
                    item.text,
                    style: TextStyle(fontSize: 13.sp, color: const Color(0xFF374151), fontWeight: FontWeight.w500),
                  ),
                  if (item.isMandatory)
                    Text(' *', style: TextStyle(fontSize: 13.sp, color: Colors.red)),
                ],
              ),
            ),
          );
        }),
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
            widget.initialItem == null ? '登録／編集' : '編集',
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


  Widget _buildImagePickerItem(String label, String? imageUrl, ValueChanged<String?> onUpload, {bool isMandatory = false}) {
    bool isNetwork = imageUrl != null && (imageUrl.startsWith('http') || imageUrl.startsWith('https'));
    bool isFile = imageUrl != null && !isNetwork;

    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(label, style: TextStyle(fontSize: 12.sp, color: const Color(0xFF374151))),
              if (isMandatory) Text('*', style: TextStyle(fontSize: 12.sp, color: Colors.red)),
            ],
          ),
          SizedBox(height: 4.h),
          Container(
            height: 80.h,
            decoration: BoxDecoration(
              color: const Color(0xFFF3F4F6),
              borderRadius: BorderRadius.circular(4.w),
                image: imageUrl != null
                    ? DecorationImage(
                        image: isNetwork
                            ? NetworkImage(imageUrl)
                            : (kIsWeb ? NetworkImage(imageUrl) : FileImage(File(imageUrl))) as ImageProvider,
                        fit: BoxFit.cover,
                      )
                    : null,
            ),
            child: imageUrl == null
                ? Center(child: Icon(Icons.image_outlined, color: const Color(0xFF9CA3AF), size: 32.sp))
                : null,
          ),
          SizedBox(height: 8.h),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () async {
                try {
                  final ImagePicker picker = ImagePicker();
                  final XFile? image = await picker.pickImage(
                    source: ImageSource.gallery,
                    maxWidth: 1024,
                    maxHeight: 1024,
                    imageQuality: 85,
                  );
                  if (image != null) {
                    onUpload(image.path);
                  }
                } catch (e) {
                  debugPrint('Error picking image: $e');
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('画像の選択に失敗しました: $e')),
                    );
                  }
                }
              },
              icon: Icon(Icons.upload_outlined, size: 14.sp),
              label: Text('アップロード', style: TextStyle(fontSize: 12.sp)),
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFF374151),
                side: const BorderSide(color: Color(0xFFD1D5DB)),
                padding: EdgeInsets.symmetric(vertical: 8.h),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.w)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownInput(String? value, List<String> items, ValueChanged<String?> onChanged) {
    return Container(
      height: 48.h,
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
          hint: Text('選択してください', style: TextStyle(fontSize: 14.sp, color: const Color(0xFF9CA3AF))),
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
            child: Text('戻る', style: TextStyle(fontSize: 14.sp)),
          ),
          SizedBox(width: 12.w),
          ElevatedButton(
            onPressed: _onSave,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1D4ED8),
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 40.w, vertical: 14.h),
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

class _LabelItem {
  final String text;
  final bool isMandatory;

  _LabelItem(this.text, {this.isMandatory = false});
}
