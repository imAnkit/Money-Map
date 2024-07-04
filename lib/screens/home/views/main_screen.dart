import 'dart:math';

import 'package:expense_repository/expense_repository.dart';
import 'package:expense_tracker_project/blocs/authentication_bloc/authentication_bloc.dart';
import 'package:expense_tracker_project/blocs/expense_bloc/expense_bloc.dart';
import 'package:expense_tracker_project/blocs/local_auth_bloc/local_auth_bloc.dart';

import 'package:expense_tracker_project/blocs/sign_in_bloc/sign_in_bloc.dart';

import 'package:expense_tracker_project/screens/home/views/options_screen.dart';
import 'package:expense_tracker_project/screens/stats/stats.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:pinput/pinput.dart';
import 'package:user_repository/user_repository.dart';

import '../../../blocs/my_user_bloc/my_user_bloc.dart';
import '../../../blocs/update_user_info_bloc/update_user_info_bloc.dart';

class MainScreen extends StatefulWidget {
  MyUser? user;

  MainScreen(this.user, {super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late double totalExpense;
  @override
  void initState() {
    super.initState();
    BlocProvider.of<ExpenseBloc>(context).add(LoadExpenses());
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<UpdateUserInfoBloc, UpdateUserInfoState>(
          listener: (context, state) {
            if (state is UploadPictureSuccess) {
              setState(() {
                context.read<MyUserBloc>().state.user!.picture =
                    state.userImage;
              });
            }
          },
        ),
      ],
      child: BlocBuilder<ExpenseBloc, ExpenseState>(
        builder: (context, state) {
          if (state is ExpenseLoading) {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          } else if (state is ExpenseLoaded) {
            return SafeArea(
              child: Padding(
                padding:
                    const EdgeInsets.only(left: 20.0, right: 20.0, top: 20.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () async {
                                final ImagePicker picker = ImagePicker();
                                final XFile? image = await picker.pickImage(
                                    source: ImageSource.gallery,
                                    maxHeight: 500,
                                    maxWidth: 500,
                                    imageQuality: 40);
                                if (image != null) {
                                  CroppedFile? croppedFile =
                                      await ImageCropper().cropImage(
                                    sourcePath: image.path,
                                    aspectRatio: const CropAspectRatio(
                                        ratioX: 1, ratioY: 1),
                                    uiSettings: [
                                      AndroidUiSettings(
                                          toolbarTitle: 'Cropper',
                                          aspectRatioPresets: [
                                            CropAspectRatioPreset.square
                                          ],
                                          toolbarColor: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                          toolbarWidgetColor: Colors.white,
                                          initAspectRatio:
                                              CropAspectRatioPreset.original,
                                          lockAspectRatio: false),
                                      IOSUiSettings(
                                        title: 'Cropper',
                                      ),
                                    ],
                                  );
                                  if (croppedFile != null) {
                                    setState(() {
                                      context.read<UpdateUserInfoBloc>().add(
                                          UploadPicture(
                                              croppedFile.path,
                                              context
                                                  .read<MyUserBloc>()
                                                  .state
                                                  .user!
                                                  .id));
                                    });
                                  }
                                }
                              },
                              child: Container(
                                width: 50,
                                height: 50,
                                child: widget.user!.picture == ""
                                    ? Container(
                                        width: 50,
                                        height: 50,
                                        decoration: BoxDecoration(
                                            color: Colors.grey.shade300,
                                            shape: BoxShape.circle),
                                        child: Icon(CupertinoIcons.person,
                                            color: Colors.grey.shade400),
                                      )
                                    : Container(
                                        width: 50,
                                        height: 50,
                                        decoration: BoxDecoration(
                                            color: Colors.grey,
                                            shape: BoxShape.circle,
                                            image: DecorationImage(
                                                image: NetworkImage(
                                                  widget.user!.picture!,
                                                ),
                                                fit: BoxFit.cover)),
                                      ),
                              ),
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Welcome!",
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .outline),
                                ),
                                Text(
                                  widget.user!.name,
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onBackground),
                                )
                              ],
                            )
                          ],
                        ),
                        IconButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => MultiBlocProvider(
                                      providers: [
                                        BlocProvider(
                                          create: (context) => SignInBloc(
                                            userRepository: context
                                                .read<AuthenticationBloc>()
                                                .userRepository,
                                          ),
                                        ),
                                        BlocProvider(
                                          create: (context) => MyUserBloc(
                                              myUserRepository: context
                                                  .read<AuthenticationBloc>()
                                                  .userRepository)
                                            ..add(GetMyUser(
                                                myUserId: context
                                                    .read<AuthenticationBloc>()
                                                    .state
                                                    .user!
                                                    .uid)),
                                        ),
                                      ],
                                      child: const OptionsScreen(),
                                    ),
                                  ));
                            },
                            icon: const Icon(CupertinoIcons.settings))
                      ],
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.width / 2,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                              blurRadius: 5,
                              color: Colors.grey.shade300,
                              offset: const Offset(5, 5))
                        ],
                        gradient: LinearGradient(colors: [
                          Theme.of(context).colorScheme.primary,
                          Theme.of(context).colorScheme.secondary,
                          Theme.of(context).colorScheme.tertiary,
                        ], transform: const GradientRotation(pi / 4)),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Total Balance',
                            style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                                fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          state.income - state.expense >= 0
                              ? Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text(
                                      '+',
                                      style: TextStyle(
                                          fontSize: 40,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const Icon(
                                      Icons.currency_rupee,
                                      size: 40,
                                      color: Colors.white,
                                    ),
                                    Text(
                                      '${state.income - state.expense}',
                                      style: const TextStyle(
                                          fontSize: 40,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                )
                              : Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text(
                                      '-',
                                      style: TextStyle(
                                          fontSize: 40,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const Icon(
                                      Icons.currency_rupee,
                                      size: 40,
                                      color: Colors.white,
                                    ),
                                    Text(
                                      '${-(state.income - state.expense)}',
                                      style: const TextStyle(
                                          fontSize: 40,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                          const SizedBox(
                            height: 12,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 12.0, horizontal: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      width: 25,
                                      height: 25,
                                      decoration: const BoxDecoration(
                                          color: Colors.white30,
                                          shape: BoxShape.circle),
                                      child: const Center(
                                          child: Icon(
                                        CupertinoIcons.arrow_down,
                                        color: Colors.greenAccent,
                                        size: 12,
                                      )),
                                    ),
                                    const SizedBox(
                                      width: 8,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          'Income',
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w400),
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            const Icon(
                                              Icons.currency_rupee,
                                              size: 14,
                                              color: Colors.white,
                                            ),
                                            Text(
                                              '${state.income}',
                                              style: const TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                                Row(
                                  children: [
                                    Container(
                                      width: 25,
                                      height: 25,
                                      decoration: const BoxDecoration(
                                          color: Colors.white30,
                                          shape: BoxShape.circle),
                                      child: const Center(
                                          child: Icon(
                                        CupertinoIcons.arrow_up,
                                        color: Color.fromARGB(255, 246, 18, 2),
                                        size: 12,
                                      )),
                                    ),
                                    const SizedBox(
                                      width: 8,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          'Expenses',
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w400),
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            const Icon(
                                              Icons.currency_rupee,
                                              size: 14,
                                              color: Colors.white,
                                            ),
                                            Text(
                                              '${state.expense}',
                                              style: const TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                      ],
                                    )
                                  ],
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Transactions',
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.onBackground,
                              fontWeight: FontWeight.bold,
                              fontSize: 16),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>const StatsScreeen()));
                          },
                          child: Text(
                            'See all',
                            style: TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.w400,
                                fontSize: 14),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Expanded(
                        child: ListView.builder(
                      itemCount: state.expenses.length,
                      itemBuilder: (context, index) {
                        final expense = state.expenses[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16.0),
                          child: GestureDetector(
                            onTap: () {
                              Slidable.of(context)?.close();
                            },
                            child: Slidable(
                              key: Key(expense.expenseId),
                              endActionPane: ActionPane(
                                  motion: const StretchMotion(),
                                  extentRatio: 0.3,
                                  children: [
                                    SlidableAction(
                                      onPressed: (context) {
                                        context.read<ExpenseBloc>().add(
                                            ExpenseDeleted(expense.expenseId));
                                      },
                                      icon: Icons.delete,
                                      backgroundColor: Colors.red,
                                      borderRadius: BorderRadius.circular(12),
                                    )
                                  ]),
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12)),
                                child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Stack(
                                            alignment: Alignment.center,
                                            children: [
                                              Container(
                                                width: 50,
                                                height: 50,
                                                decoration: BoxDecoration(
                                                    color: Color(
                                                        expense.category.color),
                                                    shape: BoxShape.circle),
                                              ),
                                              Image.asset(
                                                'assets/${expense.category.icon}.png',
                                                scale: 2,
                                                color: Colors.white,
                                              )
                                            ],
                                          ),
                                          const SizedBox(
                                            width: 12,
                                          ),
                                          Text(
                                            expense.category.name,
                                            style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .onBackground),
                                          ),
                                        ],
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Row(
                                            children: [
                                              expense.isExpense
                                                  ? const Text(
                                                      '-',
                                                      style: TextStyle(
                                                          color: Colors.red),
                                                    )
                                                  : const Text(
                                                      '+',
                                                      style: TextStyle(
                                                          color: Colors.green),
                                                    ),
                                              Icon(
                                                Icons.currency_rupee,
                                                size: 14,
                                                color: expense.isExpense
                                                    ? Colors.red
                                                    : Colors.green,
                                              ),
                                              Text(
                                                '${expense.amount}',
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w400,
                                                    color: expense.isExpense
                                                        ? Colors.red
                                                        : Colors.green),
                                              ),
                                            ],
                                          ),
                                          Text(
                                            DateFormat('dd/MM/yyyy')
                                                .format(expense.date),
                                            style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w400,
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .outline),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ))
                  ],
                ),
              ),
            );
          } else if (state is ExpenseError) {
            return Center(child: Text(state.message));
          } else {
            return const Center(child: Text('No expenses'));
          }
        },
      ),
    );
  }
}
