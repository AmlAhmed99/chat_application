import 'package:chat_app/Screens/auth/RegisterScreen.dart';
import 'package:chat_app/provider/AppProvider.dart';
import 'package:chat_app/constants/extenstions.dart';
import 'package:chat_app/styles/chatTheme.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

class LoginScreen extends StatelessWidget {
  static const ROUTE_NAME = 'Login';

  final _registerFormKey = GlobalKey<FormState>();

  late AppProvider provider;

  @override
  Widget build(BuildContext context) {
     provider = Provider.of<AppProvider>(context);
    provider.isLoading=false;
    return SafeArea(
      child: Stack(
        children: [
          Container(
            color: MyThemeData.white,
          ),
          Image(image: AssetImage('assets/images/bg_top_shape.png'),
            fit: BoxFit.fitWidth,width: double.infinity,),
          Scaffold(
            appBar: AppBar(
              centerTitle: true,
              backgroundColor: Colors.transparent,
              elevation: 0,
              title: Text(
                'Create Account',
                style: TextStyle(
                  color: MyThemeData.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 22,
                ),
              ),
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Form(
                  key: _registerFormKey,
                  child: Column(
                    mainAxisAlignment:MainAxisAlignment.center,
                    children: [
                      SizedBox(height: 250,),
                      TextFormField(
                        onChanged: (text){
                          provider.email = text;
                        },
                        keyboardType: TextInputType.emailAddress,

                        decoration: InputDecoration(
                            labelText: 'Email',
                            floatingLabelBehavior: FloatingLabelBehavior.auto
                        ),
                        // The validator receives the text that the user has entered.
                        validator: (String? value) {
                          if (value == null || value.isEmpty ) {
                            return 'Please enter Email';
                          }else if (!isValidEmail(value)){
                            return 'Please enter valid email';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        onChanged: (text){
                          provider.password = text;
                        },
                        decoration: InputDecoration(
                          labelText: 'Password',
                          floatingLabelBehavior: FloatingLabelBehavior.auto,
                        ),
                        // The validator receives the text that the user has entered.
                        validator: (String? value) {
                          if (value == null || value.isEmpty ) {
                            return 'Please enter password';
                          }else if (!isValidPassword(value)){
                            return 'password must be at least 6 characters';
                          }
                          return null;
                        },
                        obscureText: true,
                      ),
                      SizedBox(height: 10,),
                      Container(
                        width: double.infinity,
                        child: ElevatedButton(
                            onPressed: (){
                              if(_registerFormKey.currentState?.validate()==true){
                                // create user in firebase auth
                                provider.SigninFirebaseUser(context);
                              }
                            }, child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child:
                          provider.isLoading?
                          Center(child: CircularProgressIndicator(),)
                              : Text('Login'),
                        )),
                      ),
                      TextButton(child: Text('Or Create My Account!'),
                        onPressed: (){Navigator.pushReplacementNamed(context, RegisterScreen.ROUTE_NAME);
                        },)

                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }


}
