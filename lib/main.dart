import 'package:flutter/material.dart';
import 'screens/splash/splash_screen.dart';
import 'screens/routes/routes_generator.dart';
import 'screens/routes/app_routes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.splash,
      onGenerateRoute: RouteGenerator.generateRoute,
      title: 'PinjamDapur',
      home: const SplashScreen(),
    );
  }
}
