import 'package:flutter/material.dart';
import 'app_header.dart';
import 'side_menu.dart';
import '../../core/di/injection_container.dart';
import '../../core/utils/responsive_utils.dart';
import '../views/home/view_model/home_view_model.dart';
import '../views/sound/view_model/sound_view_model.dart';
import '../views/payment/view_model/payment_view_model.dart';
import '../views/wallet/view_model/wallet_view_model.dart';
import '../views/fingerprint/view_model/fingerprint_view_model.dart';
import '../views/summary_format/view_model/summary_format_view_model.dart';
import '../views/summary_time/view_model/summary_time_view_model.dart';
import '../views/ticket/view_model/ticket_view_model.dart';
import '../views/operation_print/view_model/operation_print_view_model.dart';
import '../views/network/view_model/network_view_model.dart';
import '../views/ordering/view_model/ordering_view_model.dart';
import '../views/ftp/view_model/ftp_view_model.dart';
import '../views/parent_child/view_model/parent_child_view_model.dart';
import '../views/options/view_model/option_1_view_model.dart';
import '../views/details/view_model/details_view_model.dart';

class MainLayout extends StatelessWidget {
  final Widget child;
  final String currentRoute;
  final bool showSideMenu;

  const MainLayout({
    super.key,
    required this.child,
    required this.currentRoute,
    this.showSideMenu = true,
  });


  @override
  Widget build(BuildContext context) {
    Scaling.init(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: Row(
        children: [
          if (showSideMenu) SideMenu(currentRoute: currentRoute),
          Expanded(
            child: Column(
              children: [
                AppHeader(
                  title: '',
                  actions: [
                    const Spacer(),
                    SizedBox(width: 60.w),
                    _buildSearchBox(),
                    const Spacer(),
                    _buildUploadButton(),
                    SizedBox(width: 12.w),
                    _buildSaveButton(context),
                  ],
                ),
                Expanded(
                  child: Container(
                    color: Colors.white, // Background outside the content view
                    padding: EdgeInsets.all(8.w),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: const Color(0xFFCCCCCC).withValues(alpha: 0.5)),
                          borderRadius: BorderRadius.circular(4.w),
                        ),
                        padding: EdgeInsets.all(8.w),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(4.w),
                          child: child,
                        ),
                      ),
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

  Widget _buildSearchBox() {
    return Container(
      width: 352.w,
      height: 45.h,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6.w),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        children: [
          SizedBox(width: 12.w),
          Expanded(
            child: TextField(
              style: TextStyle(fontSize: 20.sp),
              decoration: InputDecoration(
                hintText: '読み込むファイル名',
                hintStyle: TextStyle(color: Color(0xFF3A3A3A), fontSize: 13.sp),
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(2.w),
            child: Container(
              height: double.infinity,
              width: 140.w,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.all(Radius.circular(5.w)),
                border: Border(left: BorderSide(color: Colors.grey.shade300)),
              ),
              padding: EdgeInsets.symmetric(vertical: 2.w, horizontal: 8.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.file_upload_outlined, size: 16.sp, color: Colors.black),
                  SizedBox(width: 4.w),
                  Text('ファイル取込', style: TextStyle(fontSize: 12.sp, color: Colors.black)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUploadButton() {
    return Container();
  }

  Widget _buildSaveButton(BuildContext context) {
    return InkWell(
      onTap: () {
        if (currentRoute == '/') {
          sl<HomeViewModel>().onSave(context);
        } else if (currentRoute == '/sound') {
          sl<SoundViewModel>().onSave();
        } else if (currentRoute == '/payment') {
          sl<PaymentViewModel>().onSave();
        } else if (currentRoute == '/wallet') {
          sl<WalletViewModel>().onSave();
        } else if (currentRoute == '/fingerprint') {
          sl<FingerprintViewModel>().onSave();
        } else if (currentRoute == '/report') {
          sl<SummaryFormatViewModel>().onSave();
        } else if (currentRoute == '/time') {
          sl<SummaryTimeViewModel>().onSave();
        } else if (currentRoute == '/ticket') {
          sl<TicketViewModel>().onSave();
        } else if (currentRoute == '/print') {
          sl<OperationPrintViewModel>().onSave();
        } else if (currentRoute == '/network') {
          sl<NetworkViewModel>().onSave();
        } else if (currentRoute == '/ordering') {
          sl<OrderingViewModel>().onSave();
        } else if (currentRoute == '/ftp') {
          sl<FtpViewModel>().onSave();
        } else if (currentRoute == '/parent') {
          sl<ParentChildViewModel>().onSave();
        } else if (currentRoute == '/option1') {
          sl<Option1ViewModel>().onSave();
        } else if (currentRoute == '/details') {
          sl<DetailsViewModel>().onSave();
        }
      },
      borderRadius: BorderRadius.circular(6.w),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: const Color(0xFF0F1ED2),
          borderRadius: BorderRadius.circular(6.w),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.save_outlined, size: 16.sp, color: Colors.white),
            SizedBox(width: 6.w),
            Text(
              '保存',
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
