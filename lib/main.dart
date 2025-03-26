import 'package:flutter/material.dart';
import 'package:mad2_mtr/difficulty_dialog.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, 
    home: SplashScreen());
  }
}

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) => DifficultyDialog(),
            );
          },
          child: Text(
            'Play',
            style: TextStyle(fontSize: 24, color: Colors.white),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red, 
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),
          ),
        ),
      ),
    );
  }
}
