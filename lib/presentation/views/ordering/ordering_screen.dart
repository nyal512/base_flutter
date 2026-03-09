import 'package:flutter/material.dart';
import '../../../../core/di/injection_container.dart';
import '../../widgets/widgets.dart';
import '../../../../core/utils/responsive_utils.dart';
import 'view_model/ordering_view_model.dart';
import '../../widgets/form_widgets.dart';

class OrderingScreen extends StatefulWidget {
  const OrderingScreen({super.key});

  @override
  State<OrderingScreen> createState() => _OrderingScreenState();
}

class _OrderingScreenState extends State<OrderingScreen> {
  late final OrderingViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = sl<OrderingViewModel>()..init();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _viewModel,
      builder: (context, _) {
        return Form(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(24.w),
            child: Column(
              children: [
                // Top section: Output Destinations
                FormCard(
                  title: 'Title', // As per mockups, it says "Title"
                  child: Column(
                    children: List.generate(7, (index) => _buildDestinationRow(index)),
                  ),
                ),
                SizedBox(height: 16.h),
                // Bottom section: Details and Preview
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 詳細 (Details)
                    Expanded(
                      flex: 5,
                      child: FormCard(
                        title: '詳細',
                        child: Column(
                          children: [
                            _buildRadioRow('印字形式', '一括', 0, '個別', 1, _viewModel.printFormat, _viewModel.setPrintFormat),
                            _buildRadioRow('連番種類', 'メニュー別連番', 0, '発券連番', 1, _viewModel.serialNumberType, _viewModel.setSerialNumberType),
                            _buildRadioRow('メニュー名文字サイズ', '大', 0, '標準', 1, _viewModel.menuNameFontSize, _viewModel.setMenuNameFontSize),
                            _buildRadioRow('連番文字サイズ', '大', 0, '標準', 1, _viewModel.serialNumberFontSize, _viewModel.setSerialNumberFontSize),
                            _buildRadioRow('連番号機付加', 'あり', 0, 'なし', 1, _viewModel.addSerialNumberMachine, _viewModel.setAddSerialNumberMachine),
                            FormRow(
                              label: '連番印字桁数',
                              showInfoIcon: false,
                              content: _buildDropdown(
                                value: _viewModel.serialNumberDigits,
                                items: _viewModel.serialNumberDigitsOptions,
                                onChanged: (v) => _viewModel.setSerialNumberDigits(v!),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(width: 16.w),
                    // プレビュー (Preview)
                    Expanded(
                      flex: 4,
                      child: FormCard(
                        title: 'プレビュー',
                        child: Container(
                          height: 250.h,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: const Color(0xFFE5E7EB),
                            borderRadius: BorderRadius.circular(4.w),
                          ),
                          // Empty box as per mockup
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDestinationRow(int index) {
    final dest = _viewModel.destinations[index];
    return FormRow(
      label: '出力先 ${index + 1}',
      showInfoIcon: false,
      content: Row(
        children: [
          // Switch and Text
          Row(
            children: [
              AppSwitch(
                value: dest.isConnected,
                onChanged: (val) => _viewModel.toggleConnection(index, val),
              ),
              SizedBox(width: 8.w),
              Text(
                '接続する子機の有無',
                style: TextStyle(fontSize: 12.sp, color: const Color(0xFF374151)),
              ),
            ],
          ),
          SizedBox(width: 24.w),
          // IP Address Custom Field
          Expanded(
            child: _buildTextFieldBox(
              hintText: 'ＩＰアドレス',
              value: dest.ipAddress,
              onChanged: (val) => _viewModel.setIpAddress(index, val),
              enabled: dest.isConnected,
            ),
          ),
          SizedBox(width: 16.w),
          // Port Number Custom Field
          Expanded(
            child: _buildTextFieldBox(
              hintText: 'ポート番号',
              value: dest.portNumber,
              onChanged: (val) => _viewModel.setPortNumber(index, val),
              enabled: dest.isConnected,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextFieldBox({
    required String hintText,
    required String value,
    required ValueChanged<String> onChanged,
    required bool enabled,
  }) {
    return Container(
      height: 36.h,
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      decoration: BoxDecoration(
        color: enabled ? Colors.white : const Color(0xFFF9FAFB),
        border: Border.all(color: const Color(0xFFE5E7EB)),
        borderRadius: BorderRadius.circular(4.w),
      ),
      alignment: Alignment.centerLeft,
      child: AppTextField(
        initialValue: value,
        hintText: hintText,
        onChanged: onChanged,
        enabled: enabled,
      ),
    );
  }

  Widget _buildRadioRow(String label, String opt1Label, int opt1Value, String opt2Label, int opt2Value, int groupValue, ValueChanged<int> onChanged) {
    return FormRow(
      label: label,
      showInfoIcon: false,
      content: Wrap(
        spacing: 24.w,
        runSpacing: 8.h,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          _buildRadio(opt1Label, opt1Value, groupValue, (v) => onChanged(v!)),
          _buildRadio(opt2Label, opt2Value, groupValue, (v) => onChanged(v!)),
        ],
      ),
    );
  }

  Widget _buildRadio<T>(String label, T value, T groupValue, ValueChanged<T?> onChanged) {
    return InkWell(
      onTap: () => onChanged(value),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Radio<T>(
            value: value,
            groupValue: groupValue,
            onChanged: onChanged,
            activeColor: const Color(0xFF0F1ED2),
            visualDensity: VisualDensity.compact,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          SizedBox(width: 8.w),
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

  Widget _buildDropdown({
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      width: 140.w,
      height: 36.h,
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFE5E7EB)),
        borderRadius: BorderRadius.circular(4.w),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          icon: Icon(Icons.keyboard_arrow_down, size: 16.w, color: const Color(0xFF9CA3AF)),
          items: items.map((String item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(
                item,
                style: TextStyle(fontSize: 12.sp, color: const Color(0xFF374151)),
              ),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}
