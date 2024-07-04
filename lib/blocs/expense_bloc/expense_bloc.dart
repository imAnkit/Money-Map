import 'dart:async';

import 'package:expense_repository/expense_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:user_repository/user_repository.dart';

part 'expense_event.dart';
part 'expense_state.dart';

class ExpenseBloc extends Bloc<ExpenseEvent, ExpenseState> {
  final ExpenseRepository expenseRepository;
  // final UserRepository userRepository;

  ExpenseBloc(this.expenseRepository) : super(ExpenseInitial()) {
    on<LoadExpenses>(_onLoadExpenses);
    on<CreateExpense>(_onCreateExpense);
    on<ExpenseDeleted>(_onDeleteExpense);
  }

  void _onLoadExpenses(LoadExpenses event, Emitter<ExpenseState> emit) async {
    emit(ExpenseLoading());

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final currentUser = MyUser(
          id: user.uid,
          name: user.displayName ?? '',
          email: user.email ?? '',
        );
        final expenses = await expenseRepository.getExpense(currentUser);
        expenses.sort((a, b) => b.date.compareTo(a.date));

        final expense = expenses.fold<double>(0,
            (sum, expense) => sum + (expense.isExpense ? expense.amount : 0));
        final income = expenses.fold<double>(0,
            (sum, expense) => sum + (expense.isExpense ? 0 : expense.amount));

        final List<Expense> incomeList =
            await expenseRepository.getExpense(currentUser);

        emit(ExpenseLoaded(expenses, expense, income));
      } else {
        emit(ExpenseError('User not logged in'));
      }
    } catch (e) {
      print('Error loading expenses in bloc: $e'); // Debugging line
      emit(ExpenseError('Failed to load expenses'));
    }
  }

  void _onCreateExpense(CreateExpense event, Emitter<ExpenseState> emit) async {
    try {
      await expenseRepository.createExpense(event.expense);
      add(LoadExpenses());
    } catch (e) {
      print('Error adding expense in bloc: $e'); // Debugging line
      emit(ExpenseError('Failed to add expense'));
    }
  }

  FutureOr<void> _onDeleteExpense(
      ExpenseDeleted event, Emitter<ExpenseState> emit) async {
    try {
      await expenseRepository.deleteExpense(event.expenseId);
      add(LoadExpenses());
    } catch (e) {
      print('Error deleting expense in bloc: $e'); // Debugging line
      emit(ExpenseError('Failed to delete expense'));
    }
  }
}
