
import 'package:chatapp_master/screens/chat/chat.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/chat_usermodel.dart';
import '../../shared/constants.dart';
import 'chathome_states.dart';

class LayoutCubit extends Cubit<LayoutStates>{
  LayoutCubit():super(InitialLayoutstates());
  UserModel2? user;
  void getmydata()async{
    try{
      await FirebaseFirestore.instance.collection('users').doc(Constants.userid!).get().then((value) {
        user=UserModel2.fromjson(value.data()!);
      });
      emit(GetMyDataSuccessState());
    }on FirebaseException catch(e){
      emit(GetMyDataFailuresState());
    }
  }
  String userRole='patient';
  List<UserModel2> users =[];
  List<String> patientsid = [];
  void getpharmacists() async{
    users.clear();
    emit(GetUsersLoadingState());
    try{
      await FirebaseFirestore.instance.collection('users').get().then((value) {
        users.clear();
        for(var item in value.docs){
          if(item.id!=Constants.userid){
            if(item.data()["userRole"]=='Pharmacy')
              {
                users.add(UserModel2.fromjson(item.data()));
              }
          }
        }
      });
      emit(GetUsersDataSuccessState());
    }on FirebaseException catch(e){
      users = [];
      emit(GetUsersDataFailuresState());
    }
  }
  void getallptinets()async{
    users.clear();
    emit(GetUsersLoadingState());
    try{
      await FirebaseFirestore.instance.collection('users').get().then((value) {
        users.clear();
        for(var item in value.docs){
          if(item.id!=Constants.userid){
            if(item.data()["userRole"]=='Patient')
            {
              users.add(UserModel2.fromjson(item.data()));
            }
          }
        }
      });
      emit(GetUsersDataSuccessState());
    }on FirebaseException catch(e){
      users = [];
      emit(GetUsersDataFailuresState());
    }
  }


  void getpatients() async{
    print("patient");
    users.clear();
    emit(GetUsersLoadingState());
    try{
      print("patient");
      getpatientsid();
      int count=0;
      await FirebaseFirestore.instance.collection('users').get().then((value){
        print("patient");
        users.clear();
        for( var item in value.docs)
          {
            print("patient");
            if(item.id==patientsid[count])
              {
                users.add(UserModel2.fromjson(item.data()));
                print(patientsid[count]);
                print("patient");
                count+=1;
              }
          }
      });
    }on FirebaseException catch(e){
      users = [];
      emit(GetUsersDataFailuresState());
    }
  }
  //userrole==patient ? getpharmacists : getpatients ;
  List<UserModel2> usersFiltered = [];
  void searchAboutUser({required String query}){
    usersFiltered = users.where((element) => element.username.toLowerCase().startsWith(query.toLowerCase())).toList();
    emit(FilteredUsersSuccessState());
  }
  bool issearched=false;
  void isserch(){
    issearched=!issearched;
    if( issearched == false ) usersFiltered.clear();
    emit(SearchState());
  }
  void getpatientsid()async{
    patientsid.clear();
    await FirebaseFirestore.instance.collection('users').
    doc(Constants.userid).collection("Chats").
    get().then((value){
      patientsid.clear();
      for(var item in value.docs)
      {
        patientsid.add(item.id.toString());
        print(item.id);
      }
    });
  }



  void getusers(){
    if(Constants.userRole=="Patient"){
      getpharmacists();
      print("getpharmacy");
    }
    else
      {
        getallptinets();
      }
  }

}

