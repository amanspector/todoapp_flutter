import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CategoryModel {
  static late SharedPreferences pref;
  String? catid;
  String? categoryName;
  String? iconString;

  CategoryModel({
    required this.categoryName,
    required this.iconString,
    this.catid,
  });

  static Map<IconData, String> iconStringMap = {
    Icons.work: "work",
    Icons.menu_book_sharp: "study",
    Icons.airplanemode_active: "travel",
    Icons.health_and_safety_sharp: "health",
    Icons.family_restroom: "family",
    Icons.attach_money: "finance",
    Icons.shopping_cart: "shopping",
    Icons.person: "personal",
  };

  static Map<String, IconData> StringiconMap = {
    "work": Icons.work,
    "study": Icons.menu_book_sharp,
    "travel": Icons.airplanemode_active,
    "health": Icons.health_and_safety_sharp,
    "family": Icons.family_restroom,
    "finance": Icons.attach_money,
    "shopping": Icons.shopping_cart,
    "personal": Icons.person,
  };

  static Future<void> initpref() async {
    pref = await SharedPreferences.getInstance();
  }

  static IconData stringtoIcon(String? iconst) {
    if (iconst == null) return Icons.category;
    String key = iconst.trim();

    return StringiconMap[key] ?? Icons.category;
  }

  Map<String, dynamic> modeltomap() {
    return {"categoryName": categoryName, "categoryIcon": iconString};
  }

  factory CategoryModel.fromMap(Map<String, dynamic> map, String docid) {
    return CategoryModel(
      catid: docid,
      categoryName: map['categoryName'],
      iconString: map['categoryIcon'],
    );
  }
}
