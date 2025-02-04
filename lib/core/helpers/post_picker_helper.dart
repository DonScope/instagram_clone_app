import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_clone_app/presentation/profile/cubit/posts_cubit/post_cubit.dart';

import '../../presentation/profile/cubit/reel_cubit/reel_cubit.dart';

class ImagePickerHelper {
  final ImagePicker _picker = ImagePicker();

  Future<void> pickAndUploadImage(BuildContext context, String type) async {
    final pickedFile;
    if (type == "reels") {
      pickedFile = await _picker.pickVideo(source: ImageSource.gallery);
    } else {
      pickedFile = await _picker.pickMedia();
    }
    if (pickedFile != null) {
      final imageFile = File(pickedFile.path);

      String? caption = await _showCaptionDialog(context);
      if (type == "reels") {
      ReelCubit.get(context).emit(ReelsUploadLoading());

      }
      await PostCubit.get(context)
          .uploadPost(mediaFile: imageFile, caption: caption ?? "", type: type);

        if (type == "reels") {
      ReelCubit.get(context).emit(ReelsUploadSuccess());

      }
    }
  }

  Future<String?> _showCaptionDialog(BuildContext context) async {
    String caption = '';
    return await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Enter Caption'),
          content: TextField(
            onChanged: (text) {
              caption = text;
            },
            decoration: InputDecoration(hintText: 'Enter your caption'),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context, caption);
              },
              child: Text('Submit'),
            ),
          ],
        );
      },
    );
  }
}
