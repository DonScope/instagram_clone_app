
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:instagram_clone_app/config/app_colors/app_colors.dart';
import 'package:instagram_clone_app/presentation/edit_profile/widgets/ProfileField.dart';
import 'package:instagram_clone_app/shared_widgets/vertical_spacer.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController _nameController = TextEditingController();
    TextEditingController _usernameController = TextEditingController();
    TextEditingController _websiteController = TextEditingController();
    TextEditingController _bioController = TextEditingController();
    TextEditingController _emailController = TextEditingController();
    TextEditingController _phoneController = TextEditingController();
    TextEditingController _genderController = TextEditingController();

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                      onPressed: () {
                      },
                      child: Text(
                        "Cancel",
                        style: TextStyle(color: error, fontSize: 16.sp),
                      )),
                  Text(
                    "Edit Profile",
                    style: TextStyle(
                        color: textPrimary,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold),
                  ),
                  TextButton(
                      onPressed: () {},
                      child: Text(
                        "Done",
                        style: TextStyle(color: buttonPrimary, fontSize: 16.sp),
                      )),
                ],
              ),
              const VerticalSpacer(
                size: 15,
              ),
              const CircleAvatar(
                radius: 50,
                backgroundColor: primary,
                // backgroundImage: AssetImage("assets/images/profile.jpg"),
              ),
              const VerticalSpacer(
                size: 10,
              ),
              TextButton(
                  onPressed: () {},
                  child: const Text(
                    "Change Profile Photo",
                    style: TextStyle(color: Colors.blue),
                  )),
              ProfileField(
                label: "Name",
                controller: _nameController,
                onChanged: (value) {},
              ),
              ProfileField(
                label: "Username",
                controller: _usernameController,
                onChanged: (value) {},
              ),
              ProfileField(
                label: "Website",
                controller: _websiteController,
                onChanged: (value) {},
              ),
              ProfileField(
                label: "Bio",
                controller: _bioController,
                onChanged: (value) {},
              ),
              VerticalSpacer(size: 15),
              Divider(
                color: divider,
              ),
              VerticalSpacer(size: 15),
              Align(
                alignment: Alignment.centerLeft,
                child: SizedBox(
                  width: 260.w,
                  child: InkWell(
                      onTap: () {},
                      child: Text(
                        "Switch to Professional Account",
                        style: TextStyle(color: buttonPrimary, fontSize: 16.sp),
                      )),
                ),
              ),
              VerticalSpacer(size: 20),
              Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Private Information",
                    style: TextStyle(
                        color: textPrimary,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold),
                  )),
              ProfileField(
                label: "Email",
                controller: _emailController,
                onChanged: (value) {},
              ),
              ProfileField(
                label: "Phone",
                controller: _phoneController,
                onChanged: (value) {},
              ),
              ProfileField(
                label: "Gender",
                controller: _genderController,
                onChanged: (value) {},
              )
            ],
          ),
        ),
      ),
    );
  }
}
