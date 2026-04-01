import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shimmer/shimmer.dart';
import 'package:todoapp/categoryPage.dart';
import 'package:todoapp/loginScreen.dart';
import 'package:todoapp/models/category_model.dart';
import 'package:todoapp/models/user_model.dart';
import 'package:todoapp/serviceFile.dart';
import 'package:todoapp/shared_pref_file.dart';
import 'package:todoapp/updateList.dart';
import 'package:todoapp/userProfile.dart';
import 'todoinsertpage.dart';
import 'package:todoapp/color_for_the_app.dart';
import 'package:todoapp/models/todo_model.dart';
import 'package:todoapp/text_for_the_app.dart';

class Homepage extends StatefulWidget {
  String uid;

  Homepage({super.key, required this.uid});

  @override
  State<StatefulWidget> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  bool isloading = false;
  bool? dontaskdeletestore;
  String selectedcategory = "All";
  int _currentIndex = 0;

  String? mail;
  bool isSearching = false;
  List<TodoModel> todoList = [];
  List<TodoModel> _foundList = [];
  List<CategoryModel> categorylist = [];
  final TextEditingController _searchController = TextEditingController();

  bool isLight = true;

  Future<void> _exit() async {
    final exitapp = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        content: Text(TextForTheApp.areyousuretoexit),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context, true);
            },
            child: Text(
              TextForTheApp.yes,
              style: TextStyle(color: ColorForTheApp.redColor),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context, false);
            },
            child: Text(TextForTheApp.no),
          ),
        ],
      ),
    );
    if (exitapp == true) {
      SystemNavigator.pop();
    }
  }

  Future<void> _gotoInsertPage(String uid) async {
    FocusManager.instance.primaryFocus?.unfocus();
    try {
      final result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Todoinsertpage(todoList: todoList, uid: uid),
        ),
      );

      if (result == true) {
        await loadData();
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> _gotoUpdatePage(TodoModel todo) async {
    FocusManager.instance.primaryFocus?.unfocus();
    try {
      final result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Updatelist(todo: todo, uid: widget.uid),
        ),
      );

      if (result == true) {
        await loadData();
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> loadData() async {
    setState(() {
      isloading = true;
    });
    UserModel? usersdata = await Servicefile.getUser(widget.uid);
    String? usermail = usersdata!.gmail;
    mail = usermail;

    if (mail == null) {
      setState(() {});
      FirebaseAuth.instance.signOut();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Loginscreen()),
      );
      return;
    }
    List<TodoModel> fetchedData = await Servicefile.getTodos(widget.uid);
    List<CategoryModel> fetchedCatgories = await Servicefile.getCategories(
      widget.uid,
    );
    if (mounted) {
      setState(() {
        mail = usermail;
        todoList = fetchedData;
        _foundList = fetchedData;
        categorylist = fetchedCatgories;
        isloading = false;
        dontaskdeletestore = usersdata.dialogBoxDelete;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    loadData();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    loadData();
  }

  Future<void> performDeleteList(TodoModel todo) async {
    await Servicefile.removeTodos(widget.uid, todo.todoid!);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("${todo.title} : ${TextForTheApp.dataRemoved}")),
    );
    setState(() {
      todoList.removeWhere((element) => element.title == todo.title);
      _foundList.removeWhere((element) => element.title == todo.title);
    });
  }

  Future<void> showdialogDelete(TodoModel todo) async {
    bool tempdelete = false;
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text(TextForTheApp.delete),
          content: SizedBox(
            height: 80,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  TextForTheApp.areyousuretodelete,
                  style: TextStyle(fontSize: 17),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Checkbox(
                      value: tempdelete,
                      onChanged: (value) {
                        setState(() {
                          tempdelete = value!;
                        });
                      },
                    ),
                    Text(TextForTheApp.dontaskmeagain),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                setState(() {
                  dontaskdeletestore = tempdelete;
                });
                await FirebaseFirestore.instance
                    .collection('users')
                    .doc(widget.uid)
                    .update({"dialogBoxDelete": true});
                await performDeleteList(todo);
                Navigator.pop(context);
              },
              child: Text(
                TextForTheApp.yes,
                style: TextStyle(color: ColorForTheApp.redColor),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(TextForTheApp.no),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _deletefromList(TodoModel todo) async {
    UserModel? user = await Servicefile.getUser(widget.uid);
    if (user == null) {
      return;
    }
    if (dontaskdeletestore != null && dontaskdeletestore == true) {
      await performDeleteList(todo);
    } else {
      showdialogDelete(todo);
    }
  }

  Future _isLogOut() {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).colorScheme.onSecondary,
        content: Text(
          style: TextStyle(fontSize: 17),
          TextForTheApp.wanttologout,
        ),
        actions: [
          TextButton(
            onPressed: () async {
              // SecuredStorage.logout();
              await FirebaseAuth.instance.signOut();
              Navigator.pop(context);
            },
            child: Text(
              TextForTheApp.yes,
              style: TextStyle(
                color: ColorForTheApp.redColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(
              style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
              TextForTheApp.no,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        await _exit();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(TextForTheApp.todoapptitle),
          actions: [
            Text(mail ?? ""),
            IconButton(
              icon: Icon(Icons.logout_outlined),
              onPressed: () => _isLogOut(),
            ),
          ],
        ),
        body: SafeArea(
          child: IndexedStack(
            index: _currentIndex,
            children: [
              todoHome(),
              Categorypage(uid: widget.uid),
              Userprofile(uid: widget.uid),
            ],
          ),
        ),

        floatingActionButton: _currentIndex == 0
            ? FloatingActionButton(
                onPressed: () {
                  _gotoInsertPage(widget.uid);
                },
                child: Icon(Icons.add, size: 30),
              )
            : null,

        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (value) async {
            setState(() {
              _currentIndex = value;
            });

            if (value == 0) {
              categorylist;
              await loadData();
            }
          },
          items: [
            BottomNavigationBarItem(
              label: TextForTheApp.home,
              icon: Icon(
                _currentIndex == 0 ? Icons.home_sharp : Icons.home_outlined,
              ),
            ),
            BottomNavigationBarItem(
              label: TextForTheApp.category,
              icon: Icon(
                _currentIndex == 1 ? Icons.category : Icons.category_outlined,
              ),
            ),
            BottomNavigationBarItem(
              label: TextForTheApp.profile,
              icon: Icon(
                _currentIndex == 2
                    ? Icons.person_rounded
                    : Icons.person_outline,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget todoHome() {
    return SizedBox(
      height: 800,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (todoList.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
              child: TextField(
                controller: _searchController,
                onChanged: (value) {
                  setState(() {
                    _foundList = todoList
                        .where(
                          (item) =>
                              item.title.toString().toLowerCase().contains(
                                value.toLowerCase(),
                              ) ||
                              item.task.toString().toLowerCase().contains(
                                value.toLowerCase(),
                              ),
                        )
                        .toList();
                  });
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.search),
                  labelText: TextForTheApp.searchLabel,
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          onPressed: () {
                            setState(() {
                              _searchController.clear();
                              _foundList = todoList;
                            });
                          },
                          icon: Icon(Icons.cancel),
                        )
                      : null,
                ),
              ),
            ),

          if (todoList.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: SizedBox(
                height: 50,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: categorylist.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 10.0),
                      child: ChoiceChip(
                        label: Text(categorylist[index].categoryName!),
                        selected:
                            selectedcategory ==
                            categorylist[index].categoryName,

                        onSelected: (value) {
                          setState(() {
                            if (value) {
                              selectedcategory =
                                  categorylist[index].categoryName!;
                              _foundList = todoList.where((element) {
                                return element.categoryName ==
                                    categorylist[index].categoryName;
                              }).toList();
                            } else {
                              selectedcategory = "All";
                              _foundList = todoList;
                            }
                          });
                        },
                      ),
                    );
                  },
                ),
              ),
            ),

          Expanded(
            child: _foundList.isEmpty
                ? emptyStateScreen()
                : ListView.builder(
                    itemCount: _foundList.length,
                    itemBuilder: (context, index) {
                      final todo = _foundList[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        child: _customCard2(todo),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _customCard2(TodoModel todo) {
    return Dismissible(
      key: UniqueKey(),
      direction: DismissDirection.horizontal,

      background: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        alignment: Alignment.centerLeft,
        color: ColorForTheApp.greenColor,
        child: Icon(Icons.edit, color: ColorForTheApp.whiteColor),
      ),

      secondaryBackground: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        alignment: Alignment.centerRight,
        color: ColorForTheApp.redColor,
        child: Icon(Icons.delete, color: ColorForTheApp.whiteColor),
      ),

      confirmDismiss: (direction) async {
        if (direction == DismissDirection.endToStart) {
          _deletefromList(todo);
        } else {
          _gotoUpdatePage(todo);
        }
        return null;
      },

      onDismissed: (direction) {},
      child: Card(
        color: Theme.of(context).colorScheme.onSecondary,
        elevation: 6,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            width: MediaQuery.widthOf(context) - 16,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                SizedBox(
                  width: 70,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        backgroundColor: Theme.of(
                          context,
                        ).colorScheme.surfaceContainerHighest,
                        radius: 26,
                        child: Icon(
                          CategoryModel.stringtoIcon(todo.categoryIcon),
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        todo.categoryName ?? "",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              todo.title ?? "",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),

                          SizedBox(width: 10),

                          if (todo.scheduleForDate != null &&
                              todo.scheduleForTime != null)
                            Stack(
                              children: [
                                Icon(Icons.timer_outlined, size: 30),
                                Positioned(
                                  bottom: 6,
                                  left: -3,
                                  child: Container(
                                    child: Icon(
                                      weight: 500,
                                      color: ColorForTheApp.greenColor,
                                      Icons.check_outlined,
                                    ),
                                  ),
                                ),
                              ],
                            )
                          else
                            Icon(Icons.timer_outlined, size: 30),

                          // Icon(Icons.schedule_sharp),
                        ],
                      ),
                      Text(
                        todo.task ?? "",
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontWeight: FontWeight.w400),
                      ),
                      SizedBox(height: 10),
                      Text(todo.craeteAt_formated()),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget shimmerforhomepage() {
    return Padding(
      padding: const EdgeInsets.only(top: 60),
      child: ListView.builder(
        itemCount: 4,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Card(
              elevation: 6,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  width: MediaQuery.widthOf(context) - 16,
                  child: Shimmer.fromColors(
                    baseColor: ColorForTheApp.greycolor.shade400,
                    highlightColor: Theme.of(
                      context,
                    ).colorScheme.surfaceContainerHighest,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        SizedBox(
                          width: 70,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              CircleAvatar(
                                backgroundColor: Theme.of(
                                  context,
                                ).colorScheme.surfaceContainerHighest,
                                radius: 26,
                              ),
                              SizedBox(height: 10),
                              Container(
                                height: 30,
                                color: ColorForTheApp.greycolor,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Container(
                                      height: 30,
                                      color: ColorForTheApp.greycolor,
                                    ),
                                  ),
                                ],
                              ),

                              Container(
                                height: 20,
                                color: ColorForTheApp.greycolor,
                              ),
                              Container(
                                height: 30,
                                color: ColorForTheApp.greycolor,
                              ),

                              SizedBox(height: 10),
                              Container(
                                height: 30,
                                color: ColorForTheApp.greycolor,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
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
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Theme.of(context).colorScheme.onSurface
                      : Theme.of(context).colorScheme.surface,
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
            TextForTheApp.emptyPageText,
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
