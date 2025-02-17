import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:instagram_clone_app/core/helpers/cache_helper.dart';
import 'package:instagram_clone_app/data/models/post_model.dart';
import 'package:instagram_clone_app/data/models/user_model.dart';
import 'package:instagram_clone_app/shared_widgets/horizontal_spacer.dart';
import 'package:instagram_clone_app/shared_widgets/vertical_spacer.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:video_player/video_player.dart';

class ReelItem extends StatefulWidget {
  const ReelItem(
      {super.key,
      required this.videoController,
      required this.reelModel,
      required this.userData,
      required this.likePost});
  final VideoPlayerController videoController;
  final PostModel reelModel;
  final UserModel userData;
  final Function(String postId) likePost;

  @override
  State<ReelItem> createState() => _ReelItemState();
}

class _ReelItemState extends State<ReelItem> {
 final uId = CacheHelper.getData(key: "uId");
  void toggleLike() {
    final isLiked = widget.reelModel.liked_by.contains(uId);

    setState(() {
      if (isLiked) {
        widget.reelModel.liked_by.remove(uId);
      } else {
        widget.reelModel.liked_by.add(uId);
      }
    });
    try {
      widget.likePost(widget.reelModel.id);
    } catch (e) {
      setState(() {
        if (isLiked) {
          widget.reelModel.liked_by.remove(uId);
        } else {
          widget.reelModel.liked_by.add(uId);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Ensure video is paused when it's not visible
    return VisibilityDetector(
      key: Key(widget.videoController.hashCode.toString()),
      onVisibilityChanged: (VisibilityInfo info) {
        double visibleFraction = info.visibleFraction;

        if (visibleFraction > 0.80) {
          widget.videoController.play();
        }
      },
      child: Stack(
        children: [
          Positioned.fill(
            child: AspectRatio(
              aspectRatio: widget.videoController.value.aspectRatio,
              child: VideoPlayer(widget.videoController),
            ),
          ),
          Positioned(
            bottom: 20,
            left: 15,
            child: Column(
              children: [
                GestureDetector(
                  onTap: () {},
                  child: Row(
                    children: [
                      CircleAvatar(
                          radius: 15,
                          backgroundImage: NetworkImage(
                              widget.userData.profilePicUrl.toString())),
                      HorizontalSpacer(
                        size: 10,
                      ),
                      Container(
                        width: 100.w,
                        child: Text(
                          widget.userData.name ?? "",
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              overflow: TextOverflow.ellipsis),
                        ),
                      ),
                    ],
                  ),
                ),
                VerticalSpacer(
                  size: 15,
                ),
                Text(
                  widget.reelModel.caption ?? "",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            right: 10.r,
            top: MediaQuery.of(context).size.height * 0.4,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                 Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                       toggleLike();

                        });

                      },
                      child: widget.reelModel.liked_by
                              .contains(uId)
                          ? Image.asset("assets/icons/liked_red.png")
                          : Image.asset("assets/icons/like_outline_white.png"),
                    ),
                    Text(widget.reelModel.liked_by.length.toString(),
                        style: TextStyle(color: Colors.white)),
                  ],
                ),
                const VerticalSpacer(
                  size: 20,
                ),
                GestureDetector(
                  child: Image.asset("assets/icons/comment_white.png"),
                ),
                const VerticalSpacer(
                  size: 20,
                ),
                IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.share,
                      color: Colors.white,
                    ))
              ],
            ),
          ),
        ],
      ),
    );
  }
}
