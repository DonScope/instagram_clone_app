import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../config/app_colors/app_colors.dart';

class CustomTextField extends StatelessWidget {
  final String labelText;
  final bool obscureText;
  final Widget? prefix;
  final Widget? ic;
  final FormFieldValidator<String>? validator;
  final TextEditingController? controller;
  const CustomTextField(
      {super.key,
      required this.labelText,
      this.validator,
      this.obscureText = false,
      this.ic,
      this.controller,
      this.prefix});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: TextStyle(color: Colors.white),
      
      validator: validator,
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(

        labelText: labelText,
        labelStyle: TextStyle(color: textPrimary),
        prefixIcon: prefix != null ? prefix : null,
        suffixIcon: ic != null ? ic : null,
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
            color: Color.fromRGBO(22, 31, 40, 1),
            width: 0.5.w,
          ),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.r),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.r),
          borderSide: BorderSide(
            color:  Color(0xFF8C6658),
            width: 2.0.w,
          ),
        ),
      ),
    );
  }
}
