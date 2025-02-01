import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_clone_app/presentation/profile/cubit/posts/post_cubit.dart';

class ImagePickerHelper {
  final ImagePicker _picker = ImagePicker();

  Future<void> pickAndUploadImage(BuildContext context) async {
    final pickedFile = await _picker.pickMedia();

    if (pickedFile != null) {
      final imageFile = File(pickedFile.path);

      // Prompt for caption
      String? caption = await _showCaptionDialog(context);

      await PostCubit.get(context)
          .uploadPost(mediaFile: imageFile, caption: caption ?? "")
          .then((value) => PostCubit.get(context).getPosts());
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
