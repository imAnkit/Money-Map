part of 'bills_bloc.dart';

sealed class BillsState extends Equatable {
  const BillsState();

  @override
  List<Object> get props => [];
}

class BillsInitial extends BillsState {}

class BillsLoading extends BillsState {}

class BillsLoaded extends BillsState {
  final List<Bills> bills;
  const BillsLoaded(this.bills);
  @override
  List<Object> get props => [bills];
}

class BillsFailure extends BillsState {
  final String message;
  const BillsFailure(this.message);
  @override
  List<Object> get props => [message];
}
