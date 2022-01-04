import 'package:chat_app/Screens/auth/LoginScreen.dart';
import 'package:chat_app/Screens/home/HomeScreen.dart';
import 'package:chat_app/database/DataBaseHelper.dart';
import 'package:chat_app/model/Message.dart';
import 'package:chat_app/model/User.dart' as MyUser;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../model/Room.dart';

class AppProvider extends ChangeNotifier{
  MyUser.User? currentUser;

  bool checkLoggedInUser(){
    final firebaseUser = FirebaseAuth.instance.currentUser;
    if(firebaseUser!=null){
      // retrieve current user data from fire store notify
     //    listeners
      getUsersCollectionWithConverter()
          .doc(firebaseUser.uid).get()
      .then((retUser) {
        if(retUser.data()!=null)
        {
          currentUser=retUser.data();
        }
      });

    }
    return firebaseUser!=null;
  }

  void updateUser(MyUser.User? user){
    currentUser  = user;
    notifyListeners();
  }


  bool isLoading=false;
  void addRoom(
      {
        context,
         required String roomName,
        required String description,
        required String selectedCategory
      }
        ){

      isLoading=true;
    final docRef = getRoomsCollectionWithConverter()
        .doc();
     Room room = Room(id: docRef.id ,
        name: roomName,
        description: description,
        category: selectedCategory);
    docRef.set(room)
        .then((value) {

        isLoading=false;

      Fluttertoast.showToast(msg: 'Room Added Successfully',
          toastLength: Toast.LENGTH_LONG);
      Navigator.pop(context);
    });

      notifyListeners();
  }

  String password='';
  String email='';

  void SigninFirebaseUser(context)async{
      isLoading=true;

    try {
      UserCredential userCredential = await
      FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password
      );
      if(userCredential.user==null){
        showErrorMessage('invalid credientials no user exist'' with this email and password',context);
      }else {
        // navigate to home
        getUsersCollectionWithConverter().doc(userCredential.user!.uid)
            .get()
            .then((retrievedUser){
          updateUser(retrievedUser.data());
          Navigator.pushReplacementNamed(context, HomeScreen.ROUTE_NAME);
        });
      }
    } on FirebaseAuthException catch (e) {
      showErrorMessage(e.message??'',context);
    } catch (e) {
      showErrorMessage(e.toString(),context);
    }
      isLoading=false;
      notifyListeners();

  }

  String createpassword='';
  String createemail='';
  String createuserName = '';

  void createFirebaseUser(context)async{

      isLoading=true;

    try {
      UserCredential userCredential = await
      FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: createemail,
          password: createpassword
      );
      // step2
      final usersCollectionRef = getUsersCollectionWithConverter();
      final user =
      MyUser.User(id: userCredential.user!.uid, userName:createuserName ,
          email: createemail);
      usersCollectionRef.doc(user.id)
          .set(user)
          .then((value){
        updateUser(user);
        Navigator.of(context).pushReplacementNamed(HomeScreen.ROUTE_NAME);
        // navigate home Screen

      });

    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        showErrorMessage(e.message??'',context);
      } else if (e.code == 'email-already-in-use') {
        showErrorMessage(e.message??'',context);
      }
    } catch (e) {
      showErrorMessage(e.toString()??'',context);
    }

      isLoading=false;


  }


  void showErrorMessage(String error,context){
    showDialog(context: context, builder:(buildContext){
      return SimpleDialog(
          children: [
            Center(child: Text(error))
          ]
      );
    });
  }

  late Room room;
  String messageFieldText = '';
  TextEditingController editingController = TextEditingController();
  void insertMessage(String messageText) {
    if (messageText.trim().isEmpty) return;
    CollectionReference<Message> messages =
    getMessagesCollectionWithConverter(room);
    DocumentReference<Message> doc = messages.doc();
    Message message = Message(
        id: doc.id,
        messageContent: messageText,
        senderName: currentUser?.userName ?? "",
        senderId: currentUser?.id ?? "",
        dateTime: DateTime.now());
    doc.set(message).then((addedMessage) {
      print('in then');
        print('set  state');
        messageFieldText = '';
        editingController.text = '';

    }).onError((error, stackTrace) {
      print('on error');
      Fluttertoast.showToast(
          msg: error.toString(), toastLength: Toast.LENGTH_LONG);
    });
  }

    void signOut(context)  {
     FirebaseAuth.instance.signOut().then(
             (value) {
               Navigator.pushReplacementNamed(context, LoginScreen.ROUTE_NAME);
             }).catchError((error){
               print(error.toString());
     });
  }
}