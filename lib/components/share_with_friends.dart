
import 'package:flutter/material.dart';

class ShareWithFriends extends StatefulWidget {
  //const ShareWithFriends({Key key}) : super(key: key);

  @override
  _ShareWithFriendsState createState() => _ShareWithFriendsState();
}

class _ShareWithFriendsState extends State<ShareWithFriends> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pink,
        title: Text("Share With Friends"),
        centerTitle: true,
      ),);
  }
}
