import 'package:flutter/material.dart';
import '../../../core/di/injection_container.dart';
import '../../widgets/widgets.dart';
import '../../../core/utils/responsive_utils.dart';
import 'view_model/operation_print_view_model.dart';

class OperationPrintScreen extends StatefulWidget {
  const OperationPrintScreen({super.key});

  @override
  State<OperationPrintScreen> createState() => _OperationPrintScreenState();
}

class _OperationPrintScreenState extends State<OperationPrintScreen> {
  late final OperationPrintViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = sl<OperationPrintViewModel>()..init();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _viewModel,
      builder: (context, _) {
        return Form(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(24.w),
            child: FormCard(
              title: '操作印字設定',
              child: Column(
                children: [
                  FormSwitchRow(
                    label: '全操作印字',
                    value: _viewModel.isTotalOperationPrintEnabled,
                    onChanged: _viewModel.setTotalOperationPrint,
                    showInfoIcon: true,
                    infoTooltip: '再送、復元、それ以外(入金等)の全操作を\n電文形式ログの末尾に出力させて',
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
