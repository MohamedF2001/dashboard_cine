// ===================================
// FICHIER 1: lib/views/dashboard_layout.dart
// ===================================
import 'package:dashbord_cine/views/modern_movie_page.dart';
import 'package:dashbord_cine/views/modern_session_page.dart';
import 'package:flutter/material.dart';
import 'package:dashbord_cine/views/old/movie_page.dart';
import 'package:dashbord_cine/views/old/session_page.dart';
import 'package:dashbord_cine/views/old/reservation_page.dart';
import 'package:dashbord_cine/views/home_dashboard_page.dart';

import 'modern_reservation_page.dart';

class DashboardLayout extends StatefulWidget {
  const DashboardLayout({Key? key}) : super(key: key);

  @override
  State<DashboardLayout> createState() => _DashboardLayoutState();
}

class _DashboardLayoutState extends State<DashboardLayout> {
  int _selectedIndex = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final List<Map<String, dynamic>> _menuItems = [
    {
      'icon': Icons.dashboard_rounded,
      'title': 'Tableau de bord',
      'page': HomeDashboardPage(),
    },
    {
      'icon': Icons.movie_rounded,
      'title': 'Films',
      'page': MoviesPagee(),
    },
    {
      'icon': Icons.schedule_rounded,
      'title': 'Séances',
      'page': SessionsPagee(),
    },
    {
      'icon': Icons.confirmation_number_rounded,
      'title': 'Réservations',
      'page': ReservationsPagee(),
    },
  ];

  bool _isDesktop(BuildContext context) {
    return MediaQuery.of(context).size.width >= 1200;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Row(
        children: [
          // Sidebar - visible seulement sur desktop
          if (_isDesktop(context)) _buildSidebar(),

          // Corps principal
          Expanded(
            child: Column(
              children: [
                _buildTopBar(),
                Expanded(
                  child: _menuItems[_selectedIndex]['page'],
                ),
              ],
            ),
          ),
        ],
      ),
      // Drawer pour mobile/tablet
      drawer: !_isDesktop(context) ? _buildDrawer() : null,
    );
  }

  Widget _buildSidebar() {
    return Container(
      width: 280,
      decoration: BoxDecoration(
        color: Color(0xFF1E1E1E),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        children: [
          // Logo et titre
          Container(
            padding: EdgeInsets.all(24),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Color(0xFFE50914),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.movie_filter_rounded,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
                SizedBox(width: 12),
                Text(
                  'CINEMA',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFFFD700),
                  ),
                ),
              ],
            ),
          ),
          Divider(color: Color(0xFF333333), height: 1),

          // Menu items
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.symmetric(vertical: 8),
              itemCount: _menuItems.length,
              itemBuilder: (context, index) {
                return _buildMenuItem(index);
              },
            ),
          ),

          // Footer
          Divider(color: Color(0xFF333333), height: 1),
          Padding(
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: Color(0xFFE50914),
                  child: Icon(Icons.person, color: Colors.white),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Admin',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        'Administrateur',
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFFB3B3B3),
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.settings, color: Color(0xFFB3B3B3)),
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(int index) {
    final item = _menuItems[index];
    final isSelected = _selectedIndex == index;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: isSelected
            ? Color(0xFFE50914).withOpacity(0.15)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        border: isSelected
            ? Border.all(color: Color(0xFFE50914).withOpacity(0.3), width: 1)
            : null,
      ),
      child: ListTile(
        leading: Icon(
          item['icon'],
          color: isSelected ? Color(0xFFE50914) : Color(0xFFB3B3B3),
        ),
        title: Text(
          item['title'],
          style: TextStyle(
            color: isSelected ? Color(0xFFE50914) : Colors.white,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
        onTap: () {
          setState(() {
            _selectedIndex = index;
          });
          // Fermer le drawer si mobile
          if (!_isDesktop(context)) {
            Navigator.pop(context);
          }
        },
      ),
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      backgroundColor: Color(0xFF1E1E1E),
      child: Column(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Color(0xFF121212),
            ),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Color(0xFFE50914),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.movie_filter_rounded,
                    color: Colors.white,
                    size: 32,
                  ),
                ),
                SizedBox(width: 12),
                Text(
                  'CINEMA',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFFFD700),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(8),
              itemCount: _menuItems.length,
              itemBuilder: (context, index) {
                return _buildMenuItem(index);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopBar() {
    return Container(
      height: 70,
      decoration: BoxDecoration(
        color: Color(0xFF1E1E1E),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            // Menu button pour mobile
            if (!_isDesktop(context))
              IconButton(
                icon: Icon(Icons.menu, color: Colors.white),
                onPressed: () {
                  //Scaffold.of(context).openDrawer();
                  _scaffoldKey.currentState?.openDrawer();
                },
              ),

            // Titre de la page
            Text(
              _menuItems[_selectedIndex]['title'],
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),

            Spacer(),

            // Search button
            IconButton(
              icon: Icon(Icons.search, color: Colors.white),
              onPressed: () {},
            ),

            // Notifications
            Stack(
              children: [
                IconButton(
                  icon: Icon(Icons.notifications_outlined, color: Colors.white),
                  onPressed: () {},
                ),
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Color(0xFFE50914),
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      '3',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(width: 8),

            // User avatar
            if (_isDesktop(context))
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Color(0xFFE50914),
                    child: Icon(Icons.person, color: Colors.white),
                  ),
                  SizedBox(width: 8),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Admin',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        'Administrateur',
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFFB3B3B3),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

