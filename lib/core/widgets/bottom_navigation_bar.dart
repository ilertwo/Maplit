import 'package:flutter/material.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final VoidCallback? onHomeTap;
  final VoidCallback? onProfileTap;

  const CustomBottomNavBar({
    super.key,
    required this.selectedIndex,
    this.onHomeTap,
    this.onProfileTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: Colors.grey.shade200)),
      ),
      child: NavigationBarTheme(
        data: NavigationBarThemeData(
          indicatorColor: const Color(0xFFEBE4F4),

          // Стиль тексту
          labelTextStyle: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.selected)) {
              return const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF6B4FA0));
            }
            return const TextStyle(fontSize: 12, color: Colors.grey);
          }),

          // Стиль іконок
          iconTheme: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.selected)) {
              return const IconThemeData(color: Color(0xFF6B4FA0));
            }
            return const IconThemeData(color: Colors.grey);
          }),
        ),

        child: NavigationBar(
          backgroundColor: const Color(0xFFFAF8FC),
          selectedIndex: selectedIndex,
          labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
          elevation: 0,
          onDestinationSelected: (index) {
            if (index == 0 && onHomeTap != null) {
              onHomeTap!();
            } else if (index == 1 && onProfileTap != null) {
              onProfileTap!();
            }
          },
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.home_outlined),
              label: 'Home',
            ),
            NavigationDestination(
              icon: Icon(Icons.person_outline),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}