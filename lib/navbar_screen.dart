import 'package:crypto_map/main.dart';
import 'package:crypto_map/price_screen.dart';
import 'package:crypto_map/trends_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:crypto_map/venues_screen.dart';
import 'package:crypto_map/map_screen.dart';

class NavBarScreen extends StatefulWidget {
  NavBarScreen({Key key}) : super(key: key);
  @override
  _NavBarScreenState createState() => _NavBarScreenState();
}

class _NavBarScreenState extends State<NavBarScreen> {
  int currentIndex = 2;

  PageController _pageController = PageController();
  //List of all the pages the NavBar will lead to. If new pages are added to the navbar
  //they must be added here too.
  List<Widget> _screens = [
    PriceScreen(),
    TrendsScreen(),
    MapScreen(),
    VScreen()
  ];

  //currentIndex is set to the index of the current page when page is changed.
  void _onPageChanged(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  //Changes the page when an item in the navbar is selected.
  void _onItemTapped(int selectedIndex) {
    _pageController.jumpToPage(selectedIndex);
  }

  //Builds the navbar.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(40.0),
          child: AppBar(
            title: Text(
              'CryptoMap',
              style: GoogleFonts.monda(
                color: Color(0xFF00858A),
              ),
            ),
            centerTitle: true,
            backgroundColor: Color(0xFF263238),
            elevation: 0.0,
          )),
      body: PageView(
        controller: _pageController,
        children: _screens,
        onPageChanged: _onPageChanged,
        physics: NeverScrollableScrollPhysics(),
      ),
      backgroundColor: Color(0xFF263238),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        backgroundColor: Color(0xFF263238),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Color(0xFF00858A),
        unselectedItemColor: Color(0xFFFFFFFF),
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
            ),
            title: Text(
              'Home',
              style: GoogleFonts.monda(),
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.trending_up,
            ),
            title: Text(
              'Trends',
              style: GoogleFonts.monda(),
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.place,
            ),
            title: Text(
              'Map',
              style: GoogleFonts.monda(),
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.apartment,
            ),
            title: Text(
              'Venues',
              style: GoogleFonts.monda(),
            ),
          ),
        ],
        onTap: _onItemTapped,
      ),
    );
  }
}
