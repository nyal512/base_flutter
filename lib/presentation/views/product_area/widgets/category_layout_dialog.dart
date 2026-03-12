import 'package:flutter/material.dart';
import 'package:reorderables/reorderables.dart';
import 'dart:io';
import '../../../../core/utils/responsive_utils.dart';
import '../view_model/product_area_view_model.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class CategoryLayoutDialog extends StatefulWidget {
  final List<CategoryItem> categories;

  const CategoryLayoutDialog({super.key, required this.categories});

  @override
  State<CategoryLayoutDialog> createState() => _CategoryLayoutDialogState();
}

class _CategoryLayoutDialogState extends State<CategoryLayoutDialog> {
  late List<CategoryItem> _localCategories;

  @override
  void initState() {
    super.initState();
    // Initialize with only active categories for layout adjustment
    _localCategories = List.from(widget.categories.where((c) => c.status));
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.w)),
      child: Container(
        width: 1000.w,
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
                   _buildGridArea(),
                   SizedBox(height: 24.h),
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

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'カテゴリレイアウト調整',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF111827),
                ),
              ),
              Text(
                '長押ししてドラッグで配置をカスタマイズ',
                style: TextStyle(fontSize: 12.sp, color: const Color(0xFF6B7280)),
              ),
            ],
          ),
          InkWell(
            onTap: () => Navigator.of(context).pop(),
            child: Icon(Icons.close, size: 24.sp, color: const Color(0xFF6B7280)),
          ),
        ],
      ),
    );
  }

  Widget _buildGridArea() {
    return Container(
      width: 800.w,
      height: 480.h,
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        border: Border.all(color: const Color(0xFFE5E7EB)),
        borderRadius: BorderRadius.circular(8.w),
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: CustomPaint(
              painter: GridPainter(),
            ),
          ),
          ReorderableWrap(
            spacing: 8.w,
            runSpacing: 8.h,
            padding: EdgeInsets.all(16.w),
            needsLongPressDraggable: false, // Start drag immediately on mouse click
            onReorder: (oldIndex, newIndex) {
              setState(() {
                final item = _localCategories.removeAt(oldIndex);
                _localCategories.insert(newIndex, item);
              });
            },
            children: _localCategories.map((item) => _buildGridItem(item)).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildGridItem(CategoryItem item) {
    // Scaling for the 10x6 grid in the dialog
    // Total width available for grid content = 800.w - 32.w (padding) = 768.w
    // (unitWidth * 10) + (8.w * 9) = 768.w
    // unitWidth * 10 = 768.w - 72.w = 696.w
    // unitWidth = 69.6.w
    final double unitWidth = 69.6.w;
    final double unitHeight = 60.h;
    final double spacing = 8.w;

    final double width = (unitWidth * item.widthSpan) + (spacing * (item.widthSpan - 1));
    final double height = (unitHeight * item.heightSpan) + (spacing * (item.heightSpan - 1));

    return Container(
      key: ValueKey(item.no),
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.w),
        border: Border.all(color: const Color(0xFFE5E7EB)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material( // Added Material to avoid text style issues during drag
        color: Colors.transparent,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8.w),
          child: Stack(
            children: [
              _buildImage(item),
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
                bottom: 8.h,
                left: 8.w,
                right: 8.w,
                child: Text(
                  item.category,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: (11 * item.widthSpan).sp.clamp(10.sp, 14.sp),
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImage(CategoryItem item) {
    bool isNetwork = item.imageUrl != null && (item.imageUrl!.startsWith('http') || item.imageUrl!.startsWith('https'));
    
    if (item.imageUrl == null) {
      return Container(
        color: const Color(0xFFF3F4F6),
        child: Center(child: Text(item.image, style: TextStyle(fontSize: 24.sp))),
      );
    }

    return Image(
      image: isNetwork
          ? NetworkImage(item.imageUrl!)
          : (kIsWeb ? NetworkImage(item.imageUrl!) : FileImage(File(item.imageUrl!))) as ImageProvider,
      width: double.infinity,
      height: double.infinity,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) => Container(
        color: const Color(0xFFF3F4F6),
        child: Center(child: Text(item.image, style: TextStyle(fontSize: 24.sp))),
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
            onPressed: () => Navigator.of(context).pop(_localCategories),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4F46E5),
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 40.w, vertical: 14.h),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.w)),
              elevation: 0,
            ),
            child: Text('レイアウトを保存', style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}

class GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFE5E7EB)
      ..strokeWidth = 0.5;

    final double unitWidth = 69.6.w;
    final double unitHeight = 60.h;
    final double spacing = 8.w;
    final double startPadding = 16.w;

    for (var i = 0; i <= 10; i++) {
        double x = startPadding + i * (unitWidth + spacing);
        canvas.drawLine(Offset(x, 16.w), Offset(x, startPadding + 6 * (unitHeight + spacing)), paint);
    }
    for (var i = 0; i <= 6; i++) {
        double y = startPadding + i * (unitHeight + spacing);
        canvas.drawLine(Offset(startPadding, y), Offset(startPadding + 10 * (unitWidth + spacing), y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
