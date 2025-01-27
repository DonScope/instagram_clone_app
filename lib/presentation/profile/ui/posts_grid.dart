import 'package:flutter/material.dart';
class PostsGrid extends StatelessWidget {
  const PostsGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3, // 3 posts in a row
        crossAxisSpacing: 2,
        mainAxisSpacing: 2,
      ),
      itemCount: 9, // Dummy count
      itemBuilder: (context, index) {
        return Container(
          color: Colors.grey[300], // Placeholder color
          child: Center(child: Text('Post ${index + 1}')),
        );
      },
    );
  }
}