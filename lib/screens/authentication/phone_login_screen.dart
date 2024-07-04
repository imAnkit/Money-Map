import 'package:expense_repository/expense_repository.dart';
import 'package:expense_tracker_project/blocs/authentication_bloc/authentication_bloc.dart';
import 'package:expense_tracker_project/blocs/category_bloc/category_bloc.dart';
import 'package:expense_tracker_project/blocs/expense_bloc/expense_bloc.dart';
import 'package:expense_tracker_project/blocs/my_user_bloc/my_user_bloc.dart';
import 'package:expense_tracker_project/blocs/sign_in_bloc/sign_in_bloc.dart';
import 'package:expense_tracker_project/blocs/update_user_info_bloc/update_user_info_bloc.dart';
import 'package:expense_tracker_project/components/textfield.dart';
import 'package:expense_tracker_project/screens/authentication/sign_in_screen.dart';
import 'package:expense_tracker_project/screens/home/views/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pinput/pinput.dart';

class PhoneScreen extends StatefulWidget {
  const PhoneScreen({super.key});

  @override
  State<PhoneScreen> createState() => _PhoneScreenState();
}

class _PhoneScreenState extends State<PhoneScreen> {
  final TextEditingController _phoneController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _phoneController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: BlocProvider(
            create: (context) => SignInBloc(
                userRepository:
                    context.read<AuthenticationBloc>().userRepository),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 40),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Log In with Phone",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 30,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  MyTextField(
                    controller: _phoneController,
                    hintText: 'Phone Number',
                    keyboardType: TextInputType.visiblePassword,
                    obscureText: false,
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  ElevatedButton(
                      onPressed: () {
                        final phoneNumber = _phoneController.text.trim();
                        if (phoneNumber.isNotEmpty) {
                          context.read<SignInBloc>().add(
                                PhoneSignInRequired(phoneNumber: phoneNumber),
                              );

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BlocProvider(
                                create: (context) => SignInBloc(
                                    userRepository: context
                                        .read<AuthenticationBloc>()
                                        .userRepository),
                                child: OTPScreen(phoneNumber: phoneNumber),
                              ),
                            ),
                          );
                        }
                      },
                      child: const Text('Get OTP')),
                  const SizedBox(
                    height: 20,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  const Text(
                    'OR',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 25,
                        fontWeight: FontWeight.w400),
                  ),
                  const SizedBox(
                    height: 10,
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

class OTPScreen extends StatefulWidget {
  final String phoneNumber;

  const OTPScreen({super.key, required this.phoneNumber});

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController _otpController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _otpController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocListener<SignInBloc, SignInState>(
          listener: (context, state) {
            if (state is SignInSuccess) {
              // Log sign-in success
              print("Sign-in success!");

              // Navigate to the home screen
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => MultiBlocProvider(
                    providers: [
                      BlocProvider(
                        create: (context) => SignInBloc(
                          userRepository:
                              context.read<AuthenticationBloc>().userRepository,
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
                    ],
                    child: const HomeScreen(),
                  ),
                ),
              );
            } else if (state is PhoneVerificationFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            }
          },
          child: SizedBox.expand(
            child: BlocProvider(
              create: (context) => SignInBloc(
                  userRepository:
                      context.read<AuthenticationBloc>().userRepository),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      const Text(
                        "Verification",
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 25),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const Text(
                        "Enter the code sent to your number",
                        style: TextStyle(
                            fontWeight: FontWeight.w300,
                            fontSize: 15,
                            color: Colors.black38),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        widget.phoneNumber,
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                  Form(
                    key: formKey,
                    child: Column(
                      children: [
                        Pinput(
                          length: 6,
                          controller: _otpController,
                          validator: (value) {
                            return value != null && value.length == 6
                                ? null
                                : 'Invalid OTP';
                          },
                          onCompleted: (pin) {
                            final currentState =
                                context.read<SignInBloc>().state;
                            if (currentState is PhoneVerificationInProgress) {
                              context.read<SignInBloc>().add(
                                    PhoneSignInWithCredential(
                                      verificationId:
                                          currentState.verificationId,
                                      smsCode: pin,
                                    ),
                                  );
                            }
                          },
                          errorBuilder: (errorText, pin) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: Center(
                                child: Text(
                                  errorText ?? "",
                                  style: const TextStyle(color: Colors.red),
                                ),
                              ),
                            );
                          },
                        ),
                        TextButton(
                          onPressed: () {
                            if (formKey.currentState!.validate()) {
                              final currentState =
                                  context.read<SignInBloc>().state;
                              final smsCode = _otpController.text.trim();
                              if (currentState is PhoneVerificationInProgress) {
                                context.read<SignInBloc>().add(
                                      PhoneSignInWithCredential(
                                        verificationId:
                                            currentState.verificationId,
                                        smsCode: smsCode,
                                      ),
                                    );
                              }
                            }
                          },
                          child: const Text('Validate'),
                        ),
                      ],
                    ),
                  ),
                  const Text(
                    "Didn't get the code?\nResend code",
                    style: TextStyle(
                        fontWeight: FontWeight.w200,
                        fontSize: 15,
                        color: Colors.blue),
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
