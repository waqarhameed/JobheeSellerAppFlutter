import 'package:flutter/widgets.dart';
import 'package:jobheeseller/screens/complete_profile/complete_profile_screen.dart';
import 'package:jobheeseller/screens/details/details_screen.dart';
import 'package:jobheeseller/screens/forgot_password/forgot_password_screen.dart';
import 'package:jobheeseller/screens/home/home_screen.dart';
import 'package:jobheeseller/screens/otp/components/otp_verification.dart';
import 'package:jobheeseller/screens/profile/profile_screen.dart';
import 'package:jobheeseller/screens/sign_in/sign_in_screen.dart';
import 'package:jobheeseller/screens/splash/splash_screen.dart';
import 'package:jobheeseller/screens/user_register/user_registration_screen.dart';

import 'screens/sign_up/sign_up_screen.dart';

// We use name route
// All our routes will be available here
final Map<String, WidgetBuilder> routes = {
  SplashScreen.routeName: (context) => SplashScreen(),
  OtpVerification.routeName: (context) => OtpVerification(),
  SignInScreen.routeName: (context) => SignInScreen(),
  ForgotPasswordScreen.routeName: (context) => ForgotPasswordScreen(),
  UserRegisterScreen.routeName: (context) => UserRegisterScreen(),
  SignUpScreen.routeName: (context) => SignUpScreen(),
  CompleteProfileScreen.routeName: (context) => CompleteProfileScreen(),
  OtpVerification.routeName: (context) => OtpVerification(),
  HomeScreen.routeName: (context) => HomeScreen(),
  DetailsScreen.routeName: (context) => DetailsScreen(),
  //CartScreen.routeName: (context) => CartScreen(),
  ProfileScreen.routeName: (context) => ProfileScreen(),
};
