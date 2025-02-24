import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:instagram_clone_app/core/helpers/navigation_helper.dart';
import 'package:instagram_clone_app/core/web_services/user_service.dart';
import 'package:instagram_clone_app/data/repository/user_services/user_repository.dart';
import 'package:instagram_clone_app/presentation/chat/ui/users_screen.dart';

import 'package:instagram_clone_app/presentation/home/cubit/home_cubit.dart';
import 'package:instagram_clone_app/presentation/home/widgets/placeholder_shimmer.dart';
import 'package:instagram_clone_app/presentation/home/widgets/story_view_screen.dart';
import 'package:instagram_clone_app/presentation/profile/cubit/story_cubit/story_cubit.dart';
import 'package:instagram_clone_app/shared_widgets/horizontal_spacer.dart';
import 'package:instagram_clone_app/shared_widgets/vertical_spacer.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocProvider(
          create: (_) =>
              HomeCubit(UserRepository(UserService()))..getAllPosts(),
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                      child: Row(
                        children: [
                          SizedBox(
                              width: 137.w,
                              height: 65.h,
                              child: Row(
                                children: [
                                  Image.asset(
                                    "assets/instagram_logo_text_black.png",
                                    fit: BoxFit.contain,
                                  ),
                                ],
                              )),
                          Spacer(),
                          Icon(Icons.favorite_border_outlined),
                          HorizontalSpacer(),
                          GestureDetector(
                              onTap: () {
                                NavigationHelper.goTo(context, UsersScreen());
                              },
                              child: Icon(Icons.chat_bubble_outline_outlined)),
                          HorizontalSpacer(),
                          Icon(Icons.add),
                        ],
                      ),
                    ),
                    BlocBuilder<StoryCubit, StoryState>(
                      builder: (context, state) {
                        if (state is StoryGetSuccess) {
                          final userList = state.stories.keys.toList();
                          final storiesMap = state.stories;
                          return SizedBox(
                            height: 100,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: userList.length,
                              itemBuilder: (context, index) {
                                final user = userList[index];
                                final userStories = storiesMap[user] ?? [];
                                return GestureDetector(
                                  onTap: () => NavigationHelper.goTo(
                                    context,
                                    StoryViewScreen(
                                      stories: userStories,
                                      initialPage: 0,
                                    ),
                                  ),
                                  child: Container(
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 8.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        CircleAvatar(
                                          radius: 25,
                                          backgroundImage:
                                              NetworkImage(user.profilePicUrl!),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          user.name.toString(),
                                          style: const TextStyle(fontSize: 12),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          );
                        } else if (state is StoryGetLoading) {
                          return SizedBox.shrink();
                        } else if (state is StoryGetError) {
                          return const SizedBox(
                            height: 100,
                            child:
                                Center(child: Text("Failed to load stories")),
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                  ],
                ),
              ),
              SliverToBoxAdapter(
                child: const Divider(),
              ),
              BlocBuilder<HomeCubit, HomeState>(
                builder: (context, state) {
                  if (state is PostsLoading) {
                    return const SliverToBoxAdapter(
                      child: PlaceholderShimmer(),
                    );
                  } else if (state is PostsError) {
                    return const SliverToBoxAdapter(
                      child: Center(child: Text("Error loading posts")),
                    );
                  } else if (state is PostsLoaded) {
                    var cubit = HomeCubit.get(context);
                    final posts = state.posts;
                    return SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final post = posts[index];
                          final userData = cubit.userDataList[index];
                          final isLiked =
                              post.liked_by.contains(cubit.getCurrentUserId);

                          return Padding(
                            padding: const EdgeInsets.only(bottom: 10.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 15,
                                      backgroundImage: NetworkImage(
                                        userData.profilePicUrl.toString(),
                                      ),
                                    ),
                                    const HorizontalSpacer(),
                                    Text(userData.name.toString()),
                                    const Spacer(),
                                    const Icon(Icons.more_horiz),
                                  ],
                                ),
                                const VerticalSpacer(size: 5),
                                SizedBox(
                                  width: MediaQuery.of(context).size.width,
                                  height: 390.h,
                                  child: Image.network(
                                    post.mediaUrl,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                const VerticalSpacer(size: 10),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 6),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(post.caption.toString(), style: TextStyle(fontWeight: FontWeight.bold),),
                                      VerticalSpacer(),
                                      Row(
                                        children: [
                                          GestureDetector(
                                            onTap: () =>
                                                cubit.likePost(post.id),
                                            child: Icon(
                                              isLiked
                                                  ? Icons.favorite
                                                  : Icons.favorite_border,
                                            ),
                                          ),
                                          const HorizontalSpacer(size: 12),
                                          GestureDetector(
                                            onTap: () {},
                                            child: const Icon(
                                                Icons.comment_outlined),
                                          ),
                                          const HorizontalSpacer(size: 12),
                                          GestureDetector(
                                            onTap: () {},
                                            child:
                                                const Icon(Icons.send_outlined),
                                          ),
                                          const Spacer(),
                                          GestureDetector(
                                            onTap: () {},
                                            child: const Icon(
                                                Icons.archive_outlined),
                                          ),
                                        ],
                                      ),
                                      Text('${post.liked_by.length} likes'),
                                    ],
                                  ),
                                ),
                                const VerticalSpacer(),
                              ],
                            ),
                          );
                        },
                        childCount: posts.length,
                      ),
                    );
                  }

                  return const SliverToBoxAdapter(
                    child: Center(child: Text("List is empty.")),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
