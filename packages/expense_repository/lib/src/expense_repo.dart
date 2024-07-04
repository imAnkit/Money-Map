import 'package:user_repository/user_repository.dart';

import '../expense_repository.dart';

abstract class ExpenseRepository {
  Future<void> createCategory(Category category);
  Future<List<Category>> getCategory(MyUser user);

  // Future<void> createExpense(Expense expense);

  // Future<List<Expense>> getExpense();

  Future<void> createExpense(Expense expense);

  // Future<List<Expense>> getExpense();
  Future<List<Expense>> getExpense(MyUser user);
  Future<void> deleteExpense(String expenseId);
}
