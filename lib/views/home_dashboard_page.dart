// lib/views/home_dashboard_page.dart
/*
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../config/app_theme.dart';
import '../config/responsive.dart';

class HomeDashboardPage extends StatelessWidget {
  const HomeDashboardPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF121212),
            Color(0xFF1A1A1A),
            Color(0xFF121212),
          ],
        ),
      ),
      child: SingleChildScrollView(
        padding: EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Stats Cards
            _buildStatsCards(context),

            SizedBox(height: 24),

            // Prochaines séances
            _buildUpcomingSessions(),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsCards(BuildContext context) {
    final stats = [
      {
        'title': 'Films à l\'affiche',
        'value': '24',
        'icon': Icons.movie_rounded,
        'color': Color(0xFFE50914),
        'trend': '+3',
      },
      {
        'title': 'Réservations aujourd\'hui',
        'value': '156',
        'icon': Icons.confirmation_number_rounded,
        'color': Color(0xFFFFD700),
        'trend': '+12%',
      },
      {
        'title': 'Taux d\'occupation',
        'value': '78%',
        'icon': Icons.event_seat_rounded,
        'color': Color(0xFF4CAF50),
        'trend': '+5%',
      },
      {
        'title': 'Revenus du jour',
        'value': '12.5K€',
        'icon': Icons.attach_money_rounded,
        'color': Color(0xFF2196F3),
        'trend': '+8%',
      },
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: MediaQuery.of(context).size.width < 768 ? 2 : 4,
        childAspectRatio: 1.5,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: stats.length,
      itemBuilder: (context, index) => _buildStatCard(stats[index]),
    );
  }

  Widget _buildStatCard(Map<String, dynamic> stat) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF1E1E1E),
            Color(0xFF2A2A2A),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: (stat['color'] as Color).withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              stat['icon'],
              color: stat['color'],
              size: 28,
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                stat['title'],
                style: TextStyle(
                  color: Color(0xFFB3B3B3),
                  fontSize: 12,
                ),
              ),
              SizedBox(height: 4),
              Row(
                children: [
                  Text(
                    stat['value'],
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(width: 8),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: Color(0xFF4CAF50).withOpacity(0.15),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      stat['trend'],
                      style: TextStyle(
                        color: Color(0xFF4CAF50),
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildUpcomingSessions() {
    final sessions = [
      {
        'title': 'Avatar: The Way of Water',
        'time': '14:30',
        'room': 'Salle 1',
        'seats': 45,
      },
      {
        'title': 'Top Gun: Maverick',
        'time': '17:00',
        'room': 'Salle 2',
        'seats': 38,
      },
      {
        'title': 'The Batman',
        'time': '19:30',
        'room': 'Salle 3',
        'seats': 52,
      },
    ];

    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF1E1E1E),
            Color(0xFF2A2A2A),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Prochaines séances',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              TextButton(
                onPressed: () {},
                child: Text('Voir tout'),
              ),
            ],
          ),
          SizedBox(height: 16),
          ...sessions.map((session) => _buildSessionItem(session)),
        ],
      ),
    );
  }

  Widget _buildSessionItem(Map<String, dynamic> session) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Color(0xFF121212).withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 80,
            decoration: BoxDecoration(
              color: Color(0xFF333333),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(Icons.movie, color: Color(0xFFB3B3B3)),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  session['title'],
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: Colors.white,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.access_time, size: 14, color: Color(0xFFB3B3B3)),
                    SizedBox(width: 4),
                    Text(
                      session['time'],
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xFFB3B3B3),
                      ),
                    ),
                    SizedBox(width: 12),
                    Icon(Icons.room, size: 14, color: Color(0xFFB3B3B3)),
                    SizedBox(width: 4),
                    Text(
                      session['room'],
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xFFB3B3B3),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.event_seat, size: 14, color: Color(0xFFFFD700)),
                    SizedBox(width: 4),
                    Text(
                      '${session['seats']} places disponibles',
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xFFFFD700),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
*/

// lib/views/home_dashboard_page.dart
import 'package:flutter/material.dart';
import '../config/app_theme.dart';
import '../config/responsive.dart';

class HomeDashboardPage extends StatelessWidget {
  const HomeDashboardPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF121212),
            Color(0xFF1A1A1A),
            Color(0xFF121212),
          ],
        ),
      ),
      child: SingleChildScrollView(
        padding: EdgeInsets.all(Responsive.isMobile(context) ? 16 : 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Stats Cards
            _buildStatsCards(context),

            SizedBox(height: 24),

            // Prochaines séances
            _buildUpcomingSessions(context),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsCards(BuildContext context) {
    final stats = [
      {
        'title': 'Films à l\'affiche',
        'value': '24',
        'icon': Icons.movie_rounded,
        'color': Color(0xFFE50914),
        'trend': '+3',
      },
      {
        'title': 'Réservations aujourd\'hui',
        'value': '156',
        'icon': Icons.confirmation_number_rounded,
        'color': Color(0xFFFFD700),
        'trend': '+12%',
      },
      {
        'title': 'Taux d\'occupation',
        'value': '78%',
        'icon': Icons.event_seat_rounded,
        'color': Color(0xFF4CAF50),
        'trend': '+5%',
      },
      {
        'title': 'Revenus du jour',
        'value': '12.5K€',
        'icon': Icons.attach_money_rounded,
        'color': Color(0xFF2196F3),
        'trend': '+8%',
      },
    ];

    final isMobile = Responsive.isMobile(context);
    final isTablet = Responsive.isTablet(context);

    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: isMobile ? 2 : (isTablet ? 2 : 4),
        childAspectRatio: isMobile ? 1.2 : (isTablet ? 1.4 : 1.5),
        crossAxisSpacing: isMobile ? 12 : 16,
        mainAxisSpacing: isMobile ? 12 : 16,
      ),
      itemCount: stats.length,
      itemBuilder: (context, index) => _buildStatCard(stats[index], context),
    );
  }

  Widget _buildStatCard(Map<String, dynamic> stat, BuildContext context) {
    final isMobile = Responsive.isMobile(context);

    return Container(
      padding: EdgeInsets.all(isMobile ? 12 : 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF1E1E1E),
            Color(0xFF2A2A2A),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: EdgeInsets.all(isMobile ? 8 : 12),
            decoration: BoxDecoration(
              color: (stat['color'] as Color).withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              stat['icon'],
              color: stat['color'],
              size: isMobile ? 20 : 28,
            ),
          ),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  stat['title'],
                  style: TextStyle(
                    color: Color(0xFFB3B3B3),
                    fontSize: isMobile ? 10 : 12,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4),
                Flexible(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Flexible(
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: Alignment.centerLeft,
                          child: Text(
                            stat['value'],
                            style: TextStyle(
                              fontSize: isMobile ? 18 : 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 4),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: isMobile ? 4 : 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Color(0xFF4CAF50).withOpacity(0.15),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          stat['trend'],
                          style: TextStyle(
                            color: Color(0xFF4CAF50),
                            fontSize: isMobile ? 10 : 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUpcomingSessions(BuildContext context) {
    final sessions = [
      {
        'title': 'Avatar: The Way of Water',
        'time': '14:30',
        'room': 'Salle 1',
        'seats': 45,
      },
      {
        'title': 'Top Gun: Maverick',
        'time': '17:00',
        'room': 'Salle 2',
        'seats': 38,
      },
      {
        'title': 'The Batman',
        'time': '19:30',
        'room': 'Salle 3',
        'seats': 52,
      },
    ];

    final isMobile = Responsive.isMobile(context);

    return Container(
      padding: EdgeInsets.all(isMobile ? 16 : 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF1E1E1E),
            Color(0xFF2A2A2A),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  'Prochaines séances',
                  style: TextStyle(
                    fontSize: isMobile ? 16 : 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              TextButton(
                onPressed: () {},
                style: TextButton.styleFrom(
                  padding: EdgeInsets.symmetric(
                    horizontal: isMobile ? 8 : 12,
                    vertical: 4,
                  ),
                ),
                child: Text(
                  'Voir tout',
                  style: TextStyle(fontSize: isMobile ? 12 : 14),
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          ...sessions.map((session) => _buildSessionItem(session, context)),
        ],
      ),
    );
  }

  Widget _buildSessionItem(Map<String, dynamic> session, BuildContext context) {
    final isMobile = Responsive.isMobile(context);

    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(isMobile ? 8 : 12),
      decoration: BoxDecoration(
        color: Color(0xFF121212).withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            width: isMobile ? 50 : 60,
            height: isMobile ? 70 : 80,
            decoration: BoxDecoration(
              color: Color(0xFF333333),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.movie,
              color: Color(0xFFB3B3B3),
              size: isMobile ? 24 : 32,
            ),
          ),
          SizedBox(width: isMobile ? 12 : 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  session['title'],
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: isMobile ? 13 : 14,
                    color: Colors.white,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4),
                Wrap(
                  spacing: 8,
                  runSpacing: 4,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.access_time,
                          size: isMobile ? 12 : 14,
                          color: Color(0xFFB3B3B3),
                        ),
                        SizedBox(width: 4),
                        Text(
                          session['time'],
                          style: TextStyle(
                            fontSize: isMobile ? 11 : 12,
                            color: Color(0xFFB3B3B3),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.room,
                          size: isMobile ? 12 : 14,
                          color: Color(0xFFB3B3B3),
                        ),
                        SizedBox(width: 4),
                        Text(
                          session['room'],
                          style: TextStyle(
                            fontSize: isMobile ? 11 : 12,
                            color: Color(0xFFB3B3B3),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 4),
                Row(
                  children: [
                    Icon(
                      Icons.event_seat,
                      size: isMobile ? 12 : 14,
                      color: Color(0xFFFFD700),
                    ),
                    SizedBox(width: 4),
                    Flexible(
                      child: Text(
                        '${session['seats']} places disponibles',
                        style: TextStyle(
                          fontSize: isMobile ? 11 : 12,
                          color: Color(0xFFFFD700),
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}