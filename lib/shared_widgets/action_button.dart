import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ActionButton extends StatelessWidget {
  final String? text; // Optional text
  final IconData? icon; // Optional icon
  final VoidCallback onPressed;
  final double? width; // Optional width
  final double? height; // Optional height
  final Color? color; // Optional background color
  final Color? iconColor; // Optional icon color

  const ActionButton({
    Key? key,
    this.text, // Accept text
    this.icon, // Accept icon
    required this.onPressed,
    this.width, // Accept width
    this.height, // Accept height
    this.color, // Accept background color
    this.iconColor, // Accept icon color
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? double.infinity, // Default to full width if null
      height: height ?? 50.h, // Default height if null
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color ?? const Color(0xFF0099FF), // Default blue if null
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.r),
          ),
          padding: EdgeInsets.symmetric(vertical: 13.h),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min, // Adapt size to content
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                size: 16.sp,
                color: iconColor ?? Colors.white, // Default icon color
              ),
              if (text != null) SizedBox(width: 8.w), // Add spacing if text is present
            ],
            if (text != null)
              Center(
                child: Text(
                  text!,
                  style: TextStyle(
                    fontSize: 15.sp, // Responsive font size
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
