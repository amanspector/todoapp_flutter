import 'package:flutter/material.dart';
import 'package:todoapp/color_for_the_app.dart';
import 'package:todoapp/text_for_the_app.dart';

class FormPrac extends StatefulWidget {
  const FormPrac({super.key});

  @override
  State<StatefulWidget> createState() => _FormPracState();
}

class _FormPracState extends State<FormPrac> {
  final _formkey = GlobalKey<FormState>();

  bool ischackedCricket = false;
  bool ischackedFootball = false;
  bool ischackedChess = false;
  @override
  Widget build(BuildContext context) {
    TextEditingController firstnameTexteditingcontroller =
        TextEditingController();
    TextEditingController lastnameTexteditingcontroller =
        TextEditingController();
    return Scaffold(
      appBar: AppBar(title: Text("Form")),
      body: Form(
        key: _formkey,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextFormField(
                textInputAction: TextInputAction.next,
                controller: firstnameTexteditingcontroller,
                decoration: InputDecoration(
                  label: Text(TextForTheApp.firstNameLabel),
                  prefixIcon: Icon(Icons.person),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                validator: firstnameValidaton,
              ),

              SizedBox(height: 10),
              TextFormField(
                textInputAction: TextInputAction.next,
                controller: lastnameTexteditingcontroller,
                decoration: InputDecoration(
                  label: Text(TextForTheApp.lastNameLabel),
                  prefixIcon: Icon(Icons.person_off),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                validator: lastnameValidaton,
              ),

              SizedBox(height: 10),

              RadioGroup(
                groupValue: TextForTheApp.selectedGender,
                onChanged: (value) {
                  setState(() {
                    // TextForTheApp.selectedGender = value ;
                  });
                },
                child: Column(
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
                height: 25,
                child: Text(
                  "Hobbies",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),

              CheckboxListTile(
                value: ischackedCricket,
                title: Text(TextForTheApp.checkbokCricket),
                onChanged: (bool? value) {
                  setState(() {
                    ischackedCricket = value!;
                  });
                },
              ),

              CheckboxListTile(
                value: ischackedFootball,
                title: Text(TextForTheApp.checkbokFootball),
                onChanged: (bool? value) {
                  setState(() {
                    ischackedFootball = value!;
                  });
                },
              ),
              CheckboxListTile(
                value: ischackedChess,
                title: Text(TextForTheApp.checkbokChess),
                onChanged: (bool? value) {
                  setState(() {
                    ischackedChess = value!;
                  });
                },
              ),
              MaterialButton(
                textColor: ColorForTheApp.whiteColor,
                onPressed: () {
                  if (_formkey.currentState!.validate()) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(TextForTheApp.dataInserted)),
                    );
                  }
                },
                child: Text("Submit"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String? firstnameValidaton(String? value) {
    if (value == null || value.isEmpty) {
      return TextForTheApp.firstnamevalid;
    }
    return null;
  }

  String? lastnameValidaton(String? value) {
    if (value == null || value.isEmpty) {
      return TextForTheApp.lastnamevalid;
    }
    return null;
  }
}
