import 'package:chat_app/Screens/auth/LoginScreen.dart';
import 'package:chat_app/provider/AppProvider.dart';
import 'package:chat_app/constants/extenstions.dart';
import 'package:chat_app/styles/chatTheme.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
final FirebaseAuth auth = FirebaseAuth.instance;
class RegisterScreen extends StatelessWidget {
  static const ROUTE_NAME = 'register';

  final _registerFormKey = GlobalKey<FormState>();

  late AppProvider provider;
  @override
  Widget build(BuildContext context) {
    provider =Provider.of<AppProvider>(context);
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
            body: Column(
              children: [
                Expanded(flex:1,child: Container()),
                Expanded(
                  flex: 3,
                  child: Container(
                    padding: EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Form(
                          key: _registerFormKey,
                          child: Column(
                          children: [
                            TextFormField(
                              onChanged: (text){
                                provider.createuserName = text;
                              },
                              keyboardType: TextInputType.name,
                              decoration: InputDecoration(
                                labelText: 'User Name',
                                floatingLabelBehavior: FloatingLabelBehavior.auto
                              ),
                              // The validator receives the text that the user has entered.
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter user name';
                                }
                                return null;
                              },
                            ),
                            TextFormField(
                              onChanged: (text){
                                provider.createemail = text;
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
                                provider.createpassword = text;
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
                            )
                          ],
                        ),
                        ),
                        Spacer(),
                        ElevatedButton(
                            onPressed: (){
                              if(_registerFormKey.currentState?.validate()==true){
                                // create user in firebase auth
                                provider.createFirebaseUser(context);
                              }
                        }, child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child:
                          provider.isLoading?
                              Center(child: CircularProgressIndicator(),)
                          : Text('Create Account'),
                        )),
                        Spacer(),
                        TextButton(child: Text('Already have Account!'),
                          onPressed: (){Navigator.pushReplacementNamed(context, LoginScreen.ROUTE_NAME);
                          },),
                        Spacer()

                      ],

                    ),

                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }


}
