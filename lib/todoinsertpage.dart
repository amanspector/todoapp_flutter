import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:todoapp/color_for_the_app.dart';
import 'package:todoapp/models/authwrapper.dart';
import 'package:todoapp/models/category_model.dart';
import 'package:todoapp/models/todo_model.dart';
import 'package:todoapp/serviceFile.dart';
import 'package:todoapp/shared_pref_file.dart';
import 'package:todoapp/text_for_the_app.dart';

class Todoinsertpage extends StatefulWidget {
  List<TodoModel> todoList;
  String uid;
  Todoinsertpage({super.key, required this.todoList, required this.uid});

  @override
  State<StatefulWidget> createState() => _TodoinsertpageState();
}

class _TodoinsertpageState extends State<Todoinsertpage> {
  final _formkey = GlobalKey<FormState>();
  String gmail = "";
  List<CategoryModel> categories = [];
  String? iconString;
  IconData? selectedIcon;

  String selectedCategory = "";
  TextEditingController titleController = TextEditingController();
  TextEditingController subtitleController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadCategories();
  }

  void loadCategories() async {
    List<CategoryModel> cat = await Servicefile.getCategories(widget.uid);
    setState(() {
      categories = cat;
    });
  }

  void _addtodo() {
    FocusScope.of(context).unfocus();
    DateTime createdAt = DateTime.now();
    if (_formkey.currentState!.validate()) {
      if (selectedCategory.isEmpty) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(TextForTheApp.selectcategory)));
        return;
      }

      Servicefile.setTodo(
        widget.uid,
        TodoModel(
          title: titleController.text.trim(),
          task: subtitleController.text.trim(),
          createdAt: createdAt,
          scheduleForDate: null,
          scheduleForTime: null,
          categoryName: selectedCategory,
          categoryIcon: iconString,
        ),
      );

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(TextForTheApp.dataInserted)));

      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(TextForTheApp.dataInsertionFailed)),
      );
    }
  }

  @override
  void dispose() {
    super.dispose();
    titleController.dispose();
    subtitleController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(TextForTheApp.addTodoTitle)),
      body: SafeArea(
        child: Form(
          key: _formkey,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(TextForTheApp.title),
                TextFormField(
                  controller: titleController,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    hintText: TextForTheApp.labelTitle,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return TextForTheApp.errormsgforTitle;
                    } else {
                      return null;
                    }
                  },
                ),
                SizedBox(height: 10),
                Text(TextForTheApp.description),

                TextFormField(
                  controller: subtitleController,
                  maxLines: 6,
                  textInputAction: TextInputAction.done,

                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    hintText: TextForTheApp.labelSubtitle,
                  ),

                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return TextForTheApp.errormsgforDescription;
                    } else {
                      return null;
                    }
                  },
                ),
                SizedBox(height: 10),
                Text(TextForTheApp.category),

                Flexible(
                  flex: 2,
                  child: Container(
                    // height: 800,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        width: 1,

                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: categories.isEmpty
                          ? emptyStateScreen()
                          : GridView.builder(
                              gridDelegate:
                                  SliverGridDelegateWithMaxCrossAxisExtent(
                                    maxCrossAxisExtent: 100,
                                    mainAxisSpacing: 5,
                                  ),
                              itemCount: categories.length,
                              itemBuilder: (context, index) {
                                return Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        color:
                                            selectedCategory ==
                                                categories[index].categoryName
                                            ? Theme.of(
                                                context,
                                              ).colorScheme.onSecondary
                                            : ColorForTheApp.transperent,
                                      ),
                                      child: IconButton(
                                        iconSize: 40,
                                        onPressed: () {
                                          setState(() {
                                            selectedCategory =
                                                categories[index].categoryName!;
                                            selectedIcon =
                                                CategoryModel
                                                    .StringiconMap[categories[index]
                                                    .iconString];
                                            iconString =
                                                categories[index].iconString;
                                          });
                                        },
                                        icon: Icon(
                                          CategoryModel.stringtoIcon(
                                            categories[index].iconString,
                                          ),
                                        ),
                                      ),
                                    ),

                                    Text(categories[index].categoryName!),
                                  ],
                                );
                              },
                            ),
                    ),
                  ),
                ),
                Spacer(),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      width: 2,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: MaterialButton(
                    onPressed: _addtodo,
                    child: Text(
                      TextForTheApp.add,
                      style: TextStyle(fontSize: 16),
                    ),
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
