import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:instagram_clone_app/shared_widgets/horizontal_spacer.dart';
import 'package:instagram_clone_app/shared_widgets/vertical_spacer.dart';
import 'package:shimmer/shimmer.dart';

class PlaceholderShimmer extends StatelessWidget {
  const PlaceholderShimmer({super.key});

  @override
  Widget build(BuildContext context) {
      return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Shimmer for profile picture
            Row(
              children: [
                CircleAvatar(
                  radius: 15.r,
                  backgroundColor: Colors.grey[300],
                ),
                HorizontalSpacer(),
                Container(
                  width: 100.w,
                  height: 15.h,
                  color: Colors.grey[300],
                ),
              ],
            ),
            VerticalSpacer(size: 5),
            // Shimmer for post image
            Container(
              width: MediaQuery.of(context).size.width,
              height: 390.h,
              color: Colors.grey[300],
            ),
            VerticalSpacer(size: 10),
            // Shimmer for icons (like buttons)
            Row(
              children: [
                Container(
                  width: 24.w,
                  height: 24.h,
                  color: Colors.grey[300],
                ),
                HorizontalSpacer(),
                Container(
                  width: 24.w,
                  height: 24.h,
                  color: Colors.grey[300],
                ),
                HorizontalSpacer(),
                Container(
                  width: 24.w,
                  height: 24.h,
                  color: Colors.grey[300],
                ),
                Spacer(),
                Container(
                  width: 24.w,
                  height: 24.h,
                  color: Colors.grey[300],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}