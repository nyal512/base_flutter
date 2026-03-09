import 'package:flutter/material.dart';
import '../../../../core/di/injection_container.dart';
import '../../widgets/form_widgets.dart';
import '../../../../core/utils/responsive_utils.dart';
import 'view_model/network_view_model.dart';

class NetworkScreen extends StatefulWidget {
  const NetworkScreen({super.key});

  @override
  State<NetworkScreen> createState() => _NetworkScreenState();
}

class _NetworkScreenState extends State<NetworkScreen> {
  late final NetworkViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = sl<NetworkViewModel>()..init();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _viewModel,
      builder: (context, _) {
        return Form(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(24.w),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Left Column: 券売機 (Ticket Machine)
                Expanded(
                  child: FormCard(
                    title: '券売機',
                    child: Column(
                      children: [
                        FormRow(
                          label: 'IPアドレス',
                          showInfoIcon: false,
                          content: AppTextField(
                            initialValue: _viewModel.ipAddress,
                            onChanged: _viewModel.setIpAddress,
                            hintText: '1〜99999',
                          ),
                        ),
                        FormRow(
                          label: 'サブネットマスク',
                          showInfoIcon: false,
                          content: AppTextField(
                            initialValue: _viewModel.subnetMask,
                            onChanged: _viewModel.setSubnetMask,
                            hintText: '1〜99999',
                          ),
                        ),
                        FormRow(
                          label: 'ポート番号1',
                          showInfoIcon: true,
                          infoTooltip: '運用系のポート番号',
                          content: AppTextField(
                            initialValue: _viewModel.portNumber1,
                            onChanged: _viewModel.setPortNumber1,
                          ),
                        ),
                        FormRow(
                          label: 'ポート番号2',
                          showInfoIcon: true,
                          infoTooltip: '待機系のポート番号',
                          content: AppTextField(
                            initialValue: _viewModel.portNumber2,
                            onChanged: _viewModel.setPortNumber2,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 24.w),
                // Right Column: 上位端末 (Upper Terminal)
                Expanded(
                  child: FormCard(
                    title: '上位端末',
                    child: Column(
                      children: [
                        FormSwitchRow(
                          label: '接続',
                          value: _viewModel.isUpperTerminalConnected,
                          onChanged: _viewModel.setUpperTerminalConnected,
                          showInfoIcon: false,
                        ),
                        FormRow(
                          label: 'IPアドレス',
                          showInfoIcon: false,
                          enabled: _viewModel.isUpperTerminalConnected,
                          content: AppTextField(
                            initialValue: _viewModel.upperTerminalIpAddress,
                            onChanged: _viewModel.setUpperTerminalIpAddress,
                            hintText: '1〜99999',
                            enabled: _viewModel.isUpperTerminalConnected,
                          ),
                        ),
                        FormRow(
                          label: 'ポート番号',
                          showInfoIcon: true,
                          infoTooltip: '上位端末のポート番号',
                          enabled: _viewModel.isUpperTerminalConnected,
                          content: AppTextField(
                            initialValue: _viewModel.upperTerminalPortNumber,
                            onChanged: _viewModel.setUpperTerminalPortNumber,
                            enabled: _viewModel.isUpperTerminalConnected,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
