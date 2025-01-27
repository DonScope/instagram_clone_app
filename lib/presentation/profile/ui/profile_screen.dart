import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:instagram_clone_app/config/app_colors/app_colors.dart';
import 'package:instagram_clone_app/core/helpers/navigation_helper.dart';
import 'package:instagram_clone_app/presentation/edit_profile/ui/edit_profile_screen.dart';
import 'package:instagram_clone_app/presentation/profile/cubit/profile/profile_cubit.dart';
import 'package:instagram_clone_app/presentation/profile/ui/posts_grid.dart';
import 'package:instagram_clone_app/presentation/profile/ui/reels_grid.dart';
import 'package:instagram_clone_app/presentation/profile/ui/tagged_grid.dart';
import 'package:instagram_clone_app/shared_widgets/horizontal_spacer.dart';
import 'package:instagram_clone_app/shared_widgets/action_button.dart';
import 'package:instagram_clone_app/shared_widgets/vertical_spacer.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    ProfileCubit.get(context).fetchUserData();
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        if (state is ProfileFetchSuccess) {
          var data = state.userModel;
          return DefaultTabController(
            length: 3,
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
                                onPressed: () {},
                                icon: const Icon(Icons.add_box_outlined),
                              ),
                              IconButton(
                                onPressed: () {},
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
                                  const Text(
                                    "1234",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text("Posts")
                                ],
                              ),
                              HorizontalSpacer(),
                              Column(
                                children: [
                                  const Text(
                                    "1234",
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
                                  const Text(
                                    "1234",
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
                            "${data.name}",
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
                            width: 100, // Specify the width
                            height: 40, // Specify the height
                            child: Stack(
                              children: List.generate(3, (index) {
                                return Positioned(
                                  left: index *
                                      20.0, // Adjust the overlap spacing
                                  child: CircleAvatar(
                                    radius: 20, // Adjust the size of the circle
                                    backgroundImage: NetworkImage(
                                        data.profilePicUrl.toString()),
                                    backgroundColor: Colors.grey[
                                        200], // Placeholder background color
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
                        Tab(
                          icon: Icon(Icons.person_pin_outlined),
                        ),
                      ]),
                      VerticalSpacer(),
                      Expanded(
                          child: TabBarView(children: [
                        PostsGrid(),
                        ReelsGrid(),
                        TaggedGrid()
                      ]))
                    ],
                  ),
                ),
              ),
            ),
          );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
