import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:matrimony/Nav_pages/home/home_view.dart';
import 'package:matrimony/Nav_pages/match/match_list_view.dart';
import 'package:matrimony/Nav_pages/more/more_likes_view.dart';
import 'package:matrimony/One_time_pages/Login/LoginView.dart';
import 'package:matrimony/One_time_pages/Updated_Profile/Updated%20ProfileView.dart';
import 'nav_controller.dart';

class NavView extends StatelessWidget {
  final NavController controller = Get.put(NavController());

  final List<Widget> pages = [
    HomeView(), //home
    MatchListView(), //MatchesPage
    ChatListView(), //InterestsPage
  ];

  NavView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
      body: AnimatedSwitcher(
        duration: Duration(milliseconds: 300),
        transitionBuilder: (child, animation) => FadeTransition(
          opacity: animation,
          child: child,
        ),
        child: pages[controller.selectedIndex.value],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              offset: Offset(0, -5),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildNavItem(
                  index: 0,
                  icon: Icons.home_outlined,
                  activeIcon: Icons.home,
                  label: 'Home',
                  color: Color(0xFFFF6B35),
                ),
                _buildNavItem(
                  index: 1,
                  icon: Icons.favorite_border,
                  activeIcon: Icons.favorite,
                  label: 'Matches',
                  color: Colors.pink,
                ),
                _buildNavItem(
                  index: 2,
                  icon: Icons.local_fire_department,       // hotter flame icon
                  activeIcon: Icons.diversity_2,       // two-person icon (close to hug)
                  label: 'Chat',
                  color: Colors.redAccent,
                ),

              ],
            ),
          ),
        ),
      ),
    ));
  }

  Widget _buildNavItem({
    required int index,
    required IconData icon,
    required IconData activeIcon,
    required String label,
    required Color color,
  }) {
    final isSelected = controller.selectedIndex.value == index;

    return GestureDetector(
      onTap: () => controller.changeIndex(index),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        padding: EdgeInsets.symmetric(
          horizontal: isSelected ? 20 : 12,
          vertical: 10,
        ),
        decoration: BoxDecoration(
          gradient: isSelected
              ? LinearGradient(
            colors: [
              color.withOpacity(0.2),
              color.withOpacity(0.1),
            ],
          )
              : null,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedSwitcher(
              duration: Duration(milliseconds: 200),
              transitionBuilder: (child, animation) => ScaleTransition(
                scale: animation,
                child: child,
              ),
              child: Icon(
                isSelected ? activeIcon : icon,
                key: ValueKey(isSelected),
                color: isSelected ? color : Colors.grey[400],
                size: 26,
              ),
            ),
            if (isSelected) ...[
              SizedBox(width: 8),
              AnimatedDefaultTextStyle(
                duration: Duration(milliseconds: 200),
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
                child: Text(label),
              ),
            ],
          ],
        ),
      ),
    );
  }
}