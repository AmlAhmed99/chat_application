import 'package:chat_app/Screens/auth/LoginScreen.dart';
import 'package:chat_app/Screens/auth/RegisterScreen.dart';
import 'package:chat_app/styles/chatTheme.dart';
import 'package:flutter/material.dart';

class IntroScreen extends StatelessWidget {
  static const ROUTE_NAME = 'IntroScreen';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('assets/images/intro.png'),
          SizedBox(
            height: 100,
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 3),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
            width: double.infinity,
            child: MaterialButton(
                color: MyThemeData.primaryColor,
                onPressed: () {
                  Navigator.pushReplacementNamed(
                      context, RegisterScreen.ROUTE_NAME);
                },
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text('Sign up'),
                )),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
              width: double.infinity,
              margin: EdgeInsets.symmetric(horizontal: 3),
              child: FlatButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(
                      context, LoginScreen.ROUTE_NAME);
                },
                child: Text(
                  'Login',
                ),
                textColor: Colors.black,
                shape: RoundedRectangleBorder(
                    side: BorderSide(
                        color: Colors.blue, width: 2, style: BorderStyle.solid),
                    borderRadius: BorderRadius.circular(5)),
              )),
        ],
      ),
    );
  }
}
