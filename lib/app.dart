import 'package:expense_repository/expense_repository.dart';
import 'package:expense_tracker_project/app_view.dart';
import 'package:expense_tracker_project/blocs/category_bloc/category_bloc.dart';

import 'package:expense_tracker_project/blocs/expense_bloc/expense_bloc.dart';
import 'package:expense_tracker_project/blocs/local_auth_bloc/local_auth_bloc.dart';

import 'package:expense_tracker_project/blocs/my_user_bloc/my_user_bloc.dart';
import 'package:expense_tracker_project/blocs/sign_in_bloc/sign_in_bloc.dart';
import 'package:expense_tracker_project/blocs/update_user_info_bloc/update_user_info_bloc.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_repository/user_repository.dart';

import 'blocs/authentication_bloc/authentication_bloc.dart';
import 'package:user_repository/src/local_auth_services.dart';

class MyApp extends StatelessWidget {
  final UserRepository userRepository;

  const MyApp(this.userRepository, {super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
        providers: [
          RepositoryProvider<AuthenticationBloc>(
              create: (_) =>
                  AuthenticationBloc(myUserRepository: userRepository))
        ],
        child: MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) => SignInBloc(
                userRepository:
                    context.read<AuthenticationBloc>().userRepository,
              ),
            ),
            BlocProvider(
              create: (context) => UpdateUserInfoBloc(
                  userRepository:
                      context.read<AuthenticationBloc>().userRepository),
            ),
            BlocProvider(
              create: (context) => MyUserBloc(
                  myUserRepository:
                      context.read<AuthenticationBloc>().userRepository)
                ..add(GetMyUser(
                    myUserId:
                        context.read<AuthenticationBloc>().state.user!.uid)),
            ),
            BlocProvider(
                create: (context) => ExpenseBloc(
                      FirebaseExpenseReport(),
                    )),
            BlocProvider(
              create: (context) => CategoryBloc(FirebaseExpenseReport()),
            ),
            BlocProvider(
              create: (context) => LocalAuthBloc(
                  userRepository:
                      context.read<AuthenticationBloc>().userRepository),
            ),
          ],
          child: const AppView(),
        ));
  }
}
