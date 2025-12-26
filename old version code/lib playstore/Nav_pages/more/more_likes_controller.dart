import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class ChatListController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  RxInt totalUser = 0.obs;

  @override
  void onInit() {
    super.onInit();
    countOfUser();
  }

  Future<void> countOfUser() async {
    try {
      QuerySnapshot snapshot =
      await _firestore.collection('userList').get();

      totalUser.value = snapshot.docs.length;
    } catch (e) {
      print("Error counting users: $e");
    }
  }

  // ✅ Use getter instead of field initializer
  Map<String, dynamic> get openTalk => {
    "name": "Open Talk",
    "image": "https://randomuser.me/api/portraits/lego/1.jpg",
    "lastMessage":"make a connection 💕 ",

    "time": "Now",
    "online": true,
    "isGroup": true,
    "memberCount": totalUser.value, // SAFE
  };


// Individual chat list
  List<Map<String, dynamic>> chatList = [
    {
      "name": "Priya",
      "image": "https://randomuser.me/api/portraits/women/1.jpg",
      "lastMessage": "How are you?",
      "time": "2h ago",
      "unreadCount": 4,
      "online": true,
      "isGroup": false,
    },
    {
      "name": "Anitha",
      "image": "https://randomuser.me/api/portraits/women/2.jpg",
      "lastMessage": "See you soon 😊",
      "time": "5h ago",
      "unreadCount": 2,
      "online": true,
      "isGroup": false,
    },
    {
      "name": "Bala",
      "image": "https://randomuser.me/api/portraits/men/5.jpg",
      "lastMessage": "Ok bro 👍",
      "time": "Yesterday",
      "unreadCount": 1,
      "online": false,
      "isGroup": false,
    },
    {
      "name": "Vintha",
      "image": "https://randomuser.me/api/portraits/women/4.jpg",
      "lastMessage": "How are you?",
      "time": "14h ago",
      "unreadCount": 0,
      "online": false,
      "isGroup": false,
    },
    {
      "name": "Vishnu",
      "image": "https://randomuser.me/api/portraits/men/7.jpg",
      "lastMessage": "Message me",
      "time": "3 days ago",
      "unreadCount": 0,
      "online": false,
      "isGroup": false,
    },
  ];
}