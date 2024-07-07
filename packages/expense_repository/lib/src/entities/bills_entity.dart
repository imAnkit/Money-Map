import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_repository/expense_repository.dart';
import 'package:expense_repository/src/models/category.dart';
import 'package:flutter/material.dart';
import 'package:user_repository/user_repository.dart';

class BillsEntity {
  String billId;
  String name;
  String frequency;
  DateTime date;
  double amount;
  int? daysBefore;
  bool isPaid;
  Category category;
  String? note;
  String userId;
  bool remind;
  TimeOfDay time;

  BillsEntity(
      {required this.billId,
      required this.name,
      required this.frequency,
      required this.date,
      required this.amount,
      this.daysBefore,
      required this.category,
      required this.userId,
      required this.isPaid,
      required this.remind,
      required this.time,
      this.note});

  Map<String, Object?> toDocument() {
    DateTime now = DateTime.now();
    DateTime combinedDateTime = DateTime(
      now.year,
      now.month,
      now.day,
      time.hour,
      time.minute,
    );
    return {
      'billId': billId,
      'name': name,
      'frequency': frequency,
      'date': date,
      'amount': amount,
      'daysBefore': daysBefore,
      'category': category.toEntity().toDocument(),
      'userId': userId,
      'note': note,
      'isPaid': isPaid,
      'remind': remind,
      'time': Timestamp.fromDate(combinedDateTime),
    };
  }

  static BillsEntity fromDocument(
      Map<String, dynamic> doc, MyUser user, String id) {
    Timestamp timeStamp = doc['time'] as Timestamp;
    TimeOfDay timeOfDay;

    DateTime dateTime = timeStamp.toDate();
    timeOfDay = TimeOfDay(hour: dateTime.hour, minute: dateTime.minute);

    return BillsEntity(
        billId: id,
        name: doc['name'],
        isPaid: doc['isPaid'],
        frequency: doc['frequency'],
        // time: doc['time'],
        time: timeOfDay,
        date: (doc['date'] as Timestamp).toDate(),
        amount: doc['amount'],
        daysBefore: doc['daysBefore'],
        category: Category.fromEntity(
            CategoryEntity.fromDocument(doc['category']), user),
        userId: doc['userId'],
        note: doc['note'],
        remind: doc['remind']);
  }
}
