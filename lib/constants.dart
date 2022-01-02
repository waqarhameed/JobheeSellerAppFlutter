import 'package:flutter/material.dart';
import 'package:jobheeseller/size_config.dart';

const kPrimaryColor = Color(0xFF00B6F0);
const kPrimaryLightColor = Color(0xFFFFECDF);
const kPrimaryWhiteColor = Color(0xFFFFFFFF);
const kPrimaryGradientColor = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [Color(0xFFFFA53E), Color(0xFFFF7643)],
);
const kSecondaryColor = Color(0xFF979797);
const kTextColor = Color(0xFF757575);

const kAnimationDuration = Duration(milliseconds: 200);

final headingStyle = TextStyle(
  fontSize: getProportionateScreenWidth(28),
  fontWeight: FontWeight.bold,
  color: Colors.black,
  height: 1.5,
);

final fcmKey =
    "AAAA0bwCa1A:APA91bGOUCaHQX2DHALNIw_og0DpW7u-X9UA4s1__YpGy7HalbrnUoADyIGxAScLN6zffOTNYQ7mj8Xpt4o2n00LDx7oOcknUnUmzXkl4AhwtvjiHtcRftAWndxP6PnU7FlGgikhCS2A";
final apiKey = "AIzaSyATqxhwVJGlltWIGxXWECV4BxbLrAABCWE";
const defaultDuration = Duration(milliseconds: 250);

// Form Error
final RegExp emailValidatorRegExp =
    RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
final RegExp textPattern = RegExp('[a-zA-Z]');
const String kEmailNullError = "Please Enter your email";
const String kInvalidEmailError = "Please Enter Valid Email";
const String kPassNullError = "Please Enter your password";
const String kShortPassError = "Password is too short";
const String kMatchPassError = "Passwords don't match";
const String kNameNullError = "Please Enter your name";
const String kBusTypeNullError = "Please enter business type";
const String kBusDescNullError = "Please enter your business description";
const String kMapAddressNullError = "Please select your current location";
const String kPhoneNumberNullError = "Please Enter your phone number";
const String kAddressNullError = "Please Enter your address";
const String kJob = 'kjobhee';
const String kSeller = "seller";

final otpInputDecoration = InputDecoration(
  contentPadding:
      EdgeInsets.symmetric(vertical: getProportionateScreenWidth(15)),
  border: outlineInputBorder(),
  focusedBorder: outlineInputBorder(),
  enabledBorder: outlineInputBorder(),
);

OutlineInputBorder outlineInputBorder() {
  return OutlineInputBorder(
    borderRadius: BorderRadius.circular(getProportionateScreenWidth(15)),
    borderSide: BorderSide(color: kTextColor),
  );
}
