import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:visa_dashboard/screens/login_page.dart';
import 'controller/auth_controller.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  print('object');
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyAn6qMm70uVthfwRGeJy4f1kk2K5CrvNys",
      projectId: "hotels-26696",
      messagingSenderId: "690360267959",
       
      appId: "1:690360267959:web:25ab50c0e256890d1cc932",
       storageBucket: "hotels-26696.appspot.com",
    ),
  );
  Get.put(AuthController());
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);
  final AuthController controller = Get.find();
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Visa Dashboard',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const LoginPage(),
    );
  }
}
