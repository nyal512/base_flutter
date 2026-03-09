import 'package:flutter/material.dart';
import '../../../core/di/injection_container.dart';
import '../../widgets/widgets.dart';
import '../../../core/utils/responsive_utils.dart';
import 'view_model/summary_time_view_model.dart';

class SummaryTimeScreen extends StatefulWidget {
  const SummaryTimeScreen({super.key});

  @override
  State<SummaryTimeScreen> createState() => _SummaryTimeScreenState();
}

class _SummaryTimeScreenState extends State<SummaryTimeScreen> {
  late final SummaryTimeViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = sl<SummaryTimeViewModel>()..init();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _viewModel,
      builder: (context, _) {
        return Form(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: SingleChildScrollView(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: ConstrainedBox(
                constraints: BoxConstraints(minWidth: 1040.w),
                child: Padding(
                  padding: EdgeInsets.all(16.w),
                  child: FormCard(
                    title: '番号',
                    child: Padding(
                      padding: EdgeInsets.only(top: 8.h),
                      child: Wrap(
                        spacing: 12.w,
                        runSpacing: 8.h,
                        children: List.generate(4, (colIndex) {
                          return SizedBox(
                            width: 240.w,
                            child: Column(
                              children: List.generate(6, (rowIndex) {
                                final index = colIndex * 6 + rowIndex;
                                return _buildTimeSlotRow(index);
                              }),
                            ),
                          );
                        }),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTimeBox(String hour, String minute, int index, bool isEnd) {
    return Container(
      width: 78.w,
      height: 32.h,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFD1D5DB)),
        borderRadius: BorderRadius.circular(6.w),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildDropdown(hour, _hours, () => _viewModel.setSelectedSlot(index), 
              (v) => _viewModel.updateSlot(index, sh: !isEnd ? v : null, eh: isEnd ? v : null)),
          Text(':', style: TextStyle(fontSize: 12.sp, color: const Color(0xFF374151))),
          _buildDropdown(minute, _minutes, () => _viewModel.setSelectedSlot(index), 
              (v) => _viewModel.updateSlot(index, sm: !isEnd ? v : null, em: isEnd ? v : null)),
        ],
      ),
    );
  }

  Widget _buildDropdown(String value, List<String> items, VoidCallback onTap, ValueChanged<String?> onChanged) {
    return SizedBox(
      width: 30.w,
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          onTap: onTap,
          alignment: Alignment.center,
          items: items.map((String item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Center(
                child: Text(
                  item,
                  style: TextStyle(fontSize: 12.sp, color: const Color(0xFF374151)),
                ),
              ),
            );
          }).toList(),
          onChanged: onChanged,
          icon: const SizedBox.shrink(),
          isExpanded: true,
          dropdownColor: Colors.white,
          borderRadius: BorderRadius.circular(4.w),
          menuMaxHeight: 300.h,
        ),
      ),
    );
  }

  // Helper lists for dropdowns
  final List<String> _hours = List.generate(24, (i) => i.toString().padLeft(2, '0'));
  final List<String> _minutes = List.generate(60, (i) => i.toString().padLeft(2, '0'));

  Widget _buildTimeSlotRow(int index) {
    final slot = _viewModel.timeSlots[index];
    final label = '区分${(index + 1).toString().padLeft(2, '0')}';
    final isSelected = _viewModel.selectedSlotIndex == index;
    
    return Container(
      height: 42.h,
      margin: EdgeInsets.only(bottom: 2.h),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFE5E7EB)),
        borderRadius: BorderRadius.circular(4.w),
      ),
      child: Row(
        children: [
          Container(
            width: 60.w,
            height: double.infinity,
            decoration: BoxDecoration(
              color: const Color(0xFFF3F4F6),
              border: isSelected 
                ? Border.all(color: const Color(0xFF8B5CF6), width: 1.5)
                : const Border(right: BorderSide(color: Color(0xFFE5E7EB))),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(3.w),
                bottomLeft: Radius.circular(3.w),
              ),
            ),
            alignment: Alignment.center,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 12.sp, 
                color: const Color(0xFF374151),
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildTimeBox(slot.startHour, slot.startMinute, index, false),
                  Text('-', style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.bold, color: Colors.grey)),
                  _buildTimeBox(slot.endHour, slot.endMinute, index, true),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
