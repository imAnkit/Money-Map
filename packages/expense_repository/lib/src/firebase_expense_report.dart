import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_repository/src/entities/bills_entity.dart';
import 'package:expense_repository/src/models/bill.dart';
import 'package:user_repository/user_repository.dart';

import '../expense_repository.dart';

class FirebaseExpenseReport implements ExpenseRepository {
  final categoryCollection =
      FirebaseFirestore.instance.collection('categories');
  final expenseCollection = FirebaseFirestore.instance.collection('expenses');
  final billsCollection = FirebaseFirestore.instance.collection('bills');

  @override
  Future<void> createCategory(Category category) async {
    try {
      await categoryCollection.add(category.toEntity().toDocument());
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  Future<List<Category>> getCategory(MyUser user) async {
    try {
      final snapshot =
          await categoryCollection.where('userId', isEqualTo: user.id).get();

      return snapshot.docs
          .map((doc) => Category.fromEntity(
              CategoryEntity.fromDocument(doc.data()), user))
          .toList();
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  Future<void> deleteCategory(String categoryId) async {
    try {
      await categoryCollection.doc(categoryId).delete();
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  Future<List<Expense>> getExpense(MyUser user) async {
    final snapshot =
        await expenseCollection.where('userId', isEqualTo: user.id).get();
    return snapshot.docs
        .map((doc) => Expense.fromEntity(
            ExpenseEntity.fromDocument(doc.data(), doc.id, user), user))
        .toList();
  }

  @override
  Future<void> createExpense(Expense expense) async {
    try {
      await expenseCollection.add(expense.toEntity().toDocument());
      print(
          'Expense added: ${expense.toEntity().toDocument()}'); // Debugging line
    } catch (e) {
      log(e.toString()); // Debugging line
      rethrow;
    }
  }
   @override
  Future<void> editExpense(Expense expense) async {
    try {
      await expenseCollection.doc(expense.expenseId).set(expense.toEntity().toDocument());
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  Future<void> deleteExpense(String expenseId) async {
    try {
      await expenseCollection.doc(expenseId).delete();
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  Future<List<Bills>> getBillsAll(MyUser user) async {
    try {
      final snapshot =
          await billsCollection.where('userId', isEqualTo: user.id).get();
      return snapshot.docs
          .map((doc) => Bills.fromEntity(
              BillsEntity.fromDocument(doc.data(), user, doc.id), user))
          .toList();
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  Future<void> createBills(Bills bill) async {
    try {
      await billsCollection.add(bill.toEntity().toDocument());
      print('bill added: ${bill.toEntity().toDocument()}');
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  Future<void> editBill(Bills bill) async {
    try {
      await billsCollection.doc(bill.billId).set(bill.toEntity().toDocument());
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  Future<void> deleteBill(String billId) async {
    try {
      await billsCollection.doc(billId).delete();
      print('bill deleted: ${billId}');
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }
}
