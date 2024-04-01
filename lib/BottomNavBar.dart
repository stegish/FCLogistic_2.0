import 'package:fcmagazzino/VTotale.dart';
import 'package:fcmagazzino/home.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'Trova.dart';
import 'snakBar.dart';
import 'Carica.dart';
import 'MagazzinoCompleto.dart';

class BottomNavBar extends StatefulWidget{
  const BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
  }

  class _BottomNavBarState extends State<BottomNavBar> {

  final PersistentTabController _controller = PersistentTabController(initialIndex: 0); //cambio posizione footBar

  List<Widget> _buildScreens() {
    return [
      const Trova(),
      const Carica(),
      Home(),
      VTotale(),
      VTotale(),
    ];
  }

  void showSnackbar(String titolo, String messaggio, String tipologia){
    GlobalValues.showSnackbar(
        ScaffoldMessenger.of(context) ,titolo ,messaggio ,tipologia );
  }

  //pagine nella footBar
  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: const Icon(CupertinoIcons.download_circle_fill),
        title: ("Trova Pezzo"),
        activeColorPrimary: CupertinoColors.systemRed,
        inactiveColorPrimary: CupertinoColors.black,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(CupertinoIcons.upload_circle_fill),
        title: ("Carica pezzi"),
        activeColorPrimary: CupertinoColors.systemRed,
        inactiveColorPrimary: CupertinoColors.black,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(CupertinoIcons.home),
        title: ("home"),
        activeColorPrimary: CupertinoColors.systemRed,
        inactiveColorPrimary: CupertinoColors.black,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.list),
        title: ("visualizza"),
        activeColorPrimary: CupertinoColors.systemRed,
        inactiveColorPrimary: CupertinoColors.black,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.list),
        title: ("visualizza"),
        activeColorPrimary: CupertinoColors.systemRed,
        inactiveColorPrimary: CupertinoColors.black,
      ),
    ];
  }
@override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      child: Scaffold(
          bottomNavigationBar: PersistentTabView(
            context,
            controller: _controller,
            screens: _buildScreens(),
            items: _navBarsItems(),
            confineInSafeArea: true,
            backgroundColor: Colors.white, // Default is Colors.white.
            handleAndroidBackButtonPress: true, // Default is true.
            resizeToAvoidBottomInset: true, // This needs to be true if you want to move up the screen when keyboard appears. Default is true.
            stateManagement: true, // Default is true.
            hideNavigationBarWhenKeyboardShows: true, // Recommended to set 'resizeToAvoidBottomInset' as true while using this argument. Default is true.
            decoration: NavBarDecoration(
              borderRadius: BorderRadius.circular(10.0),
              colorBehindNavBar: Colors.white,
            ),
            popAllScreensOnTapOfSelectedTab: true,
            popActionScreens: PopActionScreensType.all,
            itemAnimationProperties: const ItemAnimationProperties( // Navigation Bar's items animation properties.
              duration: Duration(milliseconds: 200),
              curve: Curves.ease,
            ),
            screenTransitionAnimation: const ScreenTransitionAnimation( // Screen transition animation on change of selected tab.
              animateTabTransition: true,
              curve: Curves.ease,
              duration: Duration(milliseconds: 200),
            ),
            navBarStyle: NavBarStyle.style16, // Choose the nav bar style with this property.
          )
      ),
    );
  }
}