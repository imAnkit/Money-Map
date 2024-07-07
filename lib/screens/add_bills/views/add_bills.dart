// import 'dart:ffi';
// import 'dart:math';

import 'package:expense_repository/expense_repository.dart';
import 'package:expense_tracker_project/blocs/bills_bloc/bills_bloc.dart';
import 'package:expense_tracker_project/blocs/category_bloc/category_bloc.dart';

import 'package:expense_tracker_project/screens/add_expens/views/category_creattion.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:user_repository/user_repository.dart';
import 'package:uuid/uuid.dart';

class AddBills extends StatefulWidget {
  const AddBills({super.key});

  @override
  State<AddBills> createState() => _AddBillsState();
}

class _AddBillsState extends State<AddBills>
    with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _expenseController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _daysBeforeController = TextEditingController();

  final TextEditingController _noteController = TextEditingController();
  bool isPaid = false;
  bool allFilled = true;
  bool toRemind = true;
  TimeOfDay _selectedTime = TimeOfDay.now();
  late Bills bill;
  bool isLoading = false;
  bool _isCategorySelected = false;
  String _selectedFrequency = '';
  int days = 0;

  bool categoryOpen = false;
  final List<String> _frequencies = [
    'Daily',
    'Weekly',
    'Monthly',
    'Yearly',
    'None'
  ];

  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;

  @override
  void dispose() {
    super.dispose();
    _dateController.dispose();
    _categoryController.dispose();
    _expenseController.dispose();
    _noteController.dispose();
    _nameController.dispose();
    _daysBeforeController.dispose();
  }

  void _refreshCategories() {
    context.read<CategoryBloc>().add(LoadCategory());
  }

  @override
  void initState() {
    super.initState();
    _selectedFrequency = 'Monthly';
    _dateController.text = DateFormat('dd/MM/yyyy').format(DateTime.now());
    bill = Bills.empty;
    bill.category = Category.empty;
    bill.billId = const Uuid().v1();
    _daysBeforeController.text = days.toString();

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
      _isCategorySelected = bill.category != Category.empty;
    });
  }

  void _toggleDropdown() {
    if (_overlayEntry == null) {
      _overlayEntry = _createOverlayEntry();
      Overlay.of(context).insert(_overlayEntry!);
    } else {
      _overlayEntry!.remove();
      _overlayEntry = null;
    }
  }

  OverlayEntry _createOverlayEntry() {
    RenderBox renderBox = context.findRenderObject() as RenderBox;
    Size size = renderBox.size;
    Offset offset = renderBox.localToGlobal(Offset.zero);

    return OverlayEntry(
      builder: (context) => Stack(
        children: [
          GestureDetector(
            onTap: () {
              _overlayEntry?.remove();
              _overlayEntry = null;
            },
            child: Container(
              color: Colors.transparent,
            ),
          ),
          Positioned(
            width: size.width,
            left: offset.dx,
            top: offset.dy + size.height,
            child: CompositedTransformFollower(
              link: _layerLink,
              showWhenUnlinked: false,
              offset: Offset(0.0, 5.0),
              child: Material(
                elevation: 16,
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListView(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    children: _frequencies.map((String value) {
                      return ListTile(
                        title: Text(value),
                        onTap: () {
                          setState(() {
                            _selectedFrequency = value;
                          });
                          _overlayEntry!.remove();
                          _overlayEntry = null;
                        },
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String formatTimeOfDay(TimeOfDay time) {
    final now = DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, time.hour, time.minute);
    final format = DateFormat.jm(); // Uses local time format (AM/PM)
    return format.format(dt);
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
            'Add Bill',
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
              key: _formKey,
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
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.7,
                              child: TextFormField(
                                controller: _expenseController,
                                keyboardType:
                                    const TextInputType.numberWithOptions(),
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
                          ],
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Align(
                          alignment: Alignment.topRight,
                          child: Column(
                            children: [
                              const Text('Paid'),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    isPaid = !isPaid;
                                    bill.isPaid = isPaid;
                                  });
                                },
                                child: Container(
                                  width: 30,
                                  height: 30,
                                  decoration: BoxDecoration(
                                    color: isPaid ? Colors.green : Colors.grey,
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color:
                                          isPaid ? Colors.green : Colors.grey,
                                      width: 2,
                                    ),
                                  ),
                                  child: isPaid
                                      ? const Icon(
                                          Icons.check_rounded,
                                          color: Colors.white,
                                          size: 23,
                                        )
                                      : null,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
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
                  const SizedBox(height: 10),
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
                            fillColor: bill.category == Category.empty
                                ? Colors.white
                                : Color(bill.category.color),
                            prefixIcon: bill.category == Category.empty
                                ? const Icon(
                                    FontAwesomeIcons.list,
                                    color: Colors.grey,
                                    size: 16,
                                  )
                                : Image.asset(
                                    'assets/${bill.category.icon}.png',
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
                                  bill.category = Category.empty;
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
                                                  bill.category =
                                                      state.categories[i];
                                                  _categoryController.text =
                                                      bill.category.name;

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
                    height: 10,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    // height: MediaQuery.of(context).size.width / 6.3,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15)),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10.0, vertical: 8),
                      child: CompositedTransformTarget(
                        link: _layerLink,
                        child: GestureDetector(
                          onTap: _toggleDropdown,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 12, vertical: 8),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Repeating',
                                  style: TextStyle(fontSize: 16),
                                ),
                                Row(
                                  children: [
                                    Text(
                                      _selectedFrequency,
                                      style: const TextStyle(
                                          color: Colors.deepPurple,
                                          fontSize: 16.0),
                                    ),
                                    const Icon(Icons.unfold_more,
                                        color: Colors.deepPurple),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          const Text('Remind'),
                          const SizedBox(
                            height: 6,
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                toRemind = !toRemind;
                                bill.remind = toRemind;
                              });
                            },
                            child: Container(
                              width: 30,
                              height: 30,
                              decoration: BoxDecoration(
                                color: toRemind ? Colors.blue : Colors.grey,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: toRemind ? Colors.blue : Colors.grey,
                                  width: 2,
                                ),
                              ),
                              child: toRemind
                                  ? const Icon(
                                      Icons.check_rounded,
                                      color: Colors.white,
                                      size: 23,
                                    )
                                  : null,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Text('Days Before'),
                          Container(
                            width: MediaQuery.of(context).size.width / 2,
                            height: MediaQuery.of(context).size.width / 11,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: Colors.white),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  width: 50,
                                  child: TextField(
                                    controller: _daysBeforeController,
                                    decoration: const InputDecoration(
                                      filled: true,
                                      fillColor: Colors.white,
                                      border: OutlineInputBorder(
                                        borderSide: BorderSide.none,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  child: Row(
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            days > 0 ? days-- : null;
                                            _daysBeforeController.text =
                                                days.toString();
                                          });
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.all(3.0),
                                          child: Container(
                                              width: 50,
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  12.5,
                                              decoration: BoxDecoration(
                                                  color: const Color.fromARGB(
                                                      255, 218, 218, 218),
                                                  borderRadius:
                                                      BorderRadius.circular(5)),
                                              child: Icon(Icons.remove)),
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          days++;
                                          _daysBeforeController.text =
                                              days.toString();
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.all(3.0),
                                          child: Container(
                                            width: 50,
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                12.5,
                                            decoration: BoxDecoration(
                                                color: const Color.fromARGB(
                                                    255, 218, 218, 218),
                                                borderRadius:
                                                    BorderRadius.circular(5)),
                                            child: Icon(Icons.add),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              'Time',
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.w400),
                            ),
                            SizedBox(height: 5),
                            GestureDetector(
                              onTap: () async {
                                TimeOfDay? picked = await showTimePicker(
                                  context: context,
                                  initialTime: _selectedTime,
                                );
                                if (picked != null && picked != _selectedTime) {
                                  setState(() {
                                    _selectedTime = picked;
                                  });
                                }
                              },
                              child: Container(
                                padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    border: Border.all(color: Colors.black12)),
                                child: Text(
                                  formatTimeOfDay(_selectedTime),
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    controller: _dateController,
                    readOnly: true,
                    onTap: () async {
                      DateTime? newDate = await showDatePicker(
                          initialDate: bill.date,
                          context: context,
                          firstDate: DateTime.utc(2024, 01, 01),
                          lastDate:
                              DateTime.now().add(const Duration(days: 365)));
                      if (newDate != null) {
                        setState(() {
                          _dateController.text =
                              DateFormat('dd/MM/yyyy').format(newDate);
                          bill.date = newDate;
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
                  const SizedBox(height: 15),
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
                    height: 15,
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
                                          bill.amount = double.parse(
                                              _expenseController.text);

                                          bill.name = _nameController.text;
                                          bill.user = currentUser;
                                          bill.frequency = _selectedFrequency;
                                          allFilled = true;
                                          bill.daysBefore = int.parse(
                                              _daysBeforeController.text);
                                          bill.note = _noteController.text;
                                          bill.time = _selectedTime;
                                        });
                                        bill.sceduleNotifications();

                                        context
                                            .read<BillsBloc>()
                                            .add(CreateBill(bill));
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
  }
}
