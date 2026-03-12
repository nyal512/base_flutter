import 'package:flutter/material.dart';
import '../../../core/di/injection_container.dart';
import '../../../core/utils/responsive_utils.dart';
import 'view_model/menu_button_master_view_model.dart';
import 'widgets/confirm_delete_dialog.dart';
import 'widgets/menu_button_master_settings_dialog.dart';

class MenuButtonMasterScreen extends StatefulWidget {
  const MenuButtonMasterScreen({super.key});

  @override
  State<MenuButtonMasterScreen> createState() => _MenuButtonMasterScreenState();
}

class _MenuButtonMasterScreenState extends State<MenuButtonMasterScreen> {
  late final MenuButtonMasterViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = sl<MenuButtonMasterViewModel>()..init();
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
                  'メニューボタンマスター',
                  style: TextStyle(
                    fontSize: 22.sp,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF111827),
                  ),
                ),
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
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.w),
        border: Border.all(color: const Color(0xFFE5E7EB)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 2),
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
          Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFFE5E7EB)),
              borderRadius: BorderRadius.circular(8.w),
            ),
            child: Icon(Icons.power_settings_new_outlined, size: 20.sp, color: const Color(0xFF374151)),
          ),
        ],
      ),
    );
  }

  Widget _buildTableSection() {
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
                    'メニューボタン一覧',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF111827),
                    ),
                  ),
                ],
              ),
              OutlinedButton.icon(
                onPressed: () async {
                  final newItem = await showDialog<MenuButtonItem>(
                    context: context,
                    builder: (context) => const MenuButtonMasterSettingsDialog(),
                  );
                  if (newItem != null && context.mounted) {
                    _viewModel.addMenuItem(newItem);
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
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: ConstrainedBox(
                  constraints: BoxConstraints(minWidth: 600.w),
                  child: Table(
                    columnWidths: const {
                      0: FixedColumnWidth(50),
                      1: FlexColumnWidth(4),
                      2: FlexColumnWidth(1.2),
                      3: FlexColumnWidth(1.8),
                      4: FlexColumnWidth(2),
                      5: FixedColumnWidth(120),
                    },
                    defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                    children: [
                      _buildTableHeader(),
                      ..._viewModel.menuItems.map((item) => _buildTableRow(item)),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  TableRow _buildTableHeader() {
    return TableRow(
      decoration: const BoxDecoration(color: Color(0xFFF9FAFB)),
      children: [
        _buildHeaderCell('No.'),
        _buildHeaderCell('名称'),
        _buildHeaderCell('画像'),
        _buildHeaderCell('サイズ'),
        _buildHeaderCell('タイプ'),
        _buildHeaderCell('操作'),
      ],
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

  TableRow _buildTableRow(MenuButtonItem item) {
    return TableRow(
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFFE5E7EB))),
      ),
      children: [
        _buildCell(item.no.toString()),
        _buildCell(item.name),
        _buildCell(item.image),
        _buildCell(item.size),
        _buildCell(item.type),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                onPressed: () async {
                  final updatedItem = await showDialog<MenuButtonItem>(
                    context: context,
                    builder: (context) => MenuButtonMasterSettingsDialog(initialItem: item),
                  );
                  if (updatedItem != null && context.mounted) {
                    _viewModel.updateMenuItem(updatedItem);
                  }
                },
                icon: const Icon(Icons.edit_outlined, size: 18, color: Colors.blue),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
              SizedBox(width: 6.w),
              IconButton(
                onPressed: () async {
                  final confirm = await showDialog<bool>(
                    context: context,
                    builder: (context) => const ConfirmDeleteDialog(),
                  );
                  if (confirm == true && context.mounted) {
                    _viewModel.onDelete(item.no);
                  }
                },
                icon: const Icon(Icons.delete_outline, size: 18, color: Colors.red),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
              SizedBox(width: 6.w),
              IconButton(
                onPressed: () => _viewModel.onView(item.no),
                icon: const Icon(Icons.visibility_outlined, size: 18, color: Color(0xFF6B7280)),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
        ),
      ],
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
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFFF9FAFB),
                border: Border.all(color: const Color(0xFFE5E7EB)),
                borderRadius: BorderRadius.circular(8.w),
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

  Widget _buildFooter() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        OutlinedButton(
          onPressed: () => _viewModel.onAddToFavorites(),
          style: OutlinedButton.styleFrom(
            foregroundColor: const Color(0xFF1D4ED8),
            side: const BorderSide(color: Color(0xFF1D4ED8)),
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 14.h),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6.w)),
          ),
          child: Text('お気に入り登録', style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold)),
        ),
        SizedBox(width: 12.w),
        ElevatedButton(
          onPressed: () => _viewModel.onSave(),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF0F1ED2),
            foregroundColor: Colors.white,
            padding: EdgeInsets.symmetric(horizontal: 40.w, vertical: 14.h),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6.w)),
          ),
          child: Text('保存', style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }
}
