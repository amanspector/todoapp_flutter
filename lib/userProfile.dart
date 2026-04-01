import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:todoapp/color_for_the_app.dart';
import 'package:todoapp/models/user_model.dart';
import 'package:todoapp/serviceFile.dart';
// import 'package:todoapp/shared_pref_file.dart';
import 'package:todoapp/text_for_the_app.dart';

class Userprofile extends StatefulWidget {
  String uid;
  Userprofile({super.key, required this.uid});

  @override
  State<StatefulWidget> createState() => _UserprofileState();
}

class _UserprofileState extends State<Userprofile> {
  final _formkey = GlobalKey<FormState>();
  String? selectedGender = TextForTheApp.maleText;
  bool isObsured = true;
  FocusNode nameAutofocus = FocusNode();
  FocusNode passAutofocus = FocusNode();
  bool namereadonly = true;
  bool passreadonly = true;
  bool isEdit = false;
  DateTime? pickedDate;
  String? errorDate;
  String labelforbirthDate = TextForTheApp.birthdateLabel;
  TextEditingController passwordController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController phonenoController = TextEditingController();
  UserModel? userData;
  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  @override
  void dispose() {
    passwordController.dispose();
    nameController.dispose();
    phonenoController.dispose();
    nameAutofocus.dispose();
    passAutofocus.dispose();
    super.dispose();
  }

  // void _onUpdateProfile() {
  //   FocusManager.instance.primaryFocus!.unfocus();
  //   // setState(() {
  //   //   errorDate = null;
  //   // });

  //   if (labelforbirthDate == TextForTheApp.birthdateLabel) {
  //     setState(() {
  //       errorDate = "please enter birthdate";
  //     });
  //   }
  //   if (_formkey.currentState!.validate()) {
  //     String name = nameController.text.trim();
  //     String gmail = userData!.gmail;
  //     String phoneno = phonenoController.text.trim();
  //     String pickeddate = labelforbirthDate;

  //     // if (pickedDate == null) {
  //     //   errorDate = "NO DATA FOUND";
  //     //   print(errorDate);
  //     //   return;
  //     // }
  //     String gender = selectedGender.toString().trim();

  //     UserModel u = UserModel(
  //       name: name,
  //       gmail: gmail,
  //       phoneno: phoneno,
  //       dateofbirth: pickeddate,
  //       gender: gender,
  //     );

  //     // Servicefile.updateprofile(widget.uid, u);
  //     // SharedPrefFile.setData(
  //     //   name,
  //     //   gmail,
  //     //   password,
  //     //   phoneno,
  //     //   pickeddate,
  //     //   gender,
  //     // );

  //     // UserModel user =
  //     // SharedPrefFile.updateUserProfile(user);
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text(TextForTheApp.profileupdatesuccess)),
  //     );
  //   } else {
  //     ScaffoldMessenger.of(
  //       context,
  //     ).showSnackBar(SnackBar(content: Text(TextForTheApp.dataUpdationFailed)));
  //   }
  // }

  Future _passwordRest() async {
    UserModel? user = await Servicefile.getUser(widget.uid);
    if (user == null) {
      return;
    }

    await FirebaseAuth.instance.sendPasswordResetEmail(email: user.gmail);
    if (!mounted) {
      return;
    }
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text("Email sent to ${user.gmail}")));
  }

  void _loadUserData() async {
    if (!mounted) {
      return;
    }
    userData = await Servicefile.getUser(widget.uid);
    if (mounted) {
      setState(() {
        nameController.text = userData!.name;
        phonenoController.text = userData!.phoneno;
        selectedGender = userData!.gender;
        labelforbirthDate = userData!.dateofbirth;
      });
    }
  }

  Future _showDialogBox() async {
    pickedDate = await showDatePicker(
      context: context,
      firstDate: DateTime(1990),
      lastDate: DateTime(2015).copyWith(day: 31, month: 12, year: 2015),
      // barrierColor: Theme.of(context).colorScheme.onSurface,
    );

    if (pickedDate == null) {
      return;
    }
    Servicefile.updateField(
      "dateofbirth",
      UserModel.DateToString(pickedDate!),
      widget.uid,
    );
    setState(() {
      labelforbirthDate = UserModel.DateToString(pickedDate!);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (userData == null) {
      return SizedBox(height: 20, child: Center(child: Text("DATA NOT FOUND")));
    }
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              child: Form(
                key: _formkey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 6,
                      ),
                      child: Text(
                        TextForTheApp.profile,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    Text(
                      "${TextForTheApp.gmailLabel} : ${userData!.gmail}",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    _commonTextFormField(
                      prefixIcon: Icon(Icons.person_rounded),
                      labeltext: TextForTheApp.nameLabel,
                      fieldController: nameController,
                      readonly: namereadonly,
                      hintText: TextForTheApp.hintTextname,
                      fnode: nameAutofocus,
                      validationfunc: UserModel.validateName,
                      editableFields: () {
                        if (namereadonly) {
                          setState(() {
                            namereadonly = !namereadonly;
                          });
                          nameAutofocus.requestFocus();
                        } else {
                          if (_formkey.currentState!.validate()) {
                            Servicefile.updateField(
                              "name",
                              nameController.text.trim().toString(),
                              widget.uid,
                            );
                          }
                          setState(() {
                            namereadonly = !namereadonly;
                          });
                          nameAutofocus.unfocus();
                        }
                      },
                      edit: namereadonly ? Icons.edit : Icons.check,
                    ),

                    SizedBox(height: 10),

                    _commonTextFormField(
                      prefixIcon: Icon(Icons.phone_rounded),
                      labeltext: TextForTheApp.phoneLabel,
                      fieldController: phonenoController,
                      textinputtype: TextInputType.number,
                      readonly: passreadonly,
                      maxlength: 10,
                      hintText: TextForTheApp.hintTextphoneno,

                      fnode: passAutofocus,
                      validationfunc: UserModel.validatePhoneno,
                      editableFields: () {
                        if (passreadonly) {
                          setState(() {
                            passreadonly = !passreadonly;
                          });
                          passAutofocus.requestFocus();
                        } else {
                          if (_formkey.currentState!.validate()) {
                            Servicefile.updateField(
                              "phoneno",
                              phonenoController.text.trim().toString(),
                              widget.uid,
                            );
                          }
                          setState(() {
                            passreadonly = !passreadonly;
                          });
                          passAutofocus.unfocus();
                        }
                      },
                      edit: passreadonly ? Icons.edit : Icons.check,
                    ),

                    SizedBox(height: 10),
                    _customBirthDate(),

                    if (errorDate != null)
                      Align(
                        alignment: AlignmentGeometry.centerLeft,
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14.0,
                              vertical: 2,
                            ),
                            child: Text(
                              errorDate!,
                              style: TextStyle(
                                fontSize: 12,
                                color: ColorForTheApp.redColor,
                              ),
                            ),
                          ),
                        ),
                      ),
                    SizedBox(height: 10),
                    resertPassword(),
                    SizedBox(height: 10),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget resertPassword() {
    return Padding(
      padding: const EdgeInsets.only(left: 4, right: 4),

      child: GestureDetector(
        onTap: () {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                backgroundColor: Theme.of(context).colorScheme.onSecondary,
                content: Text(
                  style: TextStyle(fontSize: 17),
                  TextForTheApp.areyousure,
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      _passwordRest();
                      Navigator.pop(context);
                    },
                    child: Text(
                      TextForTheApp.yes,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: ColorForTheApp.redColor,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                      TextForTheApp.no,
                    ),
                  ),
                ],
              );
            },
          );
        },
        child: Card(
          elevation: 6,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
            height: 55,
            decoration: BoxDecoration(
              border: Border.all(
                color: errorDate != null
                    ? ColorForTheApp.redColor
                    : Theme.of(context).colorScheme.onSurface,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Icon(Icons.password),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      TextForTheApp.resetPasswordLabel,
                      style: TextStyle(
                        fontSize: 17,
                        color: errorDate != null
                            ? ColorForTheApp.redColor
                            : Theme.of(context).colorScheme.onSurface,
                      ),
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

  Widget _customBirthDate() {
    return Padding(
      padding: const EdgeInsets.only(left: 4, right: 4),
      child: Card(
        elevation: 6,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
          height: 55,
          decoration: BoxDecoration(
            border: Border.all(
              color: errorDate != null
                  ? ColorForTheApp.redColor
                  : Theme.of(context).colorScheme.onSurface,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(12),
                child: Icon(Icons.calendar_month_rounded),
              ),

              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    labelforbirthDate,
                    style: TextStyle(
                      fontSize: 17,
                      color: errorDate != null
                          ? ColorForTheApp.redColor
                          : Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2.0),
                child: IconButton(
                  alignment: Alignment.topRight,
                  onPressed: () {
                    _showDialogBox();
                  },
                  icon: Icon(Icons.edit),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _commonTextFormField({
    required Icon prefixIcon,
    required String labeltext,
    String? hintText,
    TextEditingController? fieldController,
    bool autofocus = false,
    FocusNode? fnode,
    VoidCallback? editableFields,
    VoidCallback? onTap,
    bool? isEnable,
    bool isObsure = false,
    bool readonly = true,
    int? maxlength,
    String? Function(String?)? validationfunc,
    TextInputType textinputtype = TextInputType.text,
    IconData? edit,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      child: Card(
        elevation: 6,
        child: TextFormField(
          enabled: isEnable,
          onTap: onTap,
          obscureText: isObsure,
          controller: fieldController,
          keyboardType: textinputtype,
          maxLength: maxlength,
          autofocus: autofocus,
          readOnly: readonly,
          focusNode: fnode,
          decoration: InputDecoration(
            counterText: "",
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            prefixIcon: prefixIcon,
            suffixIcon: IconButton(onPressed: editableFields, icon: Icon(edit)),
            labelText: labeltext,
            hint: hintText != null ? Text(hintText) : null,
            errorStyle: TextStyle(color: ColorForTheApp.redColor),
            hintStyle: TextStyle(
              fontSize: 17,
              color: ColorForTheApp.greycolor.shade700,
            ),
          ),
          validator: validationfunc,
        ),
      ),
    );
  }
}
