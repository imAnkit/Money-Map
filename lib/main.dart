import 'package:expense_tracker_project/app.dart';

import 'package:expense_tracker_project/firebase_options.dart';
import 'package:expense_tracker_project/simple_bloc_observer.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_repository/user_repository.dart';
import 'package:user_repository/src/local_auth_services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  Bloc.observer = SimpleBlocObserver();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  // await FirebaseAppCheck.instance
  //     .activate(androidProvider: AndroidProvider.playIntegrity);

  runApp(MyApp(FirebaseUserRepository()));
}
