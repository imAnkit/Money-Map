import 'package:expense_repository/expense_repository.dart';
import 'package:expense_tracker_project/blocs/authentication_bloc/authentication_bloc.dart';
import 'package:expense_tracker_project/blocs/category_bloc/category_bloc.dart';
import 'package:expense_tracker_project/blocs/expense_bloc/expense_bloc.dart';
import 'package:expense_tracker_project/blocs/my_user_bloc/my_user_bloc.dart';
import 'package:expense_tracker_project/blocs/sign_in_bloc/sign_in_bloc.dart';
import 'package:expense_tracker_project/blocs/update_user_info_bloc/update_user_info_bloc.dart';
import 'package:expense_tracker_project/screens/authentication/sign_in_screen.dart';
import 'package:expense_tracker_project/screens/home/views/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_repository/user_repository.dart';

import '../../blocs/sign_up_bloc/sign_up_bloc.dart';
import '../../components/strings.dart';
import '../../components/textfield.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool obscurePassword = true;
  IconData iconPassword = CupertinoIcons.eye_fill;
  final nameController = TextEditingController();
  bool signUpRequired = false;

  bool containsUpperCase = false;
  bool containsLowerCase = false;
  bool containsNumber = false;
  bool containsSpecialChar = false;
  bool contains8Length = false;
  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SignUpBloc, SignUpState>(
      listener: (context, state) {
        if (state is SignUpSuccess) {
          setState(() {
            signUpRequired = false;

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
          });
        } else if (state is SignUpProcess) {
          setState(() {
            signUpRequired = true;
          });
        } else if (state is SignUpFailure) {
          return;
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
                      'Create Your\nAccount',
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
                            const SizedBox(
                              height: 30,
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.9,
                              child: MyTextField(
                                  controller: nameController,
                                  hintText: 'Name',
                                  obscureText: false,
                                  keyboardType: TextInputType.name,
                                  prefixIcon:
                                      const Icon(CupertinoIcons.person_fill),
                                  validator: (val) {
                                    if (val!.isEmpty) {
                                      return 'Please fill in this field';
                                    } else if (val.length > 30) {
                                      return 'Name too long';
                                    }
                                    return null;
                                  }),
                            ),
                            const SizedBox(height: 20),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.9,
                              child: MyTextField(
                                  controller: emailController,
                                  hintText: 'Email',
                                  obscureText: false,
                                  keyboardType: TextInputType.emailAddress,
                                  prefixIcon:
                                      const Icon(CupertinoIcons.mail_solid),
                                  validator: (val) {
                                    if (val!.isEmpty) {
                                      return 'Please fill in this field';
                                    } else if (!emailRexExp.hasMatch(val)) {
                                      return 'Please enter a valid email';
                                    }
                                    return null;
                                  }),
                            ),
                            const SizedBox(height: 20),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.9,
                              child: MyTextField(
                                  controller: passwordController,
                                  hintText: 'Password',
                                  obscureText: obscurePassword,
                                  keyboardType: TextInputType.visiblePassword,
                                  prefixIcon:
                                      const Icon(CupertinoIcons.lock_fill),
                                  onChanged: (val) {
                                    if (val!.contains(RegExp(r'[A-Z]'))) {
                                      setState(() {
                                        containsUpperCase = true;
                                      });
                                    } else {
                                      setState(() {
                                        containsUpperCase = false;
                                      });
                                    }
                                    if (val.contains(RegExp(r'[a-z]'))) {
                                      setState(() {
                                        containsLowerCase = true;
                                      });
                                    } else {
                                      setState(() {
                                        containsLowerCase = false;
                                      });
                                    }
                                    if (val.contains(RegExp(r'[0-9]'))) {
                                      setState(() {
                                        containsNumber = true;
                                      });
                                    } else {
                                      setState(() {
                                        containsNumber = false;
                                      });
                                    }
                                    if (val.contains(specialCharRexExp)) {
                                      setState(() {
                                        containsSpecialChar = true;
                                      });
                                    } else {
                                      setState(() {
                                        containsSpecialChar = false;
                                      });
                                    }
                                    if (val.length >= 8) {
                                      setState(() {
                                        contains8Length = true;
                                      });
                                    } else {
                                      setState(() {
                                        contains8Length = false;
                                      });
                                    }
                                    return null;
                                  },
                                  suffixIcon: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        obscurePassword = !obscurePassword;
                                        if (obscurePassword) {
                                          iconPassword =
                                              CupertinoIcons.eye_fill;
                                        } else {
                                          iconPassword =
                                              CupertinoIcons.eye_slash_fill;
                                        }
                                      });
                                    },
                                    icon: Icon(iconPassword),
                                  ),
                                  validator: (val) {
                                    if (val!.isEmpty) {
                                      return 'Please fill in this field';
                                    } else if (!passwordRexExp.hasMatch(val)) {
                                      return 'Please enter a valid password';
                                    }
                                    return null;
                                  }),
                            ),
                            const SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "⚈  1 uppercase",
                                      style: TextStyle(
                                          color: containsUpperCase
                                              ? Colors.green
                                              : Theme.of(context)
                                                  .colorScheme
                                                  .onBackground),
                                    ),
                                    Text(
                                      "⚈  1 lowercase",
                                      style: TextStyle(
                                          color: containsLowerCase
                                              ? Colors.green
                                              : Theme.of(context)
                                                  .colorScheme
                                                  .onBackground),
                                    ),
                                    Text(
                                      "⚈  1 number",
                                      style: TextStyle(
                                          color: containsNumber
                                              ? Colors.green
                                              : Theme.of(context)
                                                  .colorScheme
                                                  .onBackground),
                                    ),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "⚈  1 special character",
                                      style: TextStyle(
                                          color: containsSpecialChar
                                              ? Colors.green
                                              : Theme.of(context)
                                                  .colorScheme
                                                  .onBackground),
                                    ),
                                    Text(
                                      "⚈  8 minimum character",
                                      style: TextStyle(
                                          color: contains8Length
                                              ? Colors.green
                                              : Theme.of(context)
                                                  .colorScheme
                                                  .onBackground),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 30),
                            !signUpRequired
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
                                            MyUser myUser = MyUser.empty;
                                            myUser = myUser.copyWith(
                                              email: emailController.text,
                                              name: nameController.text,
                                            );

                                            setState(() {
                                              context.read<SignUpBloc>().add(
                                                  SignUpRequired(myUser,
                                                      passwordController.text));
                                            });
                                          }
                                        },
                                        child: const Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 25, vertical: 5),
                                          child: Text(
                                            'Sign Up',
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
                                    child: TextButton(
                                      onPressed:
                                          null, // Disable button while loading

                                      child: Container(
                                        width: 20,
                                        height: 20,
                                        child: const CircularProgressIndicator(
                                          strokeWidth:
                                              2, // Adjust the thickness of the indicator
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                  Colors.white),
                                        ),
                                      ),
                                    ),
                                  ),
                            const SizedBox(
                              height: 20,
                            ),
                            Align(
                              alignment: Alignment.bottomRight,
                              child: GestureDetector(
                                onTap: () {
                                  // Navigate to sign up screen
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              BlocProvider<SignInBloc>(
                                                create: (context) => SignInBloc(
                                                    userRepository: context
                                                        .read<
                                                            AuthenticationBloc>()
                                                        .userRepository),
                                                child: const SignInScreen(),
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
                                      'Sign In',
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
