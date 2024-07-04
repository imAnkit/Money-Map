import 'dart:math';

import 'package:expense_repository/expense_repository.dart';
import 'package:expense_tracker_project/blocs/authentication_bloc/authentication_bloc.dart';

import 'package:expense_tracker_project/blocs/category_bloc/category_bloc.dart';

import 'package:expense_tracker_project/blocs/expense_bloc/expense_bloc.dart';
import 'package:expense_tracker_project/blocs/local_auth_bloc/local_auth_bloc.dart';

import 'package:expense_tracker_project/screens/add_expens/views/add_expense.dart';
import 'package:expense_tracker_project/screens/home/views/bill_screen.dart';
import 'package:expense_tracker_project/screens/home/views/main_screen.dart';

import 'package:expense_tracker_project/screens/stats/stats.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_repository/user_repository.dart';

import '../../../blocs/my_user_bloc/my_user_bloc.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  final Color selectedColor = const Color(0xFF00B2e7);
  final Color unselectedColor = Colors.grey;
  Expense? newExpense = Expense.empty;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MyUserBloc, MyUserState>(
      builder: (context, userState) {
        if (userState.status == MyUserStatus.success) {
          return Scaffold(
            bottomNavigationBar: _buildBottomAppBar(),
            floatingActionButton: _buildFloatingActionButton(),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
            body: _currentIndex == 0
                ? MainScreen(userState.user)
                : const BillScreen(),
          );
        } else {
          return const Scaffold(
            body: Center(
                child: CircularProgressIndicator(
              color: Colors.amber,
            )),
          );
        }
      },
    );
  }

  ClipRRect _buildBottomAppBar() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(30),
      child: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8.0,
        color: Colors.white,
        child: SizedBox(
          height: 60.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              IconButton(
                icon: const Icon(Icons.home),
                color: _currentIndex == 0 ? selectedColor : unselectedColor,
                onPressed: () {
                  setState(() {
                    _currentIndex = 0;
                  });
                },
              ),
              const SizedBox(width: 40), // The dummy child for spacing
              IconButton(
                icon: const Icon(CupertinoIcons.graph_circle_fill),
                color: _currentIndex == 1 ? selectedColor : unselectedColor,
                onPressed: () {
                  setState(() {
                    _currentIndex = 1;
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  FloatingActionButton _buildFloatingActionButton() {
    return FloatingActionButton(
      onPressed: () async {
        await Navigator.push(
          context,
          MaterialPageRoute<Expense>(
            builder: (context) => MultiBlocProvider(
              providers: [
                BlocProvider(
                  create: (context) => CategoryBloc(FirebaseExpenseReport()),
                ),
                BlocProvider(
                  create: (context) => ExpenseBloc(FirebaseExpenseReport()),
                ),
              ],
              child: AddExpense(),
            ),
          ),
        ).then((_) {
          context.read<ExpenseBloc>().add(LoadExpenses());
        });
      },
      shape: const CircleBorder(),
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            colors: [
              Theme.of(context).colorScheme.tertiary,
              Theme.of(context).colorScheme.secondary,
              Theme.of(context).colorScheme.primary,
            ],
            transform: const GradientRotation(pi / 4),
          ),
        ),
        child: const Icon(CupertinoIcons.add),
      ),
    );
  }
}
