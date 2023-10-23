import 'package:debit_notes/constants/vectors.dart';
import 'package:debit_notes/pages/homepage.dart';
import 'package:debit_notes/pages/login_page.dart';
import 'package:debit_notes/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  bool isLoading = false;

  void signUp() async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: emailController.text, password: passwordController.text);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
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
              Vectors.signUpImage,
              const SizedBox(height: 20),
              title(),
              const SizedBox(height: 20),
              emailTextField(),
              const SizedBox(height: 20),
              passwordTextField(),
              const SizedBox(height: 20),
              confirmPasswordTextField(),
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

  TextFormField confirmPasswordTextField() {
    return TextFormField(
      controller: confirmPasswordController,
      decoration: InputDecoration(
        labelText: "Confirm password",
        contentPadding: EdgeInsets.symmetric(vertical: 0),
      ),
    );
  }

  TextButton textButton(BuildContext context) {
    return TextButton(
        onPressed: () {
          if (Navigator.canPop(context)) {
            Navigator.pop(context);
          } else {
            Navigator.push(
                context,
                PageTransition(
                    duration: const Duration(milliseconds: 500),
                    child: const LoginPage(),
                    type: PageTransitionType.bottomToTop));
          }
        },
        child: Text("Do you have already an account?"));
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
        onPressed: signUp,
        child: isLoading
            ? SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              )
            : Text("Sign Up",
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
      "Sign Up",
      style: GoogleFonts.manrope(fontSize: 24, fontWeight: FontWeight.w600),
    );
  }
}
