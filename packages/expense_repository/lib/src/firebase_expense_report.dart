import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:user_repository/user_repository.dart';

import '../expense_repository.dart';

class FirebaseExpenseReport implements ExpenseRepository {
  final categoryCollection =
      FirebaseFirestore.instance.collection('categories');
  final expenseCollection = FirebaseFirestore.instance.collection('expenses');
  // final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<void> createCategory(Category category) async {
    try {
      // await categoryCollection
      //     .doc(category.categoryId)
      //     .set(category.toEntity().toDocument());
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
      // return await categoryCollection.get().then((value) => value.docs
      //     .map(
      //         (e) => Category.fromEntity(CategoryEntity.fromDocument(e.data()),user))
      //     .toList());
      return snapshot.docs
          .map((doc) => Category.fromEntity(
              CategoryEntity.fromDocument(doc.data()), user))
          .toList();
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  // @override
  // Future<void> createExpense(Expense expense) async {
  //   try {
  //     String expenseId = expense.expenseId;
  //     expense = expense.copyWith(expenseId: expenseId);
  //     await expenseCollection
  //         .doc(expenseId)
  //         .set(expense.toEntity().toDocument());
  //   } catch (e) {
  //     log(e.toString());
  //     rethrow;
  //   }
  // }

  // @override
  // Future<List<Expense>> getExpense() async {
  //   try {
  //     return await expenseCollection.get().then((value) => value.docs
  //         .map((e) => Expense.fromEntity(ExpenseEntity.fromDocument(e.data())))
  //         .toList());
  //   } catch (e) {
  //     log(e.toString());
  //     rethrow;
  //   }
  // }

  @override
  // Future<List<Expense>> getExpense() async {
  //   try {
  //     final snapshot = await _firestore.collection('expenses').get();
  //     print('Fetched ${snapshot.docs.length} expenses'); // Debugging line
  //     return snapshot.docs
  //         .map((doc) => Expense.fromEntity(ExpenseEntity.fromDocument(doc.data() as Map<String, dynamic>, doc.id)))
  //         .toList();
  //   } catch (e) {
  //     print('Error fetching expenses: $e'); // Debugging line
  //     rethrow;
  //   }
  // }

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
      print('Error adding expense: $e'); // Debugging line
      rethrow;
    }
  }

  @override
  Future<void> deleteExpense(String expenseId) async {
    try {
      await expenseCollection.doc(expenseId).delete();
    } catch (e) {}
  }
}
