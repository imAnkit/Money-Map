import 'dart:math';

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

class AddExpense extends StatefulWidget {
  const AddExpense({super.key});

  @override
  State<AddExpense> createState() => _AddExpenseState();
}

class _AddExpenseState extends State<AddExpense>
    with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _expenseController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  late TabController _tabController;
  late Expense expense;
  bool isLoading = false;
  bool allFilled = true;
  bool _isCategorySelected = true;

  @override
  void dispose() {
    super.dispose();
    _dateController.dispose();
    _categoryController.dispose();
    _expenseController.dispose();
    _tabController.dispose();
    _nameController.dispose();
  }

  void _refreshCategories() {
    context.read<CategoryBloc>().add(LoadCategory());
  }

  @override
  void initState() {
    super.initState();
    _dateController.text = DateFormat('dd/MM/yyyy').format(DateTime.now());
    expense = Expense.empty;
    expense.category = Category.empty;
    expense.expenseId = const Uuid().v1();
    _tabController = TabController(initialIndex: 1, length: 2, vsync: this);
    expense.isExpense = true;
    context.read<CategoryBloc>().add(LoadCategory());

    _tabController.addListener(() {
      setState(() {
        expense.isExpense = _tabController.index == 1;
      });
    });
  }

  void _validateCategory() {
    setState(() {
      _isCategorySelected = expense.category != Category.empty;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        floatingActionButton: Transform.scale(
          scale: 0.75,
          child: FloatingActionButton(
            elevation: 0,
            onPressed: () {
              Navigator.pop(context);
            },
            backgroundColor: Colors.white,
            child: Container(
              width: 30,
              height: 30,
              decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color.fromARGB(255, 183, 182, 182)),
              child: const Center(
                  child: Icon(
                Icons.arrow_back,
                size: 20,
              )),
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.miniStartTop,
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              onChanged: () {
                setState(() {});
                _validateCategory();
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 100),
                  const Text(
                    "Add Expenses",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.7,
                    child: TextFormField(
                      controller: _expenseController,
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
                  const SizedBox(
                    height: 15,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.85,
                    child: TextFormField(
                      controller: _nameController,
                      decoration: InputDecoration(
                          hintText: 'Name',
                          hintStyle:
                              TextStyle(color: Colors.grey.withOpacity(0.5)),
                          filled: true,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none)),
                    ),
                  ),
                  const SizedBox(height: 15),
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
                  const SizedBox(height: 15),
                  TextFormField(
                    controller: _categoryController,
                    readOnly: true,
                    decoration: InputDecoration(
                        filled: true,
                        fillColor: expense.category == Category.empty
                            ? Colors.white
                            : Color(expense.category.color),
                        prefixIcon: expense.category == Category.empty
                            ? const Icon(
                                FontAwesomeIcons.list,
                                color: Colors.grey,
                                size: 16,
                              )
                            : Image.asset(
                                'assets/${expense.category.icon}.png',
                                scale: 2,
                              ),
                        suffixIcon: IconButton(
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
                        hintText: 'Category',
                        border: const OutlineInputBorder(
                            borderRadius:
                                BorderRadius.vertical(top: Radius.circular(12)),
                            borderSide: BorderSide.none)),
                  ),
                  Container(
                    height: 200,
                    width: MediaQuery.of(context).size.width,
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                            BorderRadius.vertical(bottom: Radius.circular(12))),
                    child: BlocBuilder<CategoryBloc, CategoryState>(
                      builder: (context, state) {
                        if (state is CategoryLoaded) {
                          // final categories = state.categories;
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ListView.builder(
                                itemCount: state.categories.length,
                                itemBuilder: (context, int i) {
                                  return Card(
                                      child: ListTile(
                                    onTap: () {
                                      setState(() {
                                        expense.category = state.categories[i];
                                        _categoryController.text =
                                            expense.category.name;
                                        _validateCategory();
                                      });
                                    },
                                    leading: Image.asset(
                                      'assets/${state.categories[i].icon}.png',
                                      scale: 2,
                                    ),
                                    title: Text(state.categories[i].name),
                                    tileColor: Color(state.categories[i].color),
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8)),
                                  ));
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
                  ),
                  const SizedBox(height: 15),
                  TextFormField(
                    controller: _dateController,
                    readOnly: true,
                    onTap: () async {
                      DateTime? newDate = await showDatePicker(
                          initialDate: expense.date,
                          context: context,
                          firstDate: DateTime.utc(2024, 01, 01),
                          lastDate:
                              DateTime.now().add(const Duration(days: 365)));
                      if (newDate != null) {
                        setState(() {
                          _dateController.text =
                              DateFormat('dd/MM/yyyy').format(newDate);
                          expense.date = newDate;
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
                  const SizedBox(height: 32),
                  Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        gradient: LinearGradient(colors: [
                          Theme.of(context).colorScheme.primary,
                          Theme.of(context).colorScheme.secondary,
                          Theme.of(context).colorScheme.tertiary,
                        ], transform: const GradientRotation(pi / 4)),
                      ),
                      width: double.infinity,
                      height: kToolbarHeight,
                      child: isLoading
                          ? const Center(child: CircularProgressIndicator())
                          : TextButton(
                              onPressed: _formKey.currentState?.validate() ==
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
                                          expense.amount = double.parse(
                                              _expenseController.text);
                                          expense.user = currentUser;
                                          expense.name = _nameController.text;
                                          allFilled = true;
                                        });
                                        context
                                            .read<ExpenseBloc>()
                                            .add(CreateExpense(expense));
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
                              ),
                            )),
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
  }
}
