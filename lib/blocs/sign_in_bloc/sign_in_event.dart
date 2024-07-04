part of 'sign_in_bloc.dart';

abstract class SignInEvent extends Equatable {
  const SignInEvent();

  @override
  List<Object> get props => [];
}

class SignInRequired extends SignInEvent {
  final String email;
  final String password;

  const SignInRequired(this.email, this.password);
}

class SignOutRequired extends SignInEvent {
  const SignOutRequired();
}

class PhoneSignInRequired extends SignInEvent {
  final String phoneNumber;

  const PhoneSignInRequired({required this.phoneNumber});

  @override
  List<Object> get props => [phoneNumber];
}

class PhoneSignInWithCredential extends SignInEvent {
  final String verificationId;
  final String smsCode;

  const PhoneSignInWithCredential({
    required this.verificationId,
    required this.smsCode,
  });

  @override
  List<Object> get props => [verificationId, smsCode];
}


class BiometricSignIn extends SignInEvent {}
