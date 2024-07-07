import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:expense_repository/expense_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:user_repository/user_repository.dart';

part 'category_event.dart';
part 'category_state.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  final ExpenseRepository expenseRepository;
  CategoryBloc(this.expenseRepository) : super(CategoryInitial()) {
    on<LoadCategory>(_onLoadCategory);
    on<CreateCategory>(_onCreateCategory);
    on<DeleteCategory>(_onDeleteCategory);
  }

  Future<void> _onLoadCategory(
      LoadCategory event, Emitter<CategoryState> emit) async {
    emit(CategoryLoading());
    try {
      final user = FirebaseAuth.instance.currentUser;
      final MyUser currentUser = MyUser(
          id: user!.uid, email: user.email ?? '', name: user.displayName ?? '');
      final categories = await expenseRepository.getCategory(currentUser);
      emit(CategoryLoaded(categories));
    } catch (e) {
      print('Error loading categories in bloc: $e');
      emit(CategoryError('Failed to load Categories'));
    }
  }

  Future<void> _onCreateCategory(
      CreateCategory event, Emitter<CategoryState> emit) async {
    try {
      await expenseRepository.createCategory(event.category);
      add(LoadCategory());
    } catch (e) {
      print('Error adding category in bloc: $e');
      emit(CategoryError('Failed to add category'));
    }
  }

  FutureOr<void> _onDeleteCategory(
      DeleteCategory event, Emitter<CategoryState> emit) async {
    try {
      await expenseRepository.deleteCategory(event.categoryId);
      add(LoadCategory());
    } catch (e) {
      emit(CategoryError(e.toString()));
    }
  }
}
