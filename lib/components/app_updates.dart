import 'package:flutter/material.dart';

import '../constants.dart';

class Updates extends StatefulWidget {
  //const Updates({Key? key}) : super(key: key);

  @override
  _UpdatesState createState() => _UpdatesState();
}

class _UpdatesState extends State<Updates> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        title: Text("Updates"),
        centerTitle: true,
      ),
    );
  }
}
