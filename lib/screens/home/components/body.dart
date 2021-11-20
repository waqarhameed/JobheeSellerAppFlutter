import 'package:flutter/material.dart';

import '../../../size_config.dart';
import 'categories.dart';
import 'discount_banner.dart';
import 'home_header.dart';
import 'popular_product.dart';
import 'special_offers.dart';

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: getProportionateScreenHeight(20)),
            HomeHeader(),
            SizedBox(height: getProportionateScreenWidth(10)),
            DiscountBanner(),
            Categories(),
            SpecialOffers(),
            SizedBox(height: getProportionateScreenWidth(30)),
            PopularProducts(),
            SizedBox(height: getProportionateScreenWidth(30)),
          ],
        ),
      ),
    );
  }

    // void changeIndex(DrawerIndex drawerIndexdata) {
    //   if (drawerIndex != drawerIndexdata) {
    //     drawerIndex = drawerIndexdata;
    //     if (drawerIndex == DrawerIndex.HOME) {
    //       setState(() {
    //         screenView = const MyHomePage();
    //       });
    //     } else if (drawerIndex == DrawerIndex.AllOrder) {
    //       setState(() {
    //         screenView = AllOrders();
    //       });
    //     } else if (drawerIndex == DrawerIndex.AddOrder) {
    //       setState(() {
    //         screenView = AddOrder();
    //       });
    //     } else if (drawerIndex == DrawerIndex.CurrentOrder) {
    //       setState(() {
    //         screenView = CurrentOrder();
    //       });
    //     } else if (drawerIndex == DrawerIndex.PurchaseHistory) {
    //       setState(() {
    //         screenView = HelpScreen();
    //       });
    //     } else if (drawerIndex == DrawerIndex.Profile) {
    //       setState(() {
    //         screenView = ProfileScreen();
    //       });
    //     } else if (drawerIndex == DrawerIndex.Help) {
    //       setState(() {
    //         screenView = HelpScreen();
    //       });
    //     } else if (drawerIndex == DrawerIndex.Invite) {
    //       setState(() {
    //         screenView = InviteFriend();
    //       });
    //     } else if (drawerIndex == DrawerIndex.About) {
    //       setState(() {
    //         screenView = About();
    //       });
    //     }
    //     else {
    //       //do in your way......
    //     }

}
