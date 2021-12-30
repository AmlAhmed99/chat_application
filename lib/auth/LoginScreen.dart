import 'package:chat_app_sat/AppProvider.dart';
import 'package:chat_app_sat/auth/RegisterScreen.dart';
import 'package:chat_app_sat/database/DataBaseHelper.dart';
import 'package:chat_app_sat/extenstions.dart';
import 'package:chat_app_sat/home/HomeScreen.dart';
import 'package:chat_app_sat/model/User.dart' as MyUser;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
class LoginScreen extends StatefulWidget {
  static const ROUTE_NAME = 'Login';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _registerFormKey = GlobalKey<FormState>();
  String password='';
  String email='';
  late AppProvider provider;
  @override
  Widget build(BuildContext context) {
    provider = Provider.of<AppProvider>(context);
    return Stack(
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
                flex: 2,
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
                                email = text;
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
                                password = text;
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
                              createFirebaseUser();
                            }
                          }, child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child:
                        isLoading?
                        Center(child: CircularProgressIndicator(),)
                            : Text('Login'),
                      ))
                      , Spacer(),
                      TextButton(child: Text('Or Create My Account!'),
                      onPressed: (){Navigator.pushReplacementNamed(context, RegisterScreen.ROUTE_NAME);
                      },)
                      , Spacer(),

                    ],

                  ),

                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  bool isLoading=false;
  void createFirebaseUser()async{
    setState(() {
      isLoading=true;
    });
    try {
      UserCredential userCredential = await
      FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password
      );
      if(userCredential.user==null){
        showErrorMessage('invalid credientials no user exist'
            ' with this email and password');
      }else {
        // navigate to home
       getUsersCollectionWithConverter().doc(userCredential.user!.uid)
           .get()
           .then((retrievedUser){
             provider.updateUser(retrievedUser.data());
             Navigator.pushReplacementNamed(context,
             HomeScreen.ROUTE_NAME);
       });
      }
    } on FirebaseAuthException catch (e) {
     showErrorMessage(e.message??'');
    } catch (e) {
      showErrorMessage(e.toString()??'');
    }
    setState(() {
      isLoading=false;
    });

  }
  void showErrorMessage(String error){
    showDialog(context: context, builder:(buildContext){
      return SimpleDialog(
          children: [
            Center(child: Text(error))
          ]
      );
    });
  }
}
