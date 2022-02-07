import 'package:flutter/material.dart';
import 'package:jobheeseller/components/simple_snake_bar.dart';

import '../../size_config.dart';
import 'components/body.dart';

class SplashScreen extends StatelessWidget {
  static String routeName = "/splash";

  @override
  Widget build(BuildContext context) {
    // You have to call it on your starting screen
    SizeConfig().init(context);
    DateTime pre_backPress = DateTime.now();
    return WillPopScope(
      onWillPop: () async {
        final timeGap = DateTime.now().difference(pre_backPress);
        final cantExit = timeGap >= Duration(seconds: 2);
        pre_backPress = DateTime.now();
        if (cantExit) {
          //show snack bar
          MySnakeBar.createSnackBar('press back button again to exit', context);
          return false;
        } else {
          return true;
        }
      },
      child: Scaffold(
        body: Body(),
      ),
    );
  }
}
