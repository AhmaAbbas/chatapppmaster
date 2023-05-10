
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../shared/constants.dart';
import '../shared/database.dart';
import 'chat/conv_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late Future resultsLoaded2;
  List? _snapshotResultsList;
  List _searchResultList = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    resultsLoaded2 = getSnapshots();
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  _onSearchChanged() {
    searchResultsList();
  }

  searchResultsList() {
    var showResults = [];

    if (_searchController.text != "") {
      for (var userSnapshot in _snapshotResultsList!) {
        var title =
            UserModel.fromSnapshot(userSnapshot).userEmail!.toLowerCase();
        if (title.contains(
          _searchController.text.toLowerCase(),
        )) {
          showResults.add(userSnapshot);
        }
      }
    } else {
      showResults = List.from(_snapshotResultsList!);
    }
    setState(
      () {
        _searchResultList = showResults;
      },
    );
  }

  getSnapshots() async {
    var data = await FirebaseFirestore.instance.collection('users').get();
    setState(
      () {
        _snapshotResultsList = data.docs;
      },
    );
    searchResultsList();
    return "complete";
  }

  sendMessage(String email) {
    List<String> users = [Constants.myName, email];

    String chatRoomId = getChatRoomId("email", email);

    Map<String, dynamic> chatRoom = {
      "users": users,
      "chatRoomId": chatRoomId,
    };

    DataBaseMethods().addChatRoom(chatRoom, chatRoomId);

/*    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => Chat(
                  chatRoomId: chatRoomId,
                )));
  }*/
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ConversationScreen()));
  }
  getChatRoomId(String a, String b) {
    if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
      return "$b\_$a";
    } else {
      return "$a\_$b";
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Chats',
        ),
        elevation: 0.0,
        centerTitle: false,
      ),
      body: Container(
        child: Column(
          children: [
            Container(
              height: 70,
              width: double.infinity,
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.grey,
              ),
              child: Row(children: [
                Expanded(
                    child: TextFormField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Email',
                  ),
                )),
                SizedBox(
                  width: 10,
                ),
                CircleAvatar(child: Icon(Icons.search)),
              ]),
            ),
            SizedBox(
              height: 10,
            ),
            _searchController.text.isEmpty
                ? Column(
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        'No Data Found',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    ],
                  )
                : SingleChildScrollView(
                    physics: const ScrollPhysics(),
                    child: SizedBox(
                      height: height * 0.46,
                      child: ListView.separated(
                        physics: const ScrollPhysics(),
                        itemBuilder: (context, index) {
                          var userData = _searchResultList[index];
                          return Container(
                            padding: EdgeInsets.all(10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      userData['userName'],
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      userData['userEmail'],
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                                GestureDetector(
                                  onTap: () async {
                                    sendMessage(userData['userName']);
                                  },
                                  child: Container(
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: Colors.yellow,
                                    ),
                                    child: Center(
                                      child: Text(
                                        'Message',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                        separatorBuilder: (context, index) {
                          return const SizedBox(
                            height: 15,
                          );
                        },
                        itemCount: _searchResultList.length,
                      ),
                    ),
                  )
          ],
        ),
      ),
    );
  }
}
