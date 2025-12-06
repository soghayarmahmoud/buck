import 'package:buck/pages/favorite.dart';
import 'package:buck/pages/home_page.dart';
import 'package:buck/pages/settings.dart';
import 'package:buck/pages/statistics_page.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'dart:ui';

import '../themes/theme_provider.dart';

class CustomBottomNavigationBar extends StatefulWidget {
  const CustomBottomNavigationBar({super.key});

  @override
  State<CustomBottomNavigationBar> createState() =>
      _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar>
    with TickerProviderStateMixin {
  int _selectedIndex = 0;
  late final PageController _pageController;
  late final List<AnimationController> _animationControllers;
  late final List<Animation<double>> _animations;

  final List<Widget> _pages = const [
    HomePage(),
    FavoritePage(),
    StatisticsPage(),
    SettingsPage(),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();

    // Initialize animation controllers and animations
    _animationControllers = List.generate(
      _pages.length,
      (index) => AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 300),
      ),
    );

    _animations = _animationControllers.map((controller) {
      return Tween<double>(
        begin: 1.0,
        end: 1.2,
      ).animate(CurvedAnimation(parent: controller, curve: Curves.easeInOut));
    }).toList();

    // Start first animation
    _animationControllers[0].forward();
  }

  @override
  void dispose() {
    _pageController.dispose();
    for (var controller in _animationControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _onItemTapped(int index) {
    if (_selectedIndex != index) {
      // Reset previous animation
      _animationControllers[_selectedIndex].reverse();

      setState(() {
        _selectedIndex = index;
      });

      // Start new animation
      _animationControllers[index].forward();

      _pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOutQuart,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.themeData.brightness == Brightness.dark;

    return Scaffold(
      extendBody: true,
      body: PageView(
        controller: _pageController,
        children: _pages,
        onPageChanged: (index) {
          if (_selectedIndex != index) {
            _animationControllers[_selectedIndex].reverse();
            setState(() {
              _selectedIndex = index;
            });
            _animationControllers[index].forward();
          }
        },
      ),
      bottomNavigationBar: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1A2139) : Colors.white,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 20,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 8.0,
                vertical: 8.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildNavItem(
                    index: 0,
                    icon: Icons.home_rounded,
                    label: 'الرئيسية',
                    isSelected: _selectedIndex == 0,
                  ),
                  _buildNavItem(
                    index: 1,
                    icon: Icons.favorite_rounded,
                    label: 'المفضلة',
                    isSelected: _selectedIndex == 1,
                  ),
                  _buildNavItem(
                    index: 2,
                    icon: FontAwesomeIcons.chartPie,
                    label: 'الاحصائيات',
                    isSelected: _selectedIndex == 2,
                  ),
                  _buildNavItem(
                    index: 3,
                    icon: Icons.settings_rounded,
                    label: 'الإعدادات',
                    isSelected: _selectedIndex == 3,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required int index,
    required IconData icon,
    required String label,
    required bool isSelected,
  }) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.themeData.brightness == Brightness.dark;
    final primaryColor = themeProvider.primaryColor;

    final color = isSelected
        ? primaryColor
        : isDark
        ? Colors.white70
        : Colors.grey;

    return GestureDetector(
      onTap: () => _onItemTapped(index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? primaryColor.withOpacity(0.15)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isSelected) ...[
              Text(
                label,
                style: TextStyle(
                  fontFamily: 'Cairo',
                  color: color,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
              const SizedBox(width: 6),
            ],
            ScaleTransition(
              scale: _animations[index],
              child: Icon(icon, color: color, size: 22),
            ),
          ],
        ),
      ),
    );
  }
}
