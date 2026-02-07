import 'package:flutter/material.dart';
import 'package:pinjamdapur/screens/routes/app_routes.dart';

class AdminDrawer extends StatelessWidget {
  const AdminDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          /// DRAWER HEADER with Logo (matching original design)
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Color(0xFFB7D1A3),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset(
                  'assets/images/logo.png',
                  width: 60,
                ),
                const SizedBox(height: 10),
                const Text(
                  'PINJAMDAPUR',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const Text(
                  'Admin',
                  style: TextStyle(fontSize: 12),
                ),
              ],
            ),
          ),

          /// MENU ITEMS
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _drawerItem(
                  context,
                  icon: Icons.dashboard,
                  title: 'Dashboard',
                  route: AppRoutes.adminDashboard,
                ),
                _drawerItem(
                  context,
                  icon: Icons.inventory_2_outlined,
                  title: 'Data Barang',
                  route: AppRoutes.adminDataBarang,
                ),
                _drawerItem(
                  context,
                  icon: Icons.people_outline,
                  title: 'Data User',
                  route: AppRoutes.adminDataUser,
                ),
                _drawerItem(
                  context,
                  icon: Icons.assignment_outlined,
                  title: 'Peminjaman',
                  route: AppRoutes.adminPeminjaman,
                ),
                _drawerItem(
                  context,
                  icon: Icons.assignment_return_outlined,
                  title: 'Pengembalian',
                  route: AppRoutes.adminPengembalian,
                ),
              ],
            ),
          ),

          /// LOGOUT AT BOTTOM
          _drawerItem(
            context,
            icon: Icons.logout,
            title: 'Keluar',
            route: AppRoutes.login,
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _drawerItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String route,
  }) {
    final bool isLogout = title == 'Keluar';
    
    return ListTile(
      leading: Icon(icon, color: isLogout ? Colors.red : null),
      title: Text(
        title,
        style: TextStyle(color: isLogout ? Colors.red : null),
      ),
      onTap: () {
        if (isLogout) {
          Navigator.pushNamedAndRemoveUntil(
            context,
            route,
            (route) => false,
          );
        } else {
          Navigator.pushReplacementNamed(context, route);
        }
      },
    );
  }
}