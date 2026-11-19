import 'package:flutter/material.dart';
import 'package:cinewave/screens/screens.dart';

class AppRoutes {
  static const initialRoute = '/';
  static const detailsRoute = '/details';

  static Map<String, Widget Function(BuildContext)> routes = {
    initialRoute: (BuildContext context) => const HomeScreen(),
    detailsRoute: (BuildContext context) => const DetailsScreen(),
  };
}
