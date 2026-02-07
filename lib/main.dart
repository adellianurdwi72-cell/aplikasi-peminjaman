import 'package:flutter/material.dart';
import 'screens/splash/splash_screen.dart';
import 'screens/routes/routes_generator.dart';
import 'screens/routes/app_routes.dart';
import 'core/supabase_client.dart';

void main() async {
  // Inisialisasi Flutter binding
  WidgetsFlutterBinding.ensureInitialized();

  // Inisialisasi Supabase
  try {
    await SupabaseClientManager.initialize();
  } catch (e) {
    print('⚠️ Peringatan: $e');
    print(
      'Aplikasi akan tetap berjalan, tetapi fitur database tidak akan tersedia.',
    );
  }

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
