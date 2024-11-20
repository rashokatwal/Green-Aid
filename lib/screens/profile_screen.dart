import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:green_aid/components/navigation.dart';
import 'package:green_aid/screens/login_screen.dart';
import 'package:green_aid/services/database.dart';
import 'package:page_transition/page_transition.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key, required this.uid, required this.camera});
  final String? uid;
  final CameraDescription camera;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Map<String, dynamic>? userData;

  @override
  void initState() {
    DatabaseService(uid: widget.uid).getUserData().then((snapshot) {
      if (snapshot.exists) {
        setState(() {
          userData = snapshot.data() as Map<String, dynamic>?;
        });
      }
    });
    super.initState();
  }

  Future<void> _logout() async {
    try {
      await FirebaseAuth.instance.signOut();
      // Navigate back to the login screen or welcome screen
      Navigator.pushAndRemoveUntil(
        context,
        PageTransition(
          child: LoginScreen(camera: widget.camera), 
          type: PageTransitionType.fade, 
          curve: Curves.easeInOut,
          duration: const Duration(milliseconds: 100),
        ), (Route route) => false
      );
    } catch (e) {
      // Show an error message if logout fails
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to log out: ${e.toString()}")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
        child: userData != null
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 50),
                      child: Column(
                        children: [
                          Image(
                              image: AssetImage('assets/images/default_profile.png'),
                              width: 100,
                              height: 100),
                          SizedBox(
                            height: 30,
                          ),
                          Text(
                            "${userData?['firstName']} ${userData?['lastName']}",
                            style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.secondary,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                            child: Text(
                              "${userData?['email']}",
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  ListBody(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.secondary,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: ListTile(
                          onTap: () {}, // Navigate to settings screen
                          leading: Icon(
                            Icons.settings_outlined,
                            size: 25,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          title: Text(
                            "Settings",
                            style: TextStyle(fontSize: 15),
                          ),
                          trailing: Icon(
                            Icons.chevron_right,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.secondary,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: ListTile(
                          onTap: _logout,
                          leading:  Icon(
                            Icons.logout,
                            size: 25,
                            color: Colors.redAccent,
                          ),
                          title: Text(
                            "Log Out",
                            style: TextStyle(fontSize: 15, color: Colors.redAccent),
                          ),
                        ),
                      )
                    ],
                  )
                ],
              )
            : const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
