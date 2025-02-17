import 'package:flutter/material.dart';
import 'package:instagram_clone_app/presentation/home/ui/home_screen.dart';
import 'package:instagram_clone_app/presentation/profile/ui/profile_screen.dart';
import 'package:instagram_clone_app/presentation/reel/ui/reel_screen.dart';

class NavigationBarScreeen extends StatelessWidget {
  const NavigationBarScreeen({super.key});

  @override
  Widget build(BuildContext context) {
    final ValueNotifier<int> currentIndex = ValueNotifier<int>(0);


    List<Widget> screens = [
      HomeScreen(),
      ReelScreen(),
      ProfileScreen(),
    ];
    return Scaffold(
      bottomNavigationBar: ValueListenableBuilder<int>(
        valueListenable: currentIndex,
        builder: (context, index, child) {
          return BottomNavigationBar(
              backgroundColor: Colors.black,
              onTap: (value) {
                currentIndex.value = value;
              },
              type: BottomNavigationBarType.fixed,
              selectedItemColor: Colors.white,
              unselectedItemColor: Colors.white,
              currentIndex: index,
              items: [
                BottomNavigationBarItem(
                    icon: Icon(
                      Icons.home,
                    ),
                    label: ""),
                           BottomNavigationBarItem(
                    icon: Icon(
                      Icons.video_collection_outlined,
                    ),
                    label: ""),
                BottomNavigationBarItem(
                    icon: Icon(Icons.person), label: ""),

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
