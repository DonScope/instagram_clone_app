import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const CustomButton({
    Key? key,
    required this.text,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity, 
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white, // White text color
          backgroundColor: const Color(0xFF0099FF), // Blue background color
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.r), 
          ),
          padding: EdgeInsets.symmetric(vertical: 13.h),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 16.sp, // Responsive font size
            fontWeight: FontWeight.bold,
          ), 
        ),
      ),
    );
  }
}
