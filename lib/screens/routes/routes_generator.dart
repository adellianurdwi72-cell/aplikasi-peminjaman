import 'package:flutter/material.dart';
import 'package:pinjamdapur/screens/admin/pengembalian/pengembalian_screen.dart';
import 'app_routes.dart';

// IMPORT SCREEN
import '/screens/splash/splash_screen.dart';
import '/screens/login/login_screen.dart';
import '/screens/admin/dashboard/admin_dashboard_screen.dart';
import '/screens/admin/data_barang/data_barang_screen.dart';
import '/screens/admin/data_user/data_user_screen.dart';
import '/screens/admin/peminjaman/peminjaman_screen.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.splash:
        return MaterialPageRoute(builder: (_) => const SplashScreen());

      case AppRoutes.login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());

      case AppRoutes.adminDashboard:
        return MaterialPageRoute(builder: (_) => const AdminDashboardScreen());

      case AppRoutes.adminDataBarang:
        return MaterialPageRoute(builder: (_) => const DataBarangScreen());

      case AppRoutes.adminDataUser:
        return MaterialPageRoute(builder: (_) => const DataUserScreen());

      case AppRoutes.adminPeminjaman:
        return MaterialPageRoute(builder: (_) => const PeminjamanScreen());

      case AppRoutes.adminPengembalian:
        return MaterialPageRoute(builder: (_) => const PengembalianScreen());

      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('Halaman tidak ditemukan')),
          ),
        );
    }
  }
}
