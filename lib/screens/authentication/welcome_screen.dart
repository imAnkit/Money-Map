import 'package:expense_tracker_project/screens/authentication/phone_login_screen.dart';
import 'package:expense_tracker_project/screens/authentication/sign_in_screen.dart';
import 'package:expense_tracker_project/screens/authentication/sign_up_screen.dart';
import 'package:expense_tracker_project/screens/home/views/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/authentication_bloc/authentication_bloc.dart';
import '../../blocs/sign_in_bloc/sign_in_bloc.dart';
import '../../blocs/sign_up_bloc/sign_up_bloc.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 123, 9, 0),
              Color.fromARGB(255, 22, 1, 58)
            ],
            // begin: Alignment.topLeft,
            // end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              children: [
                const SizedBox(
                  height: 80,
                ),
                ClipOval(
                    child: SizedBox(
                  height: 100,
                  width: 100,
                  child: Image.asset(
                    'icon/icon.jpg',
                    fit: BoxFit.contain,
                  ),
                )),
                const Text(
                  'Expense Tracker',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ],
            ),
            Column(
              children: [
                const Text(
                  'Welcome Back',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => BlocProvider<SignInBloc>(
                                  create: (context) => SignInBloc(
                                      userRepository: context
                                          .read<AuthenticationBloc>()
                                          .userRepository),
                                  child: const SignInScreen(),
                                )));
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.8,
                    height: 60,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        border: Border.all(color: Colors.white)),
                    child: const Align(
                        alignment: Alignment.center,
                        child: Text(
                          'SIGN IN',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 25,
                              fontWeight: FontWeight.w500),
                        )),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => BlocProvider<SignUpBloc>(
                                  create: (context) => SignUpBloc(
                                      userRepository: context
                                          .read<AuthenticationBloc>()
                                          .userRepository),
                                  child: const SignUpScreen(),
                                )));
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.8,
                    height: 60,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: const Color.fromARGB(255, 234, 233, 233)),
                    child: const Align(
                        alignment: Alignment.center,
                        child: Text(
                          'SIGN UP',
                          style: TextStyle(
                              fontSize: 25, fontWeight: FontWeight.w500),
                        )),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    // Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //         builder: (context) => BlocProvider(
                    //               create: (context) => SignInBloc(
                    //                   userRepository: context
                    //                       .read<AuthenticationBloc>()
                    //                       .userRepository),
                    //               child: PhoneScreen(),
                    //             )));
                  },
                  child: SizedBox(
                    height: 40,
                    width: 40,
                    child: Container(
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.call),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                SizedBox(
                  height: 40,
                  width: 40,
                  child: Container(
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.amber,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                SizedBox(
                    height: 40,
                    width: 40,
                    child: Container(
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.amber,
                      ),
                    ))
              ],
            )
          ],
        ),
      ),
    );
  }
}
