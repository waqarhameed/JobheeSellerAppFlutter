import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jobheeseller/constants.dart';
import 'package:jobheeseller/screens/otp/components/otp_verification.dart';
import 'package:jobheeseller/size_config.dart';

class OtpRegistration extends StatefulWidget {
  @override
  _OtpRegistrationState createState() => _OtpRegistrationState();
}

class _OtpRegistrationState extends State<OtpRegistration> {
  final String countryCode = "+92";
  final _controller = TextEditingController();

  Future<void> onClickOTP(BuildContext context) async {
    if (_controller.text.isEmpty) {
      showErrorDialog(context, 'Contact number can\'t be empty.');
    } else if (validateMobileNumber(_controller.text) == true) {
      String contact = _controller.text;
      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (c) => OtpVerification(
            phone: contact,
            codeDigits: countryCode,
          ),
        ),
      );
    } else {
      showErrorDialog(context, 'Please enter valid mobile number');
    }
  }

  bool validateMobileNumber(String value) {
    if (!mobilePattern.hasMatch(value)) {
      return false;
    }
    return true;
  }

  void showErrorDialog(BuildContext context, String message) {
    // set up the AlertDialog
    final CupertinoAlertDialog alert = CupertinoAlertDialog(
      title: const Text('Error'),
      content: Text('\n$message'),
      actions: <Widget>[
        CupertinoDialogAction(
          isDefaultAction: true,
          child: const Text('OK'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        )
      ],
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: EdgeInsets.only(top: 15),
              child: Image.asset(
                "assets/images/Profile Image.png",
                width: getProportionateScreenWidth(300),
                height: getProportionateScreenHeight(265),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 10),
              child: Center(
                child: Text(
                  "OTP Registration",
                  style: headingStyle,
                ),
              ),
            ),
            SizedBox(
              height: 60,
            ),
            NumberTextField(),
            SizedBox(
              height: 30,
            ),
          ],
        ),
      ),
    );
  }

  Widget NumberTextField() {
    return Container(
      margin: EdgeInsets.symmetric(
          horizontal:
              SizeConfig.screenWidth > 600 ? SizeConfig.screenWidth * 0.2 : 16),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
          color: Colors.white,
          // ignore: prefer_const_literals_to_create_immutables
          boxShadow: [
            const BoxShadow(
              color: Colors.grey,
              offset: Offset(0.0, 1.0), //(x,y)
              blurRadius: 6.0,
            ),
          ],
          borderRadius: BorderRadius.circular(16.0)),
      child: Column(
        children: [
          Container(
            // margin: const EdgeInsets.all(2),
            //padding: const EdgeInsets.symmetric(horizontal: 8.0),
            height: 60,
            decoration: BoxDecoration(
              border: Border.all(
                  //color: Shade.nearlyBlue,
                  ),
              borderRadius: BorderRadius.circular(36),
            ),
            child: Row(
              children: [
                SizedBox(
                  width: 20,
                ),
                Text(
                  "+92",
                ),
                SizedBox(
                  width: 20,
                ),
                Expanded(
                  child: TextField(
                    decoration: const InputDecoration(
                      hintText: 'Contact Number',
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(vertical: 17),
                    ),
                    keyboardType: TextInputType.number,
                    controller: _controller, //  controller has phone number
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(10),
                      FilteringTextInputFormatter.digitsOnly
                    ],
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            height: 20,
          ),
          CustomButton(this.onClickOTP),
        ],
      ),
    );
  }
}

class CustomButton extends StatelessWidget {
  // ignore: prefer_typing_uninitialized_variables
  final onClickOTP;

// ignore: sort_constructors_first
  CustomButton(this.onClickOTP);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onClickOTP(context);
      },
      child: Container(
        margin: const EdgeInsets.all(8),
        height: 45,
        width: double.infinity,
        decoration: BoxDecoration(
          color: kPrimaryColor,
          borderRadius: BorderRadius.circular(36),
        ),
        alignment: Alignment.center,
        child: const Text(
          'Send OTP',
          style: TextStyle(color: Colors.black, fontSize: 16.0),
        ),
      ),
    );
  }
}
