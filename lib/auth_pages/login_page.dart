import 'package:Lucky_or_Not/app_pages/main_page.dart';
import 'package:Lucky_or_Not/app_pages/verify_email_page.dart';
import 'package:Lucky_or_Not/components/build_pages_function.dart';
import 'package:Lucky_or_Not/components/sign_in_button.dart';
import 'package:Lucky_or_Not/sign_in_methods/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../components/google_sign_in_button.dart';
import '../components/register_button.dart';
import '../components/text_field.dart';

class LoginPage extends StatefulWidget {

  LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String errorMessage = '';

  final emailController = TextEditingController();

  final passwordController = TextEditingController();

  Future sendUserInfo(String text,String uid) async {
    await FirebaseFirestore.instance.collection('users').doc(uid).set({
      'email': text.trim(),
      'highscore': 0
    });
  }

  void signUserInWithEmail() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim());
       Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => FirebaseAuth.instance.currentUser!.emailVerified ? buildPages(context)
              : VerifyEmailPage()
      ));
    } on FirebaseAuthException catch (e) {
        if (e.code == 'wrong-password') {
          wrongPassword();
        } else if (e.code == 'email-already-in-use') {
          emailInUse();
        } else if (e.code == 'user-not-found') {
          wrongEmail();
      }
        else{
         return;
        }
    }
  }
  Future<void> SignInWithGoogle() async {
    try {
      await signInWithGoogle();

      sendUserInfo(FirebaseAuth.instance.currentUser!.email!,
      FirebaseAuth.instance.currentUser!.uid);

      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => MainPage()
      ));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('An error has occured while signing in.')));
    }
  }
  void wrongPassword() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Wrong Password!'),
          actions: <Widget>[
            TextButton(
              child: Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
  void wrongEmail() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Wrong E-mail!'),
          actions: <Widget>[
            TextButton(
              child: Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
  void emailInUse() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('E-mail is already in use!'),
          actions: <Widget>[
            TextButton(
              child: Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
  void validateEmail(String val) {
    if(val.isEmpty){
      setState(() {
        errorMessage = "Email can not be empty";
      });
    }else if(!EmailValidator.validate(val, true)){
      setState(() {
        errorMessage = "Invalid Email Address";
      });
    }else{
      setState(() {
        errorMessage = "";
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                SizedBox(height: 10,),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 30),
                  width: 150,
                  height: 150,
                  child: Image.asset('assets/images/question_mark.png'),
                ),
                Text('Welcome back!',
                    style: TextStyle(fontSize: 18,
                        height: 2,
                        letterSpacing: 5,
                        fontStyle: FontStyle.italic)
                ),
                SizedBox(
                    height: 50,
                    child: Center(child: Text(
                        'Please sign-in using your e-mail and password.'))
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: TextField(
                    controller: emailController,
                    decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white)
                        ),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white)
                        ),
                        fillColor: Colors.grey.shade100,
                        filled: true,
                        hintText: 'E-mail',
                        hintStyle: TextStyle(color: Colors.grey[500])
                    ),
                    onChanged: (val){
                      validateEmail(val);
                    },
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                MyTextField(
                  controller: passwordController,
                  hintText: 'Password',
                  obscureText: true,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 25,
                      vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text('Forgot Password?', style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: Colors.black,
                          decoration: TextDecoration.underline,
                          decorationColor: Colors.brown,
                          decorationThickness: 1.5,
                          fontStyle: FontStyle.italic
                      ),
                      ),
                    ],
                  ),
                ),
                SignInButton(signUserIn:signUserInWithEmail),
                SizedBox(
                    height: 30,
                    child: Center(child: Text(errorMessage,
                    style: TextStyle(color: Colors.red))),
                    ),
                Row(
                  children: [
                    Expanded(
                      child: Divider(
                        thickness: 1,
                        color: Colors.grey,
                      ),
                    ),
                    Text('Or Sign In With',
                      textScaleFactor: 1,),
                    Expanded(
                      child: Divider(
                        thickness: 1,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 30),
                GoogleSignInGesture(onTap: SignInWithGoogle),
                SizedBox(height: 30),
                Text('Don\'t have an account?'),
                RegisterButton()
              ],
            ),
          ),
        ),
      ),
    );
  }
}


