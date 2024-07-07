import 'package:expense_repository/expense_repository.dart';
import 'package:user_repository/user_repository.dart';

class Expense {
  String expenseId;
  Category category;
  DateTime date;
  double amount;
  MyUser user;
  String name;
  bool isExpense;
  String? note;

  Expense(
      {required this.expenseId,
      required this.category,
      required this.amount,
      required this.date,
      required this.name,
      required this.user,
      required this.isExpense,this.note});

  static final empty = Expense(
      expenseId: '',
      category: Category.empty,
      amount: 0,
      name: '',
      note: '',
      date: DateTime.now(),
      user: MyUser.empty,
      isExpense: true);

  Expense copyWith(
      {String? expenseId,
      Category? category,
      DateTime? date,
      double? amount,
      MyUser? user,
      bool? isExpense,
      String? name,
      String? note}) {
    return Expense(
        expenseId: expenseId ?? this.expenseId,
        category: category ?? this.category,
        date: date ?? this.date,
        amount: amount ?? this.amount,
        user: user ?? this.user,
        isExpense: isExpense ?? this.isExpense,
        name: name ?? this.name,
        note:note??this.note);
  }

  ExpenseEntity toEntity() {
    return ExpenseEntity(
        expenseId: expenseId,
        category: category,
        date: date,
        amount: amount,
        userId: user.id,
        isExpense: isExpense,
        name: name,
        note:note);
  }

  static Expense fromEntity(ExpenseEntity entity, MyUser user) {
    return Expense(
        expenseId: entity.expenseId,
        category: entity.category,
        date: entity.date,
        amount: entity.amount,
        user: user,
        isExpense: entity.isExpense,
        name: entity.name,
        note:entity.note);
  }
}
