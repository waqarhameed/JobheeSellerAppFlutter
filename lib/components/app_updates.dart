import 'package:flutter/material.dart';

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
        backgroundColor: Colors.pink,
        title: Text("Updates"),
        centerTitle: true,
      ),
    );
  }
}
