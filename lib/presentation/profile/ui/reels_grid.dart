
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_clone_app/presentation/profile/cubit/reel_cubit/reel_cubit.dart';
import 'package:instagram_clone_app/presentation/profile/widgets/custom_shimmer.dart';

class ReelsGrid extends StatelessWidget {
  const ReelsGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReelCubit, ReelState>(builder: (context, state) {
      if (state is ReelsGetLoading || state is ReelsUploadLoading) {
        return CustomShimmer();
      }
      if (state is ReelsGetSuccess) {
        if (state.reels.isNotEmpty) {
          final reels = state.reels;

          return GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 4,
                mainAxisSpacing: 5,
                childAspectRatio: 1),
            itemCount: reels.length,
            itemBuilder: (context, index) {
              return Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
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
