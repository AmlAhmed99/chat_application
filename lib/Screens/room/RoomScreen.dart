import 'package:chat_app/Screens/room/MessageWidget.dart';
import 'package:chat_app/provider/AppProvider.dart';
import 'package:chat_app/database/DataBaseHelper.dart';
import 'package:chat_app/model/Message.dart';
import 'package:chat_app/model/Room.dart';
import 'package:chat_app/styles/chatTheme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class RoomScreen extends StatelessWidget {
  static const routeName = 'Room';

  late AppProvider provider;

  @override
  Widget build(BuildContext context) {
    provider = Provider.of<AppProvider>(context);
    provider.room = (ModalRoute.of(context)?.settings.arguments as RoomScreenArgs).room;
    final Stream<QuerySnapshot<Message>> messagesRef =
        getMessagesCollectionWithConverter(provider.room)
            .orderBy('dateTime')
            .snapshots();

    return SafeArea(
      child: Stack(children: [
        Container(
          color: MyThemeData.white,
        ),
        Image(
          image: AssetImage('assets/images/bg_top_shape.png'),
          fit: BoxFit.fitWidth,
          width: double.infinity,
        ),
        Scaffold(
          appBar: AppBar(
            title: Text(provider.room.name),
            elevation: 0,
            centerTitle: true,
            backgroundColor: Colors.transparent,
          ),
          backgroundColor: Colors.transparent,
          body: Container(
            width: double.infinity,
            padding: EdgeInsets.all(24),
            child: Column(
              children: [
                Expanded(
                    child: StreamBuilder<QuerySnapshot<Message>>(
                  stream: messagesRef,
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot<Message>> snapshot) {
                    if (snapshot.hasError) {
                      return Text(snapshot.error.toString() );
                    } else if (snapshot.hasData) {
                      return ListView.builder(
                          itemBuilder: (buildContext, index) {
                            return MessageWidget(
                                snapshot.data?.docs[index].data());
                          },
                          itemCount: snapshot.data?.size ?? 0);
                    }
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  },
                )),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        onChanged: (text) {
                          provider.messageFieldText = text;
                        },
                        controller: provider.editingController,
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.all(4),
                            hintText: 'Type your message',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(12)))),
                      ),
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        provider.insertMessage(provider.messageFieldText);
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 12),
                        child: Row(
                          children: [
                            Text('send'),
                            SizedBox(
                              width: 8,
                            ),
                            Transform(
                                transform: Matrix4.rotationZ(-45),
                                alignment: Alignment.center,
                                child: Icon(Icons.send_outlined)),
                          ],
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        )
      ]),
    );
  }

}

class RoomScreenArgs {
  Room room;
  RoomScreenArgs(this.room);
}
