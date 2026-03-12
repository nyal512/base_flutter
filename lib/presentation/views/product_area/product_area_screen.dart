import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import '../../../core/di/injection_container.dart';
import '../../../core/utils/responsive_utils.dart';
import 'view_model/product_area_view_model.dart';
import 'widgets/category_settings_dialog.dart';
import 'widgets/category_layout_dialog.dart';
import 'widgets/delete_confirmation_dialog.dart';
import 'widgets/tab_settings_dialog.dart';
import 'widgets/product_registration_dialog.dart';

class ProductAreaScreen extends StatefulWidget {
  const ProductAreaScreen({super.key});

  @override
  State<ProductAreaScreen> createState() => _ProductAreaScreenState();
}

class _ProductAreaScreenState extends State<ProductAreaScreen> {
  late final ProductAreaViewModel _viewModel;
  int _selectedTabIndex = 0;

  @override
  void initState() {
    super.initState();
    _viewModel = sl<ProductAreaViewModel>()..init();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _viewModel,
      builder: (context, _) {
        return Scaffold(
          backgroundColor: const Color(0xFFF3F4F6),
          body: Container(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                SizedBox(height: 16.h),
                Text(
                  '商品エリア',
                  style: TextStyle(
                    fontSize: 22.sp,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF111827),
                  ),
                ),
                SizedBox(height: 16.h),
                _buildTabs(),
                SizedBox(height: 16.h),
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(flex: 7, child: _buildTableSection()),
                      SizedBox(width: 20.w),
                      Expanded(flex: 4, child: _buildPreviewSection()),
                    ],
                  ),
                ),
                SizedBox(height: 16.h),
                _buildFooter(),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4.w),
        border: Border.all(color: const Color(0xFFE5E7EB)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.01),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        children: [
          Text(
            '読み込むファイル名',
            style: TextStyle(fontSize: 13.sp, color: const Color(0xFF374151), fontWeight: FontWeight.w500),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4.w),
                border: Border.all(color: const Color(0xFFD1D5DB)),
              ),
              child: Text(
                _viewModel.currentFileName,
                style: TextStyle(fontSize: 13.sp, color: const Color(0xFF6B7280)),
              ),
            ),
          ),
          SizedBox(width: 12.w),
          ElevatedButton(
            onPressed: () => _viewModel.onImportFile(),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF64748B),
              foregroundColor: Colors.white,
              elevation: 0,
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 14.h),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.w)),
            ),
            child: Text('ファイル取込', style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600)),
          ),
          SizedBox(width: 20.w),
          _buildActionIcon(Icons.power_settings_new_outlined),
        ],
      ),
    );
  }

  Widget _buildActionIcon(IconData icon) {
    return Container(
      padding: EdgeInsets.all(8.w),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFE5E7EB)),
        borderRadius: BorderRadius.circular(6.w),
      ),
      child: Icon(icon, size: 20.sp, color: const Color(0xFF374151)),
    );
  }

  Widget _buildTabs() {
    return Row(
      children: [
        _buildTabItem('カテゴリ設定', index: 0),
        SizedBox(width: 8.w),
        _buildTabItem('商品設定', index: 1),
        SizedBox(width: 8.w),
        _buildTabItem('アイテムエリア', index: 2),
      ],
    );
  }

  Widget _buildTabItem(String label, {required int index}) {
    bool isSelected = _selectedTabIndex == index;
    return InkWell(
      onTap: () => setState(() => _selectedTabIndex = index),
      child: Container(
        width: 320.w,
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(vertical: 12.h),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFEEF2FF) : Colors.white,
          borderRadius: BorderRadius.circular(4.w),
          border: isSelected ? Border.all(color: Colors.transparent) : null,
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 15.sp,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            color: isSelected ? const Color(0xFF1D4ED8) : const Color(0xFF6B7280),
          ),
        ),
      ),
    );
  }

  Widget _buildTableSection() {
    if (_selectedTabIndex == 0) {
      return _buildCategorySection();
    } else if (_selectedTabIndex == 1) {
      return _buildProductSection();
    } else {
      return _buildItemAreaSection();
    }
  }

  Widget _buildItemAreaSection() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.w),
        border: Border.all(color: const Color(0xFF4680FF), width: 2.w), // Highlighted border as in image
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: EdgeInsets.all(24.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildItemAreaSubSection(
            '縦',
            _viewModel.verticalBgColor,
            (color) => _viewModel.updateVerticalBgColor(color),
          ),
          SizedBox(height: 24.h),
          _buildItemAreaSubSection(
            '横',
            _viewModel.horizontalBgColor,
            (color) => _viewModel.updateHorizontalBgColor(color),
          ),
        ],
      ),
    );
  }

  Widget _buildItemAreaSubSection(String title, String bgColor, Function(String) onColorChanged) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFE5E7EB), style: BorderStyle.solid),
        borderRadius: BorderRadius.circular(4.w),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold, color: const Color(0xFF111827)),
          ),
          SizedBox(height: 12.h),
          Row(
            children: [
              Container(
                width: 140.w,
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                decoration: BoxDecoration(
                  color: const Color(0xFFF3F4F6),
                  borderRadius: BorderRadius.horizontal(left: Radius.circular(4.w)),
                ),
                child: Text(
                  '背景色',
                  style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.normal, color: const Color(0xFF374151)),
                ),
              ),
              Expanded(
                child: Container(
                  height: 48.h,
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  decoration: BoxDecoration(
                    border: Border.all(color: const Color(0xFFE5E7EB)),
                    borderRadius: BorderRadius.horizontal(right: Radius.circular(4.w)),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          bgColor,
                          style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.normal),
                        ),
                      ),
                      GestureDetector(
                        onTap: () => _showColorPickerForTab(bgColor, onColorChanged),
                        child: Container(
                          width: 20.w,
                          height: 20.w,
                          decoration: BoxDecoration(
                            color: _getColorFromHex(bgColor),
                            shape: BoxShape.circle,
                            border: Border.all(color: const Color(0xFFE5E7EB)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showColorPickerForTab(String initialColor, Function(String) onColorSelected) {
    Color pickerColor = _getColorFromHex(initialColor);
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
                onColorSelected('#${pickerColor.value.toRadixString(16).substring(2).toUpperCase()}');
                Navigator.of(context).pop();
              },
              child: const Text('決定'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildCategorySection() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.w),
        border: Border.all(color: const Color(0xFFE5E7EB)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: EdgeInsets.all(20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 4.w,
                    height: 14.h,
                    decoration: BoxDecoration(
                      color: const Color(0xFF1D4ED8),
                      borderRadius: BorderRadius.circular(2.w),
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    'カテゴリマスター一覧',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF111827),
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    '最大150件、${_viewModel.categories.length}件登録済みです。',
                    style: TextStyle(fontSize: 12.sp, color: const Color(0xFF6B7280)),
                  ),
                ],
              ),
              OutlinedButton.icon(
                onPressed: () async {
                  final newItem = await showDialog<CategoryItem>(
                    context: context,
                    builder: (context) => const CategorySettingsDialog(),
                  );
                  if (newItem != null && context.mounted) {
                    _viewModel.addCategory(newItem);
                  }
                },
                icon: const Icon(Icons.add, size: 18),
                label: Text('新規登録', style: TextStyle(fontSize: 14.sp)),
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFF374151),
                  side: const BorderSide(color: Color(0xFFD1D5DB)),
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6.w)),
                ),
              ),
            ],
          ),
          SizedBox(height: 24.h),
          Expanded(
            child: Column(
              children: [
                _buildTableHeaderRow(),
                Expanded(
                  child: ReorderableListView(
                    onReorder: _viewModel.reorderCategories,
                    buildDefaultDragHandles: false,
                    children: _viewModel.categories
                        .map((item) => _buildReorderableRow(item))
                        .toList(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductSection() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.w),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      padding: EdgeInsets.all(24.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: _viewModel.categories.where((c) => c.status).map((cat) {
                bool isSelected = _viewModel.selectedCategoryNo == cat.no;
                return Padding(
                  padding: EdgeInsets.only(right: 8.w),
                  child: InkWell(
                    onTap: () => _viewModel.selectCategory(cat.no),
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                      decoration: BoxDecoration(
                        color: isSelected ? const Color(0xFFEEF2FF) : const Color(0xFFF9FAFB),
                        borderRadius: BorderRadius.circular(4.w),
                        border: Border.all(color: isSelected ? const Color(0xFF1D4ED8) : const Color(0xFFE5E7EB)),
                      ),
                      child: Text(
                        cat.category,
                        style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          color: isSelected ? const Color(0xFF1D4ED8) : const Color(0xFF374151),
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          SizedBox(height: 24.h),
          Expanded(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16.w,
                mainAxisSpacing: 16.h,
                childAspectRatio: 1.5,
              ),
              itemCount: _viewModel.products.length,
              itemBuilder: (context, index) {
                final product = _viewModel.products[index];
                return Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.w),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12.w),
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            if (product.imageUrl != null)
                              Image.network(product.imageUrl!, fit: BoxFit.cover)
                            else
                              Container(color: const Color(0xFFF3F4F6)),
                            Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [Colors.transparent, Colors.black.withOpacity(0.7)],
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 16.h,
                              left: 16.w,
                              child: Text(
                                product.name,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 24.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      top: 8.h,
                      right: 8.w,
                      child: InkWell(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) => DeleteConfirmationDialog(
                              onConfirm: () => _viewModel.deleteProduct(product.id),
                            ),
                          );
                        },
                        child: Container(
                          padding: EdgeInsets.all(4.w),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(Icons.close, size: 18.sp, color: const Color(0xFF6B7280)),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductFooterButton(String label, {bool isOutlined = false, Color? color, VoidCallback? onPressed}) {
    final style = isOutlined
        ? OutlinedButton.styleFrom(
            foregroundColor: color ?? const Color(0xFF374151),
            side: BorderSide(color: color?.withOpacity(0.5) ?? const Color(0xFFD1D5DB)),
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 14.h),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.w)),
          )
        : ElevatedButton.styleFrom(
            backgroundColor: color ?? const Color(0xFF0F1ED2),
            foregroundColor: Colors.white,
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 14.h),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.w)),
            elevation: 0,
          );

    if (isOutlined) {
      return OutlinedButton(onPressed: onPressed ?? () {}, style: style, child: Text(label, style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold)));
    }
    return ElevatedButton(onPressed: onPressed ?? () {}, style: style, child: Text(label, style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold)));
  }

  Widget _buildTableHeaderRow() {
    return Container(
      color: const Color(0xFFF9FAFB),
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        children: [
          SizedBox(width: 40.w),
          _buildHeaderCellFlex('No.', 1),
          _buildHeaderCellFlex('画像', 1),
          _buildHeaderCellFlex('カテゴリ名', 4),
          _buildHeaderCellFlex('ボタンタイプ', 4),
          _buildHeaderCellFlex('Status', 2),
          SizedBox(width: 100.w, child: _buildHeaderCell('操作')),
        ],
      ),
    );
  }

  Widget _buildHeaderCellFlex(String text, int flex) {
    return Expanded(
      flex: flex,
      child: _buildHeaderCell(text),
    );
  }

  Widget _buildHeaderCell(String text) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12.sp,
          fontWeight: FontWeight.w600,
          color: const Color(0xFF6B7280),
        ),
      ),
    );
  }

  Widget _buildReorderableRow(CategoryItem item) {
    return Container(
      key: ValueKey(item.no),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFFE5E7EB))),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 40.w,
            child: ReorderableDragStartListener(
              index: _viewModel.categories.indexOf(item),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                child: Icon(Icons.drag_indicator, size: 20.sp, color: const Color(0xFFD1D5DB)),
              ),
            ),
          ),
          Expanded(flex: 1, child: _buildCell((_viewModel.categories.indexOf(item) + 1).toString())),
          Expanded(
            flex: 1,
            child: Padding(
              padding: EdgeInsets.all(4.w),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4.w),
                child: item.imageUrl != null && (item.imageUrl!.startsWith('http') || item.imageUrl!.startsWith('https'))
                    ? Image.network(
                        item.imageUrl!,
                        width: 40.w,
                        height: 40.w,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          color: const Color(0xFFF3F4F6),
                          child: Center(child: Text(item.image, style: TextStyle(fontSize: 24.sp))),
                        ),
                      )
                    : item.imageUrl != null
                        ? Image.file(
                            File(item.imageUrl!),
                            width: 40.w,
                            height: 40.w,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => Container(
                              color: const Color(0xFFF3F4F6),
                              child: Center(child: Text(item.image, style: TextStyle(fontSize: 24.sp))),
                            ),
                          )
                        : Container(
                            color: const Color(0xFFF3F4F6),
                            child: Center(child: Text(item.image, style: TextStyle(fontSize: 24.sp))),
                          ),
              ),
            ),
          ),
          Expanded(flex: 4, child: _buildCell(item.category)),
          Expanded(flex: 4, child: _buildCell(item.buttonType)),
          Expanded(
            flex: 2,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 0.w),
              child: Transform.scale(
                scale: 0.7,
                child: Switch(
                  value: item.status,
                  onChanged: (v) => _viewModel.toggleStatus(item.no),
                  activeThumbColor: Colors.white,
                  activeTrackColor: const Color(0xFF0F1ED2),
                  inactiveThumbColor: const Color(0xFF0F1ED2),
                  inactiveTrackColor: Colors.white,
                ),
              ),
            ),
          ),
          SizedBox(
            width: 100.w,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    onPressed: () async {
                      final updatedItem = await showDialog<CategoryItem>(
                        context: context,
                        builder: (context) => CategorySettingsDialog(initialItem: item),
                      );
                      if (updatedItem != null && context.mounted) {
                        _viewModel.updateCategory(updatedItem);
                      }
                    },
                    icon: const Icon(Icons.edit_outlined, size: 18, color: Color(0xFF1D4ED8)),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                  SizedBox(width: 8.w),
                  IconButton(
                    onPressed: () async {
                      showDialog(
                        context: context,
                        builder: (context) => DeleteConfirmationDialog(
                          onConfirm: () => _viewModel.onDeleteCategory(item.no),
                        ),
                      );
                    },
                    icon: const Icon(Icons.delete_outline, size: 18, color: Color(0xFFEF4444)),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCell(String text) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 13.sp,
          color: const Color(0xFF374151),
        ),
      ),
    );
  }

  Widget _buildPreviewSection() {
    bool isProductTab = _selectedTabIndex == 1;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.w),
        border: Border.all(color: const Color(0xFFE5E7EB)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: EdgeInsets.all(20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildPreviewHeader(isProductTab),
          SizedBox(height: 16.h),
          const Divider(height: 1, color: Color(0xFFE5E7EB)),
          SizedBox(height: 16.h),
          Expanded(
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                color: const Color(0xFFF9FAFB),
                border: Border.all(color: const Color(0xFFE5E7EB)),
                borderRadius: BorderRadius.circular(8.w),
              ),
              child: _selectedTabIndex == 2
                  ? _buildItemAreaPreview()
                  : (_selectedTabIndex == 1 ? _buildProductPreview() : _buildCategoryPreview()),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItemAreaPreview() {
    return Column(
      children: [
        Row(
          children: [
            Container(
              width: 4.w,
              height: 14.h,
              decoration: BoxDecoration(
                color: const Color(0xFF4680FF),
                borderRadius: BorderRadius.circular(2.w),
              ),
            ),
            SizedBox(width: 8.w),
            Text(
              'プレビュー用',
              style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold, color: const Color(0xFF111827)),
            ),
          ],
        ),
        SizedBox(height: 16.h),
        Expanded(
          child: Center(
            child: Image.network(
              'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?q=80&w=800&auto=format&fit=crop', // Placeholder for "Item Area" high-fi preview
              fit: BoxFit.contain,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPreviewHeader(bool isProductTab) {
    return InkWell(
      onTap: () async {
        if (!isProductTab) {
          final result = await showDialog<List<CategoryItem>>(
            context: context,
            builder: (context) => CategoryLayoutDialog(categories: _viewModel.categories),
          );
          if (result != null) {
            _viewModel.updateActiveCategoriesOrder(result);
          }
        }
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 4.w,
                height: 14.h,
                decoration: BoxDecoration(
                  color: _selectedTabIndex == 0
                      ? const Color(0xFF059669)
                      : (_selectedTabIndex == 1 ? const Color(0xFF4680FF) : const Color(0xFF4680FF)), // Blue for Item Area too
                  borderRadius: BorderRadius.circular(2.w),
                ),
              ),
              SizedBox(width: 8.w),
              Text(
                isProductTab ? '商品レイアウト' : 'プレビュー用',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF111827),
                ),
              ),
              if (!isProductTab) ...[
                SizedBox(width: 8.w),
                Icon(Icons.keyboard_arrow_right, size: 18.sp, color: const Color(0xFF6B7280)),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryPreview() {
    return Column(
      children: [
        Row(
          children: [
            Icon(Icons.arrow_back_ios, size: 12.sp, color: const Color(0xFF6B7280)),
            SizedBox(width: 4.w),
            Text('カテゴリーをお選びください。', style: TextStyle(fontSize: 12.sp, color: const Color(0xFF374151))),
          ],
        ),
        SizedBox(height: 8.h),
        Expanded(
          child: SingleChildScrollView(
            child: Wrap(
              spacing: 8.w,
              runSpacing: 8.h,
              children: _viewModel.categories
                  .where((c) => c.status)
                  .map((item) => _buildPreviewButton(item))
                  .toList(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProductPreview() {
    final selectedCat = _viewModel.categories.firstWhere((c) => c.no == _viewModel.selectedCategoryNo, orElse: () => _viewModel.categories.first);

    return Column(
      children: [
        Row(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
              decoration: BoxDecoration(
                color: _getColorFromHex(selectedCat.backgroundColor),
                borderRadius: BorderRadius.circular(4.w),
              ),
              child: Text(
                selectedCat.category,
                style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.bold, color: _getColorFromHex(selectedCat.fontColor)),
              ),
            ),
            SizedBox(width: 8.w),
            Text('の商品一覧', style: TextStyle(fontSize: 12.sp, color: const Color(0xFF6B7280))),
          ],
        ),
        SizedBox(height: 12.h),
        Expanded(
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 4.w,
              mainAxisSpacing: 4.h,
              childAspectRatio: 1.2,
            ),
            itemCount: _viewModel.products.length,
            itemBuilder: (context, index) {
              final product = _viewModel.products[index];
              return Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(4.w),
                  border: Border.all(color: const Color(0xFFE5E7EB)),
                ),
                child: Column(
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.vertical(top: Radius.circular(4.w)),
                        child: product.imageUrl != null
                            ? Image.network(product.imageUrl!, fit: BoxFit.cover, width: double.infinity)
                            : Container(color: const Color(0xFFF3F4F6)),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(2.w),
                      child: Text(
                        product.name,
                        style: TextStyle(fontSize: 8.sp, fontWeight: FontWeight.bold),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildPreviewButton(CategoryItem item) {
    final double unitWidth = 100.w;
    final double unitHeight = 80.h;
    final double spacing = 8.w;

    final double width = (unitWidth * item.widthSpan) + (spacing * (item.widthSpan - 1));
    final double height = (unitHeight * item.heightSpan) + (spacing * (item.heightSpan - 1));

    Color bgColor = _getColorFromHex(item.backgroundColor);
    Color fontColor = _getColorFromHex(item.fontColor);
    double fontSize = double.tryParse(item.fontSize.replaceAll('px', '')) ?? 14.0;

    return Opacity(
      opacity: item.status ? 1.0 : 0.6,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: item.status ? bgColor : Colors.white,
          borderRadius: BorderRadius.circular(8.w),
          border: Border.all(color: const Color(0xFFE5E7EB)),
        ),
        child: Stack(
          children: [
            if (item.status)
              ClipRRect(
                borderRadius: BorderRadius.circular(8.w),
                child: item.imageUrl != null && (item.imageUrl!.startsWith('http') || item.imageUrl!.startsWith('https'))
                    ? Image.network(
                        item.imageUrl!,
                        width: double.infinity,
                        height: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          color: const Color(0xFFF3F4F6),
                          child: Center(child: Text(item.image, style: TextStyle(fontSize: 40.sp))),
                        ),
                      )
                    : item.imageUrl != null
                        ? Image.file(
                            File(item.imageUrl!),
                            width: double.infinity,
                            height: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => Container(
                              color: const Color(0xFFF3F4F6),
                              child: Center(child: Text(item.image, style: TextStyle(fontSize: 40.sp))),
                            ),
                          )
                        : Container(
                            color: const Color(0xFFF3F4F6),
                            child: Center(child: Text(item.image, style: TextStyle(fontSize: 40.sp))),
                          ),
              )
            else
              Container(
                color: const Color(0xFFE5E7EB),
                width: double.infinity,
                height: double.infinity,
                child: Center(child: Icon(Icons.block, color: const Color(0xFF9CA3AF), size: 32.sp)),
              ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.w),
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    item.status ? Colors.black.withOpacity(0.6) : Colors.black.withOpacity(0.4),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 4.h,
              left: 4.w,
              right: 4.w,
              child: Text(
                item.category,
                style: TextStyle(
                  color: item.status ? fontColor : const Color(0xFFF3F4F6),
                  fontSize: fontSize.sp,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: item.heightSpan > 1 ? 2 : 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getColorFromHex(String hex) {
    if (!hex.startsWith('#')) return Colors.white;
    try {
      return Color(int.parse(hex.replaceFirst('#', '0xFF')));
    } catch (e) {
      return Colors.white;
    }
  }

  Widget _buildFooter() {
    if (_selectedTabIndex == 1 || _selectedTabIndex == 2) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          _buildProductFooterButton('商品追加', isOutlined: true, onPressed: () async {
            final selectedCat = _viewModel.categories.firstWhere((c) => c.no == _viewModel.selectedCategoryNo, orElse: () => _viewModel.categories.first);
            final result = await showDialog<ProductItem>(
              context: context,
              builder: (context) => ProductRegistrationDialog(categoryName: selectedCat.category),
            );
            if (result != null) {
              _viewModel.addProduct(result.copyWith(categoryNo: selectedCat.no));
            }
          }),
          SizedBox(width: 12.w),
          _buildProductFooterButton('タブ設定', isOutlined: true, color: const Color(0xFF1E40AF), onPressed: () async {
            final result = await showDialog<Map<String, dynamic>>(
              context: context,
              builder: (context) => const TabSettingsDialog(),
            );
            if (result != null) {
              _viewModel.updateTabSettings(result);
            }
          }),
          SizedBox(width: 12.w),
          _buildProductFooterButton('並び替え保存', color: const Color(0xFF0F1ED2)),
        ],
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        _buildProductFooterButton(
          '一括無効',
          isOutlined: true,
          onPressed: () {},
        ),
        SizedBox(width: 12.w),
        _buildProductFooterButton(
          'ファイル取込',
          isOutlined: true,
          onPressed: _viewModel.onImportFile,
        ),
        SizedBox(width: 12.w),
        _buildProductFooterButton(
          '保存',
          color: const Color(0xFF1D4ED8),
          onPressed: _viewModel.onSave,
        ),
      ],
    );
  }
}
