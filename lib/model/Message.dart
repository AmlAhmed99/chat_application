import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class Message {
  String id;
  String messageContent;
  String senderName;
  String senderId;
  DateTime dateTime;

  String getDateFormatted(){
    final df = DateFormat('hh:mm');
    return df.format(dateTime);
  }

  Message({required this.id,required this.messageContent,
    required this.senderName,required this.senderId,
    required this.dateTime}
    );

  Message.fromJson(Map<String, Object?> json)
      : this(
    id: json['id']! as String,
    messageContent: json['messageContent']! as String,
    senderName: json['senderName']! as String,
    senderId: json['senderId']! as String,
    dateTime: DateTime.fromMillisecondsSinceEpoch(json['dateTime']! as int),
  );
  Map<String,Object> toJson(){
    return {
      'id':id,
      'messageContent':messageContent,
      'senderName':senderName,
      'senderId':senderId,
      'dateTime':dateTime.millisecondsSinceEpoch,

    };
  }
}