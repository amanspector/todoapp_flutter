import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:todoapp/text_for_the_app.dart';

class UserModel {
  UserModel({
    required this.name,
    required this.gmail,
    required this.phoneno,
    required this.dateofbirth,
    required this.gender,
    required this.dialogBoxDelete,
  });
  String name;
  String gmail;
  String phoneno;
  // DateTime datepicked;
  String dateofbirth;
  String gender;
  bool dialogBoxDelete;

  UserModel? copyWith({
    String? name,
    String? gmail,
    String? phoneno,
    // DateTime datepicked;
    String? dateofbirth,
    String? gender,
    bool? dialogBoxDelete,
  }) {
    return UserModel(
      name: this.name,
      gmail: this.gmail,
      phoneno: this.phoneno,
      dateofbirth: this.dateofbirth,
      gender: this.gender,
      dialogBoxDelete: this.dialogBoxDelete,
    );
  }

  Map<String, dynamic> tomap() {
    return {
      "name": name,
      "gmail": gmail,
      "phoneno": phoneno,
      "dateofbirth": dateofbirth,
      "gender": gender,
      "dialogBoxDelete": dialogBoxDelete,
    };
  }

  factory UserModel.fromJson(DocumentSnapshot<Map<String, dynamic>> json) {
    return UserModel(
      name: json['name'] ?? "",
      gmail: json['gmail'] ?? "",
      phoneno: json['phoneno'] ?? "",
      dateofbirth: json['dateofbirth'] ?? "",
      gender: json['gender'] ?? "",
      dialogBoxDelete: json['dialogBoxDelete'] ?? "",
    );
  }

  static String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return TextForTheApp.namevalidation;
    }
    if (value.startsWith(RegExp(r"^[A-Z][a-z]+$")) ||
        value.startsWith(RegExp(r"^[A-Z][a-z]+(?: [a-z]+)+$"))) {
      return TextForTheApp.enterappropriatename;
    }
    if (!value.startsWith(RegExp(r"^[A-Z][a-z]+(?: [A-Z][a-z]+)+$"))) {
      return TextForTheApp.namecorrectvalidation;
    }

    return null;
  }

  static String? validatePhoneno(String? value) {
    if (value == null || value.isEmpty) {
      return TextForTheApp.phonevalidation;
    }
    if (value.length != 10) {
      return TextForTheApp.phonelenthvalidation;
    }
    return null;
  }

  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return TextForTheApp.emailvalidation;
    }
    if (!value.startsWith(RegExp(r'^[a-zA-Z0-9.-]+@[a-zA-Z.-]+\.[a-zA-Z]+$'))) {
      return TextForTheApp.emailcorrectvalidation;
    }
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return TextForTheApp.passwordvalidation;
    }
    if (!value.startsWith(RegExp(r'^[a-zA-Z\d@!#$%^&*\.]{8,16}$'))) {
      return TextForTheApp.passwordcorrectvalidation;
    }
    return null;
  }

  static DateTime StringtoDate(String getDateString) {
    final DateFormat datef = DateFormat('dd/MM/yyyy');
    final DateTime dateConversion = datef.parse(getDateString);
    return dateConversion;
  }

  static String DateToString(DateTime getDateTime) {
    final DateFormat datef = DateFormat('dd/MM/yyyy');
    final String dateString1 = datef.format(getDateTime);
    return dateString1;
  }
}
