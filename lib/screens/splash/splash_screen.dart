import 'package:flutter/material.dart';

import '../../size_config.dart';
import 'components/body.dart';

// class SplashScreen extends StatefulWidget {
//   //const SplashScreen({Key? key}) : super(key: key);
//   static String routeName = "/splash";
//
//   @override
//   _SplashScreenState createState() => _SplashScreenState();
// }
//
// class _SplashScreenState extends State<SplashScreen> {
//   Future<bool> _onWillPop() async {
//
//     return (await showDialog(
//           context: this.context,
//           builder: (context) => new AlertDialog(
//             title: new Text('Are you sure?'),
//             content: new Text('Do you want to exit an App'),
//             actions: <Widget>[
//               TextButton(
//                 onPressed: () => Navigator.of(context).pop(false),
//                 child: new Text('No'),
//               ),
//               TextButton(
//                 onPressed: () => Navigator.of(context).pop(true),
//                 child: new Text('Yes'),
//               ),
//             ],
//           ),
//
//         )) ??
//         false;
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//     SizeConfig().init(context);
//
//     return WillPopScope(
//       onWillPop: _onWillPop,
//       child: Scaffold(
//         body: Body(),
//       ),
//     );
//   }
// }
//
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
          final snack = SnackBar(
            content: Text('Press Back button again to Exit'),
            duration: Duration(seconds: 2),
          );
          ScaffoldMessenger.of(context).showSnackBar(snack);
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
