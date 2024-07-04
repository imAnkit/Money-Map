// import 'dart:async';
// import 'dart:developer';

// import 'package:bloc/bloc.dart';
// import 'package:equatable/equatable.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:meta/meta.dart';
// import 'package:user_repository/user_repository.dart';

// part 'sign_in_event.dart';
// part 'sign_in_state.dart';

// class SignInBloc extends Bloc<SignInEvent, SignInState> {
//   final UserRepository _userRepository;

//   SignInBloc({required UserRepository userRepository})
//       : _userRepository = userRepository,
//         super(SignInInitial()) {

//     on<SignInRequired>((event, emit) async {
//       emit(SignInProcess());
//       try {
//         await _userRepository.signIn(event.email, event.password);
//         emit(SignInSuccess());
//       } catch (e) {
//         log(e.toString());
//         emit(const SignInFailure());
//       }
//     });
//     on<SignOutRequired>((event, emit) async {
//       await _userRepository.logOut();
//     });

//     Future<void> _onPhoneSignInRequired(
//         PhoneSignInRequired event, Emitter<SignInState> emit) async {
//       try {
//         await _userRepository.verifyPhoneNumber(
//           phoneNumber: event.phoneNumber,
//           verificationCompleted: (PhoneAuthCredential credential) async {
//             await _userRepository.signInWithCredential(credential);
//             emit(SignInSuccess());
//           },
//           verificationFailed: (FirebaseAuthException e) {
//             emit(PhoneVerificationFailure(
//                 message: e.message ?? 'Unknown error'));
//           },
//           codeSent: (String verificationId, int? resendToken) {
//             emit(PhoneVerificationInProgress(verificationId: verificationId));
//           },
//           codeAutoRetrievalTimeout: (String verificationId) {},
//         );
//       } catch (e) {
//         log(e.toString());
//         emit(PhoneVerificationFailure(message: e.toString()));
//       }
//     }

//     Future<void> _onPhoneSignInWithCredential(
//         PhoneSignInWithCredential event, Emitter<SignInState> emit) async {
//       try {
//         final credential = PhoneAuthProvider.credential(
//             verificationId: event.verificationId, smsCode: event.smsCode);
//         await _userRepository.signInWithCredential(credential);
//         emit(SignInSuccess());
//       } catch (e) {
//         log(e.toString());
//         emit(PhoneVerificationFailure(message: e.toString()));
//       }
//     }
//   }
// }

import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:user_repository/user_repository.dart';

part 'sign_in_event.dart';
part 'sign_in_state.dart';

class SignInBloc extends Bloc<SignInEvent, SignInState> {
  final UserRepository _userRepository;

  SignInBloc({required UserRepository userRepository})
      : _userRepository = userRepository,
        super(SignInInitial()) {
    on<SignInRequired>(_onSignInRequired);
    on<SignOutRequired>(_onSignOutRequired);
    on<PhoneSignInRequired>(_onPhoneSignInRequired);
    on<PhoneSignInWithCredential>(_onPhoneSignInWithCredential);
    // on<BiometricSignIn>((event, emit) async {
    //   emit(SignInProcess());
    //   try {
    //     await _userRepository.biometricSignIn();
    //     emit(SignInSuccess());
    //   } catch (e) {
    //     log(e.toString());
    //     emit(SignInFailure(message: e.toString()));
    //   }
    // });
  }

  Future<void> _onSignInRequired(
      SignInRequired event, Emitter<SignInState> emit) async {
    emit(SignInProcess());
    try {
      await _userRepository.signIn(event.email, event.password);
      emit(SignInSuccess());
    } catch (e) {
      log('SignIn Error: $e');
      emit(SignInFailure(message: e.toString()));
    }
  }

  Future<void> _onSignOutRequired(
      SignOutRequired event, Emitter<SignInState> emit) async {
    await _userRepository.logOut();
  }

  Future<void> _onPhoneSignInRequired(
      PhoneSignInRequired event, Emitter<SignInState> emit) async {
    try {
      await _userRepository.verifyPhoneNumber(
        phoneNumber: event.phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          log('Verification Completed');
          await _userRepository.signInWithCredential(credential);
          emit(SignInSuccess());
        },
        verificationFailed: (FirebaseAuthException e) {
          log('Verification Failed: ${e.message}');
          emit(PhoneVerificationFailure(message: e.message ?? 'Unknown error'));
        },
        codeSent: (String verificationId, int? resendToken) {
          log('Code Sent: $verificationId');
          emit(PhoneVerificationInProgress(verificationId: verificationId));
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          log('Code Auto Retrieval Timeout: $verificationId');
        },
      );
    } catch (e) {
      log('PhoneSignIn Error: $e');
      emit(PhoneVerificationFailure(message: e.toString()));
    }
  }

  Future<void> _onPhoneSignInWithCredential(
      PhoneSignInWithCredential event, Emitter<SignInState> emit) async {
    try {
      final credential = PhoneAuthProvider.credential(
          verificationId: event.verificationId, smsCode: event.smsCode);
      await _userRepository.signInWithCredential(credential);
      emit(SignInSuccess());
    } catch (e) {
      log('PhoneSignInWithCredential Error: $e');
      emit(PhoneVerificationFailure(message: e.toString()));
    }
  }
}
