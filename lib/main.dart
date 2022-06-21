import 'package:flutter/material.dart';
import 'package:flutter_sql_tut/home_Screen.dart';

void main() {
  runApp(const MyApp());
}

// I'm using notes.dart as Model and db_handler.dart
// We are using path provider which creates a local directory in the device and stores the database file in it.

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.cyan,
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: Color(0xFF8AE9C1),
        ),
        backgroundColor: Color(0xFF172A3A),
      ),
      home: HomeScreen(),
    );
  }
}
