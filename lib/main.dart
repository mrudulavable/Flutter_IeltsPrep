import 'package:flutter/material.dart';
import 'package:ielts/app_constants.dart';
import 'package:ielts/locator.dart';
import 'package:ielts/models/themeChange.dart';
import 'package:ielts/router.dart';
import 'package:ielts/theme.dart';
import 'package:ielts/viewModels/blogCrudModel.dart';
import 'package:ielts/viewModels/listeningCrudModel.dart';
import 'package:ielts/viewModels/quizCrudModel.dart';
import 'package:ielts/viewModels/readingCrudModel.dart';
import 'package:ielts/viewModels/speakingCrudModel.dart';
import 'package:ielts/viewModels/writingCrudModel.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  setupLocator();
  var darkModeOn = false;
  SharedPreferences.getInstance().then((prefs) {
    if (prefs.containsKey('darkMode')) {
      darkModeOn = prefs.getBool('darkMode') ?? true;
    } else {
      prefs.setBool('darkMode', darkModeOn);
    }
    runApp(
      ChangeNotifierProvider<ThemeNotifier>(
        create: (_) => ThemeNotifier(darkModeOn ? darkTheme : lightTheme),
        child: MyApp(),
      ),
    );
  });
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => locator<CrudModel>()),
          ChangeNotifierProvider(create: (_) => locator<SpeakingCrudModel>()),
          ChangeNotifierProvider(create: (_) => locator<ReadingCrudModel>()),
          ChangeNotifierProvider(create: (_) => locator<ListeningCrudModel>()),
          ChangeNotifierProvider(create: (_) => locator<BlogCrudModel>()),
          ChangeNotifierProvider(create: (_) => locator<QuizCrudModel>()),
        ],
        child: Consumer<ThemeNotifier>(
          builder: (context, themeNotifier, child) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'IELTS',
              initialRoute: RoutePaths.root,
              theme: themeNotifier.getTheme(),
              onGenerateRoute: Router.generateRoute,
            );
          },
        ));
  }
}
