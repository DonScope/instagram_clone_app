import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../config/app_colors/app_colors.dart';

class CustomTextField extends StatelessWidget {
  final String labelText;
  final bool obscureText;
  final Widget? prefix;
  final Widget? ic;
  final FormFieldValidator<String>? validator;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged; // Optional onChanged callback

  const CustomTextField({
    super.key,
    required this.labelText,
    this.validator,
    this.obscureText = false,
    this.ic,
    this.controller,
    this.prefix,
    this.onChanged, // Add onChanged to constructor
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: TextStyle(color: textPrimary),
      validator: validator,
      controller: controller,
      obscureText: obscureText,
      onChanged: onChanged, // Pass onChanged to TextFormField
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: TextStyle(color: textSecondary),
        prefixIcon: prefix,
        suffixIcon: ic,
        suffixIconColor: iconPrimary,
        prefixIconColor: iconPrimary,
        hintStyle: TextStyle(
          color: Colors.white,
          fontSize: 16.sp,
        ),
        fillColor: background,
        filled: true,
        contentPadding: EdgeInsets.symmetric(
          vertical: 15.h,
          horizontal: 16.w,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.r),
          borderSide: BorderSide(
            color: border,
            width: 0.5.w,
          ),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.r),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.r),
          borderSide: BorderSide(
            color: borderFocused,
            width: 2.0.w,
          ),
        ),
      ),
    );
  }
}
