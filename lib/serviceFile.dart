import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:todoapp/models/category_model.dart';
import 'package:todoapp/models/todo_model.dart';
import 'package:todoapp/models/user_model.dart';

class Servicefile {
  static Future<UserModel?> getUser(String uid) async {
    DocumentSnapshot<Map<String, dynamic>> user = await FirebaseFirestore
        .instance
        .collection('users')
        .doc(uid)
        .get();

    if (!user.exists || user.data() == null) {
      return null;
    }
    UserModel newuser = UserModel.fromJson(user);
    return newuser;
  }

  static Future<List<TodoModel>> getTodos(String uid) async {
    QuerySnapshot<Map<String, dynamic>> todo = await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('todos')
        .get();

    List<TodoModel> todos = todo.docs
        .map((doc) => TodoModel.formjson(doc.data(), doc.id))
        .toList();

    return todos;
  }

  static Future<void> setTodo(String uid, TodoModel whichtodo) async {
    Map<String, dynamic> todomap = whichtodo.toMap();
    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('todos')
        .add(todomap);
  }

  static Future<List<CategoryModel>> getCategories(String uid) async {
    QuerySnapshot<Map<String, dynamic>> category = await FirebaseFirestore
        .instance
        .collection('users')
        .doc(uid)
        .collection('category')
        .get();

    List<CategoryModel> categories = category.docs
        .map(
          (doc) =>
              CategoryModel.fromMap(doc.data() as Map<String, dynamic>, doc.id),
        )
        .toList();

    return categories;
  }

  static Future<void> setCategogries(String uid, CategoryModel whichcat) async {
    Map<String, dynamic> catmap = whichcat.modeltomap();
    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('category')
        .add(catmap);
  }

  static Future<void> removeCategogries(String uid, String catid) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('category')
        .doc(catid)
        .delete();
  }

  static Future<void> removeTodos(String uid, String todosid) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('todos')
        .doc(todosid)
        .delete();
  }

  static Future<void> updateCategories(
    String uid,
    CategoryModel catmodel,
    String catid,
  ) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('category')
        .doc(catid)
        .update(catmodel.modeltomap());
  }

  static Future<void> updatetodos(
    String uid,
    String todoid,
    TodoModel todomodel,
  ) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('todos')
        .doc(todoid)
        .update(todomodel.toMap());
  }

  // static Future<void> updateprofile(String uid, UserModel usermodel) async {
  //   await FirebaseFirestore.instance
  //       .collection('users')
  //       .doc(uid)
  //       .update(usermodel.tomap());
  // }

  static Future<void> updateField(
    String key1,
    String value1,
    String uid,
  ) async {
    await FirebaseFirestore.instance.collection('users').doc(uid).update({
      key1: value1,
    });
  }
}
