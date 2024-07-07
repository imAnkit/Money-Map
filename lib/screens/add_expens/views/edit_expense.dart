import 'package:expense_repository/expense_repository.dart';

import 'package:expense_tracker_project/blocs/category_bloc/category_bloc.dart';
import 'package:expense_tracker_project/blocs/expense_bloc/expense_bloc.dart';

import 'package:expense_tracker_project/screens/add_expens/views/category_creattion.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:user_repository/user_repository.dart';
import 'package:uuid/uuid.dart';

class EditexpensesScreen extends StatefulWidget {
  final Expense expense;
  const EditexpensesScreen({super.key, required this.expense});

  @override
  State<EditexpensesScreen> createState() => _EditexpensesScreenState();
}

class _EditexpensesScreenState extends State<EditexpensesScreen>
    with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> _newFormKey = GlobalKey<FormState>();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _newAmountController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  late TabController _tabController;
  final TextEditingController _noteController = TextEditingController();

  bool allFilled = true;

  late Expense newexpense;
  bool isLoading = false;
  bool _isCategorySelected = true;

  bool categoryOpen = false;

  @override
  void initState() {
    super.initState();

    // _selectedTime = widget.expense.remiderTime;

    _dateController.text = DateFormat('dd/MM/yyyy').format(widget.expense.date);
    newexpense = widget.expense;
    newexpense.category = widget.expense.category;
    newexpense.expenseId = widget.expense.expenseId;
    _tabController = TabController(length: 2, vsync: this);
    _categoryController.text = newexpense.category.name.toString();
    _newAmountController.text = newexpense.amount.toString();
    _noteController.text = newexpense.note.toString();
    _nameController.text = newexpense.name;
    newexpense.isExpense = widget.expense.isExpense;
    newexpense.isExpense ? _tabController.index = 1 : _tabController.index = 0;
    context.read<CategoryBloc>().add(LoadCategory());
    _tabController.addListener(() {
      setState(() {
        newexpense.isExpense = _tabController.index == 1;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    _dateController.dispose();
    _categoryController.dispose();
    _newAmountController.dispose();
    _noteController.dispose();
    _nameController.dispose();
  }

  void _refreshCategories() {
    context.read<CategoryBloc>().add(LoadCategory());
  }

  void _toggleCategoryDropdown() {
    setState(() {
      categoryOpen = !categoryOpen;
    });
  }

  // Function to close the dropdown
  void _closeCategoryDropdown() {
    setState(() {
      categoryOpen = false;
    });
  }

  void _validateCategory() {
    setState(() {
      _isCategorySelected = newexpense.category != Category.empty;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        _closeCategoryDropdown();
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        appBar: AppBar(
          leadingWidth: 60,
          toolbarHeight: 60,
          leading: Padding(
            padding: const EdgeInsets.only(left: 20.0, top: 8, bottom: 8),
            child: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: Container(
                    width: 30,
                    height: 30,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color.fromARGB(255, 212, 212, 212),
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.arrow_back,
                        size: 18,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          automaticallyImplyLeading: false,
          backgroundColor: Theme.of(context).colorScheme.background,
          centerTitle: true,
          title: const Text(
            'Edit expense',
            style: TextStyle(
              fontSize: 22,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.only(left: 16.0, right: 16, bottom: 10),
          child: SingleChildScrollView(
            child: Form(
              key: _newFormKey,
              onChanged: () {
                setState(() {});
                _validateCategory();
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 16),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 25, right: 10, bottom: 5),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.7,
                      child: TextFormField(
                        controller: _newAmountController,
                        keyboardType: const TextInputType.numberWithOptions(),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          prefixIcon: const Icon(
                            Icons.currency_rupee,
                            color: Colors.grey,
                            size: 22,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        // validator: (value) {
                        //   if (value == null || value.isEmpty) {
                        //     return 'Please enter an amount';
                        //   }
                        //   return null;
                        // },
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 17,
                  ),
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(100)),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8.0, vertical: 5),
                      child: TabBar(
                        indicatorSize: TabBarIndicatorSize.tab,
                        indicator: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            color: _tabController.index == 1
                                ? const Color.fromARGB(255, 232, 90, 90)
                                : const Color.fromARGB(255, 126, 207, 130)),
                        dividerColor: Colors.white,
                        controller: _tabController,
                        labelColor: Colors.white,
                        unselectedLabelColor: Colors.black,
                        tabs: const [
                          Tab(
                            child: Padding(
                              padding: EdgeInsets.all(12),
                              child: Text(
                                'Income',
                                style: TextStyle(fontSize: 18),
                              ),
                            ),
                          ),
                          Tab(
                            child: Padding(
                              padding: EdgeInsets.all(12),
                              child: Text(
                                'Expense',
                                style: TextStyle(fontSize: 18),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 17,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.85,
                    child: TextFormField(
                      maxLength: 15,
                      controller: _nameController,
                      decoration: InputDecoration(
                          hintText: 'Name',
                          hintStyle:
                              TextStyle(color: Colors.grey.withOpacity(0.5)),
                          filled: true,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none)),
                      // validator: (value) {
                      //   if (value == null || value.isEmpty) {
                      //     return 'Please enter a name';
                      //   }
                      //   return null;
                      // },
                    ),
                  ),
                  const SizedBox(
                    height: 17,
                  ),
                  Stack(
                    alignment: Alignment.centerRight,
                    children: [
                      TextFormField(
                        onTap: () {
                          _toggleCategoryDropdown();
                        },
                        controller: _categoryController,
                        readOnly: true,
                        decoration: InputDecoration(
                            filled: true,
                            fillColor: newexpense.category == Category.empty
                                ? Colors.white
                                : Color(newexpense.category.color),
                            prefixIcon: newexpense.category == Category.empty
                                ? const Icon(
                                    FontAwesomeIcons.list,
                                    color: Colors.grey,
                                    size: 16,
                                  )
                                : Image.asset(
                                    'assets/${newexpense.category.icon}.png',
                                    scale: 2,
                                  ),
                            hintText: 'Category',
                            border: const OutlineInputBorder(
                                borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(12)),
                                borderSide: BorderSide.none)),
                      ),
                      _isCategorySelected
                          ? IconButton(
                              onPressed: () {
                                setState(() {
                                  newexpense.category = Category.empty;
                                  _isCategorySelected = false;
                                });
                              },
                              icon: Icon(
                                Icons.close,
                                size: 16,
                                color: Colors.grey,
                              ))
                          : IconButton(
                              onPressed: () async {
                                await getCategoryCreation(
                                    context, _refreshCategories);
                              },
                              icon: const Icon(
                                FontAwesomeIcons.plus,
                                size: 16,
                                color: Colors.grey,
                              ),
                            ),
                    ],
                  ),
                  categoryOpen
                      ? Container(
                          height: 200,
                          width: MediaQuery.of(context).size.width,
                          decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.vertical(
                                  bottom: Radius.circular(12))),
                          child: BlocBuilder<CategoryBloc, CategoryState>(
                            builder: (context, state) {
                              if (state is CategoryLoaded) {
                                // final categories = state.categories;
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ListView.builder(
                                      itemCount: state.categories.length,
                                      itemBuilder: (context, int i) {
                                        return Stack(
                                          alignment: Alignment.centerRight,
                                          children: [
                                            Card(
                                                child: ListTile(
                                              onTap: () {
                                                setState(() {
                                                  newexpense.category =
                                                      state.categories[i];
                                                  _categoryController.text =
                                                      newexpense.category.name;

                                                  categoryOpen = false;
                                                  _validateCategory();
                                                });
                                              },
                                              leading: Image.asset(
                                                'assets/${state.categories[i].icon}.png',
                                                scale: 2,
                                              ),
                                              title: Text(
                                                  state.categories[i].name),
                                              tileColor: Color(
                                                  state.categories[i].color),
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(8)),
                                            )),
                                            IconButton(
                                              onPressed: () {
                                                context
                                                    .read<CategoryBloc>()
                                                    .add(DeleteCategory(state
                                                        .categories[i]
                                                        .categoryId));
                                              },
                                              icon: Icon(
                                                Icons.delete,
                                                color: Colors.grey,
                                                size: 20,
                                              ),
                                            )
                                          ],
                                        );
                                      }),
                                );
                              } else if (state is CategoryLoading) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              } else {
                                return const Center(
                                  child: Text('Failed to load categories'),
                                );
                              }
                            },
                          ),
                        )
                      : Container(),
                  const SizedBox(
                    height: 17,
                  ),
                  TextFormField(
                    controller: _dateController,
                    readOnly: true,
                    onTap: () async {
                      DateTime? newDate = await showDatePicker(
                          initialDate: newexpense.date,
                          context: context,
                          firstDate: DateTime.utc(2024, 01, 01),
                          lastDate:
                              DateTime.now().add(const Duration(days: 365)));
                      if (newDate != null) {
                        setState(() {
                          _dateController.text =
                              DateFormat('dd/MM/yyyy').format(newDate);
                          newexpense.date = newDate;
                        });
                      }
                    },
                    decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        prefixIcon: const Icon(
                          FontAwesomeIcons.calendar,
                          color: Colors.grey,
                          size: 16,
                        ),
                        hintText: 'Date',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none)),
                    validator: (value) {
                      if (_dateController.text.isEmpty) {
                        return 'Please select a date';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 17,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.85,
                    child: TextFormField(
                      maxLines: 5,
                      controller: _noteController,
                      decoration: InputDecoration(
                          hintText: 'Note',
                          hintStyle:
                              TextStyle(color: Colors.grey.withOpacity(0.5)),
                          filled: true,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none)),
                      // validator: (value) {
                      //   if (value == null || value.isEmpty) {
                      //     return 'Please enter a name';
                      //   }
                      //   return null;
                      // },
                    ),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        gradient: LinearGradient(colors: [
                          Theme.of(context).colorScheme.primary,
                          Theme.of(context).colorScheme.secondary,
                          Theme.of(context).colorScheme.tertiary,
                        ], transform: const GradientRotation(3.14 / 4)),
                      ),
                      width: double.infinity,
                      height: kToolbarHeight,
                      child: isLoading
                          ? const Center(child: CircularProgressIndicator())
                          : TextButton(
                              onPressed: _newFormKey.currentState?.validate() ==
                                          true &&
                                      _isCategorySelected
                                  ? () {
                                      final user =
                                          FirebaseAuth.instance.currentUser;
                                      if (user != null) {
                                        final currentUser = MyUser(
                                            id: user.uid,
                                            email: user.email ?? '',
                                            name: user.displayName ?? '');

                                        setState(() {
                                          newexpense.amount = double.parse(
                                              _newAmountController.text);

                                          newexpense.name =
                                              _nameController.text;
                                          newexpense.user = currentUser;

                                          allFilled = true;

                                          newexpense.note =
                                              _noteController.text;
                                        });
                                        context
                                            .read<ExpenseBloc>()
                                            .add(EditExpense(newexpense));
                                        Navigator.pop(context);
                                      }
                                    }
                                  : () {
                                      setState(() {
                                        allFilled = false;
                                      });
                                    },
                              child: const Text(
                                'Save',
                                style: TextStyle(
                                    fontSize: 22, color: Colors.white),
                              ))),
                  allFilled
                      ? Text('')
                      : Text(
                          'Fill all the required Fields',
                          style: TextStyle(
                              color: Colors.red, fontWeight: FontWeight.bold),
                        )
                ],
              ),
            ),
          ),
        ),
      ),
    );
    ;
  }
}
