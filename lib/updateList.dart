import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:todoapp/color_for_the_app.dart';
import 'package:todoapp/models/category_model.dart';
import 'package:todoapp/models/todo_model.dart';
import 'package:todoapp/serviceFile.dart';
import 'package:todoapp/shared_pref_file.dart';
import 'package:todoapp/text_for_the_app.dart';

class Updatelist extends StatefulWidget {
  TodoModel todo;
  String uid;
  Updatelist({super.key, required this.todo, required this.uid});

  @override
  State<StatefulWidget> createState() => _UpdatelistState();
}

class _UpdatelistState extends State<Updatelist> {
  final _formkey = GlobalKey<FormState>();

  late TextEditingController titleController;
  late TextEditingController subtitleController;
  TimeOfDay? selectedTime1;
  late String dateString;
  late String timeString;
  String? iconString = "";
  String? selectcategory = "";
  List<CategoryModel> categories = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (widget.todo.scheduleForDate == null) {
      dateString = TextForTheApp.selectDate;
    } else {
      dateString = TodoModel.DateToString(widget.todo.scheduleForDate!);
    }

    if (widget.todo.scheduleForTime == null) {
      timeString = TextForTheApp.selectTime;
    } else {
      timeString = TodoModel.TimeToString(widget.todo.scheduleForTime!);
    }
  }

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.todo.title);
    subtitleController = TextEditingController(text: widget.todo.task);
    selectcategory = widget.todo.categoryName;
    iconString = widget.todo.categoryIcon;
    loadCategories();
  }

  void loadCategories() async {
    List<CategoryModel> cat = await Servicefile.getCategories(widget.uid);

    setState(() {
      categories = cat;
    });
  }

  void _showDialogBox() {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: Theme.of(context).colorScheme.onSecondary,
              content: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    TextForTheApp.scheduleDateTime,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),

                  SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(dateString, style: TextStyle(fontSize: 15)),
                        IconButton(
                          icon: Icon(Icons.date_range),
                          onPressed: () async {
                            DateTime? selectedDate = await showDatePicker(
                              context: context,
                              firstDate: DateTime.now(),
                              lastDate: DateTime(DateTime.now().year + 2),
                            );
                            if (selectedDate != null) {
                              setState(() {
                                dateString = TodoModel.DateToString(
                                  selectedDate,
                                );
                              });
                            } else {
                              setState(() {
                                dateString = TodoModel.DateToString(
                                  DateTime(
                                    DateTime.now().year,
                                    DateTime.now().month,
                                    DateTime.now().day + 1,
                                  ),
                                );
                              });
                            }
                          },
                          iconSize: 30,
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(timeString, style: TextStyle(fontSize: 15)),
                        IconButton(
                          icon: Icon(Icons.access_time_rounded),
                          onPressed: () async {
                            TimeOfDay? selectedTime = await showTimePicker(
                              context: context,
                              initialTime: TimeOfDay.now(),
                            );

                            if (selectedTime != null) {
                              setState(() {
                                timeString = TodoModel.TimeToString(
                                  selectedTime,
                                );
                              });
                            } else {
                              TimeOfDay t = TimeOfDay.now();
                              setState(() {
                                timeString = TodoModel.TimeToString(t);
                              });
                            }
                          },
                          iconSize: 30,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              actionsAlignment: MainAxisAlignment.center,
              actions: [
                MaterialButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(TextForTheApp.ok),
                ),

                MaterialButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(TextForTheApp.cancel),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void updateData() {
    if (_formkey.currentState!.validate()) {
      Servicefile.updatetodos(
        widget.uid,
        widget.todo.todoid!,
        TodoModel(
          title: titleController.text.trim(),
          task: subtitleController.text.trim(),
          createdAt: widget.todo.createdAt,
          scheduleForDate: dateString == TextForTheApp.selectDate
              ? widget.todo.scheduleForDate
              : TodoModel.StringtoDate(dateString),
          scheduleForTime: timeString == TextForTheApp.selectTime
              ? widget.todo.scheduleForTime
              : TodoModel.StringToTime(timeString),
          categoryIcon: iconString,
          categoryName: selectcategory,
        ),
      );

      // final Updatedresult = TodoModel(
      //   title: titleController.text.trim(),
      //   task: subtitleController.text.trim(),
      //   createdAt: widget.todo.createdAt,
      //   scheduleForDate: dateString == TextForTheApp.selectDate
      //       ? widget.todo.scheduleForDate
      //       : TodoModel.StringtoDate(dateString),
      //   scheduleForTime: timeString == TextForTheApp.selectTime
      //       ? widget.todo.scheduleForTime
      //       : TodoModel.StringToTime(timeString),
      //   categoryIcon: iconString,
      //   categoryName: selectcategory,
      // );
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(TextForTheApp.updateSuccessfully)));
      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(TextForTheApp.dataUpdationFailed)));
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
      appBar: AppBar(
        title: Text(TextForTheApp.updatetodoTitle),
        actions: [
          if (widget.todo.scheduleForDate != null &&
              widget.todo.scheduleForTime != null)
            Stack(
              children: [
                IconButton(
                  onPressed: _showDialogBox,
                  icon: Icon(Icons.timer_outlined, size: 30),
                ),
                Positioned(
                  bottom: 4,
                  left: 3,
                  child: Container(
                    child: Icon(
                      fill: 0.5,
                      weight: 200,
                      color: ColorForTheApp.greenColor,
                      Icons.check_outlined,
                    ),
                  ),
                ),
              ],
            )
          else
            IconButton(
              onPressed: _showDialogBox,
              icon: Icon(Icons.timer_outlined, size: 30),
            ),
        ],
      ),
      body: Form(
        key: _formkey,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 10),
              TextFormField(
                controller: titleController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  labelText: TextForTheApp.labelTitle,
                ),
              ),

              SizedBox(height: 10),

              TextFormField(
                controller: subtitleController,
                maxLines: 6,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  labelText: TextForTheApp.labelSubtitle,
                ),
              ),
              SizedBox(height: 10),
              Text(TextForTheApp.categoryIcons),

              Expanded(
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
                    child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: 100,
                        mainAxisSpacing: 5,
                        crossAxisSpacing: 5,
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
                                    selectcategory ==
                                        categories[index].categoryName
                                    ? ColorForTheApp.greycolor
                                    : ColorForTheApp.transperent,
                              ),
                              child: IconButton(
                                iconSize: 40,
                                onPressed: () {
                                  setState(() {
                                    selectcategory =
                                        categories[index].categoryName!;
                                    iconString = categories[index].iconString;
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
                  onPressed: updateData,
                  child: Text(
                    TextForTheApp.updateButton,
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),

              SizedBox(height: 15),
            ],
          ),
        ),
      ),
    );
  }
}
