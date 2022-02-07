import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:jobheeseller/components/about_us.dart';
import 'package:jobheeseller/components/app_updates.dart';
import 'package:jobheeseller/components/help.dart';
import 'package:jobheeseller/components/share_with_friends.dart';
import 'package:jobheeseller/constants.dart';
import 'package:jobheeseller/screens/complete_profile/complete_profile_screen.dart';
import 'package:jobheeseller/screens/home/components/user_page.dart';
import 'package:jobheeseller/screens/payments/your_payments.dart';
import 'package:jobheeseller/screens/splash/splash_screen.dart';
import 'package:jobheeseller/utils/image_assets.dart';

class NavigationDrawer extends StatelessWidget {
  final name;
  final urlImage;
  final padding = EdgeInsets.symmetric(horizontal: 20);
  final _auth = FirebaseAuth.instance;

  NavigationDrawer({Key key, this.name, this.urlImage}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: kPrimaryWhiteColor,
        child: ListView(
          children: [
            buildHeader(
              name: name,
              urlImage: urlImage,
              onClicked: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => UserPage(
                    name: name,
                    urlImage: urlImage,
                  ),
                ),
              ),
            ), // end buildHeader
            Container(
              padding: padding,
              color: kPrimaryWhiteColor,
              child: Column(
                children: [
                  Divider(
                    color: Colors.black,
                    height: 2,
                  ),
                  buildMenuItem(
                    text: 'Profile',
                    icon: Icons.account_circle_outlined,
                    onClicked: () => selectedItem(context, 0),
                  ),
                  buildMenuItem(
                    text: 'Payments',
                    icon: Icons.payment,
                    onClicked: () => selectedItem(context, 1),
                  ),
                  buildMenuItem(
                    text: 'Help',
                    icon: Icons.help,
                    onClicked: () => selectedItem(context, 2),
                  ),
                  buildMenuItem(
                    text: 'Share with friends',
                    icon: Icons.share,
                    onClicked: () => selectedItem(context, 3),
                  ),
                  buildMenuItem(
                    text: 'Updates',
                    icon: Icons.update,
                    onClicked: () => selectedItem(context, 4),
                  ),
                  Divider(
                    color: Colors.black,
                  ),
                  buildMenuItem(
                    text: 'About us',
                    icon: Icons.home,
                    onClicked: () => selectedItem(context, 5),
                  ),
                  buildMenuItem(
                    text: 'Logout',
                    icon: Icons.logout,
                    onClicked: () => selectedItem(context, 6),
                  ),
                  Divider(color: Colors.black),
                  SizedBox(height: 5),
                  Container(
                    child: Text(
                      'v 1.0.0',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildHeader({
    String name,
    String urlImage,
    VoidCallback onClicked,
  }) =>
      InkWell(
        onTap: onClicked,
        child: Container(
          color: kPrimaryWhiteColor,
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          child: Row(
            children: [
              CircleAvatar(
                  radius: 60,
                  backgroundImage: (urlImage == null)
                      ? AssetImage(ImagesAsset.profileImage)
                      : NetworkImage(urlImage)),
              SizedBox(width: 20),
              Container(
                child: name != null
                    ? Text(
                        name,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 20, color: Colors.black),
                      )
                    : Text(
                        'No data',
                        style: TextStyle(fontSize: 20, color: Colors.black),
                      ),
              ),
            ],
          ),
        ),
      );

  Widget buildMenuItem({String text, IconData icon, VoidCallback onClicked}) {
    final color = Colors.black;
    final hoverColor = Colors.black38;
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(text, style: TextStyle(color: color)),
      hoverColor: hoverColor,
      onTap: onClicked,
    );
  }

  void selectedItem(BuildContext context, int index) {
    switch (index) {
      case 0:
        Navigator.pushNamed(context, CompleteProfileScreen.routeName);
        break;
      case 1:
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => Payments(),
          ),
        );
        break;
      case 2:
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => Help(),
          ),
        );
        break;
      case 3:
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ShareWithFriends(),
          ),
        );
        break;
      case 4:
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => Updates(),
          ),
        );
        break;
      case 5:
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => AboutUs(),
          ),
        );
        break;
      case 6:
        onTapped(context);
        break;
    }
  }

  void onTapped(context) async {
    await _auth.signOut();
    Navigator.pushNamed(context, SplashScreen.routeName);
  }
}
