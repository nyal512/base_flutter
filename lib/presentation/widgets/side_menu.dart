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
                _buildMenuItem(context, '商品エリア', 'assets/icons/ic_product_area.svg', '/product-area'),
                _buildMenuItem(context, '商品エリア', 'assets/icons/ic_briefcase.svg', '/'),
                _buildMenuItem(context, 'メニューボタンマスター', 'assets/icons/ic_menu_button_master.svg', '/menu-button-master'),
                _buildMenuItem(context, '連携設定', 'assets/icons/ic_list_dashes.svg', '/sync-settings'),
                _buildMenuItem(context, '棚指定', 'assets/icons/ic_table.svg', '/shelf-designation'),
                _buildMenuItem(context, 'メニュー管理', 'assets/icons/ic_list_dashes.svg', '/menu-management'),
                _buildMenuItem(context, 'グループ', 'assets/icons/ic_tree_view.svg', '/group'),
                _buildMenuItem(context, 'カテゴリ', 'assets/icons/ic_grid_four.svg', '/category'),
                _buildMenuItem(context, '集計様式', 'assets/icons/ic_table.svg', '/report'),
                _buildMenuItem(context, 'QRコード', 'assets/icons/ic_receipt.svg', '/qr'),
                _buildMenuItem(context, 'バーコード', 'assets/icons/ic_receipt.svg', '/barcode'),
                _buildMenuItem(context, '操作案内', 'assets/icons/ic_printer.svg', '/guide'),
                _buildMenuItem(context, '画面構成', 'assets/icons/ic_grid_four.svg', '/layout'),
                _buildMenuItem(context, 'お知らせ', 'assets/icons/ic_envelope.svg', '/notifications'),
                _buildMenuItem(context, 'データ初期化', 'assets/icons/ic_database.svg', '/data-reset'),
                _buildMenuItem(context, 'ネットワーク', 'assets/icons/ic_cloud.svg', '/network'),
                _buildMenuItem(context, 'ログインパスワード', 'assets/icons/ic_fingerprint.svg', '/password'),
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
    final activeColor = const Color(0xFF1D4ED8);

    return InkWell(
      onTap: () => context.go(route),
      child: Container(
        height: 40.h,
        margin: EdgeInsets.symmetric(horizontal: 12.w, vertical: 2.h),
        decoration: BoxDecoration(
          color: isActive ? activeColor : Colors.transparent,
          borderRadius: BorderRadius.circular(6.w),
        ),
        padding: EdgeInsets.symmetric(horizontal: 12.w),
        child: Row(
          children: [
            SvgPicture.asset(
              pathIcon,
              width: 18.w,
              height: 18.w,
              colorFilter: ColorFilter.mode(
                isActive ? Colors.white : const Color(0xFF4B5563),
                BlendMode.srcIn,
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  color: isActive ? Colors.white : const Color(0xFF374151),
                  fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                  fontSize: 13.sp,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (isExpansion)
              Icon(
                Icons.keyboard_arrow_down,
                size: 16.sp,
                color: isActive ? Colors.white : const Color(0xFF9CA3AF),
              ),
          ],
        ),
      ),
    );
  }
}
