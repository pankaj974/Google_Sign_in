import 'package:device_preview/device_preview.dart';
import 'package:e_commerce/page/login_page.dart';
import 'package:e_commerce/page/registration_page.dart';
import 'package:e_commerce/screen/onboarding_screen.dart';
import 'package:e_commerce/screen/splash_Screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';




void main() async {

  runApp(
    DevicePreview(
      // Set to true to use DevicePreview
    enabled: true,
      builder: (context) => const MyApp(),
    ),
  );
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyBSOYO3PPWNjHX7jMd9q8NNNXTXb--rw5s",
      appId: "1:365648540331:android:1bb31401b4219966e17dee",
      messagingSenderId: "365648540331",
      projectId: "e-commerce-ecfd8",
    ),
  );




}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home:  SignUpPage(),
    );
  }
}

