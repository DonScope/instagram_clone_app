import 'package:flutter/material.dart';

class TaggedGrid extends StatelessWidget {
  const TaggedGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3, // 3 posts in a row
        crossAxisSpacing: 2,
        mainAxisSpacing: 2,
      ),
      itemBuilder: (context, index) {
        return Container(
          color: Colors.pink[200],
        );
      },
    );
  }
}
