import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/material.dart';
import 'package:quiz_app/views/result_screen.dart';

void changePage(int index,BuildContext context,PageController controller,int score){
  if (index < 9) {

    controller.nextPage(duration: const Duration(milliseconds: 10), curve: Curves.linear);
  } else {
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => ResultScreen(score: score)));
  }
}

int countNumberOfOptions(Map options){
  int i=0;
  options.forEach((key, value) {
    if(value!=null){
      i++;
    }
  });
  return i;
}


int findCorrectButton(Map correctAnswers) {
  int i = 1, result = 0;

  correctAnswers.forEach((key, value) {
    if (value == 'true') {
      result = i;
    }
    i++;
  });
  return result;
}

CircularCountDownTimer createCircularCountDownTimer(BuildContext context,CountDownController _countDownController,int _duration,int index,PageController controller,int score){
  return CircularCountDownTimer(
    duration: _duration,
    initialDuration: 0,
    controller: _countDownController,
    width: MediaQuery.of(context).size.width / 4,
    height: MediaQuery.of(context).size.height / 4,
    ringColor: Colors.grey[300]!,
    ringGradient: null,
    fillColor: Colors.purpleAccent[100]!,
    fillGradient: null,
    backgroundColor: Colors.purple[500],
    backgroundGradient: null,
    strokeWidth: 20.0,
    strokeCap: StrokeCap.round,
    textStyle: const TextStyle(
        fontSize: 15.0, color: Colors.white, fontWeight: FontWeight.bold),
    textFormat: CountdownTextFormat.S,
    isReverse: true,
    isReverseAnimation: true,
    isTimerTextShown: true,
    autoStart: true,
    onStart: () {

    },
    onComplete: () {
      changePage(index, context, controller, score);
    },
    onChange: (String timeStamp) {

    },
    timeFormatterFunction: (defaultFormatterFunction, duration) {
      if (duration.inSeconds == 0) {
        return "Time up";
      } else {
        return Function.apply(defaultFormatterFunction, [duration]);
      }
    },
  );
}
AlertDialog noInternetAlert(){
  return const AlertDialog(
    title: Text('Internet connection Required'),
    content: Text('Please, check your Internet connection. Connect to network to use this app.'),
  );
}

