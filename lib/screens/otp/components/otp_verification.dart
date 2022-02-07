import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:jobheeseller/components/simple_snake_bar.dart';
import 'package:jobheeseller/models/seller_model.dart';
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
  DatabaseReference _firebaseDatabase =
      FirebaseDatabase.instance.ref().child(kJob).child(kSeller);
  BoxDecoration pinOtpCodeDecoration = BoxDecoration(
      color: Colors.blueAccent,
      borderRadius: BorderRadius.circular(10.0),
      border: Border.all(color: Colors.grey));

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    verifyPhoneNumber();
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
                      (value) async {
                        if (value.user != null) {
                          if (value.user.uid != null) {
                            String uuid = value.user.uid;
                            try {
                              await _firebaseDatabase
                                  .child(uuid)
                                  .once()
                                  .then((event) {
                                final data = new Map<String, dynamic>.from(
                                    event.snapshot.value);
                                final result = Seller.fromJson(data);
                                if (result.name != null) {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (c) => HomeScreen()));
                                } else {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (c) => UserRegisterScreen()));
                                }
                              });
                            } catch (e) {
                              print(e);
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (c) => UserRegisterScreen()));
                            }
                          } else {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (c) => UserRegisterScreen()));
                          }
                        }
                      },
                    );
                  } catch (e) {
                    FocusScope.of(context).unfocus();
                    MySnakeBar.createSnackBar('Invalid OTP', context);
                  }
                },
              ),
            ),
            SizedBox(height: SizeConfig.screenHeight * 0.01),
            GestureDetector(
              onTap: () {
                // OTP code resend
                MySnakeBar.createSnackBar('We send the new code', context);
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

  // 321457748
  void verifyPhoneNumber() async {
    try {
      await _auth.verifyPhoneNumber(
          phoneNumber: "${widget.codeDigits + widget.phone}",
          verificationCompleted: (PhoneAuthCredential credential) async {
            await _auth.signInWithCredential(credential).then((value) async {
              if (_auth.currentUser.uid != null) {
                print(" verification completed " + value.user.toString());
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (c) => HomeScreen()));
              }
            }).onError((error, stackTrace) {
              print('verification error ' + error);
            });
            print("verification completed");
          },
          verificationFailed: (FirebaseAuthException e) {
            MySnakeBar.createSnackBar('Unable to verify pin code', context);
            print(" unable to code send ");
          },
          codeSent: (String vId, int resendCode) {
            MySnakeBar.createSnackBar('code send', context);

            setState(() {
              verificationCode = vId;
              print("code send " + verificationCode);
            });
          },
          codeAutoRetrievalTimeout: (String vId) {
            MySnakeBar.createSnackBar('code Auto Retrieval Timeout', context);
            setState(() {
              verificationCode = vId;
              print(" Time out hey");
            });
          },
          timeout: Duration(seconds: 30));
    } catch (e) {
      MySnakeBar.createSnackBar('Exception on ' + e.toString(), context);
    }
  }
}
