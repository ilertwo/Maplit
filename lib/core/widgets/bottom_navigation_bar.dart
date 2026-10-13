import 'package:flutter/material.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int selectedIndex; // Обов'язковий аргумент: який таб зараз активний
  final VoidCallback? onHomeTap; // Необов'язковий аргумент для кнопки Home
  final VoidCallback? onAddTap; // Необов'язковий аргумент для кнопки Add
  final VoidCallback? onProfileTap; // Необов'язковий аргумент для кнопки Profile

  const CustomBottomNavBar({
    super.key,
    required this.selectedIndex,
    this.onHomeTap,
    this.onAddTap,
    this.onProfileTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: Colors.grey.shade200)),
      ),
      child: BottomNavigationBar(
        backgroundColor: const Color(0xFFFAF8FC),
        selectedItemColor: const Color(0xFF6B4FA0),
        unselectedItemColor: Colors.grey,
        currentIndex: selectedIndex,
        onTap: (index) {
          if (index == 0 && onHomeTap != null) {
            onHomeTap!();
          } else if (index == 1 && onAddTap != null) {
            onAddTap!();
          } else if (index == 2 && onProfileTap != null) {
            onProfileTap!();
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: 'Add',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}