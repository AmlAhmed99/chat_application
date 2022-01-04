import 'dart:io';
import 'package:chat_app/Screens/addRoom/AddRoom.dart';
import 'package:chat_app/Screens/home/RoomWidget.dart';
import 'package:chat_app/database/DataBaseHelper.dart';
import 'package:chat_app/model/Room.dart';
import 'package:chat_app/provider/AppProvider.dart';
import 'package:chat_app/styles/chatTheme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  static const String ROUTE_NAME='home';
  late CollectionReference<Room> roomsCollectionRef ;

  HomeScreen() {
    roomsCollectionRef = getRoomsCollectionWithConverter();
  }

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initFirebaseCloudMessaging();
  }
  void initFirebaseCloudMessaging(){
    CongigIOSPlatform();
    retrievToken();
    AndroidPlatform();
    //app in foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');

      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification}');
      }
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;

      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                channel.description,
                icon:'ic_notification',
                // other properties...
              ),
            ));
      }
    });




  }

  FirebaseMessaging messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

   void CongigIOSPlatform() async{
     if(Platform.isIOS)
     NotificationSettings settings = await messaging.requestPermission(
       alert: true,
       announcement: false,
       badge: true,
       carPlay: false,
       criticalAlert: false,
       provisional: false,
       sound: true,
     );
   }
   void retrievToken() async{
     String? token = await messaging.getToken();
     print('${token}');
   }
   void AndroidPlatform() async{
     if(Platform.isAndroid) {
       await flutterLocalNotificationsPlugin
           .resolvePlatformSpecificImplementation<
           AndroidFlutterLocalNotificationsPlugin>()
           ?.createNotificationChannel(channel);
     }
   }
   AndroidNotificationChannel channel = AndroidNotificationChannel(
    'messages channel', // id
    'High Importance Notifications', // title
    'This channel is used for important notifications.', // description
    importance: Importance.max,
  );
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: [
        Container(
        color: MyThemeData.white,
      ),
      Image(image: AssetImage('assets/images/bg_top_shape.png'),
      fit: BoxFit.fitWidth,width: double.infinity,),
      Scaffold(
        appBar: AppBar(title: Text('Chat App'),
            elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
          icon: Icon(Icons.login),
          onPressed: (){
            Provider.of<AppProvider>(context,listen: false).signOut(context);
          },
        )],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: (){
            Navigator.pushNamed(context,AddRoom.ROUTE_NAME);
          },
          child: Icon(Icons.add),
        ),
        body: Container(
          margin: EdgeInsets.only(top:64 ,bottom:12,left: 12,right: 12 ),
          child: FutureBuilder<QuerySnapshot<Room> >(
            future: widget.roomsCollectionRef.get(),
            builder: (BuildContext context,
                AsyncSnapshot<QuerySnapshot<Room>> snapshot){
              if(snapshot.hasError){
                return Text('something went wrong');
              }
              else if (snapshot.connectionState == ConnectionState.done) {
                final List<Room>roomsList = snapshot.data?.docs.map((singleDoc) =>singleDoc.data())
                .toList()??[];
                return
                    GridView.builder(gridDelegate:
                    SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 4,
                      mainAxisSpacing: 4,
                    ),
                        itemBuilder: (buildContext,index){
                      return RoomWidget(roomsList[index]);
                    },itemCount:roomsList.length ,);
               }
              return Center(child: CircularProgressIndicator(),);
            },
          ),
        ),

      )]
      ),
    );
  }
}
