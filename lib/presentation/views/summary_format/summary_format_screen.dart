import 'package:flutter/material.dart';
import '../../../core/di/injection_container.dart';
import '../../widgets/widgets.dart';
import '../../../core/utils/responsive_utils.dart';
import 'view_model/summary_format_view_model.dart';

class SummaryFormatScreen extends StatefulWidget {
  const SummaryFormatScreen({super.key});

  @override
  State<SummaryFormatScreen> createState() => _SummaryFormatScreenState();
}

class _SummaryFormatScreenState extends State<SummaryFormatScreen> {
  late final SummaryFormatViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = sl<SummaryFormatViewModel>()..init();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _viewModel,
      builder: (context, _) {
        return SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(24.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FormCard(
                  title: '印字形式',
                  child: FormRow(
                    label: '印字形式',
                    showInfoIcon: true,
                    content: Row(
                      children: [
                        _buildRadio('メニュー別', 0),
                        _buildRadio('グループ別メニュー', 1),
                        _buildRadio('売れ筋', 2),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 24.h),
                FormCard(
                  title: '無操作時間', // Header from image says this, but items are summary options
                  child: Column(
                    children: [
                      _buildSwitch('グループ別集計', _viewModel.groupSummary, _viewModel.setGroupSummary),
                      _buildSwitch('時間帯別集計', _viewModel.timeSlotSummary, _viewModel.setTimeSlotSummary),
                      _buildSwitch('時間帯別グループ別集計', _viewModel.timeSlotGroupSummary, _viewModel.setTimeSlotGroupSummary),
                      _buildSwitch('入出金情報', _viewModel.depositWithdrawalInfo, _viewModel.setDepositWithdrawalInfo),
                      _buildSwitch('回収情報', _viewModel.collectionInfo, _viewModel.setCollectionInfo),
                      _buildSwitch('つり銭補充', _viewModel.changeReplenishment, _viewModel.setChangeReplenishment),
                      _buildSwitch('つり銭引出', _viewModel.changeWithdrawal, _viewModel.setChangeWithdrawal),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildRadio(String label, int value) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Radio<int>(
          value: value,
          groupValue: _viewModel.printFormat,
          onChanged: (v) => _viewModel.setPrintFormat(v!),
          activeColor: const Color(0xFF0F1ED2),
          visualDensity: VisualDensity.compact,
        ),
        Text(
          label,
          style: TextStyle(fontSize: 13.sp, color: const Color(0xFF374151)),
        ),
        SizedBox(width: 16.w),
      ],
    );
  }

  Widget _buildSwitch(String label, bool value, ValueChanged<bool> onChanged) {
    return FormSwitchRow(
      label: label,
      value: value,
      onChanged: onChanged,
      showInfoIcon: true,
    );
  }
}
