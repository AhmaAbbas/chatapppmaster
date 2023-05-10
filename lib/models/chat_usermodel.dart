class UserModel2{
  String username;
  String? email;
  String? userPhone;
  String? userRole;
  String? id;
  UserModel2({required this.username, required  this.email, required  this.userPhone, required this.id,required  this.userRole});
  factory UserModel2.fromjson(Map<String,dynamic> json )
  {
    return UserModel2(
        username: json["userName"],
        email: json['userEmail'],
        userPhone: json['userPhone'],
        id: json['userId'],
      userRole:json['userRole'],
    );
  }
  Map<String,dynamic> tojson(){
    return {
      'userName':username,
      'userRole':userRole,
      'userEmail':email,
      'userPhone':userPhone,
      'userId':id,
    };
  }
}