import 'package:chat_app_sat/AppProvider.dart';
import 'package:chat_app_sat/database/DataBaseHelper.dart';
import 'package:chat_app_sat/model/Room.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AddRoom extends StatefulWidget {
  static const String ROUTE_NAME = 'addRoom';

  @override
  _AddRoomState createState() => _AddRoomState();
}

class _AddRoomState extends State<AddRoom> {
  final _addRoomFormKey = GlobalKey<FormState>();

  String roomName = '';

  String description = '';

  List<String> categories= ['movies','sports','music'];

  String selectedCategory='sports';

  bool isLoading=false;

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
      centerTitle: true,
      elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Center(
        child: Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            color: MyThemeData.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey,
                blurRadius: 4,
                offset: Offset(4, 8), // Shadow position
              ),
            ]
          ),
          margin: EdgeInsets.symmetric(vertical: 32,horizontal: 12),
          child: ListView(
        //    crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('Create New Room',style: TextStyle(
                color: Colors.black,
                fontSize: 24,
                fontWeight: FontWeight.bold
              ),
              textAlign: TextAlign.center,
              ),
              Image(image: AssetImage('assets/images/add_room_header.png')),
              Form(
                key: _addRoomFormKey,
                child: Column(
                  children: [
                    TextFormField(
                      onChanged: (text){
                        roomName = text;
                      },
                      keyboardType: TextInputType.name,

                      decoration: InputDecoration(
                          labelText: 'Room Name',
                          floatingLabelBehavior: FloatingLabelBehavior.auto
                      ),
                      // The validator receives the text that the user has entered.
                      validator: (String? value) {
                        if (value == null || value.isEmpty ) {
                          return 'Please enter Room Name';
                        }
                        return null;
                      },
                    ),


                    TextFormField(
                      onChanged: (text){
                        description = text;
                      },
                      decoration: InputDecoration(
                        labelText: 'description',
                        floatingLabelBehavior: FloatingLabelBehavior.auto,
                      ),
                      // The validator receives the text that the user has entered.
                      validator: (String? value) {
                        if (value == null || value.isEmpty ) {
                          return 'Please enter room Description';
                        }
                        return null;
                      },
                    )
                  ],
                ),
              ),
              DropdownButton(
                value: selectedCategory,
                  iconSize: 24,
                  elevation: 16,
                  items: categories.map((name) {
                    return   DropdownMenuItem(
                        value: name,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                      children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Image(image: AssetImage('assets/images/$name.png',),
                              width: 24,height: 24,),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(name),
                          )
                      ],
                    ),
                        ));
                  }).toList(),
                onChanged: (newSelected){
                  setState(() {
                    selectedCategory = newSelected as String;
                  });
                },
                  ),
            ElevatedButton(onPressed: (){
              if(_addRoomFormKey.currentState?.validate()==true){
                addRoom();
              }
              },
                child: isLoading?Center(child:CircularProgressIndicator() ,):
                Text('Create'))

            ],
          ),
        ),
      ),
    )
    ]);
  }
  void addRoom(){
    setState(() {
      isLoading=true;
    });
    final docRef = getRoomsCollectionWithConverter()
        .doc();
    Room room = Room(id: docRef.id ,
        name: roomName,
        description: description,
        category: selectedCategory);
    docRef.set(room)
    .then((value) {
      setState(() {
        isLoading=false;
      });
      Fluttertoast.showToast(msg: 'Room Added Successfully',
      toastLength: Toast.LENGTH_LONG);
      Navigator.pop(context);
    });
  }
}
