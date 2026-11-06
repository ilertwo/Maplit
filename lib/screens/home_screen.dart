import 'package:flutter/material.dart';
import '../core/widgets/bottom_navigation_bar.dart';
import '../core/widgets/item_card.dart';
import '../core/widgets/section_header.dart';
import 'profile_screen.dart';
import 'item_details_screen.dart';
import 'add_item_screen.dart';

class HomeScreen extends StatelessWidget {
  static const String _userName = 'Artem';

  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF8FC),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFAF8FC),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.black87),
          onPressed: () {},
        ),
        title: const Text(
          'Home',
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Good morning, $_userName',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E1E1E),
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Two items need your attention this week.',
                      style: TextStyle(fontSize: 13, color: Color(0xFF7A7A7A)),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Секція "I borrowed"
            const SectionHeader(
              title: 'I borrowed',
              count: '5',
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 170,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  ItemCard(
                    title: 'Pen',
                    subtitle: 'Updated Sep 28',
                    status: 'Return by Oct 03',
                    statusColor: const Color(0xFF2E7D32),
                    imageUrl: 'assets/images/1.png',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ItemDetailsScreen(
                            title: 'Pen',
                            imageUrl: 'assets/images/1.png',
                            updatedText: 'Updated 2 days ago',
                            dateText: '03.09.2026',
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(width: 12),
                  ItemCard(
                    title: 'Zhytomyr',
                    subtitle: 'Updated Sep 26',
                    status: 'With you · 6 days',
                    statusColor: const Color(0xFF2E7D32),
                    imageUrl: 'assets/images/2.png',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ItemDetailsScreen(
                            title: 'Zhytomyr',
                            imageUrl: 'assets/images/2.png',
                            updatedText: 'Updated 2 days ago',
                            dateText: '26.09.2026',
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Секція "Give this to me"
            const SectionHeader(
              title: 'Give this to me',
              count: '4',
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 170,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  ItemCard(
                    title: 'Hair dryer',
                    subtitle: 'Roma · Sep 25',
                    status: 'Pick up today',
                    statusColor: const Color(0xFF2E7D32),
                    imageUrl: 'assets/images/3.png',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ItemDetailsScreen(
                            title: 'Hair dryer',
                            imageUrl: 'assets/images/3.png',
                            updatedText: 'Updated 2 days ago',
                            dateText: '25.09.2026',
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(width: 12),
                  ItemCard(
                    title: 'left sock',
                    subtitle: 'Olena · Sep 22',
                    status: 'Ready to collect',
                    statusColor: const Color(0xFF2E7D32),
                    imageUrl: 'assets/images/4.png',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ItemDetailsScreen(
                            title: 'left sock',
                            imageUrl: 'assets/images/4.png',
                            updatedText: 'Updated 2 days ago',
                            dateText: '22.09.2026',
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 80), // Відступ для нижньої панелі
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFFEFE7F8),
        elevation: 0,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddItemScreen()),
          );
        },
        child: const Icon(Icons.add, color: Color(0xFF6B4FA0)),
      ),
      // Нижня панель навігації
      bottomNavigationBar: CustomBottomNavBar(
        selectedIndex: 0,
        onProfileTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ProfileScreen()),
          );
        },
      ),
    );
  }
}