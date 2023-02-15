import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quiz_app/Authentication%20Screens/signup_screen.dart';

import 'package:quiz_app/views/quiz_display.dart';

import '../widgetHandler.dart';

class QuizCatagory extends StatefulWidget {
  const QuizCatagory({Key? key}) : super(key: key);

  @override
  State<QuizCatagory> createState() => _QuizCatagoryState();
}

class _QuizCatagoryState extends State<QuizCatagory> {

  ConnectivityResult _connectionStatus = ConnectivityResult.none;

  final Connectivity _connectivity = Connectivity();

  late StreamSubscription<ConnectivityResult> _connectivitySubscription;

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    initConnectivity();

    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  Future<void> initConnectivity() async {
    late ConnectivityResult result;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      print('Couldn\'t check connectivity status $e');
      return;
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) {
      return Future.value(null);
    }

    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    setState(() {
      _connectionStatus = result;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer:  Drawer(
        child: MaterialButton(child: Text("Log out"),
            onPressed: ()async{
          await _firebaseAuth.signOut();
          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => SignUpScreen()));
        }),
      ),
      backgroundColor: Colors.indigo[900],
      appBar: AppBar(
        elevation: 40,
        toolbarHeight: 100,
        backgroundColor: Colors.transparent,
        title: const Text(
          "Q  U  I  Z",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.yellow,fontSize: 25),
        ),
        centerTitle: true,
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          gradient: LinearGradient(colors: [
            Colors.indigo,
            Colors.indigo,
            Colors.blue,
            Colors.lightBlue
          ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
        ),
        child: Center(
          child: Visibility(
            visible: checkInternet(_connectionStatus),
            replacement: noInternetAlert(),
            child: ListView(
              children: [
                const Padding(
                  padding: EdgeInsets.all(25.0),
                  child: Center(
                      child: Text(
                    "Choose Catagory",
                    style: TextStyle(color: Colors.white, fontSize: 17),
                  )),
                ),
                createListTile("Any Category", context),
                createListTile("SQL", context),
                createListTile("Bash", context),
                createListTile("Code", context),
                createListTile("DevOps", context),
                createListTile("Docker", context),
                createListTile("Linux", context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  ListTile createListTile(String title, BuildContext context) {
    return ListTile(
      leading: const Icon(
        Icons.arrow_circle_right,
        color: Colors.yellow,
      ),
      title: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          title,
          style: const TextStyle(fontSize: 25, color: Colors.white),
        ),
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => QuizDisplay(
                  'https://quizapi.io/api/v1/questions?apiKey=Rdxrf32fdbU11dozBiAtoKlTfKYMuQ1Zg5G1OkoG&category=${title.toLowerCase()}&difficulty=Easy&limit=10')),
        );
      },
    );
  }
  bool checkInternet(ConnectivityResult connectionStatus) {
    print(connectionStatus);
    if(connectionStatus.toString() == "ConnectivityResult.none"){
      return false;
    }
    else{
      return true;
    }
  }
}
