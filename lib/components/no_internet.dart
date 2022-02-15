import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:jobheeseller/components/simple_snake_bar.dart';

import '../constants.dart';

class NoInternet extends StatelessWidget {
  //const NoInternet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Scaffold(
          appBar: AppBar(
            title: Text('No Internet'),
            centerTitle: true,
            automaticallyImplyLeading: false,
          ),
          body: Center(
            child: Text(
              'Please Check Your Internet Connections',
              style: customTextStyle,
            ),
          ),
        ),
        onWillPop: () async {
          var check = await InternetConnectionChecker().hasConnection;
          if (check == true) {
            MySnakeBar.createSnackBar(Colors.greenAccent, 'Connection Available', context);
            return true;
          }
          return false;
        });
  }
}
