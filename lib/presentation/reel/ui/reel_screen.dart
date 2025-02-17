import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_clone_app/core/web_services/user_service.dart';
import 'package:instagram_clone_app/data/repository/user_services/user_repository.dart';
import 'package:instagram_clone_app/presentation/reel/cubit/reel_cubit.dart';
import 'package:instagram_clone_app/presentation/reel/cubit/reel_state.dart';
import 'package:instagram_clone_app/presentation/reel/widgets/reel_item.dart';

class ReelScreen extends StatelessWidget {
  const ReelScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (context) =>
            ReelCubit(UserRepository(UserService()))..LoadReels(),
        child: BlocBuilder<ReelCubit, ReelState>(
          builder: (context, state) {
            if (state is ReelLoaded) {
              var cubit = ReelCubit.get(context);
              var reelCubit = state.allReels;
              var userCubit = state.userDataList;
              return PageView.builder(
                scrollDirection: Axis.vertical,
                itemCount: state.videoController.length,
                itemBuilder: (context, index) {
                  state.videoController[index]
                    ..setLooping(true)
                    ..setVolume(0);

                  return GestureDetector(
                    onTap: () {},
                    child: ReelItem(
                      likePost: cubit.likeReel,
                      reelModel: reelCubit[index],
                      videoController: state.videoController[index],
                      userData: userCubit[index],
                    ),
                  );
                },
              );
            } else if (state is ReelLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is ReelError) {
              return Center(
                  child: Text('No reels found. Please try again later!'));
            }
            return Center(child: Text('No reels found.'));
          },
        ),
      ),
    );
  }
}
