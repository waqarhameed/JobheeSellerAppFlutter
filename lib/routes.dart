import 'package:flutter/widgets.dart';
import 'package:jobheeseller/screens/complete_profile/complete_profile_screen.dart';
import 'package:jobheeseller/screens/details/details_screen.dart';
import 'package:jobheeseller/screens/home/home_screen.dart';
import 'package:jobheeseller/screens/otp/components/otp_verification.dart';
import 'package:jobheeseller/screens/profile/profile_screen.dart';
import 'package:jobheeseller/screens/splash/splash_screen.dart';
import 'package:jobheeseller/screens/user_register/user_registration_screen.dart';


// We use name route
// All our routes will be available here
final Map<String, WidgetBuilder> routes = {
  SplashScreen.routeName: (context) => SplashScreen(),
  OtpVerification.routeName: (context) => OtpVerification(),
  //ForgotPasswordScreen.routeName: (context) => ForgotPasswordScreen(),
  UserRegisterScreen.routeName: (context) => UserRegisterScreen(),
  CompleteProfileScreen.routeName: (context) => CompleteProfileScreen(),
  OtpVerification.routeName: (context) => OtpVerification(),
  HomeScreen.routeName: (context) => HomeScreen(),
  DetailsScreen.routeName: (context) => DetailsScreen(),
  ProfileScreen.routeName: (context) => ProfileScreen(),
};
