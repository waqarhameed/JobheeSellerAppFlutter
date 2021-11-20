import 'package:flutter/material.dart';

import '../constants.dart';
import '../size_config.dart';

class DefaultButton extends StatelessWidget {
  const DefaultButton({
    Key key,
    this.text,
    this.press,
  }) : super(key: key);
  final String text;
  final Function press;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: getProportionateScreenHeight(60),
      child: TextButton(
        style: TextButton.styleFrom(
          padding: EdgeInsets.all(10),
          alignment: Alignment.center,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          primary: Colors.white,
          backgroundColor: kPrimaryColor,
        ),
        onPressed: press as void Function(),

        child: Text(
          text,
          style: TextStyle(
            fontSize: getProportionateScreenWidth(18),
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}

// GestureDetector(
//   onTap: press as void Function(),
//
//   child: Container(
//     margin: const EdgeInsets.all(8),
//     height: 45,
//     width: double.infinity,
//     decoration: BoxDecoration(
//       color: kPrimaryColor,
//       borderRadius: BorderRadius.circular(36),
//     ),
//     alignment: Alignment.center,
//     child: Text(
//       text,
//       style: TextStyle(color: Colors.black, fontSize: 16.0),
//     ),
//   ),
// );
