import 'package:flutter/material.dart';
import '../../../core/utils/responsive_utils.dart';

class FormCard extends StatelessWidget {
  final String title;
  final Widget child;

  const FormCard({
    super.key,
    required this.title,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.w),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 8.h),
            child: Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14.sp,
                color: const Color(0xFF374151),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 16.h),
            child: child,
          ),
        ],
      ),
    );
  }
}

class FormRow extends StatelessWidget {
  final String label;
  final Widget content;
  final bool showInfo;

  const FormRow({
    super.key,
    required this.label,
    required this.content,
    this.showInfo = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 8.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4.w),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Row(
        children: [
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
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    label,
                    style: TextStyle(
                      fontSize: 13.sp,
                      color: const Color(0xFF374151),
                    ),
                  ),
                ),
                if (showInfo)
                  Icon(
                    Icons.help_outline,
                    size: 14.sp,
                    color: const Color(0xFF9CA3AF),
                  ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              child: content,
            ),
          ),
        ],
      ),
    );
  }
}
