
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
  List<UserModel2> users = [];
  void getusers() async{
    users.clear();
    emit(GetUsersLoadingState());
    try{
      await FirebaseFirestore.instance.collection('users').get().then((value) {
        users.clear();
        for(var item in value.docs){
          if(item.id!=Constants.userid){
            users.add(UserModel2.fromjson(item.data()!));
          }
        }
      });
      emit(GetUsersDataSuccessState());
    }on FirebaseException catch(e){
      users = [];
      emit(GetUsersDataFailuresState());
    }
  }
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
}