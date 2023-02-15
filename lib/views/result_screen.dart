import 'package:flutter/material.dart';

class ResultScreen extends StatelessWidget {
  int score;
  ResultScreen({Key? key,required this.score}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: const BoxDecoration(
            gradient: LinearGradient(colors: [
              Colors.indigo,
              Colors.indigo,
              Colors.blue,
              Colors.lightBlueAccent,
              Colors.blueGrey
              ,
            ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
          ),
          child: Center(child: Text('Score: ${score}/10',style: TextStyle(color:Colors.white,fontSize: 35,fontWeight: FontWeight.bold),),)),
    );

  }
}
