
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_clone_app/presentation/profile/cubit/profile_reel_cubit/profile_reel_cubit.dart';
import 'package:instagram_clone_app/presentation/profile/widgets/custom_shimmer.dart';

class ReelsGrid extends StatelessWidget {
  const ReelsGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileReelCubit, ProfileReelState>(builder: (context, state) {
      if (state is ReelsGetLoading || state is ReelsUploadLoading) {
        return CustomShimmer();
      }
      if (state is ReelsGetSuccess) {
        if (state.reels.isNotEmpty) {
          final reels = state.reels;

          return GridView.builder(
            physics: NeverScrollableScrollPhysics(  ),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 4,
                mainAxisSpacing: 5,
                childAspectRatio: 1),
            itemCount: reels.length,
            itemBuilder: (context, index) {
              return Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.transparent),
                  ),
                  child: Image.network(
                    reels[index].thumbnailUrl ?? reels[index].mediaUrl,
                    fit: BoxFit.cover,
                  ));
            },
          );
        }
      }
      return const Center(child: Text('No reels found'));
    });
  }
}
