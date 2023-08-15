import 'package:flutter/material.dart';

import '../../Features/Home/Screens/tabBarScreens/homeChatScreen.dart';
import '../../Features/Home/Screens/tabBarScreens/profileScreen.dart';

class Constants {
  static const logopath = "assets/images/logo2.png";
  static const googlePath = "assets/images/google.png";

  static const mainColor = Color.fromARGB(255, 107, 23, 128);
  static const whiteColor = Colors.white;
  static const greenColor = Color.fromARGB(255, 51, 212, 57);
  static const darkgreenColor = Color.fromARGB(255, 13, 182, 18);
  static const balckColor = Colors.black;
  static const fontsUsed = 'CaprasimoRegular';
// ?tabbar

  static const feedScreen = [
    Center(
      child: Text('Community'),
    ),
    HomeChatScreen(),
    ProfileSCreen(),
  ];
}

// idea for improvement
// 1) if the user open the app then change it to online??
// 2) edit and delete feature if time limit 10 & 15mins
// 3) Community feature or Channel feature
// 4) push notificaton
// https://www.google.com/search?q=chat%20app%20logo%20png&tbm=isch&tbs=rimg:Cd0byIhSdhUwYThd5yPl9ujasgIMCgIIABAAOgQIARAAwAIA2AIA4AIA&rlz=1C1GGRV_enIN855IN855&hl=en-US&sa=X&ved=0CBoQuIIBahcKEwiw66__rOr_AhUAAAAAHQAAAAAQBg&biw=1583&bih=732
