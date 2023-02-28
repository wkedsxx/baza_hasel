import '/views/login_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // var db = FirebaseFirestore.instance;
  // db.collection('kontrahenci').get().then((event) {
  //   for (var doc in event.docs) {
  //     print('${doc.id} => ${doc.data()}');
  //   }
  // });
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        brightness: Brightness.dark,
        useMaterial3: true,
      ),
      home: LoginPage(),
    );
  }
}
