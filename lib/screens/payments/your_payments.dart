import 'package:flutter/material.dart';

class Payments extends StatefulWidget {
  //const Payments({Key? key}) : super(key: key);

  @override
  _PaymentsState createState() => _PaymentsState();
}

class _PaymentsState extends State<Payments> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pink,
        title: Text("Payments"),
        centerTitle: true,
      ),
    );
  }
}
