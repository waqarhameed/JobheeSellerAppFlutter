import 'package:bubble_bottom_bar/bubble_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:jobheeseller/constants.dart';
import 'package:jobheeseller/screens/completed_orders/complete_orders.dart';
import 'package:jobheeseller/screens/current_order/current_order.dart';
import 'package:jobheeseller/screens/home/components/navigation_drawer.dart';

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: NavHeader(),
    );
  }
}

class NavHeader extends StatefulWidget {
  //const NavHeader({Key key}) : super(key: key);

  @override
  _NavHeaderState createState() => _NavHeaderState();
}

class _NavHeaderState extends State<NavHeader> {
  int currentIndex = 0;

  void changePage(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
      ),
      drawer: NavigationDrawer(),
      body: <Widget>[
        CurrentOrder(),
        CompletedOrders(),
      ][currentIndex],
      bottomNavigationBar: BubbleBottomBar(
        opacity: 0,
        currentIndex: currentIndex,
        onTap: changePage,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        elevation: 8,
        items: <BubbleBottomBarItem>[
          BubbleBottomBarItem(
              backgroundColor: Colors.black,
              icon: SvgPicture.asset(
                'assets/icons/Flash Icon.svg',
                width: 21,
                color: Colors.black54,
                height: 21,
              ),
              activeIcon: SvgPicture.asset(
                'assets/icons/Flash Icon.svg',
                width: 21,
                height: 21,
                color: Colors.black,
              ),
              title: const Text("Current Orders")),
          BubbleBottomBarItem(
              backgroundColor: Colors.black,
              icon: SvgPicture.asset(
                'assets/icons/Gift Icon.svg',
                width: 21,
                color: Colors.black54,
                height: 21,
              ),
              activeIcon: SvgPicture.asset(
                'assets/icons/Gift Icon.svg',
                width: 21,
                height: 21,
                color: Colors.black,
              ),
              title: const Text("Completed Orders")),
        ],
      ),
    );
  }
}
