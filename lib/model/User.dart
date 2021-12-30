class User{
  static const String COLLECTION_NAME ='users';
  String id;
  String userName;
  String email;
  User({required this.id,required this.userName,
    required this.email});
  User.fromJson(Map<String, Object?> json)
      : this(
    id: json['id']! as String,
    userName: json['userName']! as String,
    email: json['email']! as String,
  );
  Map<String,Object> toJson(){
    return {
      'id':id,
      'userName':userName,
      'email':email
    };
  }
}