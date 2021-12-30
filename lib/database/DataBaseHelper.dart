import 'package:chat_app_sat/model/Message.dart';
import 'package:chat_app_sat/model/Room.dart';
import 'package:chat_app_sat/model/User.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

CollectionReference<User> getUsersCollectionWithConverter(){
  return FirebaseFirestore.instance.collection(User.COLLECTION_NAME)
      .withConverter<User>(
    fromFirestore: (snapshot, _) => User.fromJson(snapshot.data()!),
    toFirestore: (user, _) => user.toJson(),
  );

}
CollectionReference<Room> getRoomsCollectionWithConverter(){
  return FirebaseFirestore.instance.collection(Room.COLLECTION_NAME)
      .withConverter<Room>(
    fromFirestore: (snapshot, _) => Room.fromJson(snapshot.data()!),
    toFirestore: (room, _) => room.toJson(),
  );
}
 CollectionReference<Message> getMessagesCollectionWithConverter(Room room){
    DocumentReference<Room>
   roomFireStoreRef = getRoomsCollectionWithConverter()
       .doc(room.id);

    return roomFireStoreRef.collection('messages')
   .withConverter<Message>(  fromFirestore: (snapshot, _) => Message.fromJson(snapshot.data()!),
     toFirestore: (message, _) => message.toJson(),
   );
 }