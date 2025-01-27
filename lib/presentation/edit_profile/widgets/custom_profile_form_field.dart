import 'package:flutter/material.dart';

import '../../../config/app_colors/app_colors.dart';

class CustomProfileFormField extends StatelessWidget {
  final FormFieldValidator<String>? validator;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  const CustomProfileFormField({
    super.key,
    this.validator,
    this.onChanged,
    this.controller,
    
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: TextStyle(color: textPrimary),
      validator: validator,
      controller: controller,
      onChanged: onChanged,
    );
  }
}
