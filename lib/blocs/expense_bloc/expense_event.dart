part of 'expense_bloc.dart';

abstract class ExpenseEvent extends Equatable {
  const ExpenseEvent();

  @override
  List<Object> get props => [];
}

class LoadExpenses extends ExpenseEvent {}

class CreateExpense extends ExpenseEvent {
  final Expense expense;

  const CreateExpense(this.expense);

  @override
  List<Object> get props => [expense];
}

class ExpenseDeleted extends ExpenseEvent {
  final String expenseId;

  const ExpenseDeleted(this.expenseId);
  @override
  List<Object> get props => [expenseId];
}
class EditExpense extends ExpenseEvent {
  final Expense expense;
  const EditExpense(this.expense);
  @override
  List<Object> get props => [expense];
}