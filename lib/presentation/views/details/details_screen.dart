import 'package:flutter/material.dart';
import '../../../core/di/injection_container.dart';
import '../../widgets/widgets.dart';
import '../../../core/utils/responsive_utils.dart';
import 'view_model/details_view_model.dart';

class DetailsScreen extends StatefulWidget {
  const DetailsScreen({super.key});

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  late final DetailsViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = sl<DetailsViewModel>()..init();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _viewModel,
      builder: (context, _) {
        return SingleChildScrollView(
          padding: EdgeInsets.all(24.w),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
               Expanded(
                 flex: 6,
                 child: _buildSettingsSection(),
               ),
               SizedBox(width: 24.w),
               Expanded(
                 flex: 4,
                 child: _buildPreviewSection(),
               ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSettingsSection() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.w),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
           Padding(
             padding: EdgeInsets.all(16.w),
             child: Text(
               '印字項目の選択',
               style: TextStyle(
                 fontSize: 14.sp,
                 fontWeight: FontWeight.bold,
                 color: const Color(0xFF1F2937),
               ),
             ),
           ),
           const Divider(height: 1, color: Color(0xFFE5E7EB)),
           Padding(
             padding: EdgeInsets.all(16.w),
             child: Column(
               children: [
                 _buildSwitchGrid(),
                 SizedBox(height: 16.h),
                 _buildRadioList(),
               ],
             ),
           ),
        ],
      ),
    );
  }

  Widget _buildSwitchGrid() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: _buildSwitchColumn(0, 4)),
        SizedBox(width: 16.w),
        Expanded(child: _buildSwitchColumn(4, 8)),
      ],
    );
  }

  Widget _buildSwitchColumn(int start, int end) {
    final items = _viewModel.switchLabels.sublist(start, end);
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4.w),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        children: List.generate(items.length, (index) {
          final realIndex = start + index;
          final isLast = index == items.length - 1;
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            decoration: BoxDecoration(
              border: isLast ? null : const Border(bottom: BorderSide(color: Color(0xFFE5E7EB))),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    items[index],
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: const Color(0xFF374151),
                    ),
                  ),
                ),
                AppSwitch(
                  value: _viewModel.switchFlags[realIndex],
                  onChanged: (val) => _viewModel.toggleSwitch(realIndex, val),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildRadioList() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4.w),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        children: List.generate(_viewModel.printSettings.length, (index) {
          final item = _viewModel.printSettings[index];
          final isLast = index == _viewModel.printSettings.length - 1;
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            decoration: BoxDecoration(
              border: isLast ? null : const Border(bottom: BorderSide(color: Color(0xFFE5E7EB))),
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Text(
                    item.label,
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: const Color(0xFF374151),
                    ),
                  ),
                ),
                Expanded(
                  flex: 5,
                  child: Row(
                    children: [
                      _buildRadioOption('印字する', PrintOption.print, item.selectedOption, (val) => _viewModel.updatePrintSetting(index, val)),
                      SizedBox(width: 8.w),
                      _buildRadioOption('印字しない', PrintOption.doNotPrint, item.selectedOption, (val) => _viewModel.updatePrintSetting(index, val)),
                      SizedBox(width: 8.w),
                      _buildRadioOption('0円しない', PrintOption.doNotPrintIfZeroYen, item.selectedOption, (val) => _viewModel.updatePrintSetting(index, val)),
                    ],
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildRadioOption(String label, PrintOption value, PrintOption groupValue, ValueChanged<PrintOption> onChanged) {
    return GestureDetector(
      onTap: () => onChanged(value),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Radio<PrintOption>(
            value: value,
            groupValue: groupValue,
            onChanged: (val) {
              if (val != null) onChanged(val);
            },
            activeColor: const Color(0xFF0F1ED2), // Based on mockup blue color
            fillColor: WidgetStateProperty.resolveWith<Color>((Set<WidgetState> states) {
              if (states.contains(WidgetState.selected)) {
                return const Color(0xFF0F1ED2);
              }
              return Colors.grey.shade400; // Unselected color
            }),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 12.sp,
              color: const Color(0xFF374151),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPreviewSection() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.w),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
           Padding(
             padding: EdgeInsets.all(16.w),
             child: Text(
               'Preview',
               style: TextStyle(
                 fontSize: 14.sp,
                 fontWeight: FontWeight.bold,
                 color: const Color(0xFF1F2937),
               ),
             ),
           ),
           const Divider(height: 1, color: Color(0xFFE5E7EB)),
           Padding(
             padding: EdgeInsets.all(16.w),
             // Assuming a fixed height to show the grey box properly, or aspect ratio.
             child: AspectRatio(
               aspectRatio: 3 / 4,
               child: Container(
                 decoration: BoxDecoration(
                   color: const Color(0xFFE5E7EB), // Grey background for preview
                   borderRadius: BorderRadius.circular(4.w),
                 ),
               ),
             ),
           ),
        ],
      ),
    );
  }
}
