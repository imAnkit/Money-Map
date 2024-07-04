// import 'package:cloud_firestore/cloud_firestore.dart';

// import '../../expense_repository.dart';

// class ExpenseEntity {
//   String expenseId;
//   Category category;
//   DateTime date;
//   double amount;
//   ExpenseEntity(
//       {required this.expenseId,
//       required this.category,
//       required this.amount,
//       required this.date});

//   Map<String, dynamic> toDocument() {
//     return {
//       'expenseId': expenseId,
//       'category': category.toEntity().toDocument(),
//       'date': date,
//       'amount': amount,
//     };
//   }

//   static ExpenseEntity fromDocument(
//     Map<String, dynamic> doc,
//   ) {
//     return ExpenseEntity(
//       expenseId: doc['expenseId'],
//       category:
//           Category.fromEntity(CategoryEntity.fromDocument(doc['category'])),
//       date: (doc['date'] as Timestamp).toDate(),
//       amount: doc['amount'],
//     );
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_repository/expense_repository.dart';
import 'package:user_repository/user_repository.dart';

// import '.dart';

class ExpenseEntity {
  String expenseId;
  Category category;
  DateTime date;
  double amount;
  String userId;
  bool isExpense;

  ExpenseEntity(
      {required this.expenseId,
      required this.category,
      required this.amount,
      required this.date,
      required this.userId,
      required this.isExpense});

  Map<String, dynamic> toDocument() {
    return {
      'expenseId': expenseId,
      'category': category.toEntity().toDocument(),
      'date': date,
      'amount': amount,
      'userId': userId,
      'isExpense': isExpense,
    };
  }

  static ExpenseEntity fromDocument(
      Map<String, dynamic> doc, String id, MyUser user) {
    return ExpenseEntity(
        expenseId: id,
        category: Category.fromEntity(
            CategoryEntity.fromDocument(doc['category']), user),
        date: (doc['date'] as Timestamp).toDate(),
        amount: doc['amount'],
        userId: doc['userId'],
        isExpense: doc['isExpense']);
  }
}
