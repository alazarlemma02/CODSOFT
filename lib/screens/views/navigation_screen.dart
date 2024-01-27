import 'package:flutter/material.dart';
import 'package:task_app/config/theme.dart';
import 'package:task_app/screens/views/completed_screen.dart';
import 'package:task_app/screens/views/pending_screen.dart';
import 'package:task_app/screens/views/task_screen.dart';

class NavigationScreen extends StatefulWidget {
  const NavigationScreen({super.key});

  @override
  State<NavigationScreen> createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    TaskScreen(),
    PendingScreen(),
    CompletedScreen(),
  ];

  _changeScreen(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => _changeScreen(index),
        selectedItemColor:
            _currentIndex == 2 ? Colors.green : lightColorScheme.primary,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.task_sharp),
            label: "All",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.pending_actions),
            label: "Pending",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.check_circle_outline),
            label: "Completed",
            activeIcon: Icon(Icons.check_circle),
          ),
        ],
        showSelectedLabels: true,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}
