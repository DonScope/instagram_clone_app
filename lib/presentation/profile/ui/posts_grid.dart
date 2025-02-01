import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_clone_app/presentation/profile/cubit/posts/post_cubit.dart';

class PostsGrid extends StatelessWidget {
  const PostsGrid({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PostCubit, PostState>(builder: (context, state) {
      if (state is PostGetLoading) {
        return const Center(child: CircularProgressIndicator());
      }
      if (state is PostGetSuccess) {
        if (state.posts.isNotEmpty) {
          final posts = state.posts;
          return GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 4,
                mainAxisSpacing: 5,
                childAspectRatio: 1),
            itemCount: posts.length,
            itemBuilder: (context, index) {
              return Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.blue),
                  ),
                  child:  Image.network(
  posts[index].thumbnailUrl ?? posts[index].mediaUrl,
  fit: BoxFit.cover,
  errorBuilder: (context, error, stackTrace) {
    // Fallback to a placeholder image if the thumbnail fails to load
    return Image.asset(
      'assets/placeholder.png', // Add a placeholder image to your assets
      fit: BoxFit.cover,
    );
  },
));
            },
          );
        }
      } else {
        return const Center(child: Text('No posts found'));
      }
      return const Center(child: Text('No posts found'));
    });
  }
  bool isVideo(String url) {
  return url.endsWith('.mp4') || url.endsWith('.mov') || url.endsWith('.avi') || url.endsWith('.mkv');
}
}
