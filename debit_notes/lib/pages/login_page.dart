import 'package:debit_notes/constants/vectors.dart';
import 'package:debit_notes/pages/homepage.dart';
import 'package:debit_notes/pages/sign_up_page.dart';
import 'package:debit_notes/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool isLoading = false;

  Future<void> login() async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: emailController.text, password: passwordController.text)
          .then((value) {
        Navigator.pushAndRemoveUntil(
            context,
            PageTransition(
                child: const HomePage(),
                type: PageTransitionType.rightToLeftWithFade),
            (route) => false);

        return value;
      });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var pageWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: appBar(),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: pageWidth / 12),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Vectors.loginImage,
              const SizedBox(height: 20),
              title(),
              const SizedBox(height: 20),
              emailTextField(),
              const SizedBox(height: 20),
              passwordTextField(),
              const SizedBox(height: 50),
              signInButton(),
              textButton(context),
            ],
          ),
        ),
      ),
    );
  }

  AppBar appBar() {
    return AppBar(
      title: Text("Debit Notes",
          style: GoogleFonts.prompt(
            fontSize: 30,
            fontWeight: FontWeight.w600,
          )),
      centerTitle: true,
    );
  }

  TextButton textButton(BuildContext context) {
    return TextButton(
        onPressed: () {
          Navigator.push(
              context,
              PageTransition(
                  duration: const Duration(milliseconds: 500),
                  child: const SignUpPage(),
                  type: PageTransitionType.topToBottom));
        },
        child: Text("Don't have an account?"));
  }

  SizedBox signInButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: Color.fromRGBO(185, 65, 169, 1),
          padding: EdgeInsets.symmetric(vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: login,
        child: isLoading
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  color: Colors.white,
                ))
            : Text("Sign In",
                style: GoogleFonts.manrope(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                )),
      ),
    );
  }

  TextFormField passwordTextField() {
    return TextFormField(
      controller: passwordController,
      decoration: InputDecoration(
        labelText: "Password",
        contentPadding: EdgeInsets.symmetric(vertical: 0),
      ),
    );
  }

  TextFormField emailTextField() {
    return TextFormField(
      controller: emailController,
      decoration: InputDecoration(
        labelText: "Email",
        contentPadding: EdgeInsets.symmetric(vertical: 0),
      ),
    );
  }

  Text title() {
    return Text(
      "Sign In",
      style: GoogleFonts.manrope(fontSize: 24, fontWeight: FontWeight.w600),
    );
  }
}
