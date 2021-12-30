import 'package:chat_app_sat/addRoom/AddRoom.dart';
import 'package:chat_app_sat/auth/LoginScreen.dart';
import 'package:chat_app_sat/auth/RegisterScreen.dart';
import 'package:chat_app_sat/AppProvider.dart';
import 'package:chat_app_sat/home/HomeScreen.dart';
import 'package:chat_app_sat/room/RoomScreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // Ideal time to initialize
  //await FirebaseAuth.instance.useAuthEmulator('localhost', 9099);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context){
    return ChangeNotifierProvider(
      create: (context)=>AppProvider(),
      builder: (context,widget){
        final provider  = Provider.of<AppProvider>(context);
        final isLoggedInUser = provider.checkLoggedInUser();
        return MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
              primaryColor: MyThemeData.primaryColor,
              scaffoldBackgroundColor: Colors.transparent
          ),
          routes: {
            LoginScreen.ROUTE_NAME:(buildContext)=>LoginScreen(),
            RegisterScreen.ROUTE_NAME:(buildContext)=>RegisterScreen(),
            HomeScreen.ROUTE_NAME:(buildContext)=>HomeScreen(),
            AddRoom.ROUTE_NAME:(buildContext)=>AddRoom(),
            RoomScreen.routeName:(buildContext)=>RoomScreen(),
          },
          initialRoute:
              isLoggedInUser? HomeScreen.ROUTE_NAME:
              LoginScreen.ROUTE_NAME,
        );
    },
    );
  }
}
