import 'package:flutter/material.dart';
import '../../../core/di/injection_container.dart';
import '../../widgets/widgets.dart';
import '../../../core/utils/responsive_utils.dart';
import 'view_model/payment_view_model.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  late final PaymentViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = sl<PaymentViewModel>()..init();
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
                  child: _buildBanknotesSection(),
                ),
                SizedBox(width: 24.w),
                Expanded(
                  child: _buildCoinsSection(),
                ),
              ],
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
        children: _viewModel.banknotes.entries.map((entry) {
          return _buildDenominationRow(
            entry.key.toString(),
            entry.value,
            (val) => _viewModel.setBanknoteStatus(entry.key, val),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildCoinsSection() {
    return FormCard(
      title: '硬貨',
      child: Column(
        children: _viewModel.coins.entries.map((entry) {
          return _buildDenominationRow(
            entry.key.toString(),
            entry.value,
            (val) => _viewModel.setCoinStatus(entry.key, val),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildDenominationRow(String label, bool value, ValueChanged<bool> onChanged) {
    return FormRow(
      label: label,
      showInfoIcon: false,
      content: Row(
        children: [
          _buildRadio('可', true, value, (v) => onChanged(v!)),
          SizedBox(width: 24.w),
          _buildRadio('否', false, value, (v) => onChanged(v!)),
        ],
      ),
    );
  }

  Widget _buildRadio(String label, bool value, bool groupValue, ValueChanged<bool?> onChanged) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Radio<bool>(
          value: value,
          groupValue: groupValue,
          onChanged: onChanged,
          activeColor: const Color(0xFF0F1ED2),
          visualDensity: VisualDensity.compact,
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 13.sp,
            color: const Color(0xFF374151),
          ),
        ),
      ],
    );
  }
}
