import 'package:expense_repository/expense_repository.dart';
import 'package:expense_tracker_project/blocs/category_bloc/category_bloc.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:user_repository/user_repository.dart';

import 'package:uuid/uuid.dart';

Future<void> getCategoryCreation(
    BuildContext context, VoidCallback onCategoryAdded) {
  return showDialog(
    context: context,
    builder: (ctx) {
      return BlocProvider.value(
        value: context.read<CategoryBloc>(),
        child: CategoryCreationDialog(
          onCategoryAdded: onCategoryAdded,
        ),
      );
    },
  );
}

class CategoryCreationDialog extends StatefulWidget {
  final VoidCallback onCategoryAdded;

  CategoryCreationDialog({required this.onCategoryAdded});

  @override
  _CategoryCreationDialogState createState() => _CategoryCreationDialogState();
}

class _CategoryCreationDialogState extends State<CategoryCreationDialog> {
  late TextEditingController _categoryNameController;
  late TextEditingController _categoryIconController;
  late TextEditingController _categoryColorController;
  late Color categoryColor;
  bool isLoading = false;
  String iconSelected = '';
  bool isExpanded = false;

  @override
  void initState() {
    super.initState();
    _categoryNameController = TextEditingController();
    _categoryIconController = TextEditingController();
    _categoryColorController = TextEditingController();
    categoryColor = Colors.white;
  }

  @override
  void dispose() {
    _categoryNameController.dispose();
    _categoryIconController.dispose();
    _categoryColorController.dispose();
    super.dispose();
  }

  bool _validateFields() {
    if (_categoryNameController.text.isEmpty ||
        iconSelected.isEmpty ||
        categoryColor == Colors.white) {
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    List<String> myCategoriesIcons = [
      'entertainment',
      'food',
      'home',
      'pet',
      'shopping',
      'tech',
      'travel',
      'health',
      'grooming',
      'bill',
      'education',
      'investment',
      'kids',
      'leisure',
      'loan',
      'misc',
    ];
    Category category = Category.empty;

    return BlocListener<CategoryBloc, CategoryState>(
      listener: (context, state) {
        if (state is CategoryLoaded) {
          widget.onCategoryAdded();
          // Navigator.pop(context); // Close the dialog after category is added
        } else if (state is CategoryError) {
          setState(() {
            isLoading = false;
          });
        }
      },
      child: StatefulBuilder(
        builder: (ctx, setState) {
          return AlertDialog(
            title: Row(
              children: [
                const SizedBox(
                  width: 30,
                ),
                const Expanded(
                  child: Align(
                    alignment: Alignment.center,
                    child: Text("Create Category", textAlign: TextAlign.center),
                  ),
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    icon: const Icon(
                      Icons.close,
                      color: Colors.black,
                    ),
                    onPressed: () {
                      Navigator.of(context).pop(); // Dismiss the dialog
                    },
                  ),
                ),
              ],
            ),
            content: SingleChildScrollView(
              child: GestureDetector(
                onTap: () {
                  FocusScope.of(context).unfocus();
                },
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        controller: _categoryNameController,
                        decoration: InputDecoration(
                          isDense: true,
                          filled: true,
                          fillColor: Colors.white,
                          hintText: 'Name',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        onTap: () {
                          setState(() {
                            isExpanded = !isExpanded;
                          });
                        },
                        controller: _categoryIconController,
                        readOnly: true,
                        textAlignVertical: TextAlignVertical.center,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          hintText: 'Icon',
                          suffixIcon: const Icon(
                            CupertinoIcons.chevron_down,
                            size: 12,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: isExpanded
                                ? const BorderRadius.vertical(
                                    top: Radius.circular(12))
                                : BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                      isExpanded
                          ? Container(
                              width: MediaQuery.of(context).size.width,
                              height: 200,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.vertical(
                                    bottom: Radius.circular(12)),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: GridView.builder(
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3,
                                    mainAxisSpacing: 5,
                                    crossAxisSpacing: 5,
                                  ),
                                  itemCount: myCategoriesIcons.length,
                                  itemBuilder: (context, int i) {
                                    return GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          iconSelected = myCategoriesIcons[i];
                                        });
                                      },
                                      child: Container(
                                        width: 50,
                                        height: 50,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          border: Border.all(
                                            width: iconSelected ==
                                                    myCategoriesIcons[i]
                                                ? 3
                                                : 1,
                                            color: iconSelected ==
                                                    myCategoriesIcons[i]
                                                ? Colors.green
                                                : Colors.grey,
                                          ),
                                          image: DecorationImage(
                                            image: AssetImage(
                                              'assets/${myCategoriesIcons[i]}.png',
                                            ),
                                            fit: BoxFit.scaleDown,
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            )
                          : Container(),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _categoryColorController,
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (ctx2) {
                              return AlertDialog(
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    ColorPicker(
                                      pickerColor: Colors.white,
                                      onColorChanged: (value) {
                                        setState(() {
                                          categoryColor = value;
                                        });
                                      },
                                    ),
                                    SizedBox(
                                      width: double.infinity,
                                      height: 50,
                                      child: TextButton(
                                        onPressed: () {
                                          Navigator.pop(ctx2);
                                        },
                                        style: TextButton.styleFrom(
                                          backgroundColor: Colors.black,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                        ),
                                        child: const Text(
                                          'Ok',
                                          style: TextStyle(
                                              fontSize: 22,
                                              color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        },
                        readOnly: true,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: categoryColor,
                          hintText: 'Color',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        height: kToolbarHeight,
                        child: isLoading
                            ? const Center(child: CircularProgressIndicator())
                            : TextButton(
                                onPressed: () {
                                  if (_validateFields()) {
                                    setState(() {
                                      category.categoryId = const Uuid().v1();
                                      category.name =
                                          _categoryNameController.text;
                                      category.icon = iconSelected;
                                      category.color = categoryColor.value;
                                      isLoading = true;
                                      final user =
                                          FirebaseAuth.instance.currentUser;
                                      final MyUser currentUser = MyUser(
                                          id: user!.uid,
                                          email: user.email ?? '',
                                          name: user.displayName ?? '');
                                      category.user = currentUser;
                                    });

                                    context
                                        .read<CategoryBloc>()
                                        .add(CreateCategory(category));
                                    Navigator.pop(ctx);
                                  } else {
                                    showDialog(
                                        context: context,
                                        barrierDismissible: false,
                                        builder: (ctx3) => AlertDialog(
                                              content: SizedBox(
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    const SizedBox(
                                                      height: 20,
                                                    ),
                                                    const Text(
                                                      'Enter all the details',
                                                      style: TextStyle(
                                                          fontSize: 20),
                                                    ),
                                                    const SizedBox(
                                                      height: 20,
                                                    ),
                                                    SizedBox(
                                                      width:
                                                          MediaQuery.of(context)
                                                              .size
                                                              .width,
                                                      child: ElevatedButton(
                                                          style: TextButton
                                                              .styleFrom(
                                                            backgroundColor:
                                                                Colors.black,
                                                            shape:
                                                                RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          12),
                                                            ),
                                                          ),
                                                          onPressed: () {
                                                            Navigator.pop(ctx3);
                                                          },
                                                          child: const Text(
                                                            'Ok',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 18),
                                                          )),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ));
                                  }
                                },
                                style: TextButton.styleFrom(
                                  backgroundColor: Colors.black,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: const Text(
                                  'Save',
                                  style: TextStyle(
                                      fontSize: 22, color: Colors.white),
                                ),
                              ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
