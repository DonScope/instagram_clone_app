import 'package:flutter/material.dart';
import 'package:instagram_clone_app/config/app_colors/app_colors.dart';

class ArrowBack extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Container(

      child: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new,),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
    );
  }

}