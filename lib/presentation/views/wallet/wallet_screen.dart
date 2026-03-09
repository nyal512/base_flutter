import 'package:flutter/material.dart';
import '../../../core/di/injection_container.dart';
import '../../widgets/widgets.dart';
import '../../../core/utils/responsive_utils.dart';
import 'view_model/wallet_view_model.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  late final WalletViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = sl<WalletViewModel>()..init();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _viewModel,
      builder: (context, _) {
        return Form(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(24.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: _buildBanknotesSection()),
                      SizedBox(width: 24.w),
                      Expanded(child: _buildCoinsSection()),
                    ],
                  ),
                  SizedBox(height: 24.h),
                  _buildAdditionalLimitsSection(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildBanknotesSection() {
    return FormCard(
      title: '紙幣',
      child: Column(
        children: _viewModel.banknoteLimits.entries.map((entry) {
          return FormRow(
            label: entry.key.toString(),
            showInfoIcon: entry.key == 10000,
            content: _buildTextField(
              entry.value,
              '0 ～ 99 枚',
              (v) => _viewModel.setBanknoteLimit(entry.key, v),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildCoinsSection() {
    return FormCard(
      title: '硬貨',
      child: Column(
        children: _viewModel.coinLimits.entries.map((entry) {
          return FormRow(
            label: entry.key.toString(),
            showInfoIcon: entry.key == 500,
            content: _buildTextField(
              entry.value,
              '0 ～ 99 枚',
              (v) => _viewModel.setCoinLimit(entry.key, v),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildAdditionalLimitsSection() {
    return Container(
      width: 450.w, // Approximate width from design for the bottom section
      child: FormCard(
        title: '',
        child: Column(
          children: [
            FormRow(
              label: '硬貨入金合計枚数',
              showInfoIcon: true,
              content: _buildTextField(
                _viewModel.totalCoinLimit,
                '0 ～ 99 枚',
                (v) => _viewModel.setTotalCoinLimit(v),
              ),
            ),
            FormRow(
              label: '最大入金額',
              showInfoIcon: true,
              content: _buildTextField(
                _viewModel.maxDepositAmount,
                '10 ～ 200000 円',
                (v) => _viewModel.setMaxDepositAmount(v),
              ),
            ),
            FormRow(
              label: '不正取消判定額',
              showInfoIcon: true,
              content: _buildTextField(
                _viewModel.invalidEntryAmount,
                '10 ～ 200000 円',
                (v) => _viewModel.setInvalidEntryAmount(v),
              ),
            ),
            FormRow(
              label: '不正取消判定動作',
              showInfoIcon: false,
              content: Row(
                children: [
                  _buildRadio('取消無効', 0, _viewModel.invalidEntryAction, (v) => _viewModel.setInvalidEntryAction(v!)),
                  SizedBox(width: 24.w),
                  _buildRadio('取消エラー', 1, _viewModel.invalidEntryAction, (v) => _viewModel.setInvalidEntryAction(v!)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String value, String hint, ValueChanged<String> onChanged) {
    return AppTextField(
      initialValue: value,
      hintText: hint,
      onChanged: onChanged,
      validator: ValidationHelper.fromHint(hint),
    );
  }

  Widget _buildRadio(String label, int value, int groupValue, ValueChanged<int?> onChanged) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Radio<int>(
          value: value,
          groupValue: groupValue,
          onChanged: onChanged,
          activeColor: const Color(0xFF0F1ED2),
          visualDensity: VisualDensity.compact,
        ),
        Text(
          label,
          style: TextStyle(fontSize: 13.sp, color: const Color(0xFF374151)),
        ),
      ],
    );
  }
}
