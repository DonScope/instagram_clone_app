import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_clone_app/presentation/profile/widgets/custom_shimmer.dart';

import '../cubit/posts_cubit/post_cubit.dart';

class PostsGrid extends StatelessWidget {
  const PostsGrid({super.key});

  @override
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PostCubit, PostState>(builder: (context, state) {
      if (state is PostUploadLoading || state is PostGetLoading) {
        return CustomShimmer();
      }
      if (state is PostGetSuccess) {
        if (state.posts.isNotEmpty) {
          final posts = state.posts;

          return GridView.builder(
                  physics: NeverScrollableScrollPhysics( ),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 4,
                mainAxisSpacing: 5,
                childAspectRatio: 1),
            itemCount: posts.length,
            itemBuilder: (context, index) {
              return Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.transparent),
                ),
                child: Stack(
                  children: [
                    posts[index].thumbnailUrl != null
                        ? Image.network(
                            posts[index].thumbnailUrl!,
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: double.infinity,
                          )
                        : Image.network(
                            posts[index].mediaUrl,
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: double.infinity,
                          ),
                    Positioned(
                      top: 10,
                      right: 10,
                      child: Icon(
                        posts[index].thumbnailUrl != null
                            ? Icons.video_collection_rounded
                            : Icons.image,
                        color: Colors.white,
                        size: 25,
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        }
      }
      return const Center(child: Text('No posts found'));
    });
  }
}
