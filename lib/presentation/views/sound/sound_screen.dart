import 'package:flutter/material.dart';
import '../../../core/di/injection_container.dart';
import '../../widgets/widgets.dart';
import '../../../core/utils/responsive_utils.dart';
import 'view_model/sound_view_model.dart';

class SoundScreen extends StatefulWidget {
  const SoundScreen({super.key});

  @override
  State<SoundScreen> createState() => _SoundScreenState();
}

class _SoundScreenState extends State<SoundScreen> {
  late final SoundViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = sl<SoundViewModel>()..init();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _viewModel,
      builder: (context, _) {
        return SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(24.w),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: _buildBuzzerSection(),
                ),
                SizedBox(width: 24.w),
                Expanded(
                  child: _buildVoiceSection(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildBuzzerSection() {
    return FormCard(
      title: 'ブザー',
      child: Column(
        children: [
          _buildSwitchRow('締め時', _viewModel.isClosingBuzzer, _viewModel.setClosingBuzzer),
          _buildSwitchRow('出金時', _viewModel.isWithdrawalBuzzer, _viewModel.setWithdrawalBuzzer),
          _buildSwitchRow('発券時', _viewModel.isIssuanceBuzzer, _viewModel.setIssuanceBuzzer),
          _buildSwitchRow('エラー時', _viewModel.isErrorBuzzer, _viewModel.setErrorBuzzer),
        ],
      ),
    );
  }

  Widget _buildVoiceSection() {
    return FormCard(
      title: '音声',
      child: Column(
        children: [
          _buildSwitchRow('発券枚数', _viewModel.isTicketCountVoice, _viewModel.setTicketCountVoice),
          _buildSwitchRow('お釣り払出', _viewModel.isChangePayoutVoice, _viewModel.setChangePayoutVoice),
          _buildSwitchRow('お客様控え', _viewModel.isCustomerReceiptVoice, _viewModel.setCustomerReceiptVoice),
        ],
      ),
    );
  }

  Widget _buildSwitchRow(String label, bool value, ValueChanged<bool> onChanged) {
    return FormSwitchRow(
      label: label,
      value: value,
      onChanged: onChanged,
    );
  }
}
