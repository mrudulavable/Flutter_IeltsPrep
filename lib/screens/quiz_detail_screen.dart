import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:ielts/lesson_data/quiz_data.dart';
import 'package:ielts/models/quiz.dart';

class QuizDetailScreen extends StatefulWidget {
  final Quiz quiz;
  QuizDetailScreen({Key key, this.quiz}) : super(key: key);

  @override
  _QuizDetailScreenState createState() => _QuizDetailScreenState(quiz);
}

class _QuizDetailScreenState extends State<QuizDetailScreen> {
  final Quiz quiz;
  _QuizDetailScreenState(this.quiz);

  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();

  final TextStyle _questionStyle = TextStyle(
      fontSize: 18.0, fontWeight: FontWeight.w500, color: Colors.white);
  int _currentIndex = 0;
  int _optionsIndex = 0;

  String _answer;
  String _selectedAnswer;
  int answerScore = 0;

  @override
  Widget build(BuildContext context) {
    final List<dynamic> options = quiz.options[_currentIndex];

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
          key: _key,
          appBar: AppBar(
            title: Text('Quiz'),
            elevation: 0,
          ),
          body: Stack(
            children: <Widget>[
              ClipPath(
                clipper: WaveClipperTwo(),
                child: Container(
                  decoration:
                      BoxDecoration(color: Theme.of(context).primaryColor),
                  height: 200,
                ),
              ),
              Container(
                child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(children: <Widget>[
                      Row(
                        children: <Widget>[
                          CircleAvatar(
                            backgroundColor: Colors.white70,
                            child: Text("${_currentIndex + 1}"),
                          ),
                          SizedBox(width: 16.0),
                          Expanded(child: Text(quiz.question[_currentIndex])),
                        ],
                      ),
                      SizedBox(height: 20.0),
                      Card(
                        child: ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: options.length,
                            itemBuilder: (context, index) {
                              return ListTile(
                                title: Text(options[index]),
                                leading: Radio(
                                    value: options[index],
                                    groupValue: _selectedAnswer,
                                    onChanged: (value) {
                                      setState(() {
                                        _selectedAnswer = value;
                                        if (_selectedAnswer ==
                                            quiz.answers[_currentIndex]) {
                                          answerScore = answerScore + 1;
                                          _answer =
                                              'Answer is right, your score is $answerScore';
                                          print(_answer);
                                        } else {
                                          _answer =
                                              'Your answer is wrong  $answerScore';
                                          print(_answer);
                                        }
                                      });
                                    }),
                              );
                            }),
                      ),
                      RaisedButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        child: Text(
                          _currentIndex == (quiz.question.length - 1)
                              ? "Submit"
                              : "Next",
                          style: TextStyle(color: Colors.white),
                        ),
                        color: Colors.deepPurpleAccent,
                        onPressed: _nextSubmit,
                      )
                    ])),
              ),
            ],
          )),
    );
  }

  Future<bool> _onWillPop() async {
    return showDialog<bool>(
        context: context,
        builder: (_) {
          return AlertDialog(
            content: Text(
                "Are you sure you want to quit the quiz? All your progress will be lost."),
            title: Text("Warning!"),
            actions: <Widget>[
              FlatButton(
                child: Text("Yes"),
                onPressed: () {
                  Navigator.pop(context, true);
                },
              ),
              FlatButton(
                child: Text("No"),
                onPressed: () {
                  Navigator.pop(context, false);
                },
              ),
            ],
          );
        });
  }

  void _nextSubmit() {
    if (_selectedAnswer == null) {
      _key.currentState.showSnackBar(SnackBar(
        content: Text("You must select an answer to continue."),
      ));
      return;
    }
    if (_currentIndex < (quiz.question.length - 1)) {
      setState(() {
        _currentIndex++;
      });
    } else {
      // Navigator.of(context).pushReplacement(MaterialPageRoute(
      //   builder: (_) => QuizFinishedPage(questions: widget.questions, answers: _answers)
      // ));
    }
  }
}