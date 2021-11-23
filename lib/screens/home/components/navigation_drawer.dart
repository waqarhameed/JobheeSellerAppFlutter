import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:jobheeseller/components/app_updates.dart';
import 'package:jobheeseller/components/coustom_bottom_nav_bar.dart';
import 'package:jobheeseller/components/help.dart';
import 'package:jobheeseller/components/share_with_friends.dart';
import 'package:jobheeseller/constants.dart';
import 'package:jobheeseller/screens/complete_profile/complete_profile_screen.dart';
import 'package:jobheeseller/screens/home/components/user_page.dart';
import 'package:jobheeseller/screens/payments/your_payments.dart';
import 'package:jobheeseller/screens/sign_in/sign_in_screen.dart';

class NavigationDrawer extends StatelessWidget {
//   //const NavigationDrawer({Key? key}) : super(key: key);
//
//   @override
//   _NavigationDrawerState createState() => _NavigationDrawerState();
// }
//
// class _NavigationDrawerState extends State<NavigationDrawer> {

  final padding = EdgeInsets.symmetric(horizontal: 20);
  final _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    final name = 'test1';
    final email = 'test@gamil.com';
    final urlImage =
        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSPlqk-tNmFTjT7q_edAjaYLU5qf2cFUM9vfrweUbqnS_58LqF7AMp67KVdslIubuzy9b4&usqp=CAU';

    return Drawer(
      child: Container(
        color: kPrimaryLightColor,
        child: ListView(
          children: [
            buildHeader(
              urlImage: urlImage,
              name: name,
              email: email,
              onClicked: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => UserPage(
                    name: 'Himura Kenshan',
                    urlImage: urlImage,
                  ),
                ),
              ),
            ), // end buildHeader
            const SizedBox(
              height: 30,
            ),
            Container(
              padding: padding,
              child: Column(
                children: [
                  Divider(
                    color: Colors.white,
                    height: 2,
                  ),
                  const SizedBox(height: 10),
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
                  SizedBox(height: 10),
                  Divider(
                    color: Colors.white,
                  ),
                  SizedBox(height: 10),
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
                  Divider(color: Colors.white),
                  SizedBox(height: 10),
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
    String urlImage,
    String name,
    String email,
    VoidCallback onClicked,
  }) =>
      InkWell(
        onTap: onClicked,
        child: Container(
          padding: padding.add(EdgeInsets.symmetric(vertical: 40)),
          child: Row(
            children: [
              CircleAvatar(radius: 30, backgroundImage: NetworkImage(urlImage)),
              SizedBox(width: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    email,
                    style: TextStyle(fontSize: 14, color: Colors.white),
                  ),
                ],
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
            builder: (context) => CustomBottomNavBar(),
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
    Navigator.pushNamed(context, SignInScreen.routeName);
  }
}
