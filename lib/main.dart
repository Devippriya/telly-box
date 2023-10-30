import 'package:cable_record/Screens/home.dart';
import 'package:cable_record/Screens/signin.dart';
import 'package:cable_record/Screens/signup.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      name: 'telly-box',
      options: const FirebaseOptions(
        apiKey: "AIzaSyCO02wq9Vk14QpE3p5G2CLnV3MGw0QESHA",
        appId: "1:858844873233:web:a84074e7b66836ca38e7b0",
        messagingSenderId: "858844873233",
        projectId: "telly-box",
      ));
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: const Color.fromARGB(255, 136, 14, 79),
        primarySwatch: Colors.pink,
      ),
      home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Text('Something went wrong');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Text("Loading");
            }
            final user = snapshot.data;
            if (user == null) {
              return const SignIn();
            } else {
              return const HomeScreen();
            }
          }),
    );
  }
}
