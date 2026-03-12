import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/di/injection_container.dart';
import '../../../core/utils/responsive_utils.dart';
import 'view_model/home_view_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final HomeViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = sl<HomeViewModel>()..init();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _viewModel,
      builder: (context, _) {
        return Scaffold(
          backgroundColor: const Color(0xFFF9FAFB),
          body: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 40.w, vertical: 40.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF3F4F6),
                    borderRadius: BorderRadius.circular(4.w),
                    border: Border.all(color: const Color(0xFFD1D5DB), width: 1.w),
                  ),
                  child: Text(
                    'システム管理ツール',
                    style: TextStyle(
                      fontSize: 11.sp,
                      color: const Color(0xFF374151),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                SizedBox(height: 12.h),
                Text(
                  '販売画面レイアウト調整',
                  style: TextStyle(
                    fontSize: 28.sp,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF111827),
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  '券売機の運用設定および販売画面の表示レイアウトを一括管理します。',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: const Color(0xFF6B7280),
                  ),
                ),
                SizedBox(height: 48.h),
                _buildGrid(),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildGrid() {
    return Wrap(
      spacing: 24.w,
      runSpacing: 24.h,
      children: [
        _HomeCard(
          title: 'チケット設定',
          description: '券売機の運用設定および販売画面の表示レイアウトを一括管理します。',
          icon: Icons.confirmation_num_outlined,
          iconBgColor: const Color(0xFF4F46E5),
          onTap: () {},
        ),
        _HomeCard(
          title: 'ガイド画面・言語設定',
          description: '初期案内画面のレイアウトおよび多言語表示の翻訳設定を行います。',
          icon: Icons.language,
          iconBgColor: const Color(0xFF4338CA),
          onTap: () {},
        ),
        _HomeCard(
          title: 'カテゴリー画面設定',
          description: 'メニューカテゴリーの選択画面のボタン配置やデザインを調整します。',
          icon: Icons.grid_view_rounded,
          iconBgColor: const Color(0xFF7C3AED),
          onTap: () => context.go('/menu-button-master'),
        ),
        _HomeCard(
          title: '商品画面設定',
          description: '商品一覧画面のレイアウト、商品画像の表示形式を設定します。',
          icon: Icons.view_list_outlined,
          iconBgColor: const Color(0xFFDB2777),
          onTap: () => context.go('/product-area'),
        ),
        _HomeCard(
          title: 'サイズ・数量・おすすめ画面',
          description: 'トッピング、サイズ選択、おすすめ商品のポップアップ画面を管理します。',
          icon: Icons.menu_rounded,
          iconBgColor: const Color(0xFFEF4444),
          onTap: () {},
        ),
        _HomeCard(
          title: '注文確認画面設定',
          description: '注文内容の最終確認画面および購入ボタンの配置設定を行います。',
          icon: Icons.verified_outlined,
          iconBgColor: const Color(0xFF10B981),
          onTap: () {},
        ),
        _HomeCard(
          title: '電子データ出力',
          description: '運用設定データ(XML)および売上集計データ(CSV/JSON)の出力を行います。',
          icon: Icons.storage_rounded,
          iconBgColor: const Color(0xFF6B7280),
          onTap: () {},
        ),
      ],
    );
  }
}

class _HomeCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final Color iconBgColor;
  final VoidCallback onTap;

  const _HomeCard({
    required this.title,
    required this.description,
    required this.icon,
    required this.iconBgColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16.w),
      child: Container(
        width: 280.w,
        height: 180.h,
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.w),
          border: Border.all(color: const Color(0xFFE5E7EB)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 44.w,
              height: 44.w,
              decoration: BoxDecoration(
                color: iconBgColor,
                borderRadius: BorderRadius.circular(10.w),
              ),
              child: Icon(
                icon,
                color: Colors.white,
                size: 22.sp,
              ),
            ),
            SizedBox(height: 16.h),
            Text(
              title,
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF1F2937),
                letterSpacing: -0.5,
              ),
            ),
            SizedBox(height: 6.h),
            Expanded(
              child: Text(
                description,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 13.sp,
                  color: const Color(0xFF6B7280),
                  height: 1.4,
                  letterSpacing: -0.2,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
