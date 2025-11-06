import 'package:dashbord_cine/views/old/movie_page.dart';
import 'package:dashbord_cine/views/old/reservation_page.dart';
import 'package:dashbord_cine/views/old/session_page.dart';
import 'package:flutter/material.dart';

Widget buildPage(int index) {
  switch (index) {
    case 0:
      return Navigator(
        key: GlobalKey<NavigatorState>(),
        onGenerateRoute: (settings) {
          return MaterialPageRoute(builder: (context) => MoviesPage());
        },
      );
    case 1:
      return Navigator(
        key: GlobalKey<NavigatorState>(),
        onGenerateRoute: (settings) {
          return MaterialPageRoute(builder: (context) => SessionsPage());
        },
      );
    case 2:
      return Navigator(
        key: GlobalKey<NavigatorState>(),
        onGenerateRoute: (settings) {
          return MaterialPageRoute(builder: (context) => ReservationsPage());
        },
      );
    default:
      return ReservationsPage();
  }
}
