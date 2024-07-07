import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:expense_repository/expense_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:user_repository/user_repository.dart';

part 'bills_event.dart';
part 'bills_state.dart';

class BillsBloc extends Bloc<BillsEvent, BillsState> {
  final ExpenseRepository expenseRepository;
  BillsBloc(this.expenseRepository) : super(BillsInitial()) {
    on<LoadBills>(_onLoadBills);
    on<CreateBill>(_onCreateBill);
    on<DeleteBill>(_onDeleteBill);
    on<UpdatePaidStatus>(_onbillPaid);
    on<EditBill>(_onEditBill);
  }

  FutureOr<void> _onLoadBills(LoadBills event, Emitter<BillsState> emit) async {
    emit(BillsLoading());
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final currentUser = MyUser(
            id: user.uid,
            email: user.email ?? '',
            name: user.displayName ?? '');
        final bills = await expenseRepository.getBillsAll(currentUser);
        // bills.sort((a, b) => b.date.compareTo(a.date));
        emit(BillsLoaded(bills));
      }
    } catch (e) {
      emit(BillsFailure(e.toString()));
    }
  }

  FutureOr<void> _onCreateBill(
      CreateBill event, Emitter<BillsState> emit) async {
    // emit(BillsLoading());
    try {
      await expenseRepository.createBills(event.bill);
      add(LoadBills());
    } catch (e) {
      emit(BillsFailure(e.toString()));
    }
  }

  FutureOr<void> _onDeleteBill(
      DeleteBill event, Emitter<BillsState> emit) async {
    emit(BillsLoading());
    try {
      await expenseRepository.deleteBill(event.billId);
      add(LoadBills());
    } catch (e) {
      emit(BillsFailure(e.toString()));
    }
  }

  FutureOr<void> _onbillPaid(
      UpdatePaidStatus event, Emitter<BillsState> emit) async {
    try {
      final bill = event.bill;
      bill.isPaid = !bill.isPaid;
      await expenseRepository.editBill(bill);
      add(LoadBills());
    } catch (e) {
      emit(BillsFailure(e.toString()));
    }
  }

  FutureOr<void> _onEditBill(EditBill event, Emitter<BillsState> emit) async {
    try {
      await expenseRepository.editBill(event.bill);
      add(LoadBills());
    } catch (e) {
      emit(BillsFailure(e.toString()));
    }
  }
}
