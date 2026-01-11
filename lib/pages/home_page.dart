import 'dart:ui';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
Widget _drawerItem(Widget icon, String title) {
  return ListTile(
    leading: icon,
    title: Text(
      title,
      style: const TextStyle(
        fontWeight: FontWeight.w500,
      ),
    ),
    onTap: () {},
  );
}

  int _selectedItemIndex = 0;
  final List<Map<String, dynamic>> _pages = [
    {
      'title': "Homes",
      'icon': Icons.home_rounded,
      'image': 'https://picsum.photos/200/300'
    },
    {
      'title': "Videos",
      'icon': Icons.photo_album_rounded,
      'image': 'https://picsum.photos/200/300'
    },
    {
      'title': "Premium",
      'icon': Icons.workspace_premium_rounded,
      'image': 'https://picsum.photos/200/300'
    },
  ];
  void _onItemTapped(int index) {
    setState(() {
      _selectedItemIndex = index;
    });
  }
  @override
  Widget build(BuildContext context) {
    final page = _pages[_selectedItemIndex];
    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(40),
        child: ClipRRect(
          borderRadius: const BorderRadius.vertical(
            bottom: Radius.circular(30),
          ),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.white.withValues(alpha: .35),
                    Colors.white.withValues(alpha: .10),
                  ],
                ),
                border: Border(
                  bottom: BorderSide(
                    color: Colors.white.withValues(alpha: .4),
                    width: 1.2,
                  ),
                ),
              ),
              child: AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                centerTitle: true,
                title: Text(
                  _pages[_selectedItemIndex]['title'],
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.2,
                  ),
                ),
                actions: const [
                  Padding(
                    padding: EdgeInsets.only(right: 16),
                    child: Icon(Icons.notifications_none_rounded),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
      drawer: Drawer(
  backgroundColor: Colors.transparent,
  elevation: 0,
  child: ClipRRect(
    borderRadius: const BorderRadius.horizontal(
      right: Radius.circular(30),
    ),
    child: BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
      child: Container(
        width: 300,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.white.withValues(alpha: .35),
              Colors.white.withValues(alpha: .10),
            ],
          ),
          border: Border(
            right: BorderSide(
              color: Colors.white.withValues(alpha: .4),
              width: 1.2,
            ),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: .25),
              blurRadius: 20,
              offset: const Offset(5, 0),
            )
          ],
        ),
        child: Column(
          children: [
            const SizedBox(height: 40),

            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: const [
                  CircleAvatar(
                    radius: 30,
                    backgroundImage: NetworkImage(
                      "https://randomuser.me/api/portraits/men/46.jpg",
                    ),
                  ),
                  SizedBox(width: 15),
                  Text(
                    "User Name",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // Menu Items
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
  _drawerItem(FaIcon(FontAwesomeIcons.house), "Home Page"),
  _drawerItem(FaIcon(FontAwesomeIcons.user), "My Profile"),
  _drawerItem(FaIcon(FontAwesomeIcons.creditCard), "View Subscription"),
  _drawerItem(FaIcon(FontAwesomeIcons.whatsapp), "Join WhatsApp"),
  _drawerItem(FaIcon(FontAwesomeIcons.telegram), "Join Telegram"),
  _drawerItem(FaIcon(FontAwesomeIcons.addressBook), "Contact Us"),
  _drawerItem(FaIcon(FontAwesomeIcons.circleInfo), "About"),
  _drawerItem(FaIcon(FontAwesomeIcons.shareNodes), "Share App"),
  _drawerItem(FaIcon(FontAwesomeIcons.arrowsRotate), "Refresh"),
  _drawerItem(FaIcon(FontAwesomeIcons.crown), "Go Premium"),
  _drawerItem(FaIcon(FontAwesomeIcons.star), "Showcase"),
  _drawerItem(FaIcon(FontAwesomeIcons.gear), "Settings"),
  _drawerItem(FaIcon(FontAwesomeIcons.rightFromBracket), "Logout"),
],
              ),
            ),
          ],
        ),
      ),
    ),
  ),
),
      body: Stack(
        children: [
          AnimatedSwitcher(
            duration: const Duration(microseconds: 700),
            transitionBuilder: (child, animation) {
              return FadeTransition(
                opacity: animation,
                child: ScaleTransition(
                  scale: Tween(begin: 1.05, end: 1.0).animate(animation),
                  child: child,
                  alignment: Alignment.center ,
                ),
              );
            },
            child: Container(
              key: ValueKey(page['image']),
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: NetworkImage(page['image']), fit: BoxFit.cover)),
            ),
          ),
          Container(
            color: Colors.black.withValues(alpha: 0.25),
          ),
          Center(
            child: Text(
              (page['title'] as String).toUpperCase(),
              style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.6,
                  color: Colors.white),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: SafeArea(
                child: Padding(
              padding: const EdgeInsets.only(bottom: 25, left: 20, right: 20),
              child: GlassmorphicBottomNavBar(
                  selectedIndex: _selectedItemIndex,
                  onItemTapped: _onItemTapped,
                  items: _pages),
            )),
          )
        ],
      ),
    );
  }
}

class GlassNavItem extends StatelessWidget {
  final IconData icon;
  final String lebel;
  final bool isSelected;
  final VoidCallback onTap;
  const GlassNavItem(
      {super.key,
      required this.icon,
      required this.lebel,
      required this.isSelected,
      required this.onTap});
  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: InkWell(
      borderRadius: BorderRadius.circular(30),
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedScale(
            scale: isSelected ? 1.25 : 1.0,
            duration: const Duration(milliseconds: 200),
            child: Icon(
              icon,
              size: 22,
              color: isSelected ? Colors.white : Colors.white70,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            lebel,
            style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: isSelected ? Colors.white : Colors.white60),
          )
        ],
      ),
    ));
  }
}

class GlassmorphicBottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onItemTapped;
  final List<Map<String, dynamic>> items;

  const GlassmorphicBottomNavBar({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(40),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
        child: Container(
          height: 60,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(40),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.white.withValues(alpha: .38),
                Colors.white.withValues(alpha: .10),
              ],
            ),
            border: Border.all(
              color: Colors.white.withValues(alpha: .4),
              width: 1.2,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: .25),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),

          child: Row(
            children: List.generate(items.length, (index) {
              final item = items[index];
              return GlassNavItem(
                icon: item['icon'],
                lebel: item['title'],
                isSelected: selectedIndex == index,
                onTap: () => onItemTapped(index)
              );
            }),
          ),
        ),
      ),
    );
  }
}
