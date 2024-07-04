import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../user_repository.dart';

abstract class UserRepository {
  Stream<User?> get user;

  Future<void> signIn(String email, String password);

  Future<void> logOut();

  Future<MyUser> signUp(MyUser myUser, String password);

  Future<void> resetPassword(String email);

  Future<void> setUserData(MyUser user);

  Future<MyUser> getMyUser(String myUserId);
  User? get currentUser;

  Future<String> uploadPicture(String file, String userId);
  // Future<void> signInWithPhone(BuildContext context, String phoneNumber);
  Future<void> verifyPhoneNumber({
    required String phoneNumber,
    required Function(PhoneAuthCredential) verificationCompleted,
    required Function(FirebaseAuthException) verificationFailed,
    required Function(String, int?) codeSent,
    required Function(String) codeAutoRetrievalTimeout,
  });
  Future<void> signInWithCredential(AuthCredential credential);
Future<bool> isAppLockEnabled();
  // Future<void> signInWithGoogle(BuildContext context);
}
