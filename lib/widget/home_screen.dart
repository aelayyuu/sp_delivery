import 'package:flutter/material.dart';
import 'package:sp_delivery/constant/constant.dart';
import 'package:sp_delivery/model/drawer_model.dart';
import 'package:sp_delivery/page/home_page.dart';
import 'package:sp_delivery/page/profile_page.dart';
import 'package:sp_delivery/widget/sp_drawer_controller.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<HomeScreen> {
  late Widget? screenView;
  late DrawerIndex drawerIndex;
  late AnimationController sliderAnimationController;
  static const String home = 'Home HomePage';
  static const String message = 'Message';
  static const String profile = 'Profile';
  static const String notification = 'Notification';

  @override
  void initState() {
    drawerIndex = DrawerIndex.HOME;

    /// first  Item in drawer
    screenView = const HomePage(
      content: home,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey,
      child: SafeArea(
        top: false,
        bottom: false,
        child: Scaffold(
          drawerScrimColor: Colors.lime,
          body: SpDrawerController(
            animatedIconData: AnimatedIcons.arrow_menu,
            screenIndex: drawerIndex,
            drawerWidth: width * 0.75,
            animationController: (AnimationController animationController) {
              sliderAnimationController = animationController;
            },
            onDrawerCall: (DrawerIndex drawerIndexdata) {
              changeIndex(drawerIndexdata);
            },
            screenView: screenView,
          ),
        ),
      ),
    );
  }

  /// changing current item in drawer

  void changeIndex(DrawerIndex drawerIndexdata) {
    if (drawerIndex != drawerIndexdata) {
      drawerIndex = drawerIndexdata;
      if (drawerIndex == DrawerIndex.HOME) {
        setState(() {
          screenView = const HomePage(
            content: home,
          );
        });
      } else if (drawerIndex == DrawerIndex.Message) {
        setState(() {
          screenView = const HomePage(
            content: message,
          );
        });
      } else if (drawerIndex == DrawerIndex.Profile) {
        setState(() {
          screenView = const ProfilePage(
            content : profile,
          );
        });
      } else if (drawerIndex == DrawerIndex.Notification) {
        setState(() {
          screenView = const HomePage(
            content: notification,
          );
        });
      } else {
        Navigator.of(context).pop();
      }
    }
  }
}
