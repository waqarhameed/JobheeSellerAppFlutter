import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:jobheeseller/components/simple_snake_bar.dart';
import 'package:jobheeseller/handler/firebase_notification_handler.dart';

class CurrentOrder extends StatefulWidget {
  //const CurrentOrder(String route, {Key key}) : super(key: key);

  @override
  _CurrentOrderState createState() => _CurrentOrderState();
}

class _CurrentOrderState extends State<CurrentOrder> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            final check = await InternetConnectionChecker().hasConnection;
            if (check == true) {
              // await FirebaseNotifications
              //     .sendPushMessage();
              // await FirebaseNotifications.sendFcmMessage(
              //     'New Order',
              //     'From Seller accepted',
              //     "fgt8l6mTSTGOiwXsuA83Y6:APA91bFoNp5zE5yoHqGbSnk93jcTIKTP1DGiU5vMIpslWS5-tYaPOtBop4QFrTy_ZGF8eGxesX1_p4YnYEL2JrFBCQQ1bE8W0hM6gu7bV9K5_h5fqyywXEzqqI1guG1s4jzx224Cv0Gt",
              //     'HomeScreen');

              // Navigator.push(
              //     context,
              //     MaterialPageRoute(
              //       builder: (context) =>
              //           HomeScreen(
              //               sellerData:
              //                   seller.uuid),
              //     ));
            } else {
              MySnakeBar.createSnackBar(
                  Colors.red, "No internet connections", context);
            }
          },
          child: Text('Send Order'),
        ),
      ),
    );
  }
}
