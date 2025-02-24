import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:instagram_clone_app/config/app_colors/app_colors.dart';
import 'package:instagram_clone_app/core/web_services/user_service.dart';
import 'package:instagram_clone_app/data/models/user_model.dart';
import 'package:instagram_clone_app/data/repository/user_services/user_repository.dart';
import 'package:instagram_clone_app/presentation/profile/cubit/posts_cubit/post_cubit.dart';
import 'package:instagram_clone_app/presentation/profile/cubit/profile_cubit/profile_cubit.dart';
import 'package:instagram_clone_app/presentation/profile/cubit/profile_reel_cubit/profile_reel_cubit.dart';
import 'package:instagram_clone_app/presentation/profile/ui/posts_grid.dart';
import 'package:instagram_clone_app/presentation/profile/ui/reels_grid.dart';
import 'package:instagram_clone_app/shared_widgets/action_button.dart';
import 'package:instagram_clone_app/shared_widgets/horizontal_spacer.dart';
import 'package:instagram_clone_app/shared_widgets/vertical_spacer.dart';

class UserProfileScreen extends StatelessWidget {
  const UserProfileScreen({Key? key, required this.userModel})
      : super(key: key);

  final UserModel userModel;

  @override
  Widget build(BuildContext context) {
    final data = userModel;

    return DefaultTabController(
      length: 2,
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
              create: (context) => PostCubit(UserRepository(UserService()))
                ..getPosts(userId: userModel.uId)),
          BlocProvider(
            create: (context) => ProfileReelCubit(UserRepository(UserService()))
              ..getReels(userId: userModel.uId),
          ),
          BlocProvider(
              create: (context) => ProfileCubit(UserRepository(UserService()))),
        ],
        child: Scaffold(
          body: SafeArea(
            child: Padding(
              padding: EdgeInsets.all(12.w),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// -- Header Row (Username + Add/Menu Icons) --
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: Icon(
                              Icons.arrow_back_ios_new_outlined,
                              size: 25,
                            )),
                        Text(
                          data.name ?? "Profile",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 22.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Row(
                          children: [
                            IconButton(
                              onPressed: () {},
                              icon: const Icon(Icons.notifications_outlined),
                            ),
                            IconButton(
                              onPressed: () {},
                              icon: const Icon(Icons.more_horiz_outlined),
                            ),
                          ],
                        ),
                      ],
                    ),

                    /// -- Profile Picture & Stats (Posts/Followers/Following) --
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 50.r,
                          backgroundImage:
                              NetworkImage(data.profilePicUrl ?? ""),
                        ),
                        HorizontalSpacer(size: 85.h),
                        Row(
                          children: [
                            /// Posts
                            Builder(builder: (context) {
                              return Column(
                                children: [
                                  Text(
                                    // If you store post count in userModel, show it here
                                    "${context.watch<PostCubit>().postLength}",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text("posts".tr()),
                                ],
                              );
                            }),
                            HorizontalSpacer(),

                            Column(
                              children: [
                                Text(
                                  "${data.followersCount ?? 0}",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text("followers".tr())
                              ],
                            ),
                            HorizontalSpacer(),

                            Column(
                              children: [
                                Text(
                                  "${data.followingCount ?? 0}",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text("following".tr())
                              ],
                            ),
                          ],
                        )
                      ],
                    ),
                    VerticalSpacer(),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          data.userName ?? "",
                          style: TextStyle(
                            color: textPrimary,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          data.bio?.isEmpty == true ? "" : data.bio ?? "",
                          style: TextStyle(
                            color: textPrimary,
                            fontSize: 13.sp,
                          ),
                        ),
                      ],
                    ),
                    VerticalSpacer(),

                    Row(
                      children: [
                        SizedBox(
                          width: 100.w,
                          height: 40.h,
                          child: Stack(
                            children: List.generate(3, (index) {
                              return Positioned(
                                left: index * 20.0.w,
                                child: CircleAvatar(
                                  radius: 20.r,
                                  backgroundImage:
                                      NetworkImage(data.profilePicUrl ?? ""),
                                  backgroundColor: Colors.grey[200],
                                ),
                              );
                            }),
                          ),
                        ),
                        SizedBox(
                          width: 250.w,
                          child: Text(
                            "Followed by username, username and 100 others",
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                          ),
                        )
                      ],
                    ),
                    VerticalSpacer(),

                    Builder(builder: (context) {
                      return Row(
                        children: [
                          ActionButton(
                            text: "Follow".tr(),
                            width: 340.w,
                            height: 45.h,
                            color: textDisabled,
                            iconColor: textPrimary,
                            onPressed: () {
                              ProfileCubit.get(context)
                                  .followUser(targetUserId: userModel.uId!);
                            },
                          ),
                          HorizontalSpacer(),
                          ActionButton(
                            icon: Icons.person_add_alt,
                            width: 40.w,
                            height: 45.h,
                            color: textDisabled,
                            iconColor: textPrimary,
                            onPressed: () {
                              // For example: handle "Add friend" or "Follow" logic
                            },
                          ),
                        ],
                      );
                    }),
                    VerticalSpacer(),

                    const TabBar(
                      tabs: [
                        Tab(icon: Icon(Icons.grid_on_sharp)),
                        Tab(icon: Icon(Icons.video_collection_rounded)),
                      ],
                    ),
                    VerticalSpacer(),
                    SizedBox(
                      width: double.infinity,
                      height: 350.h,
                      child: const TabBarView(
                        children: [
                          PostsGrid(),
                          ReelsGrid(),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
