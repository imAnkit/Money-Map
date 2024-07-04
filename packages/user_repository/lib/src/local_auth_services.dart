import 'dart:developer';

import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BiometricAuth {
  final LocalAuthentication auth = LocalAuthentication();

  Future<bool> isBiometricAvailable() async {
    try {
      return await auth.canCheckBiometrics;
    } catch (e) {
      return false;
    }
  }

  Future<void> authenticate() async {
    bool isAuthenticated = false;

    bool canCheckBiometrics = await auth.canCheckBiometrics;
    if (canCheckBiometrics) {
      try {
        isAuthenticated = await auth.authenticate(
            localizedReason: 'Please authenticate to unlock the app',
            options: const AuthenticationOptions(
                biometricOnly: true, stickyAuth: true));
      } catch (e) {
        log('Biometric authentication failed: $e');
        throw Exception('Biometric authentication failed');
      }
    } else {
      throw Exception('Biometric authentication not available');
    }

    if (!isAuthenticated) {
      throw Exception('Biometric authentication failed or was canceled');
    }
  }

  Future<void> enableAppLock() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('app_lock', true);
  }

  Future<void> disableAppLock() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('app_lock', false);
  }

  Future<bool> isAppLockEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('app_lock') ?? false;
  }
}
