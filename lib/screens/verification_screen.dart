import 'dart:math';

import 'package:camera/camera.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:green_aid/components/navigation.dart';
import 'package:page_transition/page_transition.dart';
// import 'package:page_transition/page_transition.dart';

class VerificationScreen extends StatelessWidget {
  VerificationScreen({super.key, required this.camera, required this.verificationId});
  final CameraDescription camera;
  late List<TextEditingController?> controls;
  String verificationId;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Theme.of(context).colorScheme.primary,
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 50),
                Image(
                  image: const AssetImage("assets/images/verification.png"),
                  width: screenWidth / 2,
                ),
                const SizedBox(height: 50),
                const Text(
                  "Verification",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    // color: Color.fromRGBO(33, 33, 33, 1)
                  )
                ),
                const Text(
                  "Enter your OTP code number",
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 13,
                    color: Color.fromRGBO(83, 83, 83, 1)
                  )
                ),
                const SizedBox(height: 50),
                OtpTextField(
                  numberOfFields: 4,
                  focusedBorderColor: Theme.of(context).colorScheme.primary,
                  onCodeChanged: (String code) {},
                  handleControllers: (controllers) {
                    controls = controllers;
                  },
                  onSubmit: (String verificationCode) async {
                    try {
                      PhoneAuthCredential credential = await PhoneAuthProvider.credential(
                            verificationId: this.verificationId,
                            smsCode: verificationCode,
                      );
                      FirebaseAuth.instance.signInWithCredential(credential).then((value) {
                        Navigator.pushAndRemoveUntil(
                          context,
                          PageTransition(
                            child: Navigation(camera: camera, uid: 'asdf',), 
                            type: PageTransitionType.fade, 
                            curve: Curves.easeInOut,
                            duration: const Duration(milliseconds: 100),
                          ), (Route route) => false
                        );
                      });
                    }catch(ex) {
                      print(ex.toString());
                    }
                  },
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: screenWidth - 60,
                  child: TextButton(
                    onPressed: () async {
                      // String code = "";
                      // controls.forEach((control) async {
                      //   code += control?.text;
                      // });
                      // try {
                      //   PhoneAuthCredential credential = await PhoneAuthProvider.credential(verificationId: this.verificationId, smsCode: otpCo)
                      // }catch(ex) {

                      // }
                      // Navigator.pushAndRemoveUntil(
                      //   context,
                      //   PageTransition(
                      //     child: Navigation(camera: camera), 
                      //     type: PageTransitionType.fade, 
                      //     curve: Curves.easeInOut,
                      //     duration: const Duration(milliseconds: 100),
                      //   ), (Route route) => false
                      // );
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: const Color.fromARGB(255, 255, 255, 255),
                    ),
                    child: const Text("Verify"),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  "Didn't receive any code?",
                  style: TextStyle(
                    fontSize: 14
                  ),
                ),
                // const SizedBox(height: 10),
                TextButton(
                  onPressed: () {
                    
                  },
                  child: const Text(
                    "Resend Code",
                    style: TextStyle(
                      color: Color.fromRGBO(52, 190, 73, 1),
                      fontSize: 15
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      );
  }
}