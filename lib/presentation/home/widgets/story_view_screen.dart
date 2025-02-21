import 'package:flutter/material.dart';
import 'package:instagram_clone_app/data/models/story_model.dart';

class StoryViewScreen extends StatelessWidget {
  const StoryViewScreen({super.key, required this.stories,  this.initialPage = 0});
   final List<StoryModel> stories;
  final int initialPage;
  @override
  Widget build(BuildContext context) {
    final PageController pageController = PageController(initialPage: initialPage);
    return PageView.builder(
      controller: pageController,
      itemCount: stories.length,
      itemBuilder: (context, index) {
        final story = stories[index];
        return Container(
          width: double.infinity,
          height: double.infinity,
          child: Image.network(story.mediaUrl, fit: BoxFit.cover,),
        );
      },
    );
  }
}