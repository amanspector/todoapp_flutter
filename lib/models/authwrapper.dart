import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todoapp/color_for_the_app.dart';
import 'package:todoapp/loginScreen.dart';
import 'package:todoapp/models/user_model.dart';
import 'package:todoapp/serviceFile.dart';

import '../homepage.dart';

class Authwrapper extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _AuthwrapperState();
}

class _AuthwrapperState extends State<Authwrapper> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.surface,
      child: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot1) {
          if (snapshot1.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                color: Theme.of(context).colorScheme.onSurface,
              ),
            );
          }
          final snap1 = snapshot1.data;
          if (snap1 == null) {
            print("data not found");
            return Loginscreen();
          }
          return FutureBuilder(
            future: Servicefile.getUser(snap1.uid),
            builder: (context, snapshot2) {
              if (snapshot2.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                );
                // return CircularProgressIndicator();
              }
              if (snapshot2.hasError) {
                print(
                  "--------------------------------------------------------" +
                      snapshot2.error.toString(),
                );
              }

              if (snapshot2.hasData) {
                return Homepage(uid: snap1.uid);
              } else {
                print("data not found in snapshot2");
                return Loginscreen();
              }
            },
          );
        },
      ),
    );
  }
}
