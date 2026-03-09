import 'package:flutter/material.dart';
import '../../../core/di/injection_container.dart';
import '../../widgets/widgets.dart';
import '../../../core/utils/responsive_utils.dart';
import 'view_model/fingerprint_view_model.dart';

class FingerprintScreen extends StatefulWidget {
  const FingerprintScreen({super.key});

  @override
  State<FingerprintScreen> createState() => _FingerprintScreenState();
}

class _FingerprintScreenState extends State<FingerprintScreen> {
  late final FingerprintViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = sl<FingerprintViewModel>()..init();
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
                children: [
                  Container(
                    width: 450.w,
                    child: FormCard(
                      title: '号機設定',
                      child: FormRow(
                        label: '号機',
                        showInfoIcon: true,
                        content: AppTextField(
                          initialValue: _viewModel.machineNumber,
                          hintText: '1〜99号機',
                          onChanged: _viewModel.setMachineNumber,
                          validator: ValidationHelper.fromHint('1〜99'),
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
}
