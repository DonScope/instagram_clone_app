import 'package:flutter/material.dart';

class ReelsGrid extends StatelessWidget {
  const ReelsGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(       crossAxisCount: 3,
        crossAxisSpacing: 2,
        mainAxisSpacing: 2,), itemBuilder: (context, index) {
      return Container(color: Colors.blue,);
    },);
  }
}