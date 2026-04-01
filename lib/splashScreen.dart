import 'package:flutter/material.dart';
import 'package:todoapp/homepage.dart';
import 'package:todoapp/loginScreen.dart';
import 'package:todoapp/models/authwrapper.dart';
import 'package:todoapp/shared_pref_file.dart';
import 'package:todoapp/text_for_the_app.dart';

class Splashscreen extends StatefulWidget {
  const Splashscreen({super.key});

  @override
  State<StatefulWidget> createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> {
  @override
  void initState() {
    super.initState();
    loginCheck();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Image.asset(
              'assets/images/tasklist.png',
              height: 100,
              width: 100,
            ),
          ),

          SizedBox(height: 10),

          Center(
            child: Text(
              TextForTheApp.todoapptitle,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  void loginCheck() async {
    // bool isloggin = await SecuredStorage.isLoggedIn();
    await Future.delayed(Duration(seconds: 3), () {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => Authwrapper()),
        (route) => false,
      );
    });

    // String? isloggin = SharedPrefFile.pref.getString('isLoggedin');

    // if (isloggin) {
    //   Navigator.pushAndRemoveUntil(
    //     context,
    //     MaterialPageRoute(builder: (context) => Homepage()),
    //     (route) => false,
    //   );
    // } else {
    //   Navigator.pushAndRemoveUntil(
    //     context,
    //     MaterialPageRoute(builder: (context) => Loginscreen()),
    //     (route) => false,
    //   );
    // }
  }
}
