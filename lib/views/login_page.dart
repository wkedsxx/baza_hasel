import '/views/konta_search_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  var loginController = TextEditingController();
  var passwordController = TextEditingController();

  void submitCredentials() async {
    // FirebaseAuth.instance.setPersistence(Persistence.NONE);

    // Do zakomentowania na prod
    loginController.text = 'dawid.debest@gmail.com';
    passwordController.text = 'Gromxoger1!';
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: loginController.text,
        password: passwordController.text,
      );
      final User? firebaseUser = userCredential.user;
      if (firebaseUser != null) {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => KontaSearchPage()));
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-email') {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Niepoprawny adres email!'),
        ));
      }
      if (e.code == 'user-not-found' || e.code == 'wrong-password') {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Niepoprawna nazwa użytkownika lub hasło!'),
        ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          width: 600,
          height: 600,
          child: Column(
            children: [
              Row(
                children: [
                  const Text('Login:'),
                  SizedBox(
                      width: 200,
                      child: TextField(
                        controller: loginController,
                      ))
                ],
              ),
              Row(
                children: [
                  const Text('Hasło:'),
                  SizedBox(
                    width: 200,
                    child: TextField(
                      controller: passwordController,
                      obscureText: true,
                    ),
                  ),
                ],
              ),
              ElevatedButton(
                onPressed: submitCredentials,
                child: const Text('Zaloguj się'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
