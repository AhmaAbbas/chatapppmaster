
import 'package:chatapp_master/models/chat_usermodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../chat contorllers/chathome_controller/chathome_cubit.dart';
import '../../chat contorllers/chathome_controller/chathome_states.dart';
import '../../shared/usable/customtextformfeild.dart';
import 'chatpage.dart';



class ChatHome extends StatelessWidget {
  const ChatHome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var layoutCubit = BlocProvider.of<LayoutCubit>(context)
      ..getmydata()..getusers();
    return SafeArea(
        child: BlocConsumer<LayoutCubit, LayoutStates>(
          listener: (context, state) {},
          builder: (context, state) {
            return Scaffold(
                appBar: AppBar(
                  title: layoutCubit.issearched?CustomTextFormFeild(
                    label_text: 'serach user',
                    onchaged: (value){
                      layoutCubit.searchAboutUser(query: value);
                    },
                  ):const Text("Users"),
                  actions: [IconButton(onPressed: (){
                    layoutCubit.isserch();
                  }, icon: layoutCubit.issearched?Icon(Icons.clear):Icon(Icons.search))],
                ),
                body: layoutCubit.users.isEmpty
                    ? const Center(
                  child: Text("Net users"),
                )
                    : Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: state is GetUsersLoadingState ?const Center(child: CircularProgressIndicator(),):
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListView.separated(
                        separatorBuilder: (context, index) => const SizedBox(
                          height: 18,
                        ),
                        itemCount: layoutCubit.usersFiltered.isEmpty?layoutCubit.users.length:layoutCubit.usersFiltered.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context){
                                print(layoutCubit.patientsid[index]);
                                return ChatPage(
                                  user:layoutCubit.usersFiltered.isEmpty?
                                  layoutCubit.users[index]:
                                  layoutCubit.usersFiltered[index],);
                              }));
                            },
                            child: item_use(
                              user: layoutCubit.usersFiltered.isEmpty?layoutCubit.users[index]:layoutCubit.usersFiltered[index],
                            ),
                          );
                        }),
                  ),
                ));
          },
        ));
  }
}

class item_use extends StatelessWidget {
  const item_use({
    super.key,
    required this.user,
  });
  final UserModel2 user;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      trailing: Icon(Icons.message_outlined),
        contentPadding: EdgeInsets.zero,
        subtitle: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Text(user.userRole.toString(),),
        ),
        title: Text(user.username));
  }
}
