import 'package:flutter/material.dart';

import '../../screens/wishlistP.dart';
import '../model/home.dart';
import '../model/search.dart';
import 'MyProfileP.dart';
import 'cart.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

int selectedIndex = 0;

class _HomePageState extends State<HomePage> {
  void _onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

//  Stack(
  //     children: <Widget>[
  //       image,
  //       Positioned(
  //         bottom: 10.0,
  //         left: 10.0,
  //         child: Text(
  //           text,
  //           style: TextStyle(
  //             color: Colors.white,
  //             fontWeight: FontWeight.bold,
  //             fontSize: 20.0,
  //           ),
  //         ),
  //       ),
  //     ],
  //   );
  // }
  static const List<Widget> _pages = <Widget>[
    Home(),
    Explore(),
    Cart(),
    WishListP(),
    MyProfileP()
  ];
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        bottomNavigationBar: BottomNavigationBar(
            selectedLabelStyle: TextStyle(fontSize: 12),
            unselectedLabelStyle: TextStyle(fontSize: 12),
            unselectedItemColor: Colors.grey,
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.home, size: 27),
                label: ('Home'),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.explore_outlined, size: 27),
                label: ('Explore'),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.shopping_cart_outlined, size: 27),
                label: ('Cart'),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.favorite_border_outlined, size: 27),
                label: ('Wishlist'),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person, size: 27),
                label: ('Profile'),
              ),
            ],
            type: BottomNavigationBarType.fixed,
            currentIndex: selectedIndex,
            selectedItemColor: Colors.blue[700],
            onTap: _onItemTapped,
            elevation: 5),
        body: _pages.elementAt(selectedIndex),
      ),
    );
  }
}
