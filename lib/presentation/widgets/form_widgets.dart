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
  final bool showInfoIcon;
  final String? infoTooltip;
  final bool enabled;

  const FormRow({
    super.key,
    required this.label,
    required this.content,
    this.showInfoIcon = false,
    this.infoTooltip,
    this.enabled = true,
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
                if (showInfoIcon)
                  Tooltip(
                    message: infoTooltip ?? '',
                    preferBelow: true,
                    verticalOffset: 20.w,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4.w),
                      border: Border.all(color: const Color(0xFFE5E7EB)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    textStyle: TextStyle(
                      color: const Color(0xFF374151),
                      fontSize: 12.sp,
                    ),
                    child: Icon(
                      Icons.help_outline,
                      size: 14.sp,
                      color: const Color(0xFF9CA3AF),
                    ),
                  ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
              decoration: BoxDecoration(
                color: enabled ? Colors.white : const Color(0xFFF3F4F6),
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(4.w),
                  bottomRight: Radius.circular(4.w),
                ),
              ),
              child: content,
            ),
          ),
        ],
      ),
    );
  }
}
class AppSwitch extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  const AppSwitch({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: 0.6,
      alignment: Alignment.centerLeft,
      child: Switch(
        value: value,
        onChanged: onChanged,
        activeThumbColor: Colors.white,
        activeTrackColor: const Color(0xFF0F1ED2),
        inactiveThumbColor: const Color(0xFF0F1ED2),
        inactiveTrackColor: Colors.white,
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
    );
  }
}

class FormSwitchRow extends StatelessWidget {
  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;
  final bool showInfoIcon;
  final String? infoTooltip;
  final bool enabled;

  const FormSwitchRow({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
    this.showInfoIcon = false,
    this.infoTooltip,
    this.enabled = true,
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
                if (showInfoIcon)
                  Tooltip(
                    message: infoTooltip ?? '',
                    preferBelow: true,
                    verticalOffset: 20.w, // add a small offset to not cover the icon
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4.w),
                      border: Border.all(color: const Color(0xFFE5E7EB)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    textStyle: TextStyle(
                      color: const Color(0xFF374151),
                      fontSize: 12.sp,
                    ),
                    child: Icon(
                      Icons.help_outline,
                      size: 14.sp,
                      color: const Color(0xFF9CA3AF),
                    ),
                  ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
              child: Align(
                alignment: Alignment.centerLeft,
                child: AppSwitch(
                  value: value,
                  onChanged: enabled ? onChanged : (_) {},
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AppTextField extends StatefulWidget {
  final String initialValue;
  final String? hintText;
  final ValueChanged<String>? onChanged;
  final bool enabled;
  final int? maxLength;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final bool readOnly;
  final Widget? suffixIcon;
  final VoidCallback? onTap;
  final bool obscureText;

  const AppTextField({
    super.key,
    required this.initialValue,
    this.hintText,
    this.onChanged,
    this.enabled = true,
    this.maxLength,
    this.keyboardType = TextInputType.number,
    this.validator,
    this.readOnly = false,
    this.suffixIcon,
    this.onTap,
    this.obscureText = false,
  });

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
  }

  @override
  void didUpdateWidget(AppTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialValue != oldWidget.initialValue &&
        widget.initialValue != _controller.text) {
      _controller.text = widget.initialValue;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: _controller,
      enabled: widget.enabled,
      obscureText: widget.obscureText,
      readOnly: widget.readOnly,
      onChanged: widget.onChanged,
      maxLength: widget.maxLength,
      keyboardType: widget.keyboardType,
      validator: widget.validator,
      onTap: widget.onTap,
      style: TextStyle(
        fontSize: 13.sp,
        color: widget.enabled ? const Color(0xFF3A3A3A) : Colors.grey.shade400,
      ),
      decoration: InputDecoration(
        hintText: widget.hintText,
        hintStyle: TextStyle(
          color: const Color(0xFFD1D5DB),
          fontSize: 13.sp,
        ),
        border: InputBorder.none,
        isDense: true,
        contentPadding: EdgeInsets.symmetric(vertical: 12.h),
        counterText: '',
        suffixIcon: widget.suffixIcon,
        suffixIconConstraints: BoxConstraints(
          minWidth: 24.w,
          minHeight: 24.h,
        ),
      ),
    );
  }
}

class ValidationHelper {
  static String? Function(String?)? fromHint(String? hint) {
    if (hint == null) return null;

    return (String? value) {
      if (value == null || value.isEmpty) return null;

      // Handle simple numeric ranges: "0 ～ 99 枚", "10 ～ 200000 円", "0 ～ 99 %"
      final rangeMatch = RegExp(r'(\d+)\s*～\s*(\d+)').firstMatch(hint);
      if (rangeMatch != null) {
        final min = int.parse(rangeMatch.group(1)!);
        final max = int.parse(rangeMatch.group(2)!);
        final val = int.tryParse(value);
        if (val == null || val < min || val > max) {
          return ''; // Returning empty string to let the field handle the red styling
        }
      }

      // Handle era base year: "20 [10 ～ 90]"
      final eraMatch = RegExp(r'\[(\d+)\s*～\s*(\d+)\]').firstMatch(hint);
      if (eraMatch != null) {
        final min = int.parse(eraMatch.group(1)!);
        final max = int.parse(eraMatch.group(2)!);
        final val = int.tryParse(value);
        if (val == null || val < min || val > max) {
          return '';
        }
      }

      // Handle A ～ Z
      if (hint.contains('A ～ Z')) {
        if (!RegExp(r'^[A-Z]$').hasMatch(value)) {
          return '';
        }
      }

      return null;
    };
  }
}
