import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:expense_repository/expense_repository.dart';
import 'package:expense_tracker_project/blocs/authentication_bloc/authentication_bloc.dart';
import 'package:expense_tracker_project/blocs/bills_bloc/bills_bloc.dart';
import 'package:expense_tracker_project/blocs/category_bloc/category_bloc.dart';
import 'package:expense_tracker_project/blocs/expense_bloc/expense_bloc.dart';
import 'package:expense_tracker_project/blocs/local_auth_bloc/local_auth_bloc.dart';
import 'package:expense_tracker_project/blocs/my_user_bloc/my_user_bloc.dart';
import 'package:expense_tracker_project/blocs/sign_in_bloc/sign_in_bloc.dart';
import 'package:expense_tracker_project/blocs/update_user_info_bloc/update_user_info_bloc.dart';
import 'package:expense_tracker_project/notification_controller.dart';
import 'package:expense_tracker_project/screens/add_bills/views/bill_screen.dart';

import 'package:expense_tracker_project/screens/authentication/welcome_screen.dart';
import 'package:expense_tracker_project/screens/home/views/home_screen.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:local_auth/local_auth.dart';
import 'package:user_repository/user_repository.dart';

class AppView extends StatefulWidget {
  const AppView({super.key});

  @override
  State<AppView> createState() => _AppViewState();
}

class _AppViewState extends State<AppView> {
 @override
  void initState() {
    AwesomeNotifications().setListeners(
        onActionReceivedMethod: NotificationController.onActionReceivedMethod,
        onNotificationCreatedMethod:
            NotificationController.onNotificationCreateMethod,
        onNotificationDisplayedMethod:
            NotificationController.onNotificationDisplayMethod,
        onDismissActionReceivedMethod:
            NotificationController.onDismissActionReceivedMethod);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Money Map',
      theme: ThemeData(
          colorScheme: ColorScheme.light(
              background: Colors.grey.shade200,
              onBackground: Colors.black,
              primary: Color(0xFF00B2e7),
              secondary: Color(0xFFE064F7),
              tertiary: Color(0xFFFF8D6C),
              outline: Colors.grey)),
      routes: {
        '/billScreen': (context) =>
            BillScreen(), // Define the route for the second screen
      },
      home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (context, state) {
          if (state.status == AuthenticationStatus.authenticated) {
            return FutureBuilder<bool>(
                future: (context.read<AuthenticationBloc>().userRepository
                        as FirebaseUserRepository)
                    .isAppLockEnabled(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Container();
                  }
                  if (snapshot.data == true) {
                    return BiometricLockScreen(
                      onAuthenticated: () {
                        print('Navigate to Home Screen');
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                            builder: (_) => MultiBlocProvider(providers: [
                                  BlocProvider(
                                      create: (context) => BillsBloc(context
                                          .read<ExpenseBloc>()
                                          .expenseRepository)),
                                  BlocProvider(
                                    create: (context) => SignInBloc(
                                      userRepository: context
                                          .read<AuthenticationBloc>()
                                          .userRepository,
                                    ),
                                  ),
                                  BlocProvider(
                                    create: (context) => UpdateUserInfoBloc(
                                        userRepository: context
                                            .read<AuthenticationBloc>()
                                            .userRepository),
                                  ),
                                  BlocProvider(
                                    create: (context) => MyUserBloc(
                                        myUserRepository: context
                                            .read<AuthenticationBloc>()
                                            .userRepository)
                                      ..add(GetMyUser(
                                          myUserId: context
                                              .read<AuthenticationBloc>()
                                              .state
                                              .user!
                                              .uid)),
                                  ),
                                  BlocProvider(
                                      create: (context) => ExpenseBloc(
                                            FirebaseExpenseReport(),
                                          )),
                                  BlocProvider(
                                    create: (context) =>
                                        CategoryBloc(FirebaseExpenseReport()),
                                  ),
                                  BlocProvider(
                                    create: (context) => LocalAuthBloc(
                                        userRepository: context
                                            .read<AuthenticationBloc>()
                                            .userRepository),
                                  ),
                                ], child: const HomeScreen())));
                      },
                    );
                  } else {
                    return MultiBlocProvider(
                      providers: [
                        BlocProvider(
                            create: (context) => BillsBloc(
                                context.read<ExpenseBloc>().expenseRepository)),
                        BlocProvider(
                          create: (context) => SignInBloc(
                            userRepository: context
                                .read<AuthenticationBloc>()
                                .userRepository,
                          ),
                        ),
                        BlocProvider(
                          create: (context) => UpdateUserInfoBloc(
                              userRepository: context
                                  .read<AuthenticationBloc>()
                                  .userRepository),
                        ),
                        BlocProvider(
                          create: (context) => MyUserBloc(
                              myUserRepository: context
                                  .read<AuthenticationBloc>()
                                  .userRepository)
                            ..add(GetMyUser(
                                myUserId: context
                                    .read<AuthenticationBloc>()
                                    .state
                                    .user!
                                    .uid)),
                        ),
                        BlocProvider(
                            create: (context) => ExpenseBloc(
                                  FirebaseExpenseReport(),
                                )),
                        BlocProvider(
                          create: (context) =>
                              CategoryBloc(FirebaseExpenseReport()),
                        ),
                        BlocProvider(
                          create: (context) => LocalAuthBloc(
                              userRepository: context
                                  .read<AuthenticationBloc>()
                                  .userRepository),
                        ),
                      ],
                      child: const HomeScreen(),
                    );
                  }
                });
          } else {
            return const WelcomeScreen();
          }
        },
      ),
    );
  }
}

class BiometricLockScreen extends StatelessWidget {
  final VoidCallback onAuthenticated;

  const BiometricLockScreen({required this.onAuthenticated, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    _authenticate();

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
          Color.fromARGB(255, 131, 12, 3),
          // Color.fromARGB(255, 165, 105, 218),
          Color.fromARGB(255, 53, 2, 141)
        ])),
        child: Center(
          child: Icon(
            Icons.fingerprint,
            color: Colors.white,
            size: 40,
          ),
        ),
      ),
    );
  }

  Future<void> _authenticate() async {
    final localAuth = LocalAuthentication();
    bool isAuthenticated = await localAuth.authenticate(
      localizedReason: 'Authenticate to unlock the app',
      options: const AuthenticationOptions(biometricOnly: true),
    );

    if (isAuthenticated) {
      onAuthenticated();
    } else {
      SystemNavigator.pop();
    }
  }
}

// class BiometricLockScreen extends StatefulWidget {

//   const BiometricLockScreen(
//       {
//       super.key});

//   @override
//   State<BiometricLockScreen> createState() => _BiometricLockScreenState();
// }

// class _BiometricLockScreenState extends State<BiometricLockScreen> {
//   @override
//   void initState() {
//     super.initState();
//     context.read<LocalAuthBloc>().add(BiometricAuthentication());
//   }
//   @override
//   Widget build(BuildContext context) {
//     return BlocConsumer<LocalAuthBloc, LocalAuthState>(
//       listener: (context, state) {
//         // TODO: implement listener
//         if (state is BiometricAuthSuccess) {
//           Navigator.pushReplacement(
//               context,
//               MaterialPageRoute(
//                   builder: (context) => BlocProvider(
//                         create: (context) => MyUserBloc(
//                             myUserRepository: context
//                                 .read<AuthenticationBloc>()
//                                 .userRepository),
//                         child: HomeScreen(),
//                       )));
//         }
//       },
//       builder: (context, state) {
//         if (state is BiometricAuthLoding) {
//           return Container(
//             decoration: BoxDecoration(
//                 gradient: LinearGradient(colors: [
//               Color.fromARGB(255, 131, 12, 3),
//               // Color.fromARGB(255, 165, 105, 218),
//               Color.fromARGB(255, 53, 2, 141)
//             ])),
//             child: Center(
//               child: CircularProgressIndicator(
//                 color: Colors.blue,
//               ),
//             ),
//           );
//         } else if (state is BiometricAuthSuccess) {
//           return Container();
//         } else if (state is BiometricAuthFailure) {
//           return Center(
//             child: Text('Error : ${state.message}'),
//           );
//         } else {
//           return Container(
//             decoration: BoxDecoration(
//                 gradient: LinearGradient(colors: [
//               Color.fromARGB(255, 131, 12, 3),
//               // Color.fromARGB(255, 165, 105, 218),
//               Color.fromARGB(255, 53, 2, 141)
//             ])),
//             child: Center(
//               child: CircularProgressIndicator(
//                 color: Colors.blue,
//               ),
//             ),
//           );
//         }
//       },
//     );
//   }
// }
