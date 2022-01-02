
import 'package:flutter/material.dart';

import '../constants.dart';

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
        backgroundColor: kPrimaryColor,
        title: Text("Share With Friends"),
        centerTitle: true,
      ),);
  }
}
