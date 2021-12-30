import 'package:chat_app_sat/AppProvider.dart';
import 'package:chat_app_sat/model/Message.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MessageWidget extends StatelessWidget {
  Message? message;
  MessageWidget(this.message);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AppProvider>(context);
    return message==null? Container():(
      message?.senderId == provider.currentUser?.id ?
          SentMessage(message!):
          RecievedMessage(message!)
    );
  }
}

class SentMessage extends StatelessWidget{
  Message message ;

  SentMessage(this.message);
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(message.getDateFormatted()),
        Container(
            padding: EdgeInsets.all(12),
            margin: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: MyThemeData.primaryColor,
              borderRadius: BorderRadius.only(topRight: Radius.circular(12)
                  ,bottomRight: Radius.circular(12)
                  ,bottomLeft: Radius.circular(12))
            ),
            child: Text(message.messageContent,style: TextStyle(
              color: Colors.white
            ),))
      ],
    );
  }

}
class RecievedMessage extends StatelessWidget{
  Message message ;
  RecievedMessage(this.message);
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(message.senderName),
        Row(
          children: [
            Container(
                padding: EdgeInsets.all(12),
                margin: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 248, 248, 248),
                  borderRadius: BorderRadius.only(topRight: Radius.circular(12)
                      ,bottomRight: Radius.circular(12)
                      ,bottomLeft: Radius.circular(12))
                ),
                child: Text(message.messageContent,
                style: TextStyle(
                    color: Color.fromARGB(255, 120, 121, 147))
                )
            ),
            Text(message.getDateFormatted()),

          ],
        ),
      ],
    );
  }

}
