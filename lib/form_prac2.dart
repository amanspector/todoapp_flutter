import 'package:flutter/material.dart';
import 'package:todoapp/color_for_the_app.dart';
import 'package:todoapp/text_for_the_app.dart';

class FormPrac2 extends StatefulWidget {
  const FormPrac2({super.key});

  @override
  State<StatefulWidget> createState() => _FormPrac2State();
}

class _FormPrac2State extends State<FormPrac2> {
  TextEditingController nameTexteditingController = TextEditingController();
  final _formkey = GlobalKey<FormState>();

  List selectedCheckBox = [];

  List<Map> checkboxusingmap = [
    {'name': 'hello1', 'ischeck': false},
    {'name': 'hello2', 'ischeck': false},
    {'name': 'hello3', 'ischeck': false},
  ];

  String? selectedGender = TextForTheApp.selectedGender;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Form prac 2")),
      body: Form(
        key: _formkey,
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TextFormField(
                  controller: nameTexteditingController,
                  style: TextStyle(
                    // fontSize: 50
                  ),
                  decoration: InputDecoration(
                    // hintText: "ENTER NAME",
                    labelText: TextForTheApp.nameLabel,
                    // hint: Text("heelo"),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),

                      // borderRadius: BorderRadius.all(Radius.circular(20))
                    ),
                  ),

                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return TextForTheApp.namevalid;
                    }
                    return null;
                  },
                ),

                RadioGroup(
                  onChanged: (value) {
                    setState(() {
                      selectedGender = value;
                      print(selectedGender);
                    });
                  },
                  groupValue: selectedGender,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,

                    children: [
                      RadioListTile(
                        title: Text(TextForTheApp.maleText),
                        value: TextForTheApp.maleText,
                      ),
                      RadioListTile(
                        title: Text(TextForTheApp.femaleText),
                        value: TextForTheApp.femaleText,
                      ),
                    ],
                  ),
                ),

                SizedBox(
                  height: 400,
                  child: ListView.builder(
                    itemCount: checkboxusingmap.length,
                    itemBuilder: (context, index) {
                      return CheckboxListTile(
                        title: Text(checkboxusingmap[index]['name']),
                        value: checkboxusingmap[index]['ischeck'],

                        onChanged: (value) {
                          setState(() {
                            checkboxusingmap[index]['ischeck'] = value;
                          });

                          if (checkboxusingmap[index]['ischeck'] == true) {
                            setState(() {
                              selectedCheckBox.add(
                                checkboxusingmap[index]['name'],
                              );
                            });
                          }
                          if (checkboxusingmap[index]['ischeck'] == false) {
                            setState(() {
                              selectedCheckBox.remove(
                                checkboxusingmap[index]['name'],
                              );
                            });
                          }
                        },
                      );
                    },
                  ),
                ),

                SizedBox(height: 20),

                DropdownButtonFormField(
                  items: selectedCheckBox
                      .map(
                        (option) => DropdownMenuItem(
                          value: option,
                          child: Text(option),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {},
                  validator: (value) {
                    if (value == null) {
                      return TextForTheApp.errorForDropdown;
                    }
                    return null;
                  },
                ),

                MaterialButton(
                  textColor: ColorForTheApp.whiteColor,
                  color: ColorForTheApp.deeppurpleColor,

                  child: Text(TextForTheApp.saveButton),
                  onPressed: () {
                    setState(() {
                      if (_formkey.currentState!.validate()) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(TextForTheApp.dataInserted)),
                        );
                      }
                    });
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
