import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import '../../core/utils/responsive_utils.dart';

class SideMenu extends StatelessWidget {
  final String currentRoute;

  const SideMenu({
    super.key,
    required this.currentRoute,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 210.w,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          right: BorderSide(color: Colors.grey.shade200),
        ),
      ),
      child: Column(
        children: [
          _buildLogo(),
          const Divider(
            height: 1,
            thickness: 1,
            color: Color(0xFFE5E7EB),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.fromLTRB(0, 8.h, 0, 16.h),
              children: [
                _buildMenuItem(context, '販売モード', 'assets/icons/ic_store.svg', '/'),
                _buildMenuItem(context, 'ブザー音／音声', 'assets/icons/ic_sound.svg', '/sound'),
                _buildMenuItem(context, '入金金種', 'assets/icons/ic_money.svg', '/payment'),
                _buildMenuItem(context, '入金制限', 'assets/icons/ic_wallet.svg', '/limit'),
                _buildMenuItem(context, '号機', 'assets/icons/ic_fingerprint.svg', '/machine'),
                _buildMenuItem(context, '発券連番', 'assets/icons/ic_receipt.svg', '/ticket'),
                _buildMenuItem(context, '集計様式', 'assets/icons/ic_table.svg', '/report'),
                _buildMenuItem(context, '集計時間帯', 'assets/icons/ic_database.svg', '/time'),
                _buildMenuItem(context, '操作印字', 'assets/icons/ic_printer.svg', '/print'),
                _buildMenuItem(context, 'ネットワーク', 'assets/icons/ic_envelope.svg', '/network'),
                _buildMenuItem(context, 'オーダリング', 'assets/icons/ic_list_dashes.svg', '/ordering'),
                _buildMenuItem(context, 'FTP', 'assets/icons/ic_cloud.svg', '/ftp'),
                _buildMenuItem(context, '親子', 'assets/icons/ic_tree_view.svg', '/parent'),
              ],
            ),
          ),
          _buildMenuItem(context, 'オプション', 'assets/icons/ic_grid_four.svg', '/settings', isExpansion: true),
          _buildMenuItem(context, '集計詳細', 'assets/icons/ic_graph.svg', '/details'),
        ],
      ),
    );
  }

  Widget _buildLogo() {
    return Container(
      padding: EdgeInsets.fromLTRB(16.w, 24.h, 16.w, 9.h),
      alignment: Alignment.centerLeft,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SvgPicture.asset(
            'assets/icons/ic_logo.svg',
            width: 21.w,
            height: 16.w,
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '販売データ作成ツール',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14.sp,
                    letterSpacing: -0.5,
                  ),
                ),
                DecoratedBox(
                  decoration: const BoxDecoration(
                    color: Color(0xFFF8F9F9),
                    borderRadius: BorderRadius.all(Radius.circular(4)),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                    child: Text(
                      'V 2.4.1',
                      style: TextStyle(
                        color: const Color(0xFF6A7282),
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w500,
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

  Widget _buildMenuItem(
    BuildContext context,
    String title,
    String pathIcon,
    String route, {
    bool isExpansion = false,
  }) {
    final isActive = currentRoute == route;
    final primaryColor = const Color(0xFF6366F1);

    return InkWell(
      onTap: () => context.go(route),
      child: Container(
        height: 48.h,
        decoration: BoxDecoration(
          color: isActive ? Colors.indigo.shade50.withOpacity(0.5) : Colors.transparent,
          border: Border(
            left: BorderSide(
              color: isActive ? primaryColor : Colors.transparent,
              width: 3.w,
            ),
          ),
        ),
        padding: EdgeInsets.symmetric(horizontal: 12.w),
        child: Row(
          children: [
            SvgPicture.asset(
              pathIcon,
              width: 18.sp,
              height: 18.sp,
              colorFilter: ColorFilter.mode(
                isActive ? primaryColor : Colors.grey.shade600,
                BlendMode.srcIn,
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  color: isActive ? primaryColor : Colors.grey.shade700,
                  fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                  fontSize: 12.sp,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (isExpansion)
              Icon(Icons.keyboard_arrow_down, size: 16.sp, color: Colors.grey.shade400),
          ],
        ),
      ),
    );
  }
}
