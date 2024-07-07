import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_repository/expense_repository.dart';
import 'package:user_repository/user_repository.dart';

class ExpenseEntity {
  String expenseId;
  String name;
  Category category;
  DateTime date;
  double amount;
  String userId;
  bool isExpense;
  String? note;

  ExpenseEntity(
      {required this.expenseId,
      required this.name,
      required this.category,
      required this.amount,
      required this.date,
      required this.userId,
      required this.isExpense,
      this.note});

  Map<String, dynamic> toDocument() {
    return {
      'expenseId': expenseId,
      'name': name,
      'category': category.toEntity().toDocument(),
      'date': date,
      'amount': amount,
      'userId': userId,
      'isExpense': isExpense,
      'note': note
    };
  }

  static ExpenseEntity fromDocument(
      Map<String, dynamic> doc, String id, MyUser user) {
    return ExpenseEntity(
        expenseId: id,
        name: doc['name'],
        category: Category.fromEntity(
            CategoryEntity.fromDocument(doc['category']), user),
        date: (doc['date'] as Timestamp).toDate(),
        amount: doc['amount'],
        userId: doc['userId'],
        isExpense: doc['isExpense'],
        note: doc['note']);
  }
}
