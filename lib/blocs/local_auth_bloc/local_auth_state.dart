part of 'local_auth_bloc.dart';

sealed class LocalAuthState extends Equatable {
  const LocalAuthState();

  @override
  List<Object> get props => [];
}

final class LocalAuthInitial extends LocalAuthState {}

class LocalAuthLoading extends LocalAuthState {}

class LocalAuthFailure extends LocalAuthState {
  final String message;
  const LocalAuthFailure({required this.message});
  @override
  List<Object> get props => [message];
}

class LocalAuthUpdated extends LocalAuthState {}

class BiometricAuthLoding extends LocalAuthState {}

class BiometricAuthSuccess extends LocalAuthState {
  // final String userId;
  // const BiometricAuthSuccess({required this.userId});
  // @override
  // List<Object> get props => [userId];
}

class BiometricAuthFailure extends LocalAuthState {
  final String message;
  const BiometricAuthFailure({required this.message});
  @override
  List<Object> get props => [message];
}
