import 'package:camera/camera.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:green_aid/components/navigation.dart';
import 'package:green_aid/screens/register_screen.dart';
import 'package:page_transition/page_transition.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key, required this.camera});
  final CameraDescription camera;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _loginKey = GlobalKey();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController= TextEditingController();

  // String phoneNumber = "";
  bool valid = false;
  bool emptyEmail = false;
  bool emptyPassword = false;
  bool obscurePassword = true;

  dynamic buttonChild = const Text("Continue");

  Future<void> userLogin() async {

    try {
      buttonChild = const SizedBox(height: 15, width: 15, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2,));
      setState(() {
      });
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text
      );
      // print(credential.user?.uid);
      Navigator.pushAndRemoveUntil(
        context,
        PageTransition(
          child: Navigation(camera: widget.camera, uid: credential.user?.uid), 
          type: PageTransitionType.fade, 
          curve: Curves.easeInOut,
          duration: const Duration(milliseconds: 100),
        ), (Route route) => false
      );
    } on FirebaseAuthException catch (e) {
      // print(e.code);
      buttonChild = const Text("Continue");
      setState(() {
      });
      switch(e.code) {
        case 'user-not-found':
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('No user found for that email.')));
          break;
        case 'wrong-password':
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Wrong password provided for that user.')));
          break;
        case 'invalid-credential':
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Email or password doesn't match")));
          break;
        default:
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Something went wrong. Please try again!")));
          break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Form(
          key: _loginKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image(image: const AssetImage('assets/images/logo_green.png'), width: MediaQuery.sizeOf(context).width/2.5),
                const SizedBox(height: 70),
                SizedBox(
                  width: MediaQuery.sizeOf(context).width - 70,
                  child: Column(
                    children: [
                      TextField(
                        controller: emailController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide(
                              color: Theme.of(context).colorScheme.primary,
                            )
                          ),
                            focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide(
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                          labelText: 'Email',
                          hintText: 'johndoe@xyz.com',
                          hintStyle: TextStyle(
                            color: Colors.grey
                          ),
                          // ignore: dead_code
                          errorText: emptyEmail ? "Email is required" : null,
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          floatingLabelStyle: TextStyle(
                            // color: emptyFirstName ? null : Theme.of(context).colorScheme.primary,
                          )
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Container(
                        height: 55,
                        child: TextField(
                          obscureText: obscurePassword,
                          controller: passwordController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide(
                                color: Theme.of(context).colorScheme.primary,
                              )
                            ),
                              focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide(
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                            labelText: 'Password',
                            hintText: '',
                            hintStyle: TextStyle(
                              color: Colors.grey
                            ),
                            suffix: IconButton(
                              onPressed: () {
                                setState(() {
                                  obscurePassword = !obscurePassword;
                                });
                              }, 
                              icon: Icon(
                                obscurePassword ? Icons.visibility_off : Icons.visibility,
                                size: 20,
                              )
                            ),
                            // ignore: dead_code
                            // errorText: emptyPassword ? "Enter password" : null,
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            floatingLabelStyle: TextStyle(
                              // color: emptyFirstName ? null : Theme.of(context).colorScheme.primary,
                            )
                          ),
                        ),
                      )
                    ],
                  ),
                  // child: IntlPhoneField(
                  //   initialCountryCode: 'IN',
                  //   languageCode: 'en',
                  //   keyboardType: TextInputType.number,
                  //   controller: phoneNoController,
                  //   onChanged: (value) {
                  //     phoneNumber = value.completeNumber;
                  //     emptyPhoneNo = phoneNoController.text.isEmpty;
                  //     setState(() {
                  //       valid = _loginKey.currentState!.validate();
                  //     });
                  //   },
                  //   decoration: InputDecoration(
                  //     border: OutlineInputBorder(
                  //       borderRadius: BorderRadius.circular(15),
                  //       borderSide: BorderSide(
                  //         color: Theme.of(context).colorScheme.primary,
                  //       )
                  //     ),
                  //     focusedBorder: OutlineInputBorder(
                  //       borderRadius: BorderRadius.circular(15),
                  //       borderSide: BorderSide(
                  //         color: Theme.of(context).colorScheme.primary,
                  //       ),
                  //     ),
                  //     labelText: 'Phone Number',
                  //     errorText: emptyPhoneNo ? "Please enter a Phone Number" : null,
                      
                  //     floatingLabelBehavior: FloatingLabelBehavior.always,
                  //     floatingLabelStyle: TextStyle(
                  //       color: emptyPhoneNo || !valid ? null : Theme.of(context).colorScheme.primary,
                  //     ),
                  //   ),
                  // ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: MediaQuery.sizeOf(context).width - 60,
                  child: TextButton(
                    // onPressed: () {
                      
                    // },
                    onPressed: () async{
                      valid = _loginKey.currentState!.validate();
                      emptyEmail = emailController.text.isEmpty;
                      emptyPassword = passwordController.text.isEmpty;
                      setState(() {});
                      if(valid && !emptyEmail && !emptyPassword) {
                        // print(phoneNumber);
                        // await FirebaseAuth.instance.verifyPhoneNumber(
                        //   verificationCompleted: (PhoneAuthCredential credential) {},
                        //   verificationFailed: (Exception ex) {print(ex);}, 
                        //   codeSent: (String verificationId, int? resendToken) {
                        //     Navigator.push(
                        //       context, 
                        //       PageTransition(
                        //         child: VerificationScreen(camera: widget.camera, verificationId: verificationId,), 
                        //         type: PageTransitionType.rightToLeftJoined, 
                        //         childCurrent: widget,
                        //         curve: Curves.easeInOut,
                        //         duration: const Duration(milliseconds: 300),
                        //         reverseDuration: const Duration(milliseconds: 300)
                        //       )
                        //     );
                        //   }, 
                        //   codeAutoRetrievalTimeout: (String verificationId) {}, 
                        //   phoneNumber: phoneNumber
                        // );
                        userLogin();
                      }
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: const Color.fromARGB(255, 255, 255, 255),
                    ),
                    child: buttonChild,
                  ),
                ),
                const SizedBox(height: 20,),
                const Text(
                  "Don't have an account?",
                  style: TextStyle(
                    fontSize: 14
                  ),
                ),
                // const SizedBox(height: 10),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context, 
                      PageTransition(
                        child: RegisterScreen(camera: widget.camera,), 
                        type: PageTransitionType.rightToLeftJoined, 
                        childCurrent: widget,
                        curve: Curves.easeInOut,
                        duration: const Duration(milliseconds: 300),
                        reverseDuration: const Duration(milliseconds: 300)
                      )
                    );
                  },
                  child: Text(
                    "Register",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: 15
                    ),
                  ),
                )
              ],
            ),
          )
        ),
      ),
    );
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    // phoneNoController.dispose();
    super.dispose();
  }
}