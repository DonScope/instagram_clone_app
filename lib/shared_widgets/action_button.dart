import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ActionButton extends StatelessWidget {
  final String? text; 
  final IconData? icon; 
  final VoidCallback onPressed;
  final double? width; 
  final double? height; 
  final Color? color; 
  final Color? iconColor; 

  const ActionButton({
    Key? key,
    this.text, 
    this.icon, 
    required this.onPressed,
    this.width, 
    this.height, 
    this.color,
    this.iconColor, 
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? double.infinity, 
      height: height ?? 50.h, 
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color ?? const Color(0xFF0099FF), 
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.r),
          ),
          padding: EdgeInsets.symmetric(vertical: 3.h),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min, 
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                size: 16.sp,
                color: iconColor ?? Colors.white, 
              ),
              if (text != null) SizedBox(width: 8.w), 
            ],
            if (text != null)
              Center(
                child: Text(
                  text!,
                  style: TextStyle(
                    fontSize: 15.sp, 
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
