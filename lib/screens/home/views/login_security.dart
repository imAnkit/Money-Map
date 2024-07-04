import 'package:expense_tracker_project/blocs/local_auth_bloc/local_auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginAndSecurityScreen extends StatefulWidget {
  const LoginAndSecurityScreen({super.key});

  @override
  State<LoginAndSecurityScreen> createState() => _LoginAndSecurityScreenState();
}

class _LoginAndSecurityScreenState extends State<LoginAndSecurityScreen> {
  bool isSwitched = false;
  Future<void> getLocalAuthValue() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      isSwitched = prefs.getBool('app_lock') ?? false;
    });
  }

  void toogleSwithc(bool value) {
    setState(() {
      isSwitched = value;
    });
    context.read<LocalAuthBloc>().add(LocalAuthUpdateStatus());
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getLocalAuthValue();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 60,
        toolbarHeight: 60,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(6.0),
                child: Container(
                  width: 30,
                  height: 30,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color.fromARGB(255, 212, 212, 212),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.arrow_back,
                      size: 18,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        automaticallyImplyLeading: false,
        backgroundColor: Theme.of(context).colorScheme.background,
        centerTitle: true,
        title: const Text(
          'Login And Security',
          style: TextStyle(
            fontSize: 22,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 30,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Enable Biometric Lock',
                  style: TextStyle(color: Colors.black, fontSize: 18),
                ),
                Switch(value: isSwitched, onChanged: toogleSwithc),
              ],
            ),
          )
        ],
      ),
    );
  }
}
