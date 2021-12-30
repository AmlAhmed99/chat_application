import 'package:chat_app_sat/AppProvider.dart';
import 'package:chat_app_sat/addRoom/AddRoom.dart';
import 'package:chat_app_sat/database/DataBaseHelper.dart';
import 'package:chat_app_sat/home/RoomWidget.dart';
import 'package:chat_app_sat/model/Room.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  static const String ROUTE_NAME='home';
  late CollectionReference<Room> roomsCollectionRef ;

  HomeScreen() {
    roomsCollectionRef = getRoomsCollectionWithConverter();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
      Container(
      color: MyThemeData.white,
    ),
    Image(image: AssetImage('assets/images/bg_top_shape.png'),
    fit: BoxFit.fitWidth,width: double.infinity,),
    Scaffold(
      appBar: AppBar(title: Text('Route Chat App'),
          elevation: 0,
      centerTitle: true,
      backgroundColor: Colors.transparent,),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.pushNamed(context,AddRoom.ROUTE_NAME);
        },
        child: Icon(Icons.add),
      ),
      body: Container(
        margin: EdgeInsets.only(top:64 ,bottom:12,left: 12,right: 12 ),
        child: FutureBuilder<QuerySnapshot<Room> >(
          future: roomsCollectionRef.get(),
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
    );
  }
}
