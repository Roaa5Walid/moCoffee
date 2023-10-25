import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:mo/pages/detals/view.dart';
import 'package:mo/pages/manager/view.dart';
import 'package:mo/pages/order/view.dart';

//////mor
class MainNav extends StatefulWidget {
  @override
  _MainNavState createState() => _MainNavState();
}

class _MainNavState extends State<MainNav> {
  int _selectedIndex = 0;

  static List<Widget> _widgetOptions = <Widget>[
   ManagerApp(),
    ChefApp(),
    OrderPage(),

  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff1e81b0),
      /*
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 70.0,
              height: 23,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('asset/image/tamiText.png'),
                  fit: BoxFit.fill,
                ),
              ),
            ),
          ],
        ),
        elevation: 0.0,
        backgroundColor: Color(0xFF1E3799),
        automaticallyImplyLeading: false,
      ),

       */
      body: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
            bottomLeft: Radius.circular(20.0),
            bottomRight: Radius.circular(20.0),
          ),
        ),
        child: Center(
          child: _widgetOptions.elementAt(_selectedIndex),
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.2),
          boxShadow: [
            BoxShadow(
              blurRadius: 20,
              color: Colors.black.withOpacity(.1),
            )
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
            child: GNav(
              rippleColor: Colors.white,
              hoverColor: Colors.black,
              gap: 8,
              activeColor: Colors.white.withOpacity(1),
              iconSize: 24,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              duration: Duration(milliseconds: 400),
              tabBackgroundColor: Color(0xff00b692),
              color: Colors.orange,
              tabs: [
                GButton(
                  icon: Icons.person,
                  text: 'Manager',
                ),
                GButton(
                  icon: Icons.home,
                  text: 'chef',
                ),

                GButton(
                  icon: Icons.inbox_outlined,
                  text: 'Order',
                ),

              ],
              selectedIndex: _selectedIndex,
              onTabChange: (index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
            ),
          ),
        ),
      ),
    );
  }
}