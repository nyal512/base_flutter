import 'package:flutter/material.dart';
import '../../core/utils/responsive_utils.dart';

class SaveTargetDialog extends StatefulWidget {
  const SaveTargetDialog({super.key});

  @override
  State<SaveTargetDialog> createState() => _SaveTargetDialogState();
}

class _SaveTargetDialogState extends State<SaveTargetDialog> {
  final List<Map<String, dynamic>> _targets = [
    {'label': '販売モード・販売方式', 'value': true},
    {'label': '入金金種', 'value': true},
    {'label': '入金制限', 'value': true},
    {'label': '号機', 'value': true},
    {'label': '発券連番', 'value': true},
    {'label': '集計様式', 'value': true},
    {'label': '集計時間帯', 'value': true},
    {'label': '操作印字', 'value': true},
    {'label': 'ネットワーク', 'value': true},
    {'label': 'オーダリング', 'value': true},
    {'label': 'FTP', 'value': true},
    {'label': '親子', 'value': true},
    {'label': '集計詳細', 'value': true},
    {'label': 'オプション', 'value': true},
  ];

  bool get _isAllSelected => _targets.every((t) => t['value'] == true);

  void _toggleAll(bool? value) {
    setState(() {
      for (var target in _targets) {
        target['value'] = value ?? false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.w)),
      child: Container(
        width: 700.w,
        padding: EdgeInsets.all(24.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '保存対象',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF374151),
                  ),
                ),
                Row(
                  children: [
                    Text(
                      'すべて選択',
                      style: TextStyle(fontSize: 14.sp, color: const Color(0xFF374151)),
                    ),
                    SizedBox(width: 8.w),
                    Checkbox(
                      value: _isAllSelected,
                      onChanged: _toggleAll,
                      activeColor: const Color(0xFF0F1ED2),
                        checkColor: Colors.white
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 16.h),
            Wrap(
              spacing: 12.w,
              runSpacing: 12.h,
              children: [
                _buildColumn(_targets.sublist(0, 5)),
                _buildColumn(_targets.sublist(5, 10)),
                _buildColumn(_targets.sublist(10)),
              ],
            ),
            SizedBox(height: 32.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildButton(
                  '戻る',
                  onPressed: () => Navigator.pop(context),
                  isOutline: true,
                ),
                SizedBox(width: 16.w),
                _buildButton(
                  '保存',
                  onPressed: () => Navigator.pop(context, true),
                  isOutline: false,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildColumn(List<Map<String, dynamic>> items) {
    return Container(
      width: 210.w,
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFE5E7EB)),
        borderRadius: BorderRadius.circular(8.w),
      ),
      child: Column(
        children: items.map((item) {
          final isLast = items.indexOf(item) == items.length - 1;
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: items.indexOf(item) % 2 == 0 ? Colors.white : const Color(0xFFF9FAFB),
              border: isLast ? null : const Border(bottom: BorderSide(color: Color(0xFFE5E7EB))),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  item['label'],
                  style: TextStyle(fontSize: 14.sp, color: const Color(0xFF374151)),
                ),
                SizedBox(
                  width: 24.w,
                  height: 24.h,
                  child: Checkbox(
                    value: item['value'],
                    onChanged: (val) {
                      setState(() {
                        item['value'] = val ?? false;
                      });
                    },
                    activeColor: const Color(0xFF0F1ED2),
                    checkColor: Colors.white,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildButton(String label, {required VoidCallback onPressed, required bool isOutline}) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(6.w),
      child: Container(
        width: 120.w,
        height: 45.h,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isOutline ? Colors.white : const Color(0xFF4263EB),
          borderRadius: BorderRadius.circular(6.w),
          border: isOutline ? Border.all(color: const Color(0xFFCCCCCC)) : null,
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.bold,
            color: isOutline ? const Color(0xFF374151) : Colors.white,
          ),
        ),
      ),
    );
  }
}

class SaveDataSetDialog extends StatefulWidget {
  const SaveDataSetDialog({super.key});

  @override
  State<SaveDataSetDialog> createState() => _SaveDataSetDialogState();
}

class _SaveDataSetDialogState extends State<SaveDataSetDialog> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.w)),
      child: Container(
        width: 400.w,
        padding: EdgeInsets.all(24.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '保存DataSet選択',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF374151),
              ),
            ),
            SizedBox(height: 16.h),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFFE5E7EB)),
                borderRadius: BorderRadius.circular(8.w),
              ),
              child: Column(
                children: List.generate(5, (index) {
                  final isLast = index == 4;
                  return InkWell(
                    onTap: () => setState(() => _selectedIndex = index),
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                      decoration: BoxDecoration(
                        border: isLast ? null : const Border(bottom: BorderSide(color: Color(0xFFE5E7EB))),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'DataSet${index + 1}',
                            style: TextStyle(fontSize: 14.sp, color: const Color(0xFF374151)),
                          ),
                          Radio<int>(
                            value: index,
                            groupValue: _selectedIndex,
                            onChanged: (val) => setState(() => _selectedIndex = val!),
                            activeColor: const Color(0xFF0F1ED2),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ),
            ),
            SizedBox(height: 32.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildButton(
                  '戻る',
                  onPressed: () => Navigator.pop(context),
                  isOutline: true,
                ),
                SizedBox(width: 16.w),
                _buildButton(
                  '保存',
                  onPressed: () => Navigator.pop(context, _selectedIndex),
                  isOutline: false,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildButton(String label, {required VoidCallback onPressed, required bool isOutline}) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(6.w),
      child: Container(
        width: 100.w,
        height: 40.h,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isOutline ? Colors.white : const Color(0xFF4263EB),
          borderRadius: BorderRadius.circular(6.w),
          border: isOutline ? Border.all(color: const Color(0xFFCCCCCC)) : null,
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.bold,
            color: isOutline ? const Color(0xFF374151) : Colors.white,
          ),
        ),
      ),
    );
  }
}
