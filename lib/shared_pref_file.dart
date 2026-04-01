import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todoapp/models/category_model.dart';
import 'package:todoapp/models/todo_model.dart';
import 'package:todoapp/models/user_model.dart';

// class SharedPrefFile {
//   static late SharedPreferences pref;
//   static Future<void> initpref() async {
//     pref = await SharedPreferences.getInstance();
//   }

//   static Future<void> saveTodos(String gmail, List<TodoModel> todos) async {
//     List<String> data = todos.map((e) => jsonEncode(e.toMap())).toList();
//     await pref.setStringList('todos_$gmail', data);
//   }

//   static Future<List<TodoModel>> loadTodos(String gmail) async {
//     await initpref();

//     List<String>? data = pref.getStringList('todos_$gmail');
//     if (data == null) {
//       return [];
//     }
//     return data.map((e) => TodoModel.formjson(jsonDecode(e))).toList();
//   }

//   static Future<void> setData(
//     String namevalue,
//     String gmailvalue,
//     String passvalue,
//     String phonevalue,
//     String birthdatevalue,
//     String gendervalue,
//   ) async {
//     List<String> users = pref.getStringList('users') ?? [];

//     Map<String, dynamic> usermap = {
//       "name": namevalue,
//       "gmail": gmailvalue,
//       "password": passvalue,
//       "phoneno": phonevalue,
//       "birthdate": birthdatevalue,
//       "gender": gendervalue,
//     };

//     users.add(jsonEncode(usermap));
//     await pref.setStringList("users", users);
//   }

  // static UserModel getUserData(String mail) {
  //   List<String> usersList = pref.getStringList('users') ?? [];
  //   List users = usersList.map((e) => jsonDecode(e)).toList();
  //   Map<String, dynamic> user = users.firstWhere(
  //     (element) => element["gmail"] == mail,
  //   );
  //   print(user);
  //   return UserModel.fromJson(user);
  // }

//   static Future<void> saveCategories(
//     String gmail,
//     List<CategoryModel> category,
//   ) async {
//     List<String> data = category
//         .map((e) => jsonEncode(e.modeltomap()))
//         .toList();
//     await pref.setStringList('category_$gmail', data);
//   }

//   static Future<List<CategoryModel>> loadCategories(String gmail) async {
//     await initpref();

//     List<String>? data = pref.getStringList('category_$gmail');
//     if (data == null) {
//       return [];
//     }
//     return data.map((e) => CategoryModel.fromMap(jsonDecode(e))).toList();
//   }

//   static Future<void> updateUserProfile(UserModel updatedUser) async {
//     List usersList = pref.getStringList('users') ?? [];
//     List users = usersList.map((e) => jsonDecode(e)).toList();
//     Map<String, dynamic> olduser = users.firstWhere(
//       (element) => element["gmail"] == updatedUser.gmail,
//     );

//     int userindex = users.indexOf(olduser);
//     users[userindex] = updatedUser.tomap();
//     List<String> updatedlist = users.map((e) => jsonEncode(e)).toList();
//     pref.setStringList("users", updatedlist);
//   }
// }

// class SecuredStorage {
//   static final FlutterSecureStorage _storage = FlutterSecureStorage();

//   static Future<void> setLoginData(String email) async {
//     await _storage.write(key: "userEmail", value: email);
//     await _storage.write(key: "isLoggedIn", value: "true");
//     await _storage.write(key: "dontaskwhiledelete", value: 'false');
//   }

//   static Future<void> logout() async {
//     await _storage.write(key: "isLoggedIn", value: "false");
//   }

//   static Future<String?> getEmail() async {
//     String? mail = await _storage.read(key: "userEmail");
//     return mail;
//   }

//   static Future<bool> isLoggedIn() async {
//     String? value = await _storage.read(key: "isLoggedIn");
//     return value == "true";
//   }

//   static Future dontaskmedelete() async {
//     String? value = await _storage.read(key: "dontaskwhiledelete");
//     return value == "true";
//   }

//   static Future<void> deleteyes() async {
//     await _storage.write(key: "dontaskwhiledelete", value: "true");
//   }
// }
