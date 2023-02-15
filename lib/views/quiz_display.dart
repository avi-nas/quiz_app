import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import '../widgetHandler.dart';
import 'package:shimmer/shimmer.dart';
import '../services/remort_service.dart';

class QuizDisplay extends StatefulWidget {
  final String url;
  const QuizDisplay(this.url, {Key? key}) : super(key: key);
  @override
  State<QuizDisplay> createState() => _QuizDisplayState(url);
}

class _QuizDisplayState extends State<QuizDisplay> {
  late String url;
  List? questions;
  var isLoaded = false;
  bool answered = false;
  var selectedOption = -1;
  final PageController _controller = PageController(initialPage: 0);

  int _score = 0;
  int buttonNumber = 1;
  bool noResponse = false;
  late int numberOfOptions;

  final int _duration = 15;
  final CountDownController _countDownController = CountDownController();

  _QuizDisplayState(this.url);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();

  }

  getData() async {
    var data = await RemortService().getQuestions(url);
    if (data == "error") {
      setState(() {
        isLoaded = false;
        noResponse = true;
      });
    } else {
      setState(() {
        questions = json.decode(data.toString());
        isLoaded = true;

      });
    }
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.indigo[900],
      body: SafeArea(
        child: Visibility(
          visible: isLoaded,
          replacement: Center(
            child: noResponse
                ? const Text(
                    "Loading failed!!",
                    style: TextStyle(color: Colors.white, fontSize: 25),
                  )
                : getShimmerLoading(),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(15, 15, 15, 15),
            child:PageView.builder(
              // ignore: avoid_types_as_parameter_names

              padEnds: true,
              itemCount: questions?.length,
              controller: _controller,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (BuildContext context, int index) {
                Map options;
                Map correctAnswers;
                int correctButton;
                options = questions?.elementAt(index)["answers"];
                correctAnswers = questions?.elementAt(index)["correct_answers"];
                correctButton = findCorrectButton(correctAnswers);
                numberOfOptions = countNumberOfOptions(options);
                return Center(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [

                        createCircularCountDownTimer(context,_countDownController,_duration,index,_controller,_score),
                        SizedBox(
                            width: double.infinity,
                            child: Text(
                              "Question ${index + 1}/${questions?.length}",
                              style: const TextStyle(
                                  color: Colors.cyanAccent,
                                  fontStyle: FontStyle.italic),
                            )),
                        const SizedBox(height: 15),
                        Text(
                          "${questions?.elementAt(index)["question"]} ",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 25,
                          ),
                        ),
                        const SizedBox(
                          height: 40,
                        ),
                        for(int i=1; i<=numberOfOptions;i++)
                          createButton(i, options[options.keys.elementAt(i-1)], correctButton, index),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(10, 30, 20, 30),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              TextButton(
                                  onPressed: () {
                                    changePage(index, context, _controller, _score);
                                  },
                                  child: const Text("Skip"))
                            ],
                          ),
                        ),

                      ],
                    ),
                  ),
                );
              },
            ) 
          ),
        ),
      ),
    );
  }
  Padding createButton(
      int buttonNumber, String title, int correctOption, int index) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: MaterialButton(
          onPressed: () {
            if (buttonNumber == correctOption) {
                setState(() {
                  selectedOption = buttonNumber;
                  _score += 1;
                  answered = true;
                });
              } else {
                setState(() {
                  selectedOption = buttonNumber;
                  answered = true;
                });
              }
            Future.delayed(const Duration(seconds: 2), (){
                changePage(index, context,_controller,_score);
              });
            _countDownController.pause();
          },
          shape: const StadiumBorder(),
          minWidth: 300,
          color: setButtonColor(buttonNumber, correctOption),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                title,
                style: const TextStyle(
                    wordSpacing: 3, fontSize: 15, color: Colors.cyanAccent),
              ),
            ),
          )),
    );
  }

  Color setButtonColor(int buttonNum, int correctOption,) {
    if (answered) {
      if (buttonNumber == numberOfOptions) {
        answered = false;
        buttonNumber = 1;
      } else {
        buttonNumber += 1;
      }
      if (buttonNum == correctOption ||
          buttonNum == correctOption && buttonNum == selectedOption) {
        return Colors.green;
      } else if (buttonNum == selectedOption) {
        selectedOption = -1;
        return Colors.red;
      } else {
        return Colors.lightBlue;
      }
    } else {
      return Colors.lightBlue;
    }
  }
  Shimmer getShimmerLoading(){
    return Shimmer.fromColors(
        baseColor: Colors.grey[800]!,
        highlightColor: Colors.grey[300]!,
      child:Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
          CircularCountDownTimer(
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
          autoStart: false,
          onStart: () {

          },
          onComplete: () {
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
        ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 0, 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                      width: 80,
                      height: 20,
                      decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.white,
                    ),

                  ),
                ],
              ),
            ),
            const SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 8, 8),
              child: Container(
                width: double.infinity,
                height: 70,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(
              height: 40,
            ),
            for(int i=1; i<=4;i++)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  width: double.infinity,
                  height: 35,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.white,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
