import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:todoapp/color_for_the_app.dart';
import 'package:todoapp/models/user_model.dart';
import 'package:todoapp/text_for_the_app.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Signupscreen extends StatefulWidget {
  const Signupscreen({super.key});

  @override
  State<StatefulWidget> createState() => _SignupscreenState();
}

class _SignupscreenState extends State<Signupscreen> {
  TextEditingController fullnameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController phonenoController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  bool isregistred = false;
  final _formkey = GlobalKey<FormState>();
  bool isObsured = true;
  String? selectedGender = TextForTheApp.maleText;
  DateTime? pickedDate;
  String? errorDate;
  String labelforbirthDate = TextForTheApp.birthdateLabel;
  bool dialogBoxDelete = false;

  Future _showDialogBox() async {
    pickedDate = await showDatePicker(
      context: context,
      firstDate: DateTime(1990),
      lastDate: DateTime(2015),
    );

    if (pickedDate == null) {
      return;
    }
    setState(() {
      labelforbirthDate = UserModel.DateToString(pickedDate!);
    });
  }

  void _onSave() async {
    debugPrint(
      "---------------------------------------------------------------------------onsaved",
    );

    FocusManager.instance.primaryFocus!.unfocus();
    setState(() {
      errorDate = null;
    });
    if (_formkey.currentState!.validate()) {
      String name = fullnameController.text.trim();
      String password = passwordController.text.trim();
      String gmail = emailController.text.toLowerCase().trim();
      String phoneno = phonenoController.text.trim();

      try {
        setState(() {
          isregistred = true;
        });

        final userCred = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: gmail, password: password);
        print(userCred);

        // if (!FirebaseAuth.instance.currentUser!.emailVerified) {
        //   await FirebaseAuth.instance.currentUser!.sendEmailVerification();
        // }

        if (pickedDate == null) {
          print(errorDate);
          return;
        }
        DateTime datepicked = pickedDate!;

        String pickeddate = UserModel.DateToString(datepicked);
        String gender = selectedGender.toString().trim();

        UserModel user = UserModel(
          name: name,
          gmail: gmail,
          phoneno: phoneno,
          dateofbirth: pickeddate,
          gender: gender,
          dialogBoxDelete: false,
        );
        await FirebaseFirestore.instance
            .collection("users")
            .doc(userCred.user!.uid)
            .set(user.tomap());

        // SharedPrefFile.setData(
        //   name,
        //   gmail,
        //   password,
        //   phoneno,
        //   pickeddate,
        //   gender,
        // );

        // UserModel user = UserModel(
        //   name: name,
        //   gmail: gmail,
        //   phoneno: phoneno,
        //   birthdate: pickeddate,
        //   gender: gender,
        // );

        debugPrint(name);
        debugPrint(password);
        debugPrint(phoneno);
        debugPrint(pickeddate);
        debugPrint(gmail);
        debugPrint(gender);
        Navigator.pop(context);
      } on FirebaseAuthException catch (e) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(e.message!)));
      } finally {
        setState(() {
          isregistred = false;
        });
      }
    }

    if (labelforbirthDate == TextForTheApp.birthdateLabel) {
      setState(() {
        errorDate = "please enter birthdate";
      });
      return;
    } else {
      Text(TextForTheApp.dataInsertionFailed);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: SizedBox(
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
                        vertical: 10,
                      ),
                      child: Text(
                        TextForTheApp.welcomeSignup,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    Text(
                      TextForTheApp.signupToContinue,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                      ),
                    ),

                    SizedBox(height: 10),
                    _commonTextFormField(
                      prefixIcon: Icon(Icons.person_rounded),
                      labeltext: TextForTheApp.nameLabel,
                      fieldController: fullnameController,
                      hintText: TextForTheApp.hintTextname,
                      validationfunc: UserModel.validateName,
                    ),

                    SizedBox(height: 10),
                    _commonTextFormField(
                      prefixIcon: Icon(Icons.email_outlined),
                      labeltext: TextForTheApp.gmailLabel,
                      fieldController: emailController,
                      hintText: TextForTheApp.hintTextgmail,
                      validationfunc: UserModel.validateEmail,
                      textinputtype: TextInputType.emailAddress,
                    ),

                    SizedBox(height: 10),
                    _commonTextFormField(
                      prefixIcon: Icon(Icons.password),
                      labeltext: TextForTheApp.passwordLabel,
                      fieldController: passwordController,
                      hintText: TextForTheApp.hintTextpassword,
                      validationfunc: UserModel.validatePassword,
                      isObsure: isObsured,
                      visibleLogo: () {
                        setState(() {
                          isObsured = !isObsured;
                        });
                      },
                    ),
                    SizedBox(height: 10),

                    _commonTextFormField(
                      prefixIcon: Icon(Icons.phone_rounded),
                      labeltext: TextForTheApp.phoneLabel,

                      fieldController: phonenoController,
                      maxlength1: 10,
                      textinputtype: TextInputType.number,
                      hintText: TextForTheApp.hintTextphoneno,
                      validationfunc: UserModel.validatePhoneno,
                    ),

                    SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: _customBirthDate(),
                    ),

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

                    RadioGroup(
                      onChanged: (value) {
                        setState(() {
                          selectedGender = value;
                        });
                      },
                      groupValue: selectedGender,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            TextForTheApp.Gender,
                            style: TextStyle(fontSize: 18),
                          ),
                          SizedBox(
                            width: 140,
                            child: RadioListTile(
                              activeColor: Theme.of(
                                context,
                              ).colorScheme.onSurface,
                              title: Text(
                                style: TextStyle(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurface,
                                ),
                                TextForTheApp.maleLabel,
                              ),
                              value: TextForTheApp.maleText,
                              selected: true,
                            ),
                          ),

                          SizedBox(
                            width: 160,
                            child: RadioListTile(
                              activeColor: Theme.of(
                                context,
                              ).colorScheme.onSurface,

                              title: Text(TextForTheApp.femaleLabel),
                              value: TextForTheApp.femaleText,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Spacer(),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: isregistred == false
                              ? OutlinedButton(
                                  style: OutlinedButton.styleFrom(
                                    minimumSize: Size(double.infinity, 50),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  onPressed: isregistred ? null : _onSave,
                                  child: Text(
                                    TextForTheApp.saveButton,
                                    style: TextStyle(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.onSurface,
                                      fontSize: 16,
                                    ),
                                  ),
                                )
                              : Container(
                                  height: 50,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      width: 1,
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.onSurface,
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Center(
                                    child: SizedBox(
                                      height: 40,
                                      width: 40,
                                      child: CircularProgressIndicator(),
                                    ),
                                  ),
                                ),
                          // ),
                        ),
                        SizedBox(height: 7),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(TextForTheApp.alreadyhaveaccount),
                            SizedBox(width: 10),
                            GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Text(
                                style: TextStyle(fontWeight: FontWeight.bold),
                                TextForTheApp.login,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _customBirthDate() {
    return InkWell(
      onTap: _showDialogBox,
      child: Container(
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
              child: Icon(Icons.calendar_month_rounded),
            ),

            Padding(
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
          ],
        ),
      ),
    );
  }

  Widget _commonTextFormField({
    required Icon prefixIcon,
    required String labeltext,
    required String hintText,
    required TextEditingController fieldController,
    VoidCallback? visibleLogo,
    bool isObsure = false,
    int? maxlength1,

    String? Function(String?)? validationfunc,
    TextInputType textinputtype = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: TextFormField(
        obscureText: isObsure,
        controller: fieldController,
        keyboardType: textinputtype,
        maxLength: maxlength1,
        decoration: InputDecoration(
          labelStyle: TextStyle(color: Theme.of(context).colorScheme.onSurface),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          prefixIcon: prefixIcon,
          counterText: "",
          suffixIcon: visibleLogo != null
              ? IconButton(
                  color: Theme.of(context).colorScheme.onSurface,
                  onPressed: visibleLogo,
                  icon: isObsure
                      ? Icon(Icons.visibility)
                      : Icon(Icons.visibility_off_rounded),
                )
              : null,
          labelText: labeltext,
          hint: Text(hintText),
          errorStyle: TextStyle(color: ColorForTheApp.redColor),
          hintStyle: TextStyle(
            fontSize: 17,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        validator: validationfunc,
      ),
    );
  }
}
