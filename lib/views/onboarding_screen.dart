// ===================================
// FICHIER 2: lib/views/onboarding_screen.dart
// ===================================
import 'package:flutter/material.dart';
import 'dart:async';
import 'login_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  Timer? _timer;

  final List<OnboardingData> _pages = [
    OnboardingData(
      icon: Icons.movie_creation_rounded,
      title: 'Gérez vos Films',
      description:
      'Accédez à une vaste collection de films populaires, à venir et les mieux notés.',
      gradient: [Color(0xFFE50914), Color(0xFFFF4444)],
    ),
    OnboardingData(
      icon: Icons.event_seat_rounded,
      title: 'Programmez vos Séances',
      description:
      'Organisez facilement vos séances de cinéma avec un système intuitif.',
      gradient: [Color(0xFFFFD700), Color(0xFFFFA726)],
    ),
    OnboardingData(
      icon: Icons.confirmation_number_rounded,
      title: 'Réservations Simplifiées',
      description:
      'Gérez toutes vos réservations en temps réel avec un tableau de bord moderne.',
      gradient: [Color(0xFF2196F3), Color(0xFF00BCD4)],
    ),
    OnboardingData(
      icon: Icons.dashboard_rounded,
      title: 'Statistiques en Direct',
      description:
      'Suivez vos performances avec des graphiques et des analyses détaillées.',
      gradient: [Color(0xFF4CAF50), Color(0xFF8BC34A)],
    ),
  ];

  @override
  void initState() {
    super.initState();
    _startAutoSlide();
  }

  void _startAutoSlide() {
    _timer = Timer.periodic(Duration(seconds: 4), (timer) {
      if (_currentPage < _pages.length - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }
      _pageController.animateToPage(
        _currentPage,
        duration: Duration(milliseconds: 800),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF0A0A0A),
              Color(0xFF1A1A1A),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Skip button
              Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: TextButton(
                    onPressed: () => _navigateToLogin(),
                    child: Text(
                      'Passer',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ),

              // PageView
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: (index) {
                    setState(() => _currentPage = index);
                  },
                  itemCount: _pages.length,
                  itemBuilder: (context, index) {
                    return _buildPage(_pages[index]);
                  },
                ),
              ),

              // Indicators
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  _pages.length,
                      (index) => _buildIndicator(index == _currentPage),
                ),
              ),
              SizedBox(height: 30),

              // Button
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 40),
                child: _currentPage == _pages.length - 1
                    ? _buildGetStartedButton()
                    : _buildNextButton(),
              ),
              SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPage(OnboardingData data) {
    return Padding(
      padding: EdgeInsets.all(40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Icon avec gradient
          Container(
            padding: EdgeInsets.all(40),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(colors: data.gradient),
              boxShadow: [
                BoxShadow(
                  color: data.gradient[0].withOpacity(0.5),
                  blurRadius: 40,
                  spreadRadius: 10,
                ),
              ],
            ),
            child: Icon(
              data.icon,
              size: 100,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 60),

          // Title
          Text(
            data.title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 20),

          // Description
          Text(
            data.description,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Colors.white70,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIndicator(bool isActive) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      margin: EdgeInsets.symmetric(horizontal: 4),
      height: 8,
      width: isActive ? 24 : 8,
      decoration: BoxDecoration(
        color: isActive ? Color(0xFFE50914) : Colors.white24,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }

  Widget _buildNextButton() {
    return OutlinedButton(
      onPressed: () {
        _pageController.nextPage(
          duration: Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      },
      style: OutlinedButton.styleFrom(
        side: BorderSide(color: Color(0xFFE50914), width: 2),
        padding: EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Suivant',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(width: 8),
          Icon(Icons.arrow_forward, color: Color(0xFFE50914)),
        ],
      ),
    );
  }

  Widget _buildGetStartedButton() {
    return ElevatedButton(
      onPressed: () => _navigateToLogin(),
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xFFE50914),
        padding: EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 8,
        shadowColor: Color(0xFFE50914).withOpacity(0.5),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Commencer',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(width: 8),
          Icon(Icons.arrow_forward, color: Colors.white),
        ],
      ),
    );
  }

  void _navigateToLogin() {
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => LoginScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          var tween = Tween(begin: Offset(1.0, 0.0), end: Offset.zero)
              .chain(CurveTween(curve: Curves.easeInOut));
          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
        transitionDuration: Duration(milliseconds: 500),
      ),
    );
  }
}

class OnboardingData {
  final IconData icon;
  final String title;
  final String description;
  final List<Color> gradient;

  OnboardingData({
    required this.icon,
    required this.title,
    required this.description,
    required this.gradient,
  });
}