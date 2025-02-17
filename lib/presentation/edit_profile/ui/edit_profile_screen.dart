import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_clone_app/core/web_services/user_service.dart';
import 'package:instagram_clone_app/data/repository/user_services/user_repository.dart';
import 'package:instagram_clone_app/presentation/edit_profile/cubit/edit_profile_cubit.dart';
import 'package:instagram_clone_app/presentation/edit_profile/ui/edit_profile_form.dart';
import 'package:instagram_clone_app/presentation/profile/cubit/profile_cubit/profile_cubit.dart';

import '../../../data/models/user_model.dart';

class EditProfileScreen extends StatelessWidget {
  EditProfileScreen({super.key, required this.profileCubit});
  final ProfileCubit profileCubit;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(BuildContext context) async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final imageFile = File(pickedFile.path);
      await EditProfileCubit.get(context).uploadProfilePicture(imageFile);
      EditProfileCubit.get(context).fetchUserData();
      profileCubit.fetchUserData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16.w), // Adjust padding using ScreenUtil
          child: BlocProvider(
            create: (context) => EditProfileCubit(UserRepository(UserService()))
              ..fetchUserData(),
            child: BlocConsumer<EditProfileCubit, EditProfileState>(
              listenWhen: (previous, current) =>
                  current is EditProfileSuccess || current is UserFetchError,
              listener: (context, state) {
                if (state is UserFetchError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text(state.error.toString(),
                            style: TextStyle(fontSize: 14.sp))),
                  );
                } else if (state is EditProfileSuccess) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text("Profile updated successfully!",
                            style: TextStyle(fontSize: 14.sp))),
                  );
                }
              },
              buildWhen: (previous, current) => current is! EditProfileLoading,
              builder: (context, state) {
                if (state is UserFetchSuccess || state is EditProfileSuccess) {
                  final userData = state is UserFetchSuccess
                      ? state.userData
                      : (state as EditProfileSuccess).userData;

                  _nameController.text = userData.name ?? '';
                  _usernameController.text = userData.userName ?? '';
                  _bioController.text = userData.bio ?? '';
                  _emailController.text = userData.email ?? '';
                  _phoneController.text = userData.phoneNumber ?? '';

                  return EditProfileForm(
                    nameController: _nameController,
                    usernameController: _usernameController,
                    bioController: _bioController,
                    emailController: _emailController,
                    phoneController: _phoneController,
                    profilePictureUrl: userData.profilePicUrl,
                    currentUsername: userData.userName ?? '',
                    currentEmail: userData.email ?? '',
                    onPickImage: () => _pickImage(context),
                    onUpdate: () async {
                      final updatedUser = UserModel(
                        name: _nameController.text,
                        userName: _usernameController.text,
                        bio: _bioController.text,
                        email: _emailController.text,
                        phoneNumber: _phoneController.text,
                      );
                      await EditProfileCubit.get(context)
                          .updateUserData(updatedUser);
                      await profileCubit.fetchUserData();
                      Navigator.pop(context);
                    },
                  );
                }
                return Center(
                  child: CircularProgressIndicator(strokeWidth: 2.5.w),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
