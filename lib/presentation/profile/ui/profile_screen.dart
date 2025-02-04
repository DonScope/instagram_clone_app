import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:instagram_clone_app/config/app_colors/app_colors.dart';
import 'package:instagram_clone_app/core/helpers/post_picker_helper.dart';
import 'package:instagram_clone_app/core/helpers/navigation_helper.dart';
import 'package:instagram_clone_app/core/web_services/user_service.dart';
import 'package:instagram_clone_app/data/repository/user_services/user_repository.dart';
import 'package:instagram_clone_app/presentation/auth/cubit/cubit/auth_cubit.dart';
import 'package:instagram_clone_app/presentation/edit_profile/ui/edit_profile_screen.dart';
import 'package:instagram_clone_app/presentation/profile/cubit/posts_cubit/post_cubit.dart';
import 'package:instagram_clone_app/presentation/profile/cubit/profile_cubit/profile_cubit.dart';
import 'package:instagram_clone_app/presentation/profile/cubit/reel_cubit/reel_cubit.dart';
import 'package:instagram_clone_app/presentation/profile/ui/posts_grid.dart';
import 'package:instagram_clone_app/presentation/profile/ui/reels_grid.dart';
import 'package:instagram_clone_app/shared_widgets/horizontal_spacer.dart';
import 'package:instagram_clone_app/shared_widgets/action_button.dart';
import 'package:instagram_clone_app/shared_widgets/show_more_options.dart';
import 'package:instagram_clone_app/shared_widgets/vertical_spacer.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
            create: (context) =>
                PostCubit(UserRepository(UserService()))..getPosts()),
        BlocProvider(
          create: (context) =>
              ReelCubit(UserRepository(UserService()))..getReels(),
        ),
        BlocProvider(
          create: (context) =>
              ProfileCubit(UserRepository(UserService()))..fetchUserData(),
        ),
      ],
      child: BlocBuilder<ProfileCubit, ProfileState>(
        builder: (context, state) {
          var postCubit = PostCubit.get(context);
          var reelCubit = ReelCubit.get(context);
          if (state is ProfileFetchSuccess) {
            var data = state.userModel;
            return DefaultTabController(
              length: 2,
              child: Scaffold(
                body: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "${data.name}",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Row(
                              children: [
                                IconButton(
                                  onPressed: () {
                                    showCustomBottomSheet(context, [
                                      ListTile(
                                          leading: Icon(
                                            Icons.video_camera_back_rounded,
                                          ),
                                          onTap: () => ImagePickerHelper()
                                                  .pickAndUploadImage(
                                                      context, "reels")
                                                  .then(
                                                (value) {
                                                  reelCubit.getReels();
                                                  postCubit.getPosts();
                                                },
                                              ),
                                          title: Text('Reel')),
                                      ListTile(
                                        leading: Icon(
                                          Icons.grid_on_sharp,
                                        ),
                                        title: Text('Post'),
                                        onTap: () => ImagePickerHelper()
                                            .pickAndUploadImage(context, "post")
                                            .then(
                                          (value) {
                                            postCubit.getPosts();
                                          },
                                        ),
                                      ),
                                      ListTile(
                                        leading: Icon(
                                          Icons.add_box_outlined,
                                        ),
                                        title: Text('Story'),
                                        onTap: () async {},
                                      ),
                                    ]);
                                  },
                                  icon: const Icon(Icons.add_box_outlined),
                                ),
                                IconButton(
                                  onPressed: () {
                                    showCustomBottomSheet(context, [
                                      ListTile(
                                        leading: Icon(Icons.logout),
                                        title: Text(
                                          'Logout',
                                          style: TextStyle(color: error),
                                        ),
                                        onTap: () => AuthCubit.get(context)
                                            .logOut(context),
                                      )
                                    ]);
                                  },
                                  icon: const Icon(Icons.menu),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 50,
                              backgroundImage: NetworkImage(
                                "${data.profilePicUrl}",
                              ),
                            ),
                            HorizontalSpacer(
                              size: 85.h,
                            ),
                            Row(
                              children: [
                                Column(
                                  children: [
                                    Text(
                                      "${context.watch<PostCubit>().postLength}",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text("Posts"),
                                  ],
                                ),
                                HorizontalSpacer(),
                                Column(
                                  children: [
                                    Text(
                                      "${data.followersCount}",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text("Followers")
                                  ],
                                ),
                                HorizontalSpacer(),
                                Column(
                                  children: [
                                    Text(
                                      "${data.followingCount}",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text("Following")
                                  ],
                                ),
                              ],
                            )
                          ],
                        ),
                        VerticalSpacer(),
                        Column(
                          children: [
                            Text(
                              "${data.userName ?? "No username yet."}",
                              style: TextStyle(
                                color: textPrimary,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "${data.bio!.isEmpty ? "Empty bio" : data.bio}",
                              style: TextStyle(
                                color: textPrimary,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                        VerticalSpacer(),
                        Row(
                          children: [
                            Container(
                              width: 100,
                              height: 40,
                              child: Stack(
                                children: List.generate(3, (index) {
                                  return Positioned(
                                    left: index * 20.0,
                                    child: CircleAvatar(
                                      radius: 20,
                                      backgroundImage: NetworkImage(
                                          data.profilePicUrl.toString()),
                                      backgroundColor: Colors.grey[200],
                                    ),
                                  );
                                }),
                              ),
                            ),
                            SizedBox(
                                width: 250,
                                child: Text(
                                  "Followed by username, username and 100 others",
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                ))
                          ],
                        ),
                        VerticalSpacer(),
                        Row(
                          children: [
                            ActionButton(
                              text: "Edit profile",
                              width: 340.w,
                              height: 45.h,
                              color: textDisabled,
                              iconColor: textPrimary,
                              onPressed: () {
                                NavigationHelper.goTo(
                                    context, EditProfileScreen());
                              },
                            ),
                            HorizontalSpacer(),
                            ActionButton(
                              icon: Icons.person_add_alt,
                              width: 40.w,
                              height: 45.h,
                              color: textDisabled,
                              iconColor: textPrimary,
                              onPressed: () {},
                            ),
                          ],
                        ),
                        VerticalSpacer(),
                        TabBar(tabs: [
                          Tab(
                            icon: Icon(Icons.grid_on_sharp),
                          ),
                          Tab(
                            icon: Icon(Icons.video_collection_rounded),
                          ),
                        ]),
                        VerticalSpacer(),
                        Expanded(
                            child: TabBarView(children: [
                          PostsGrid(),
                          ReelsGrid(),
                        ]))
                      ],
                    ),
                  ),
                ),
              ),
            );
          } else if (state is ProfileFetchError) {
            return Center(
              child: Text(
                "Error occured, please try again later.",
                style: TextStyle(color: error),
              ),
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
