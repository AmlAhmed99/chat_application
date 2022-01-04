import 'package:chat_app/Screens/addRoom/AddRoom.dart';
import 'package:chat_app/Screens/auth/LoginScreen.dart';
import 'package:chat_app/Screens/auth/RegisterScreen.dart';
import 'package:chat_app/Screens/home/HomeScreen.dart';
import 'package:chat_app/Screens/room/RoomScreen.dart';
import 'package:chat_app/provider/AppProvider.dart';
import 'package:chat_app/styles/chatTheme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  runApp(MyApp());

}
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  //app in background
  print("Handling a background message: ${message.messageId}");
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
          debugShowCheckedModeBanner: false,
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
