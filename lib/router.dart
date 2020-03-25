import 'package:flutter/material.dart';
import 'package:ielts/screens/home_screen.dart';
import 'package:ielts/screens/listening_screen.dart';
import 'package:ielts/screens/reading_screen.dart';
import 'package:ielts/screens/speaking_screen.dart';
import 'package:ielts/screens/vocabulary_screen.dart';
import 'package:ielts/screens/writing_screen.dart';
import 'app_constants.dart';

class Router {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RoutePaths.root:
        return MaterialPageRoute<Widget>(builder: (_) => HomeScreen());
      case RoutePaths.vocabulary:
        return MaterialPageRoute<Widget>(builder: (_) => VocabularyScreen());
      case RoutePaths.writing:
        return MaterialPageRoute<Widget>(builder: (_) => WritingScreen());
      case RoutePaths.speaking:
        return MaterialPageRoute<Widget>(builder: (_) => SpeakingScreen());
      case RoutePaths.reading:
        return MaterialPageRoute<Widget>(builder: (_) => ReadingScreen());
      case RoutePaths.listening:
        return MaterialPageRoute<Widget>(builder: (_) => ListeningScreen());
      default:
        return MaterialPageRoute<Widget>(
          builder: (_) => Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
        );
    }
  }
}
