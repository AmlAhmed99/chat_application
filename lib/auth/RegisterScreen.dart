import 'package:chat_app_sat/AppProvider.dart';
import 'package:chat_app_sat/auth/LoginScreen.dart';
import 'package:chat_app_sat/database/DataBaseHelper.dart';
import 'package:chat_app_sat/extenstions.dart';
import 'package:chat_app_sat/home/HomeScreen.dart';
import 'package:chat_app_sat/model/User.dart' as MyUser;
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
final FirebaseAuth auth = FirebaseAuth.instance;
class RegisterScreen extends StatefulWidget {
  static const ROUTE_NAME = 'register';

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _registerFormKey = GlobalKey<FormState>();
  String password='';
  String email='';
  String userName = '';
  late AppProvider provider;
  @override
  Widget build(BuildContext context) {
    provider =Provider.of<AppProvider>(context);
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
                              userName = text;
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
                        : Text('Create Account'),
                      ))
                  , Spacer(),
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
    );
  }

  final db = FirebaseFirestore.instance;
  bool isLoading=false;
  void createFirebaseUser()async{
    setState(() {
      isLoading=true;
    });
    try {
      UserCredential userCredential = await
      FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: password
      );
      // step2
      final usersCollectionRef = getUsersCollectionWithConverter();
      final user =
      MyUser.User(id: userCredential.user!.uid, userName:userName ,
          email: email);
      usersCollectionRef.doc(user.id)
      .set(user)
      .then((value){
        provider.updateUser(user);
        Navigator.of(context).pushReplacementNamed(HomeScreen.ROUTE_NAME);
        // navigate home Screen

      });

    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        showErrorMessage(e.message??'');
      } else if (e.code == 'email-already-in-use') {
        showErrorMessage(e.message??'');
      }
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
