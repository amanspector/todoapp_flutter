import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:todoapp/categoryPage.dart';
import 'package:todoapp/color_for_the_app.dart';
import 'package:todoapp/models/category_model.dart';
import 'package:todoapp/serviceFile.dart';
import 'package:todoapp/shared_pref_file.dart';
import 'package:todoapp/text_for_the_app.dart';

class Insertcategory extends StatefulWidget {
  final CategoryModel? category;
  String uid;
  Insertcategory({super.key, this.category, required this.uid});
  @override
  State<StatefulWidget> createState() => _InsertcategoryState();
}

class _InsertcategoryState extends State<Insertcategory> {
  final _formkey = GlobalKey<FormState>();
  String? iconString;
  final TextEditingController _categorynameController = TextEditingController();
  IconData? selectedIcon;
  List<IconData> pickIcon = [
    Icons.work,
    Icons.menu_book_sharp,
    Icons.airplanemode_active,
    Icons.health_and_safety_sharp,
    Icons.family_restroom,
    Icons.attach_money,
    Icons.shopping_cart,
    Icons.person,
  ];

  @override
  void initState() {
    super.initState();
    if (widget.category != null) {
      _categorynameController.text = widget.category!.categoryName!;
      iconString = widget.category!.iconString;

      selectedIcon =
          CategoryModel.StringiconMap[widget.category!.iconString] ??
          Icons.person;
    }
  }

  void _addcategory() async {
    FocusScope.of(context).unfocus();

    if (!_formkey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(TextForTheApp.dataInsertionFailed)),
      );
      return;
    }

    if (iconString == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(TextForTheApp.selecticonerror)));
      return;
    }

    List<CategoryModel> categories = await Servicefile.getCategories(
      widget.uid,
    );

    if (widget.category != null) {
      int index = categories.indexWhere(
        (element) => element.categoryName == widget.category!.categoryName,
      );
      bool alreadyexists = categories.any(
        (element) =>
            element.categoryName!.toLowerCase() ==
                _categorynameController.text.trim().toLowerCase() &&
            element.categoryName != widget.category!.categoryName,
      );

      if (alreadyexists) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(TextForTheApp.alreadyexistscategory)),
        );
        return;
      }

      Servicefile.updateCategories(
        widget.uid,
        CategoryModel(
          categoryName: _categorynameController.text.trim(),
          iconString: iconString,
        ),
        widget.category!.catid!,
      );

      // if (index != -1) {
      //   categories[index] = CategoryModel(
      //     categoryName: _categorynameController.text.trim(),
      //     iconString: iconString,
      //   );
      // }

      // await (mail, categories);
      // await SharedPrefFile.saveCategories(mail, categories);

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(TextForTheApp.updatecategory)));
      // Navigator.pop(context, true);
    } else {
      bool alreadyexists = categories.any(
        (element) =>
            element.categoryName!.toLowerCase() ==
            _categorynameController.text.trim().toLowerCase(),
      );

      if (alreadyexists) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(TextForTheApp.alreadyexistscategory)),
        );
        return;
      }

      Servicefile.setCategogries(
        widget.uid,
        CategoryModel(
          categoryName: _categorynameController.text.trim(),
          iconString: iconString,
        ),
      );

      // await SharedPrefFile.saveCategories(mail, categories);

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(TextForTheApp.dataInserted)));
    }

    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: widget.category != null
            ? Text(TextForTheApp.updateTodoTitle)
            : Text(TextForTheApp.addCategoryTitle),
      ),
      body: SafeArea(
        child: Form(
          key: _formkey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(TextForTheApp.category),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: TextFormField(
                    maxLength: 20,
                    controller: _categorynameController,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      hintText: TextForTheApp.labelCategoryname,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return TextForTheApp.errormsgforTitle;
                      } else {
                        return null;
                      }
                    },
                  ),
                ),
                Text(TextForTheApp.icon),

                Flexible(
                  flex: 2,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        width: 1,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: 100,
                        mainAxisSpacing: 5,
                        crossAxisSpacing: 5,
                      ),
                      itemCount: pickIcon.length,
                      itemBuilder: (context, index) {
                        return Container(
                          decoration: BoxDecoration(
                            color: selectedIcon == pickIcon[index]
                                ? ColorForTheApp.greycolor
                                : ColorForTheApp.transperent,
                          ),
                          child: IconButton(
                            iconSize: 40,
                            onPressed: () {
                              setState(() {
                                selectedIcon = pickIcon[index];
                                iconString =
                                    CategoryModel.iconStringMap[selectedIcon];
                              });
                            },
                            icon: Icon(pickIcon[index]),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                Spacer(),
                Positioned(
                  bottom: 10,
                  child: Card(
                    elevation: 6,
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 2,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: MaterialButton(
                        onPressed: () => _addcategory(),
                        child: Text(
                          widget.category != null
                              ? TextForTheApp.updateCategory
                              : TextForTheApp.addCategory,
                          style: TextStyle(fontSize: 16),
                        ),
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
}
