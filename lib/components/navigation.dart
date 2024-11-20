import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:green_aid/screens/friends_screen.dart';
import 'package:green_aid/screens/profile_screen.dart';
import 'package:green_aid/screens/library_screen.dart';
import 'package:green_aid/components/search_bar.dart';
import 'package:green_aid/screens/take_picture_screen.dart';
import 'package:green_aid/services/database.dart';
import 'package:page_transition/page_transition.dart';
import 'package:green_aid/screens/home_screen.dart';

class Navigation extends StatefulWidget {
  const Navigation({super.key, required this.camera, required this.uid});
  final CameraDescription camera;
  final String? uid;

  @override
  State<Navigation> createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  int currentPageIndex = 0;
  Map<String, dynamic>? data;

  @override
  void initState() {
    DatabaseService(uid: widget.uid).getUserData().then((snapshot) {
      if(snapshot.exists) {
        data = snapshot.data() as Map<String, dynamic>?;
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        flexibleSpace: currentPageIndex != 3 ? const AppSearchBar() : null,
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
      ),
      bottomNavigationBar: Material(
        color: Colors.white,
        elevation: 30,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
          child: NavigationBarTheme(
            data: NavigationBarThemeData(
              labelTextStyle: WidgetStateProperty.all(
                const TextStyle(
                  color: Color.fromARGB(255, 90, 90, 90),
                  fontSize: 12,
                  fontWeight: FontWeight.w500
                )
              )
            ),
            child: NavigationBar(
              onDestinationSelected: (int index) {
                setState(() {
                  // if (index != 4) {
                    index > 1 ? currentPageIndex = index - 1 : currentPageIndex = index;
                  // }
                  // else {
                  //   Navigator.push(
                  //     context, 
                  //     PageTransition(
                  //       child: ProfileScreen(firstName: data?['firstName'], lastName: data?['lastName'],email: data?['email'],), 
                  //       type: PageTransitionType.bottomToTop, 
                  //       childCurrent: widget,
                  //       curve: Curves.easeOut,
                  //       duration: const Duration(milliseconds: 200),
                  //       reverseDuration: const Duration(milliseconds: 100)
                  //     )
                  //   );
                  // }
                });
              },
              selectedIndex: currentPageIndex > 1 ? currentPageIndex + 1 : currentPageIndex,
              backgroundColor: Colors.transparent,
              destinations: <Widget> [
                NavigationDestination(icon: Icon(Icons.home_outlined, color: currentPageIndex == 0 ? Colors.white : const Color.fromARGB(255, 90, 90, 90), size: 30,), label: "Home"),
                NavigationDestination(icon: Icon(Icons.groups_2_outlined, color: currentPageIndex == 1 ? Colors.white : const Color.fromARGB(255, 90, 90, 90), size: 30,), label: "Network"),
                CircleAvatar(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  radius: 30,
                  child: IconButton(
                    onPressed: () {
                      Navigator.push(
                        context, 
                        PageTransition(
                          child: TakePictureScreen(camera: widget.camera, uid: widget.uid), 
                          type: PageTransitionType.bottomToTop, 
                          childCurrent: widget,
                          curve: Curves.easeOut,
                          duration: const Duration(milliseconds: 200),
                          reverseDuration: const Duration(milliseconds: 100)
                        )
                      );
                    },
                    icon: const Icon(Icons.camera_alt_outlined, color: Colors.white, size: 25,),
                  ),
                ),
                NavigationDestination(icon: Icon(Icons.bookmark_outline, color: currentPageIndex == 2 ? Colors.white : const Color.fromARGB(255, 90, 90, 90), size: 30,), label: "Library"),
                NavigationDestination(icon: Icon(Icons.person_outlined, color: currentPageIndex == 3 ? Colors.white : const Color.fromARGB(255, 90, 90, 90), size: 30,), label: "Profile"),
              ],
              indicatorColor: Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
      ),
      body: <Widget>[
        HomeScreen(uid: widget.uid),
        FriendsScreen(),
        LibraryScreen(uid: widget.uid),
        ProfileScreen(uid: widget.uid, camera: widget.camera)
      ][currentPageIndex],
    );
  }
}