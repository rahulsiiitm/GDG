// ignore_for_file: use_super_parameters, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const CustomBottomNavBar({
    Key? key,
    required this.selectedIndex,
    required this.onItemTapped,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 1,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BottomNavigationBar(
          backgroundColor: Colors.white,
          type: BottomNavigationBarType.fixed,
          currentIndex: selectedIndex,
          onTap: onItemTapped,
          selectedItemColor: Color(0xFF2E7D32),
          unselectedItemColor: Colors.grey.shade600,
          selectedLabelStyle: GoogleFonts.urbanist(
            fontWeight: FontWeight.bold,
            color: Color(0xFF2E7D32),
            fontSize: 11,
          ),
          unselectedLabelStyle: GoogleFonts.urbanist(
            fontWeight: FontWeight.w500,
            color: Colors.grey.shade600,
            fontSize: 10,
          ),
          selectedFontSize: 11,
          unselectedFontSize: 10,
          items: [
            _buildNavItem(
              icon: Icons.home_rounded,
              label: 'Home',
              isSelected: selectedIndex == 0,
            ),
            _buildNavItem(
              icon: Icons.chat_bubble_rounded,
              label: 'Chat',
              isSelected: selectedIndex == 1,
            ),
            _buildNavItem(
              icon: Icons.grass_rounded,
              label: 'Plantation',
              isSelected: selectedIndex == 2,
            ),
            _buildNavItem(
              icon: Icons.analytics_rounded,
              label: 'Analytics',
              isSelected: selectedIndex == 3,
            ),
          ],
        ),
      ),
    );
  }

  BottomNavigationBarItem _buildNavItem({
    required IconData icon,
    required String label,
    required bool isSelected,
  }) {
    return BottomNavigationBarItem(
      icon: Container(
        padding: EdgeInsets.symmetric(vertical: 4),
        child: Icon(
          icon,
          size: 22,
          color: isSelected ? Color(0xFF2E7D32) : Colors.grey.shade600,
        ),
      ),
      label: label,
    );
  }
}
