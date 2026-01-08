import 'package:flutter/material.dart';

import 'HomeScreen.dart';
import 'CartScreen.dart';
import 'OrdersScreen.dart';
import 'ProfileScreen.dart';

class MainNavScope extends InheritedWidget {
  final void Function(int index) goToTab;

  const MainNavScope({
    super.key,
    required this.goToTab,
    required super.child,
  });

  static MainNavScope? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<MainNavScope>();
  }

  @override
  bool updateShouldNotify(MainNavScope oldWidget) => false;
}

class MainNavScreen extends StatefulWidget {
  final int initialIndex;

  const MainNavScreen({
    super.key,
    this.initialIndex = 0,
  });

  @override
  State<MainNavScreen> createState() => _MainNavScreenState();
}

class _MainNavScreenState extends State<MainNavScreen> {
  late int _index = widget.initialIndex;

  void _setIndex(int i) {
    if (i == _index) return;
    setState(() => _index = i);
  }

  @override
  Widget build(BuildContext context) {
    return MainNavScope(
      goToTab: _setIndex,
      child: Scaffold(
        body: IndexedStack(
          index: _index,
          children: [
            const homeScreen(),
            const OrdersScreen(),
            const CartScreen(),
            const ProfileScreen(),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Color(0xFFFFF7ED),
          currentIndex: _index,
          onTap: _setIndex,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: const Color.fromARGB(173, 255, 0, 0),
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Home'),
            BottomNavigationBarItem(
                icon: Icon(Icons.local_shipping_outlined), label: 'Orders'),
            BottomNavigationBarItem(
                icon: Icon(Icons.shopping_cart_outlined), label: 'Cart'),
            BottomNavigationBarItem(
                icon: Icon(Icons.person_outline), label: 'Profile'),
          ],
        ),
      ),
    );
  }
}





