part of 'sign_in_bloc.dart';

@immutable
abstract class SignInState extends Equatable {
  const SignInState();

  @override
  List<Object> get props => [];
}

class SignInInitial extends SignInState {}

class SignInSuccess extends SignInState {}

class SignInFailure extends SignInState {
  final String? message;

  const SignInFailure({this.message});
}

class SignInProcess extends SignInState {}

class PhoneVerificationInProgress extends SignInState {
  final String verificationId;

  const PhoneVerificationInProgress({required this.verificationId});

  @override
  List<Object> get props => [verificationId];
}

class PhoneVerificationFailure extends SignInState {
  final String message;

  const PhoneVerificationFailure({this.message = 'Phone Verification Failed'});

  @override
  List<Object> get props => [message];
}

class PhoneCodeSentState extends SignInState {
  final String verificationId;

  const PhoneCodeSentState({required this.verificationId});

  @override
  List<Object> get props => [verificationId];
}
