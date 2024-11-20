import 'package:camera/camera.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:green_aid/components/navigation.dart';
import 'package:green_aid/models/user.dart';
import 'package:green_aid/screens/verification_screen.dart';
import 'package:green_aid/services/database.dart';
// import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:page_transition/page_transition.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key, required this.camera});
  final CameraDescription camera;

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final GlobalKey<FormState> _registerKey = GlobalKey();
  
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  dynamic buttonChild = const Text("Continue");

  bool emptyFirstName = false;
  bool emptyLastName = false;
  bool emptyEmail = false;
  bool emptyPassword = false;
  bool emptyConfirmPassword = false;
  bool valid = false;
  bool obscurePassword = true;
  bool obscureConfirmPassword = true;
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
            child: Form(
              key: _registerKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 10),
                  Image(
                    image: const AssetImage("assets/images/create_account.png"),
                    width: screenWidth / 2.5,
                  ),
                  const SizedBox(height: 30),
                  const Text(
                    "Sign Up",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      // color: Color.fromRGBO(33, 33, 33, 1)
                    )
                  ),
                  const Text(
                    "Create an account now!",
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 13,
                      color: Color.fromRGBO(83, 83, 83, 1)
                    )
                  ),
                  const SizedBox(height: 50),
                  SizedBox(
                    width: screenWidth - 70,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: (screenWidth / 2) - 45,
                          // height: 50,
                          child: TextField(
                            controller: firstNameController,
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
                              labelText: 'First Name',
                              hintText: 'John',
                              hintStyle: TextStyle(
                                color: Colors.grey
                              ),
                              // ignore: dead_code
                              errorText: emptyFirstName ? "" : null,
                              floatingLabelBehavior: FloatingLabelBehavior.always,
                              floatingLabelStyle: TextStyle(
                                // color: emptyFirstName ? null : Theme.of(context).colorScheme.primary,
                              )
                            ),
                            onChanged: (value) {
                              emptyFirstName = firstNameController.text.isEmpty;
                              setState(() {
                              });
                            },
                          ),
                        ),
                        const SizedBox(width: 20),
                        SizedBox(
                          width: (screenWidth / 2) - 45,
                          // height: 50,
                          child: TextField(
                            controller: lastNameController,
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
                              labelText: 'Last Name',
                              hintText: 'Doe',
                              hintStyle: TextStyle(
                                color: Colors.grey
                              ),
                              // ignore: dead_code
                              errorText: emptyLastName ? "" : null,
                              floatingLabelBehavior: FloatingLabelBehavior.always,
                              floatingLabelStyle: TextStyle(
                                // color: emptyLastName ? null : Theme.of(context).colorScheme.primary,
                              )
                            ),
                            onChanged: (value) {
                              emptyLastName = lastNameController.text.isEmpty;
                              setState(() {
                              });
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                  SizedBox(
                    width: screenWidth - 70,
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
                            errorText: emptyEmail ? "" : null,
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
                            controller: passwordController,
                            obscureText: obscurePassword,
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
                              errorText: emptyPassword ? "" : null,
                              floatingLabelBehavior: FloatingLabelBehavior.always,
                              floatingLabelStyle: TextStyle(
                                // color: emptyFirstName ? null : Theme.of(context).colorScheme.primary,
                              )
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Container(
                          height: 55,
                          child: TextField(
                            controller: confirmPasswordController,
                            obscureText: obscureConfirmPassword,
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
                              labelText: 'Confirm Password',
                              suffix: IconButton(
                                onPressed: () {
                                  setState(() {
                                    obscureConfirmPassword = !obscureConfirmPassword;
                                  });
                                }, 
                                icon: Icon(
                                  obscureConfirmPassword ? Icons.visibility_off : Icons.visibility,
                                  size: 20,
                                )
                              ),
                              // ignore: dead_code
                              errorText: emptyConfirmPassword ? "" : null,
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
                    //   controller: phoneNoController,
                    //   initialCountryCode: 'IN',
                    //   decoration: InputDecoration(
                    //     border: OutlineInputBorder(
                    //       borderRadius: BorderRadius.circular(15),
                    //       borderSide: BorderSide(
                    //         color: Theme.of(context).colorScheme.primary,
                    //       )
                    //     ),
                    //       focusedBorder: OutlineInputBorder(
                    //       borderRadius: BorderRadius.circular(15),
                    //       borderSide: BorderSide(
                    //         color: Theme.of(context).colorScheme.primary,
                    //       ),
                    //     ),
                    //     labelText: 'Phone Number',
                    //     // ignore: dead_code
                    //     errorText: emptyPhoneNo ? "Please enter a Phone number" : null,
                    //     floatingLabelBehavior: FloatingLabelBehavior.always,
                    //     floatingLabelStyle: TextStyle(
                    //       color: emptyPhoneNo || !valid ? null : Theme.of(context).colorScheme.primary,
                    //     ),
                    //   ),
                    //   onChanged: (value) {
                    //     emptyPhoneNo = phoneNoController.text.isEmpty;
                    //     valid = _registerKey.currentState!.validate();
                    //     setState(() {
                    //     });
                    //   },
                    // ),
                  ),
                  
                  const SizedBox(height: 50),
                  SizedBox(
                    width: screenWidth - 60,
                    child: TextButton(
                      onPressed: () async {
                        valid = _registerKey.currentState!.validate();
                        emptyPassword = passwordController.text.isEmpty;
                        emptyConfirmPassword = confirmPasswordController.text.isEmpty;
                        emptyFirstName = firstNameController.text.isEmpty;
                        emptyLastName = lastNameController.text.isEmpty;
                        emptyEmail = emailController.text.isEmpty;
                        setState(() {});
                        if (valid && !emptyPassword && !emptyConfirmPassword && !emptyFirstName && !emptyLastName && !emptyEmail) {
                          
                          try {
                            buttonChild = const SizedBox(height: 15, width: 15, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2,));
                            setState(() {
                            });
                            final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
                              email: emailController.text,
                              password: passwordController.text,
                            );
                            final AppUser user = AppUser(
                              uid: credential.user?.uid ?? '', 
                              firstName: firstNameController.text, 
                              lastName: lastNameController.text, 
                              email: credential.user?.email ?? ''
                            );
                            await DatabaseService(uid: user.uid).registerUserData(user.firstName, user.lastName, user.email);
                            // print(user.uid);
                            Navigator.pushAndRemoveUntil(
                              context,
                              PageTransition(
                                child: Navigation(camera: widget.camera, uid: user.uid), 
                                type: PageTransitionType.fade, 
                                curve: Curves.easeInOut,
                                duration: const Duration(milliseconds: 100),
                              ), (Route route) => false
                            );
                          } on FirebaseAuthException catch (e) {
                            buttonChild = const Text("Continue");
                            setState(() {
                              
                            });
                            if (e.code == 'weak-password') {
                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('The password provided is too weak.')));
                              // print('The password provided is too weak.');
                            } else if (e.code == 'email-already-in-use') {
                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('The account already exists for that email.')));
                              // print('The account already exists for that email.');
                            }
                            else {
                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Something went wrong. Please try again!')));        
                            }
                          } catch (e) {
                            print(e);
                          }
                        }
                      },
                      style: TextButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        foregroundColor: const Color.fromARGB(255, 255, 255, 255),
                      ),
                      child: buttonChild,
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      );
  }
  @override
  void dispose() {
    passwordController.dispose();
    confirmPasswordController.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
    super.dispose();
  }
}