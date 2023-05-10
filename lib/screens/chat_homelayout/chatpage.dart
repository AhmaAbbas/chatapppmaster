
import 'package:chatapp_master/screens/chat_homelayout/widgets/chatpubble1.dart';
import 'package:chatapp_master/screens/chat_homelayout/widgets/chatpubble2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../chat contorllers/chatpagecontroller/chatpage_cubit.dart';
import '../../chat contorllers/chatpagecontroller/chatpage_states.dart';
import '../../models/chat_usermodel.dart';
import '../../models/messegmodel.dart';
import '../../shared/constants.dart';

class ChatPage extends StatelessWidget {
   ChatPage({Key? key,required this.user}) : super(key: key);

  TextEditingController chat_controller=TextEditingController();
  final UserModel2 user;
  final controller =ScrollController();
  List<MessageModel> messeges=[];
  @override
  Widget build(BuildContext context) {
    var chatcubit=BlocProvider.of<ChatCubit>(context)..getMessages(receiverID: user.id!);
    return Scaffold(
      appBar: AppBar(title: Text(user.username!),elevation:0,automaticallyImplyLeading: false,),
      body: Column(children: [
        Expanded(child: BlocConsumer<ChatCubit,ChatStats>(
          listener: (context,state) {
            if(state is GetMessagesSuccessState)
            {
              messeges=state.messeges;
              chat_controller.clear();
            }
          },
          builder:(context,state){

            return ListView.builder(
              //reverse: true,
                controller: controller,
                itemCount: chatcubit.messages.length,
                itemBuilder: (context,index){
                  return chatcubit.messages[index].id==Constants.userid?chatbuble(massege: chatcubit.messages[index]):chatbuble2(massege: chatcubit.messages[index]);
                });
          } ,
        )),
        Container(
          padding: EdgeInsets.all(16),
          child: TextField(
            controller:chat_controller ,
            onSubmitted: (data){
              chat_controller.clear();
              controller.animateTo(
                  0,
                  duration: Duration(seconds: 1),
                  curve: Curves.fastOutSlowIn);
            },
            decoration: InputDecoration(
                suffixIcon: IconButton(icon: Icon(Icons.send),onPressed: (){
                  chatcubit.sendmessege(messege: chat_controller.text, reciverid: user.id!);
                  chatcubit.getMessages(receiverID: user.id!);
                },),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(
                        color: Colors.blue
                    )
                )
            ),
          ),
        )
      ],),
    );
  }
}
