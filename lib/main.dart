import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quiz_app/Authentication%20Screens/signup_screen.dart';
import 'package:quiz_app/views/quiz_cat.dart';

void main() async{
  ErrorWidget.builder = (FlutterErrorDetails) {
    return const Center(
        child: Text(
      "Something went wrong\nPlease try again",
      style: TextStyle(color: Colors.white, fontSize: 20),
    ));
  };
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}


class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late bool logedIn;
  @override
  void initState() {
    // TODO: implement initState


    super.initState();
  }

  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SignUpScreen(),
    );
  }
}
