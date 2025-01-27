import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:instagram_clone_app/core/helpers/navigation_helper.dart';
import 'package:instagram_clone_app/core/utils/validators.dart';
import 'package:instagram_clone_app/presentation/edit_profile/widgets/ProfileField.dart';
import 'package:instagram_clone_app/presentation/profile/ui/profile_screen.dart';

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
    required this.currentEmail, this.currentUsername,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                onPressed: () => NavigationHelper.goTo(context,ProfileScreen()),
                child: Text(
                  "Cancel",
                  style: TextStyle(color: error, fontSize: 16.sp),
                ),
              ),
              Text(
                "Edit Profile",
                style: TextStyle(
                  color: textPrimary,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final email = emailController.text;
                    final emailExistsError =
                        await Validators.validateEmailExists(email,
                            currentUserEmail: currentEmail);
                    if (emailExistsError != null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(emailExistsError),
                          backgroundColor: error,
                        ),
                      );
                      return;
                    }
                    final username = usernameController.text;
                    final usernameExistsError =
                        await Validators.validateUsernameExists(username,
                            currentUsername: currentUsername);
                             if (usernameExistsError != null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(usernameExistsError),
                          backgroundColor: error,
                        ),
                      );
                      return;
                    }
                    onUpdate();
                  }
                },
                child: Text(
                  "Done",
                  style: TextStyle(color: buttonPrimary, fontSize: 16.sp),
                ),
              ),
            ],
          ),
          const VerticalSpacer(size: 15),
          CircleAvatar(
            radius: 50,
            backgroundColor: Colors.grey,
            backgroundImage: profilePictureUrl != null
                ? NetworkImage(profilePictureUrl!)
                : const AssetImage('assets/default_profile.png')
                    as ImageProvider,
          ),
          const VerticalSpacer(size: 10),
          TextButton(
            onPressed: onPickImage,
            child: const Text(
              "Change Profile Photo",
              style: TextStyle(color: Colors.blue),
            ),
          ),
          ProfileField(
            label: "Name",
            controller: nameController,
          ),
          ProfileField(
            label: "Username",
            controller: usernameController,
            validator: Validators.validateUsername,
          ),
          ProfileField(
            label: "Bio",
            controller: bioController,
          ),
          const VerticalSpacer(size: 15),
          Divider(color: divider),
          const VerticalSpacer(size: 15),
          Align(
            alignment: Alignment.centerLeft,
            child: SizedBox(
              width: 260.w,
              child: InkWell(
                onTap: () {},
                child: Text(
                  "Switch to Professional Account",
                  style: TextStyle(color: buttonPrimary, fontSize: 16.sp),
                ),
              ),
            ),
          ),
          const VerticalSpacer(size: 20),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Private Information",
              style: TextStyle(
                color: textPrimary,
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ProfileField(
            label: "Email",
            controller: emailController,
            validator: Validators.validateEmail,
          ),
          ProfileField(
            label: "Phone",
            validator: Validators.validatePhoneNumber,
            controller: phoneController,
          ),
        ],
      ),
    );
  }
}
