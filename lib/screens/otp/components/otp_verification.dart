import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:jobheeseller/screens/home/home_screen.dart';
import 'package:jobheeseller/screens/user_register/user_registration_screen.dart';
import 'package:pinput/pin_put/pin_put.dart';

import '../../../constants.dart';
import '../../../size_config.dart';

class OtpVerification extends StatefulWidget {
  static String routeName = "/otp";

  final String phone;
  final String codeDigits;

  OtpVerification({this.phone, this.codeDigits});

  @override
  _OtpVerificationState createState() => _OtpVerificationState();
}

class _OtpVerificationState extends State<OtpVerification> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController _pinOtpCodController = TextEditingController();
  final FocusNode _pinOtpCodeFocus = FocusNode();
  FirebaseAuth _auth = FirebaseAuth.instance;
  String verificationCode;

  BoxDecoration pinOtpCodeDecoration = BoxDecoration(
      color: Colors.blueAccent,
      borderRadius: BorderRadius.circular(10.0),
      border: Border.all(color: Colors.grey));

  @override
  void initState() {

    super.initState();
    verifyPhoneNumber();
  }
  @override
  void didChangeDependencies() {

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.only(top: 20),
              child: Image.asset("assets/images/wireless headset.png",
                  width: getProportionateScreenWidth(300),
                  height: getProportionateScreenHeight(265)),
            ),
            Container(
              margin: EdgeInsets.only(top: 10),
              child: Center(
                child: Text(
                  "OTP Verification",
                  style: headingStyle,
                ),
              ),
            ),
            Text("We sent your code to  ${widget.codeDigits}-${widget.phone} "),
            buildTimer(),
            SizedBox(
              height: 30,
            ),
            Padding(
              padding: EdgeInsets.all(40.0),
              child: PinPut(
                fieldsCount: 6,
                textStyle: TextStyle(fontSize: 25.0, color: Colors.white),
                eachFieldWidth: 40.0,
                eachFieldHeight: 55.0,
                focusNode: _pinOtpCodeFocus,
                controller: _pinOtpCodController,
                selectedFieldDecoration: pinOtpCodeDecoration,
                submittedFieldDecoration: pinOtpCodeDecoration,
                followingFieldDecoration: pinOtpCodeDecoration,
                pinAnimationType: PinAnimationType.rotation,
                onSubmit: (pin) async {
                  try {
                    await _auth
                        .signInWithCredential(PhoneAuthProvider.credential(
                            verificationId: verificationCode, smsCode: pin))
                        .then(
                      (value) {
                        if (value.user != null) {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (c) => UserRegisterScreen()));
                        }
                      },
                    );
                  } catch (e) {
                    FocusScope.of(context).unfocus();
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text("Invalid OTP"),
                      duration: Duration(seconds: 3),
                    ));
                  }
                },
              ),
            ),
            SizedBox(height: SizeConfig.screenHeight * 0.01),
            GestureDetector(
              onTap: () {
                // OTP code resend
                verifyPhoneNumber();
                buildTimer();
              },
              child: Text(
                "Resend OTP Code",
                style: TextStyle(decoration: TextDecoration.underline),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Row buildTimer() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("This code will expired in "),
        TweenAnimationBuilder(
          tween: Tween(begin: 30.0, end: 0.0),
          duration: Duration(seconds: 30),
          builder: (_, dynamic value, child) => Text(
            "00:${value.toInt()}",
            style: TextStyle(color: kPrimaryColor),
          ),
        ),
      ],
    );
  }
 //03214577488
  void verifyPhoneNumber() async {
    await _auth.verifyPhoneNumber(
        phoneNumber: "${widget.codeDigits + widget.phone}",
        verificationCompleted: (PhoneAuthCredential credential) async {
          await _auth.signInWithCredential(credential).then((value) async {
            if (_auth.currentUser.uid != null) {
              print(" verification completed " + value.toString());
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (c) => HomeScreen()));
            }
          });
          print("verification completed");
        },
        verificationFailed: (FirebaseAuthException e) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Unable to verify pin code'),
            duration: Duration(seconds: 6),
          ));
          print(" unable to code send ");
        },
        codeSent: (String vId, int resendCode) {
          setState(() {
            verificationCode = vId;
            print("code send " + verificationCode);
          });
        },
        codeAutoRetrievalTimeout: (String vId) {
          setState(() {
            verificationCode = vId;
            print(" Time out hey");
          });
        },
        timeout: Duration(seconds: 30));
  }
}
