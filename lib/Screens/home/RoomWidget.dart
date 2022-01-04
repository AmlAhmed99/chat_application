import 'package:chat_app/Screens/room/RoomScreen.dart';
import 'package:chat_app/provider/AppProvider.dart';
import 'package:chat_app/model/Room.dart';
import 'package:chat_app/styles/chatTheme.dart';
import 'package:flutter/material.dart';

class RoomWidget extends StatelessWidget {
  Room room;
  RoomWidget(this.room);
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        Navigator.of(context).pushNamed(RoomScreen.routeName,
        arguments: RoomScreenArgs(room));
      },
      child: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
            color: MyThemeData.white,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 4,
                offset: Offset(4, 8), // Shadow position
              ),
            ]),
        child:
        Center(
          child: Column(
            children: [
              Image(image: AssetImage('assets/images/${room.category}.png'),
                height: 120,
                fit: BoxFit.fitHeight,
              ),
              Text(room.name,style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 24
              ),)
            ],
          ),
        ),
      ),
    );
  }
}
