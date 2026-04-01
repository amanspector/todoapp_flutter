import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:todoapp/color_for_the_app.dart';
import 'package:todoapp/homepage.dart';
import 'package:todoapp/models/user_model.dart';
import 'package:todoapp/shared_pref_file.dart';
import 'package:todoapp/signupScreen.dart';
import 'package:todoapp/text_for_the_app.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Loginscreen extends StatefulWidget {
  const Loginscreen({super.key});

  @override
  State<StatefulWidget> createState() => _LoginscreenState();
}

class _LoginscreenState extends State<Loginscreen> {
  String errormsg = "";
  // final FlutterSecureStorage _storage = FlutterSecureStorage();
  TextEditingController gmailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isValidUser = false;
  bool isObsure = true;
  final _formkey = GlobalKey<FormState>();

  void visibleLogo() {
    setState(() {
      isObsure = !isObsure;
    });
  }

  void _validUser() async {
    if (_formkey.currentState!.validate()) {
      setState(() {
        isValidUser = true;
      });

      // for (var u in users) {
      //   Map<String, dynamic> user = jsonDecode(u);
      //   if (user['gmail'] == gmailController.text.trim() &&
      //       user['password'] == passwordController.text.trim()) {
      //     isValidUser = true;
      //     await SecuredStorage.setLoginData(user['gmail']);
      //     // await _storage.write(key: "userEmail", value: user['gmail']);
      //     // await SecuredStorage. _storage.write(key: "isLoggedIn", value: 'true');
      //     Navigator.pushReplacement(
      //       context,
      //       MaterialPageRoute(builder: (context) => Homepage()),
      //     );
      //     break;
      //   }
      // }

      try {
        final userloggedin = await FirebaseAuth.instance
            .signInWithEmailAndPassword(
              email: gmailController.text.trim(),
              password: passwordController.text.trim(),
            );

        print(userloggedin);

        // Navigator.pushReplacement(
        //   context,
        //   MaterialPageRoute(builder: (context) => Homepage()),
        // );
      } on FirebaseAuthException catch (e) {
        // setState(() {
        //   errormsg = e.code.toString();
        // });

        if (e.code == 'invalid-credential') {
          setState(() {
            errormsg = 'Invalid credential';
          });
        }

        if (e.code == 'too-many-requests') {
          setState(() {
            errormsg = "too many attempts , try again later";
          });
        }
        print(e);
      } finally {
        if (!mounted) {
          return;
        }
        if (isValidUser != null) {
          setState(() {
            isValidUser = false;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Form(
          key: _formkey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 20,
                ),
                child: Text(
                  TextForTheApp.welcomeBack,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: TextFormField(
                  controller: gmailController,
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    prefixIcon: Icon(Icons.email_outlined),
                    labelText: TextForTheApp.gmailLabel,
                    labelStyle: TextStyle(
                      fontSize: 17,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),

                    hintText: TextForTheApp.hintTextgmail,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    errorStyle: TextStyle(color: ColorForTheApp.redColor),
                    hintStyle: TextStyle(
                      fontSize: 17,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  validator: UserModel.validateEmail,
                ),
              ),
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: TextFormField(
                  controller: passwordController,
                  obscureText: isObsure,
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    prefixIcon: Icon(Icons.password),
                    suffixIcon: IconButton(
                      onPressed: visibleLogo,
                      icon: isObsure
                          ? Icon(Icons.visibility)
                          : Icon(Icons.visibility_off_rounded),
                    ),
                    labelText: TextForTheApp.passwordLabel,
                    labelStyle: TextStyle(
                      fontSize: 17,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                    hintText: TextForTheApp.hintTextpassword,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    errorStyle: TextStyle(color: ColorForTheApp.redColor),

                    hintStyle: TextStyle(
                      fontSize: 17,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),

                  validator: UserModel.validatePassword,
                ),
              ),

              SizedBox(height: 20),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Container(
                      child: isValidUser == false
                          ? OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                minimumSize: Size(double.infinity, 50),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              onPressed: _validUser,
                              child: Text(
                                TextForTheApp.loginButton,
                                style: TextStyle(
                                  fontSize: 16,

                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurface,
                                ),
                              ),
                            )
                          : Container(
                              height: 50,
                              decoration: BoxDecoration(
                                border: Border.all(width: 1),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Center(
                                child: SizedBox(
                                  height: 40,
                                  width: 40,
                                  child: CircularProgressIndicator(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.onSurface,
                                  ),
                                ),
                              ),
                            ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 5),

              if (errormsg.isNotEmpty)
                Text(
                  errormsg,
                  style: TextStyle(
                    color: ColorForTheApp.redColor,
                    fontSize: 14,
                  ),
                ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(TextForTheApp.donthaveaccount),
                  SizedBox(width: 10),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Signupscreen()),
                      );
                    },
                    child: Text(
                      style: TextStyle(fontWeight: FontWeight.bold),
                      TextForTheApp.register,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
