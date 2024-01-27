import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_app/bloc/task_bloc/task_bloc.dart';
import 'package:task_app/bloc/welcome_bloc/welcome_bloc.dart';
import 'package:task_app/config/theme.dart';
import 'package:task_app/data/services/database_provider.dart';
import 'package:task_app/screens/views/navigation_screen.dart';
import 'package:task_app/screens/views/welcome_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseProvider.instance.database;
  runApp(const MyApp());
  configLoading();
}

void configLoading() {
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 2000)
    ..indicatorType = EasyLoadingIndicatorType.fadingCircle
    ..loadingStyle = EasyLoadingStyle.dark
    ..indicatorSize = 45.0
    ..radius = 10.0
    ..progressColor = Colors.yellow
    ..backgroundColor = Colors.green
    ..indicatorColor = Colors.yellow
    ..textColor = Colors.yellow
    ..maskColor = Colors.blue.withOpacity(0.5)
    ..userInteractions = true
    ..dismissOnTap = false;
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool? _firstTime = true;

  checkFirstTime() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? value = prefs.getBool("firstTime");
    if (value != null) {
      setState(() {
        _firstTime = value;
      });
    }
  }

  @override
  void initState() {
    checkFirstTime();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => WelcomeBloc(),
        ),
        BlocProvider(
          create: (context) => TaskBloc(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Task App',
        theme: lightTheme,
        darkTheme: darkTheme,
        home: _firstTime! ? const WelcomeScreen() : const NavigationScreen(),
      ),
    );
  }
}
