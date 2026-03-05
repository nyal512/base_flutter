import 'package:flutter/material.dart';
import '../../core/utils/responsive_utils.dart';

class AppHeader extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;

  const AppHeader({
    super.key,
    required this.title,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: preferredSize.height,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade200),
        ),
      ),
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Row(
        children: [
          if (title.isNotEmpty) ...[
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15.sp,
                color: Colors.black87,
              ),
            ),
          ],
          if (actions != null) ...actions!,
          SizedBox(width: 12.w),
          _buildPowerButton(),
        ],
      ),
    );
  }

  Widget _buildPowerButton() {
    return InkWell(
      onTap: () {},
      borderRadius: BorderRadius.circular(8.w),
      child: Container(
        padding: EdgeInsets.all(6.w),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(8.w),
        ),
        child: Icon(
          Icons.power_settings_new,
          size: 28.sp,
          color: const Color(0xFF3A3A3A),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(80.h);
}
