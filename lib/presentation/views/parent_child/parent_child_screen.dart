import 'package:flutter/material.dart';
import '../../../core/di/injection_container.dart';
import '../../widgets/widgets.dart';
import '../../../core/utils/responsive_utils.dart';
import 'view_model/parent_child_view_model.dart';

class ParentChildScreen extends StatefulWidget {
  const ParentChildScreen({super.key});

  @override
  State<ParentChildScreen> createState() => _ParentChildScreenState();
}

class _ParentChildScreenState extends State<ParentChildScreen> {
  late final ParentChildViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = sl<ParentChildViewModel>()..init();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _viewModel,
      builder: (context, _) {
        return SingleChildScrollView(
          padding: EdgeInsets.all(24.w),
          child: FormCard(
            title: '親子',
            child: Column(
              children: List.generate(_viewModel.connections.length, (index) {
                final conn = _viewModel.connections[index];
                return _buildConnectionRow(index + 1, conn);
              }),
            ),
          ),
        );
      },
    );
  }

  Widget _buildConnectionRow(int number, ChildConnectionModel conn) {
    return Container(
      margin: EdgeInsets.only(bottom: 8.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4.w),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Row(
        children: [
          // Label Section
          Container(
            width: 140.w,
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
            decoration: BoxDecoration(
              color: const Color(0xFFF9FAFB),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(4.w),
                bottomLeft: Radius.circular(4.w),
              ),
              border: Border(right: BorderSide(color: const Color(0xFFE5E7EB))),
            ),
            child: Text(
              '子接続 $number',
              style: TextStyle(
                fontSize: 13.sp,
                color: const Color(0xFF374151),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          
          // Content Section
          Expanded(
            child: Row(
              children: [
                // Switch Section
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Row(
                    children: [
                      AppSwitch(
                        value: conn.isConnected,
                        onChanged: (val) => _viewModel.updateConnection(number - 1, isConnected: val),
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        '接続',
                        style: TextStyle(fontSize: 13.sp, color: const Color(0xFF374151)),
                      ),
                    ],
                  ),
                ),
                
                const VerticalDivider(width: 1, color: Color(0xFFE5E7EB)),
                
                // Address Input
                Expanded(
                  flex: 3,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 12.w),
                    child: AppTextField(
                      initialValue: conn.address,
                      hintText: '1〜99999',
                      enabled: conn.isConnected,
                      onChanged: (val) => _viewModel.updateConnection(number - 1, address: val),
                    ),
                  ),
                ),
                
                const VerticalDivider(width: 1, color: Color(0xFFE5E7EB)),
                
                // Port Input
                Expanded(
                  flex: 2,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 12.w),
                    child: AppTextField(
                      initialValue: conn.port,
                      hintText: '9100',
                      enabled: conn.isConnected,
                      onChanged: (val) => _viewModel.updateConnection(number - 1, port: val),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
