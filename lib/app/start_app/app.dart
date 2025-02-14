import 'package:flutter/material.dart';
import 'package:tarjeto/app/start_app/start_screen.dart';

class AppStart extends StatelessWidget {
  const AppStart({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(

          fontFamily: "Nunito"),
      debugShowCheckedModeBanner: false,
        home: StartScreen(),
    );
  }
}
