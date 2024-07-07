import 'dart:convert';

import 'package:expense_repository/expense_repository.dart';
import 'package:flutter/material.dart';

import 'package:user_repository/user_repository.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:crypto/crypto.dart';

class Bills {
  String billId;
  String name;
  DateTime date;
  double amount;
  bool isPaid;
  bool remind;
  Category category;
  MyUser user;
  String frequency;

  int? daysBefore;
  String? note;
  TimeOfDay time;

  Bills(
      {required this.billId,
      required this.name,
      required this.isPaid,
      required this.frequency,
      required this.date,
      required this.amount,
      this.daysBefore,
      required this.remind,
      required this.category,
      required this.user,
      required this.time,
      this.note});

  static final empty = Bills(
      billId: '',
      name: '',
      frequency: '',
      remind: true,
      isPaid: false,
      date: DateTime.now(),
      amount: 0,
      daysBefore: 0,
      category: Category.empty,
      user: MyUser.empty,
      note: '',
      time: TimeOfDay.now());

  BillsEntity toEntity() {
    return BillsEntity(
        billId: billId,
        name: name,
        frequency: frequency,
        date: date,
        amount: amount,
        daysBefore: daysBefore,
        category: category,
        userId: user.id,
        note: note,
        isPaid: isPaid,
        remind: remind,
        time: time);
  }

  static Bills fromEntity(BillsEntity entity, MyUser user) {
    return Bills(
        billId: entity.billId,
        name: entity.name,
        frequency: entity.frequency,
        date: entity.date,
        amount: entity.amount,
        daysBefore: entity.daysBefore,
        category: entity.category,
        user: user,
        note: entity.note,
        isPaid: entity.isPaid,
        remind: entity.remind,
        time: entity.time);
  }

  void sceduleNotifications() {
    if (!remind) return;

    final scheduledDate =
        DateTime(date.year, date.month, date.day, time.hour, time.minute);
    final hash = sha1.convert(utf8.encode(billId)).toString();
    final notificationId = int.parse(hash.substring(0, 8), radix: 16);
    final validNotificationId = notificationId & 0x7FFFFFFF;

    AwesomeNotifications().createNotification(
        content: NotificationContent(
            id: validNotificationId,
            channelKey: 'basic_channel',
            title: 'Bill due reminder',
            body:
                'Your bill $name of amount ${amount.toStringAsFixed(2)} is due ',
            notificationLayout: NotificationLayout.Default),
        schedule: NotificationCalendar.fromDate(date: scheduledDate));
  }
}
