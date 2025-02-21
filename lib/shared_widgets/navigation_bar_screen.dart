import 'package:flutter/material.dart';
import 'package:instagram_clone_app/presentation/home/ui/home_screen.dart';
import 'package:instagram_clone_app/presentation/profile/ui/profile_screen.dart';
import 'package:instagram_clone_app/presentation/reel/ui/reel_screen.dart';
import 'package:instagram_clone_app/presentation/search/ui/search_screen.dart';

class NavigationBarScreeen extends StatelessWidget {
  const NavigationBarScreeen({super.key});

  @override
  Widget build(BuildContext context) {
    final ValueNotifier<int> currentIndex = ValueNotifier<int>(0);

    List<Widget> screens = [
      HomeScreen(),
      SearchScreen(),
      ReelScreen(),
      ProfileScreen(),
    ];
    return Scaffold(
      bottomNavigationBar: ValueListenableBuilder<int>(
        valueListenable: currentIndex,
        builder: (context, index, child) {
          return BottomNavigationBar(
              onTap: (value) {
                currentIndex.value = value;
              },
              type: BottomNavigationBarType.fixed,
              currentIndex: index,
              items: [
                BottomNavigationBarItem(
                    icon: Icon(
                      Icons.home_outlined,
                    ),
                    label: ""),
                BottomNavigationBarItem(
                    icon: Icon(
                      Icons.video_collection_outlined,
                    ),
                    label: ""),
                BottomNavigationBarItem(
                    icon: Icon(Icons.person_outline), label: ""),
              ]);
        },
      ),
      body: ValueListenableBuilder<int>(
        valueListenable: currentIndex,
        builder: (context, index, child) {
          return screens[index];
        },
      ),
    );
  }
}
