part of 'category_bloc.dart';

sealed class CategoryEvent extends Equatable {
  const CategoryEvent();

  @override
  List<Object> get props => [];
}

class CreateCategory extends CategoryEvent {
  final Category category;
  const CreateCategory(this.category);
  @override
  List<Object> get props => [category];
}

class LoadCategory extends CategoryEvent {}
