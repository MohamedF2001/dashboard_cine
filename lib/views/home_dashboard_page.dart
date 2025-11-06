// lib/views/home_dashboard_page.dart
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../config/app_theme.dart';
import '../config/responsive.dart';
/*
class HomeDashboardPage extends StatelessWidget {
  const HomeDashboardPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: AppTheme.backgroundGradient,
      ),
      child: SingleChildScrollView(
        padding: EdgeInsets.all(Responsive.isMobile(context) ? 16 : 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Stats Cards
            _buildStatsCards(context),

            SizedBox(height: 24),

            // Charts Row
            Responsive(
              mobile: Column(
                children: [
                  _buildRevenueChart(),
                  SizedBox(height: 16),
                  _buildOccupancyChart(),
                ],
              ),
              desktop: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 2,
                    child: _buildRevenueChart(),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: _buildOccupancyChart(),
                  ),
                ],
              ),
            ),

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
        'color': AppTheme.primaryRed,
        'trend': '+3',
      },
      {
        'title': 'Réservations aujourd\'hui',
        'value': '156',
        'icon': Icons.confirmation_number_rounded,
        'color': AppTheme.accentGold,
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

    return Responsive(
      mobile: Column(
        children: stats.map((stat) => Padding(
          padding: EdgeInsets.only(bottom: 12),
          child: _buildStatCard(stat),
        )).toList(),
      ),
      tablet: GridView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 2.5,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: stats.length,
        itemBuilder: (context, index) => _buildStatCard(stats[index]),
      ),
      desktop: Row(
        children: stats.map((stat) => Expanded(
          child: Padding(
            padding: EdgeInsets.only(right: stats.last == stat ? 0 : 16),
            child: _buildStatCard(stat),
          ),
        )).toList(),
      ),
    );
  }

  Widget _buildStatCard(Map<String, dynamic> stat) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: AppTheme.cardGradient,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppTheme.cardShadow,
      ),
      child: Row(
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
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  stat['title'],
                  style: TextStyle(
                    color: AppTheme.textSecondary,
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
                        color: AppTheme.textPrimary,
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
          ),
        ],
      ),
    );
  }

  Widget _buildRevenueChart() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: AppTheme.cardGradient,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppTheme.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Fréquentation sur 7 jours',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimary,
            ),
          ),
          SizedBox(height: 20),
          SizedBox(
            height: 200,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: 50,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                      color: AppTheme.dividerColor,
                      strokeWidth: 1,
                    );
                  },
                ),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          value.toInt().toString(),
                          style: TextStyle(
                            color: AppTheme.textSecondary,
                            fontSize: 12,
                          ),
                        );
                      },
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        const days = ['Lun', 'Mar', 'Mer', 'Jeu', 'Ven', 'Sam', 'Dim'];
                        return Text(
                          days[value.toInt() % 7],
                          style: TextStyle(
                            color: AppTheme.textSecondary,
                            fontSize: 12,
                          ),
                        );
                      },
                    ),
                  ),
                  rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                borderData: FlBorderData(show: false),
                minX: 0,
                maxX: 6,
                minY: 0,
                maxY: 200,
                lineBarsData: [
                  LineChartBarData(
                    spots: [
                      FlSpot(0, 120),
                      FlSpot(1, 145),
                      FlSpot(2, 135),
                      FlSpot(3, 160),
                      FlSpot(4, 150),
                      FlSpot(5, 180),
                      FlSpot(6, 175),
                    ],
                    isCurved: true,
                    color: AppTheme.primaryRed,
                    barWidth: 3,
                    dotData: FlDotData(show: true),
                    belowBarData: BarAreaData(
                      show: true,
                      color: AppTheme.primaryRed.withOpacity(0.1),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOccupancyChart() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: AppTheme.cardGradient,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppTheme.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Taux d\'occupation',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimary,
            ),
          ),
          SizedBox(height: 30),
          Center(
            child: SizedBox(
              height: 180,
              child: PieChart(
                PieChartData(
                  sectionsSpace: 2,
                  centerSpaceRadius: 50,
                  sections: [
                    PieChartSectionData(
                      value: 78,
                      title: '78%',
                      color: AppTheme.primaryRed,
                      radius: 60,
                      titleStyle: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    PieChartSectionData(
                      value: 22,
                      title: '22%',
                      color: AppTheme.dividerColor,
                      radius: 50,
                      titleStyle: TextStyle(
                        fontSize: 14,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildLegendItem('Occupé', AppTheme.primaryRed),
              SizedBox(width: 20),
              _buildLegendItem('Disponible', AppTheme.dividerColor),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        SizedBox(width: 8),
        Text(
          label,
          style: TextStyle(
            color: AppTheme.textSecondary,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildUpcomingSessions(BuildContext context) {
    final sessions = [
      {
        'title': 'Avatar: The Way of Water',
        'time': '14:30',
        'room': 'Salle 1',
        'seats': 45,
        'image': 'https://image.tmdb.org/t/p/w500/t6HIqrRAclMCA60NsSmeqe9RmNV.jpg',
      },
      {
        'title': 'Top Gun: Maverick',
        'time': '17:00',
        'room': 'Salle 2',
        'seats': 38,
        'image': 'https://image.tmdb.org/t/p/w500/62HCnUTziyWcpDaBO2i1DX17ljH.jpg',
      },
      {
        'title': 'The Batman',
        'time': '19:30',
        'room': 'Salle 3',
        'seats': 52,
        'image': 'https://image.tmdb.org/t/p/w500/74xTEgt7R36Fpooo50r9T25onhq.jpg',
      },
    ];

    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: AppTheme.cardGradient,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppTheme.cardShadow,
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
                  color: AppTheme.textPrimary,
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
        color: AppTheme.backgroundColor.withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              session['image'],
              width: 60,
              height: 80,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                width: 60,
                height: 80,
                color: AppTheme.dividerColor,
                child: Icon(Icons.movie, color: AppTheme.textSecondary),
              ),
            ),
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
                    color: AppTheme.textPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.access_time, size: 14, color: AppTheme.textSecondary),
                    SizedBox(width: 4),
                    Text(
                      session['time'],
                      style: TextStyle(
                        fontSize: 12,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                    SizedBox(width: 12),
                    Icon(Icons.room, size: 14, color: AppTheme.textSecondary),
                    SizedBox(width: 4),
                    Text(
                      session['room'],
                      style: TextStyle(
                        fontSize: 12,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.event_seat, size: 14, color: AppTheme.accentGold),
                    SizedBox(width: 4),
                    Text(
                      '${session['seats']} places disponibles',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppTheme.accentGold,
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
}*/




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
