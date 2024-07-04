import 'package:user_repository/user_repository.dart';

import '../entities/category_entity.dart';

class Category {
  String categoryId;
  String name;
  // int totalExpenses;
  String icon;
  int color;
  MyUser user;

  Category(
      {required this.categoryId,
      required this.name,
      // required this.totalExpenses,
      required this.icon,
      required this.user,
      required this.color});
      
  static final empty = Category(
      categoryId: '',
      name: '',
      user: MyUser.empty,
      //totalExpenses: 0,
      icon: '',
      color: 0);

  CategoryEntity toEntity() {
    return CategoryEntity(
        categoryId: categoryId,
        name: name,
        userId: user.id,
        icon: icon,
        color: color);
  }

  static Category fromEntity(CategoryEntity entity, MyUser user) {
    return Category(
      categoryId: entity.categoryId,
      name: entity.name,
      // totalExpenses: entity.totalExpenses,
      icon: entity.icon,
      color: entity.color,
      user: user,
    );
  }
}
