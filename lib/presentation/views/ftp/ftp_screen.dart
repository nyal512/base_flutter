import 'package:flutter/material.dart';
import '../../../../core/di/injection_container.dart';
import '../../widgets/widgets.dart';
import '../../../../core/utils/responsive_utils.dart';
import 'view_model/ftp_view_model.dart';
import '../../widgets/form_widgets.dart';

class FtpScreen extends StatefulWidget {
  const FtpScreen({super.key});

  @override
  State<FtpScreen> createState() => _FtpScreenState();
}

class _FtpScreenState extends State<FtpScreen> {
  late final FtpViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = sl<FtpViewModel>()..init();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _viewModel,
      builder: (context, _) {
        final isConnected = _viewModel.isUpperPcConnected;

        return Form(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(24.w),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Left Column: 上位PC (Upper PC 1 & 2)
                Expanded(
                  child: Column(
                    children: [
                      FormCard(
                        title: '上位PC',
                        child: Column(
                          children: [
                            FormSwitchRow(
                              label: '接続',
                              showInfoIcon: true,
                              infoTooltip: '上位PCと接続する場合に設定',
                              value: _viewModel.isUpperPcConnected,
                              onChanged: _viewModel.setUpperPcConnected,
                            ),
                            FormRow(
                              label: 'IPアドレス',
                              showInfoIcon: false,
                              enabled: isConnected,
                              content: AppTextField(
                                initialValue: _viewModel.ipAddress,
                                onChanged: _viewModel.setIpAddress,
                                enabled: isConnected,
                              ),
                            ),
                            FormRow(
                              label: 'ユーザID',
                              showInfoIcon: true,
                              infoTooltip: 'FTPサーバのユーザID',
                              enabled: isConnected,
                              content: AppTextField(
                                initialValue: _viewModel.userId1,
                                onChanged: _viewModel.setUserId1,
                                enabled: isConnected,
                              ),
                            ),
                            FormRow(
                              label: 'パスワード',
                              showInfoIcon: true,
                              infoTooltip: 'FTPサーバのパスワード',
                              enabled: isConnected,
                              content: AppTextField(
                                initialValue: _viewModel.password1,
                                onChanged: _viewModel.setPassword1,
                                enabled: isConnected,
                                obscureText: true,
                              ),
                            ),
                            FormRow(
                              label: '保存先フォルダ',
                              showInfoIcon: true,
                              infoTooltip: '上位PCの保存先フォルダ',
                              enabled: isConnected,
                              content: AppTextField(
                                initialValue: _viewModel.saveFolder,
                                onChanged: _viewModel.setSaveFolder,
                                enabled: isConnected,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 16.h),
                      FormCard(
                        title: '上位PC',
                        child: Column(
                          children: [
                            FormRow(
                              label: 'ユーザID',
                              showInfoIcon: true,
                              infoTooltip: '予備の上位PCのユーザID',
                              enabled: isConnected,
                              content: AppTextField(
                                initialValue: _viewModel.userId2,
                                onChanged: _viewModel.setUserId2,
                                enabled: isConnected,
                              ),
                            ),
                            FormRow(
                              label: 'パスワード',
                              showInfoIcon: false,
                              enabled: isConnected,
                              content: AppTextField(
                                initialValue: _viewModel.password2,
                                onChanged: _viewModel.setPassword2,
                                enabled: isConnected,
                                obscureText: true,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 24.w),
                // Right Column: 送信ファイル (Transmission File)
                Expanded(
                  child: FormCard(
                    title: '送信ファイル',
                    child: Column(
                      children: [
                        FormRow(
                          label: 'ファイル種',
                          showInfoIcon: false,
                          content: Wrap(
                            spacing: 16.w,
                            runSpacing: 8.h,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              _buildCheckboxRow('日計', _viewModel.sendFileDaily, (v) => _viewModel.setSendFileDaily(v!)),
                              _buildCheckboxRow('累計', _viewModel.sendFileCumulative, (v) => _viewModel.setSendFileCumulative(v!)),
                              _buildCheckboxRow('トランザクション', _viewModel.sendFileTransaction, (v) => _viewModel.setSendFileTransaction(v!)),
                            ],
                          ),
                        ),
                        FormSwitchRow(
                          label: 'トランザクション定時送信',
                          showInfoIcon: false,
                          value: isConnected ? _viewModel.isTransactionRegularTransmission : false,
                          onChanged: _viewModel.setTransactionRegularTransmission,
                          enabled: isConnected,
                        ),
                        FormRow(
                          label: 'トランザクション送信間隔',
                          showInfoIcon: true,
                          infoTooltip: '送信間隔（単位：分）',
                          enabled: isConnected && _viewModel.isTransactionRegularTransmission,
                          content: AppTextField(
                            initialValue: _viewModel.transactionTransmissionInterval,
                            onChanged: _viewModel.setTransactionTransmissionInterval,
                            hintText: '1〜60分',
                            enabled: isConnected && _viewModel.isTransactionRegularTransmission,
                          ),
                        ),
                        FormSwitchRow(
                          label: 'サイズ確認',
                          showInfoIcon: true,
                          infoTooltip: 'ファイルサイズの確認',
                          value: _viewModel.isSizeCheck,
                          onChanged: _viewModel.setSizeCheck,
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

  Widget _buildCheckboxRow(String label, bool value, ValueChanged<bool?> onChanged) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Checkbox(
          value: value,
          onChanged: onChanged,
          fillColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return Colors.white;
            }
            return Colors.white;
          }),
          checkColor: const Color(0xFF0F1ED2),
          side: WidgetStateBorderSide.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return BorderSide(color: const Color(0xFF0F1ED2), width: 1.5.w);
            }
            return BorderSide(color: const Color(0xFFD1D5DB), width: 1.5.w);
          }),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(3.w),
          ),
          visualDensity: VisualDensity.compact,
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        SizedBox(width: 4.w),
        Text(
          label,
          style: TextStyle(
            fontSize: 12.sp,
            color: const Color(0xFF374151),
          ),
        ),
      ],
    );
  }
}
