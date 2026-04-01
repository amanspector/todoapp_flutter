import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:todoapp/color_for_the_app.dart';
import 'package:todoapp/insertCategory.dart';
import 'package:todoapp/models/category_model.dart';
import 'package:todoapp/models/todo_model.dart';
import 'package:todoapp/models/user_model.dart';
import 'package:todoapp/serviceFile.dart';
import 'package:todoapp/shared_pref_file.dart';
import 'package:todoapp/text_for_the_app.dart';

class Categorypage extends StatefulWidget {
  String uid;
  Categorypage({super.key, required this.uid});

  @override
  State<StatefulWidget> createState() => _CategorypageState();
}

class _CategorypageState extends State<Categorypage> {
  List<CategoryModel> categoryList = [];
  List<CategoryModel> foundfromcategory = [];
  final TextEditingController _searchCategoryController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    loadCategory1();
  }

  Future<void> loadCategory1() async {
    // UserModel user = await Servicefile.getUser(widget.uid);
    final data1 = await Servicefile.getCategories(widget.uid);

    if (!mounted) {
      return;
    }

    setState(() {
      categoryList = data1;
      foundfromcategory = data1;
    });
  }

  Future<void> gotoCategoryinsertPage() async {
    FocusManager.instance.primaryFocus?.unfocus();
    try {
      final result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Insertcategory(uid: widget.uid),
        ),
      );

      if (result == true) {
        await loadCategory1();
      }
      // await SharedPrefFile.saveTodos(gmail, todoList);
    } catch (e) {
      print(e);
    }
  }

  Future<bool?> _confirmDelete(CategoryModel category) async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(TextForTheApp.delete),
          content: Text(TextForTheApp.deleteCategory),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: Text(
                TextForTheApp.delete,
                style: TextStyle(color: ColorForTheApp.redColor),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: Text(TextForTheApp.cancel),
            ),
          ],
        );
      },
    );
  }

  Future<bool?> _editCategory(CategoryModel category) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            Insertcategory(category: category, uid: widget.uid),
      ),
    );

    if (result == true) {
      await loadCategory1();
    }

    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
            child: foundfromcategory.isEmpty
                ? null
                : TextField(
                    controller: _searchCategoryController,
                    onChanged: (value) {
                      setState(() {
                        foundfromcategory = categoryList
                            .where(
                              (item) => item.categoryName!
                                  .toLowerCase()
                                  .contains(value.toLowerCase()),
                            )
                            .toList();
                      });
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.search),
                      labelText: TextForTheApp.searchLabel,
                      suffixIcon: _searchCategoryController.text.isNotEmpty
                          ? IconButton(
                              onPressed: () {
                                setState(() {
                                  _searchCategoryController.clear();
                                  foundfromcategory = categoryList;
                                });
                              },
                              icon: Icon(Icons.cancel),
                            )
                          : null,
                    ),
                  ),
          ),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: foundfromcategory.isEmpty
                  ? emptyStateScreen()
                  : ListView.builder(
                      itemCount: foundfromcategory.length,
                      itemBuilder: (context, index) {
                        final category = foundfromcategory[index];
                        return _customCard2(category);
                      },
                    ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: "catFAB",
        onPressed: () {
          gotoCategoryinsertPage();
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _customCard2(CategoryModel category) {
    IconData icondata = CategoryModel.stringtoIcon(category.iconString);
    return Dismissible(
      key: UniqueKey(),
      // key: Key(category.categoryName!),
      direction: DismissDirection.horizontal,
      background: Container(
        color: ColorForTheApp.greenColor,
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Icon(Icons.edit, color: ColorForTheApp.whiteColor),
      ),

      secondaryBackground: Container(
        color: ColorForTheApp.redColor,
        alignment: Alignment.centerRight,

        padding: EdgeInsets.symmetric(horizontal: 20),

        child: Icon(Icons.delete, color: ColorForTheApp.whiteColor),
      ),

      confirmDismiss: (direction) async {
        if (direction == DismissDirection.endToStart) {
          return await _confirmDelete(category);
        } else {
          await _editCategory(category);
          return false;
        }
      },
      onDismissed: (direction) async {
        await Servicefile.removeCategogries(widget.uid, category.catid!);
        setState(() {
          categoryList.remove(category);
          foundfromcategory.remove(category);
        });

        // await SharedPrefFile.saveCategories(mail, categoryList);
        // await Servicefile.setCategogries(widget.uid, category);

        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(TextForTheApp.categoryDelete)));
      },
      child: Card(
        color: Theme.of(context).colorScheme.onSecondary,
        elevation: 6,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: SizedBox(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 16,
                  ),
                  child: Icon(icondata, size: 30),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 16,
                  ),
                  child: Text(
                    maxLines: 1,
                    category.categoryName ?? "",
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget emptyStateScreen() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Stack(
            children: [
              Icon(size: 60, Icons.list),
              Positioned(
                bottom: 6,
                left: 37,
                child: Container(
                  color: Theme.of(context).brightness == ThemeData.dark()
                      ? ColorForTheApp.blackColor
                      : ColorForTheApp.whiteColor,
                  child: Icon(
                    size: 20,
                    color: ColorForTheApp.redColor,
                    Icons.close,
                  ),
                ),
              ),
            ],
          ),
          Text(
            TextForTheApp.emptycategoryPageText,
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
