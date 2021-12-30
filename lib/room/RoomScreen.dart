import 'package:chat_app_sat/AppProvider.dart';
import 'package:chat_app_sat/database/DataBaseHelper.dart';
import 'package:chat_app_sat/model/Message.dart';
import 'package:chat_app_sat/model/Room.dart';
import 'package:chat_app_sat/room/MessageWidget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class RoomScreen extends StatefulWidget {
  static const routeName = 'Room';

  @override
  _RoomScreenState createState() => _RoomScreenState();
}

class _RoomScreenState extends State<RoomScreen> {
  late Room room;
  late AppProvider provider;
  String messageFieldText = '';
  TextEditingController _editingController =TextEditingController();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    provider = Provider.of<AppProvider>(context);
    room = (ModalRoute.of(context)?.settings.arguments as RoomScreenArgs).room;
    final Stream<QuerySnapshot<Message>> messagesRef =
    getMessagesCollectionWithConverter(room).orderBy('dateTime').snapshots();

    return Stack(
      children: [
      Container(
      color: MyThemeData.white,
    ),
    Image(image: AssetImage('assets/images/bg_top_shape.png'),
    fit: BoxFit.fitWidth,width: double.infinity,),
    Scaffold(
      appBar: AppBar(title: Text(room.name),elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.transparent,),
      backgroundColor: Colors.transparent,
      body: Container(
        width: double.infinity,
        padding: EdgeInsets.all(24),
        child: Column(
          children: [
            Expanded(child:
                StreamBuilder<QuerySnapshot<Message>>(
                  stream: messagesRef,
                  builder: (BuildContext context, AsyncSnapshot<QuerySnapshot<Message>> snapshot){
                    if(snapshot.hasError){
                      return Text(snapshot.error.toString() ??"");
                    }
                    else if (snapshot.hasData){
                      return ListView.builder(itemBuilder: (buildContext,index){
                        return
                          MessageWidget(snapshot.data?.docs[index].data());
                      },itemCount: snapshot.data?.size??0);
                    }
                    return Center(child: CircularProgressIndicator(),);

                  },
                )
            ),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    onChanged: (text){
                      messageFieldText = text;
                    },
                    controller: _editingController,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(4),
                      hintText: 'Type your message',
                      border: OutlineInputBorder(borderRadius: BorderRadius.only(
                        topRight: Radius.circular(12)
                      ))
                    ),
                  ),
                ),
                SizedBox(width: 8,),
                ElevatedButton(onPressed: (){
                  insertMessage(messageFieldText);
                },

                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8,vertical: 12),
                    child: Row(
                    children: [
                      Text('send'),
                     SizedBox(width: 8,),
                     Transform(transform: Matrix4.rotationZ(-45),
                         alignment: Alignment.center,
                         child: Icon(Icons.send_outlined)
                     ),



                    ],
                ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    )]
    );
  }

  void insertMessage(String messageText){
    if(messageText.trim().isEmpty)
      return;
    CollectionReference <Message> messages=
    getMessagesCollectionWithConverter(room);
    DocumentReference <Message> doc = messages.doc();
    Message message =Message(id: doc.id,
        messageContent: messageText,
        senderName: provider.currentUser?.userName??"",
        senderId: provider.currentUser?.id??"",
        dateTime: DateTime.now());
    doc.set(message)
    .then((addedMessage){
      print('in then');
      setState(() {
        print('set  state');
        messageFieldText='';
        _editingController.text='';
      });
    }).onError((error, stackTrace) {
      print('on error');
      Fluttertoast.showToast(msg: error.toString(),
          toastLength: Toast.LENGTH_LONG);
    });

  }
}
class RoomScreenArgs{
  Room room;
  RoomScreenArgs(this.room);
}
