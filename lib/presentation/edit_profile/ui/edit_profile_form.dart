import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:instagram_clone_app/core/utils/validators.dart';
import 'package:instagram_clone_app/presentation/edit_profile/widgets/ProfileField.dart';

import '../../../config/app_colors/app_colors.dart';
import '../../../shared_widgets/vertical_spacer.dart';

class EditProfileForm extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController usernameController;
  final String? currentUsername;
  final TextEditingController bioController;
  final TextEditingController emailController;
  final String currentEmail;
  final TextEditingController phoneController;
  final String? profilePictureUrl;
  final VoidCallback onPickImage;
  final VoidCallback onUpdate;
  final _formKey = GlobalKey<FormState>();

  EditProfileForm({
    required this.nameController,
    required this.usernameController,
    required this.bioController,
    required this.emailController,
    required this.phoneController,
    required this.profilePictureUrl,
    required this.onPickImage,
    required this.onUpdate,
    required this.currentEmail,
    this.currentUsername,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    "cancel".tr(),
                    style: TextStyle(color: error, fontSize: 16.sp),
                  ),
                ),
                Text(
                  "edit_profile".tr(),
                  style: TextStyle(
                    color: textPrimary,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      final email = emailController.text;
                      final emailExistsError =
                          await Validators.validateEmailExists(
                        email,
                        currentUserEmail: currentEmail,
                      );
                      if (emailExistsError != null) {
                        _showSnackBar(context, emailExistsError);
                        return;
                      }
        
                      final username = usernameController.text;
                      final usernameExistsError =
                          await Validators.validateUsernameExists(
                        username,
                        currentUsername: currentUsername,
                      );
                      if (usernameExistsError != null) {
                        _showSnackBar(context, usernameExistsError);
                        return;
                      }
                      onUpdate();
                    }
                  },
                  child: Text(
                    "save".tr(),
                    style: TextStyle(color: buttonPrimary, fontSize: 16.sp),
                  ),
                ),
              ],
            ),
            VerticalSpacer(size: 15.h),
            Center(
              child: CircleAvatar(
                radius: 50.r,
                backgroundColor: Colors.grey,
                backgroundImage: profilePictureUrl != null
                    ? NetworkImage(profilePictureUrl!)
                    : const AssetImage('assets/default_profile.png')
                        as ImageProvider,
              ),
            ),
            VerticalSpacer(size: 10.h),
            Center(
              child: TextButton(
                onPressed: onPickImage,
                child: Text(
                  "change_pfp".tr(),
                  style: TextStyle(color: Colors.blue, fontSize: 14.sp),
                ),
              ),
            ),
            ProfileField(
              label: "name".tr(),
              controller: nameController,
            ),
            ProfileField(
              label: "username".tr(),
              controller: usernameController,
              validator: Validators.validateUsername,
            ),
            ProfileField(
              label: "bio".tr(),
              controller: bioController,
            ),
            VerticalSpacer(size: 15.h),
            Divider(color: divider, thickness: 1.h),
            VerticalSpacer(size: 15.h),
            Align(
              alignment: Alignment.centerLeft,
              child: SizedBox(
                width: 260.w,
                child: InkWell(
                  onTap: () {},
                  child: Text(
                    "switch_to_prof".tr(),
                    style: TextStyle(color: buttonPrimary, fontSize: 16.sp),
                  ),
                ),
              ),
            ),
            VerticalSpacer(size: 20.h),
            Text(
              "private_info".tr(),
              style: TextStyle(
                color: textPrimary,
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            ProfileField(
              label: "email".tr(),
              controller: emailController,
              validator: Validators.validateEmail,
            ),
            ProfileField(
              label: "phone".tr(),
              controller: phoneController,
              validator: Validators.validatePhoneNumber,
            ),
          ],
        ),
      ),
    );
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: TextStyle(fontSize: 14.sp)),
        backgroundColor: error,
      ),
    );
  }
}
