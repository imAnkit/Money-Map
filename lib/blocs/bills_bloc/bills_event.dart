part of 'bills_bloc.dart';

abstract class BillsEvent extends Equatable {
  const BillsEvent();

  @override
  List<Object> get props => [];
}

class LoadBills extends BillsEvent {}

class CreateBill extends BillsEvent {
  final Bills bill;
  const CreateBill(this.bill);
  @override
  List<Object> get props => [bill];
}

class DeleteBill extends BillsEvent {
  final String billId;
  const DeleteBill(this.billId);
  @override
  List<Object> get props => [billId];
}

class UpdatePaidStatus extends BillsEvent {
  final Bills bill;
  const UpdatePaidStatus(this.bill);
  @override
  List<Object> get props => [bill];
}

class EditBill extends BillsEvent {
  final Bills bill;
  const EditBill(this.bill);
  @override
  List<Object> get props => [bill];
}
