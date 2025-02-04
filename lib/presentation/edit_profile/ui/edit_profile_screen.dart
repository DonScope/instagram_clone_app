import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_clone_app/presentation/edit_profile/cubit/edit_profile_cubit.dart';
import 'package:instagram_clone_app/presentation/edit_profile/ui/edit_profile_form.dart';
import 'package:instagram_clone_app/presentation/profile/cubit/profile_cubit/profile_cubit.dart';

import '../../../data/models/user_model.dart';

class EditProfileScreen extends StatelessWidget {
  EditProfileScreen({super.key});

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
      await EditProfileCubit.get(context).uploadProfilePicture(
        imageFile,
      );
      EditProfileCubit.get(context).fetchUserData();
    }
  }

  @override
  Widget build(BuildContext context) {
    EditProfileCubit.get(context).fetchUserData();
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: BlocConsumer<EditProfileCubit, EditProfileState>(
            listener: (context, state) {
              if (state is UserFetchError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.error.toString())),
                );
              } else if (state is EditProfileSuccess) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text("Profile updated successfully!")),
                );
              }
            },
            builder: (context, state) {
              if (state is UserFetchSuccess) {
                final userData = state.userData;

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
                  onUpdate: () {
                    final updatedUser = UserModel(
                      name: _nameController.text,
                      userName: _usernameController.text,
                      bio: _bioController.text,
                      email: _emailController.text,
                      phoneNumber: _phoneController.text,
                    );
                    EditProfileCubit.get(context).updateUserData(updatedUser);
                    ProfileCubit.get(context).fetchUserData();
                  },
                );
              }
              return Center(child: CircularProgressIndicator());
            },
          ),
        ),
      ),
    );
  }
}
