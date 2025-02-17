import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:instagram_clone_app/presentation/edit_profile/widgets/custom_profile_form_field.dart';
import 'package:instagram_clone_app/shared_widgets/horizontal_spacer.dart';

class ProfileField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final FormFieldValidator<String>? validator;
  const ProfileField({
    Key? key,
    required this.label,
    required this.controller,
    this.validator
    
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        textBaseline: TextBaseline.alphabetic,
        crossAxisAlignment: CrossAxisAlignment.baseline,
        children: [
          SizedBox(
            width: 89.w,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 19.sp,
              ),
            ),
          ),
          HorizontalSpacer(size: 43.sp),
          SizedBox(
            width: 240.w,
            height: 48.h,
            child: CustomProfileFormField(
              controller: controller,
              validator: validator,
            ),
          )
        ],
      ),
    );
  }
}
