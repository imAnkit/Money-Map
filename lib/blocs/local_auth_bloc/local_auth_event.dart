part of 'local_auth_bloc.dart';

abstract class LocalAuthEvent extends Equatable {
  const LocalAuthEvent();

  @override
  List<Object> get props => [];
}

class LocalAuthUpdateStatus extends LocalAuthEvent {}

class BiometricAuthentication extends LocalAuthEvent {}
