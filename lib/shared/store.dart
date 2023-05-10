
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/chat_usermodel.dart';



class Store {
  User? user = FirebaseAuth.instance.currentUser;
  FirebaseFirestore fireStore = FirebaseFirestore.instance;


  /// After Sign in Update User Information In Firebase Firestore
  Future addUser(UserModel2 user) async {

    fireStore.collection('users').doc(user.id).set(
      {
        'userId': user.id,
        'userName': user.username,
        'userEmail': user.email,
        'userPhone': user.userPhone,
        'userRole': user.userRole,
      },
    );
  }


  
}
