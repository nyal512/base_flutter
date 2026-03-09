import 'package:flutter/material.dart';
import '../../../core/di/injection_container.dart';
import '../../widgets/widgets.dart';
import '../../../core/utils/responsive_utils.dart';
import 'view_model/ticket_view_model.dart';

class TicketScreen extends StatefulWidget {
  const TicketScreen({super.key});

  @override
  State<TicketScreen> createState() => _TicketScreenState();
}

class _TicketScreenState extends State<TicketScreen> {
  late final TicketViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = sl<TicketViewModel>()..init();
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
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Left Column: 発券連番
                  Expanded(
                    child: FormCard(
                      title: '発券連番',
                      child: Column(
                        children: [
                          FormRow(
                            label: '番号',
                            showInfoIcon: true,
                            content: AppTextField(
                              initialValue: _viewModel.serialNumber,
                              hintText: '1〜99999',
                              onChanged: _viewModel.setSerialNumber,
                              validator: ValidationHelper.fromHint('1〜99999'),
                            ),
                          ),
                          FormRow(
                            label: 'クリア条件',
                            showInfoIcon: false,
                            content: Row(
                              children: [
                                _buildRadio('無し', 0, _viewModel.clearCondition,
                                    (v) => _viewModel.setClearCondition(v!)),
                                _buildRadio('日計クリア', 1, _viewModel.clearCondition,
                                    (v) => _viewModel.setClearCondition(v!)),
                                _buildRadio('累計クリア', 2, _viewModel.clearCondition,
                                    (v) => _viewModel.setClearCondition(v!)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: 24.w),
                  // Right Column: メニュー別連番
                  Expanded(
                    child: FormCard(
                      title: 'メニュー別連番',
                      child: FormRow(
                        label: 'クリア条件',
                        showInfoIcon: false,
                        content: Row(
                          children: [
                            _buildRadio('無し', 0, _viewModel.menuClearCondition,
                                (v) => _viewModel.setMenuClearCondition(v!)),
                            _buildRadio('日計クリア', 1, _viewModel.menuClearCondition,
                                (v) => _viewModel.setMenuClearCondition(v!)),
                            _buildRadio('累計クリア', 2, _viewModel.menuClearCondition,
                                (v) => _viewModel.setMenuClearCondition(v!)),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
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
        SizedBox(width: 8.w),
      ],
    );
  }
}
