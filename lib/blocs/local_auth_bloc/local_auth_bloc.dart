import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:local_auth/local_auth.dart';
import 'package:user_repository/src/local_auth_services.dart';
import 'package:user_repository/user_repository.dart';

part 'local_auth_event.dart';
part 'local_auth_state.dart';

class LocalAuthBloc extends Bloc<LocalAuthEvent, LocalAuthState> {
  final BiometricAuth _biometricAuth = BiometricAuth();
  final UserRepository _userRepository;
  final localAuth = LocalAuthentication();
  LocalAuthBloc({required UserRepository userRepository})
      : _userRepository = userRepository,
        super(LocalAuthInitial()) {
    on<LocalAuthUpdateStatus>(_updateLocalAuthStatus);
    on<BiometricAuthentication>(_biometricAuthentication);
  }

  FutureOr<void> _updateLocalAuthStatus(
      LocalAuthUpdateStatus event, Emitter<LocalAuthState> emit) async {
    emit(LocalAuthLoading());
    try {
      bool isEnabled = await _biometricAuth.isAppLockEnabled();
      if (isEnabled) {
        await _biometricAuth.disableAppLock();
        emit(LocalAuthUpdated());
      } else {
        bool canCheckBiometrices = await _biometricAuth.isBiometricAvailable();
        if (canCheckBiometrices) {
          bool isAuthenticated = await localAuth.authenticate(
              localizedReason: 'Enable App lock',
              options: AuthenticationOptions(biometricOnly: true));
          if (isAuthenticated) {
            await _biometricAuth.enableAppLock();
            emit(LocalAuthUpdated());
          }
        }
      }
    } catch (e) {
      emit(LocalAuthFailure(message: e.toString()));
    }
  }

  FutureOr<void> _biometricAuthentication(
      BiometricAuthentication event, Emitter<LocalAuthState> emit) async {
    emit(BiometricAuthLoding());
    try {
      await _biometricAuth.authenticate();

      emit(BiometricAuthSuccess());
    } catch (e) {
      emit(BiometricAuthFailure(message: e.toString()));
    }
  }
}
