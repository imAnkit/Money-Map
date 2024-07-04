import 'package:expense_repository/expense_repository.dart';
import 'package:expense_tracker_project/blocs/authentication_bloc/authentication_bloc.dart';
import 'package:expense_tracker_project/blocs/category_bloc/category_bloc.dart';
import 'package:expense_tracker_project/blocs/expense_bloc/expense_bloc.dart';
import 'package:expense_tracker_project/blocs/my_user_bloc/my_user_bloc.dart';
import 'package:expense_tracker_project/blocs/sign_up_bloc/sign_up_bloc.dart';
import 'package:expense_tracker_project/blocs/update_user_info_bloc/update_user_info_bloc.dart';
import 'package:expense_tracker_project/screens/authentication/sign_up_screen.dart';
import 'package:expense_tracker_project/screens/home/views/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_repository/user_repository.dart';

import '../../blocs/sign_in_bloc/sign_in_bloc.dart';
import '../../components/strings.dart';
import '../../components/textfield.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  String? _errorMsg;
  bool obscurePassword = true;
  IconData iconPassword = CupertinoIcons.eye_fill;
  bool signInRequired = false;
  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SignInBloc, SignInState>(
      listener: (context, state) {
        if (state is SignInSuccess) {
          setState(() {
            signInRequired = false;
          });

          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => MultiBlocProvider(
                        providers: [
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
                          )
                        ],
                        child: HomeScreen(),
                      )));
        } else if (state is SignInProcess) {
          setState(() {
            signInRequired = true;
          });
        } else if (state is SignInFailure) {
          setState(() {
            signInRequired = false;
            _errorMsg = 'Invalid email or password';
          });
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromARGB(255, 131, 12, 3),
                // Color.fromARGB(255, 165, 105, 218),
                Color.fromARGB(255, 53, 2, 141)
              ],
              // begin: Alignment.topLeft,
              // end: Alignment.bottomRight,
            ),
          ),
          child: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(left: 30.0, top: 100.0),
                    child: Text(
                      'Hello\nSign in!',
                      style: TextStyle(
                          fontSize: 35,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 20), // Add some spacing
                  Container(
                    height: MediaQuery.of(context).size.height * 0.75,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                      color: Colors.white,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          // mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const SizedBox(height: 30),
                            MyTextField(
                                controller: emailController,
                                hintText: 'Email',
                                obscureText: false,
                                keyboardType: TextInputType.emailAddress,
                                prefixIcon:
                                    const Icon(CupertinoIcons.mail_solid),
                                errorMsg: _errorMsg,
                                validator: (val) {
                                  if (val!.isEmpty) {
                                    return 'Please fill in this field';
                                  } else if (!emailRexExp.hasMatch(val)) {
                                    return 'Please enter a valid email';
                                  }
                                  return null;
                                }),
                            const SizedBox(height: 20),
                            MyTextField(
                              controller: passwordController,
                              hintText: 'Password',
                              obscureText: obscurePassword,
                              keyboardType: TextInputType.visiblePassword,
                              prefixIcon: const Icon(CupertinoIcons.lock_fill),
                              errorMsg: _errorMsg,
                              validator: (val) {
                                if (val!.isEmpty) {
                                  return 'Please fill in this field';
                                } else if (!passwordRexExp.hasMatch(val)) {
                                  return 'Please enter a valid password';
                                }
                                return null;
                              },
                              suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    obscurePassword = !obscurePassword;
                                    if (obscurePassword) {
                                      iconPassword = CupertinoIcons.eye_fill;
                                    } else {
                                      iconPassword =
                                          CupertinoIcons.eye_slash_fill;
                                    }
                                  });
                                },
                                icon: Icon(iconPassword),
                              ),
                            ),
                            const SizedBox(height: 20),
                            const Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                'Forgot password?',
                                style: TextStyle(color: Colors.grey),
                              ),
                            ),
                            const SizedBox(height: 60),
                            !signInRequired
                                ? Container(
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(100),
                                        gradient: const LinearGradient(colors: [
                                          Color.fromARGB(255, 131, 12, 3),
                                          // Color.fromARGB(255, 165, 105, 218),
                                          Color.fromARGB(255, 53, 2, 141)
                                        ])),
                                    width:
                                        MediaQuery.of(context).size.width * 0.5,
                                    height: 60,
                                    child: TextButton(
                                        onPressed: () {
                                          if (_formKey.currentState!
                                              .validate()) {
                                            context.read<SignInBloc>().add(
                                                SignInRequired(
                                                    emailController.text,
                                                    passwordController.text));
                                          }
                                        },
                                        child: const Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 25, vertical: 5),
                                          child: Text(
                                            'Sign In',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600),
                                          ),
                                        )),
                                  )
                                : Container(
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(100),
                                        gradient: const LinearGradient(colors: [
                                          Color.fromARGB(255, 131, 12, 3),
                                          Color.fromARGB(255, 53, 2, 141)
                                        ])),
                                    width:
                                        MediaQuery.of(context).size.width * 0.5,
                                    height: 60,
                                    child: const TextButton(
                                      onPressed: null,
                                      child: SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                  Colors.white),
                                        ),
                                      ),
                                    ),
                                  ),
                            const SizedBox(height: 100),
                            Align(
                              alignment: Alignment.bottomRight,
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              BlocProvider<SignUpBloc>(
                                                create: (context) => SignUpBloc(
                                                    userRepository: context
                                                        .read<
                                                            AuthenticationBloc>()
                                                        .userRepository),
                                                child: const SignUpScreen(),
                                              )));
                                },
                                child: const Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      "Don't have account? ",
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                    Text(
                                      'Sign Up',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
