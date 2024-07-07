import 'package:expense_repository/src/models/bill.dart';
import 'package:user_repository/user_repository.dart';

import '../expense_repository.dart';

abstract class ExpenseRepository {
  Future<void> createCategory(Category category);
  Future<List<Category>> getCategory(MyUser user);
  Future<void> deleteCategory(String categoryId);

  Future<void> createExpense(Expense expense);
  Future<List<Expense>> getExpense(MyUser user);
  Future<void> editExpense(Expense expense);
  Future<void> deleteExpense(String expenseId);

  Future<List<Bills>> getBillsAll(MyUser user);
  Future<void> createBills(Bills bills);
  Future<void> editBill(Bills bill);
  Future<void> deleteBill(String BillId);
}
