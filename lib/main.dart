
import 'package:chatapp_master/shared/constants.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'chat contorllers/chathome_controller/chathome_cubit.dart';
import 'chat contorllers/chatpagecontroller/chatpage_cubit.dart';
import 'screens/main_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final sharedPref = await SharedPreferences.getInstance();
  Constants.userid = sharedPref.getString('userID');
  await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyDdRXrkocrXopW9UsseuvpYHzz7XMf5s84",
          appId: "chat-app-c886b",
          messagingSenderId: "messagingSenderId",
          projectId: "chat-app-c886b"));
  runApp(
    const Home(),
  );
}

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context)=>LayoutCubit()),
        BlocProvider(create: (context)=>ChatCubit()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          fontFamily: "Courgette",
          primarySwatch: Colors.indigo,
        ),
        home: const FirstScreen(),
      ),
    );
  }
}
