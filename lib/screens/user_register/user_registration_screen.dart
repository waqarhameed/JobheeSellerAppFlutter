import 'package:flutter/material.dart';
import 'package:jobheeseller/screens/user_register/body.dart';

import '../../constants.dart';

class UserRegisterScreen extends StatelessWidget {
  //const UserRegisterScreen({Key? key}) : super(key: key);
  static String routeName = "/user_register";

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: kPrimaryColor,
          title: Text('User Registration'),
        ),
        body: Body(),
      ),
    );
  }
}
