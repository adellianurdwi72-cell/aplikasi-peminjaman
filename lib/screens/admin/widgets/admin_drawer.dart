import 'package:flutter/material.dart';
import 'package:pinjamdapur/screens/routes/app_routes.dart';

class AdminDrawer extends StatelessWidget {
  const AdminDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(color: Color(0xFFB7D1A3)),
            child: Text(
              'Admin Menu',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          _drawerItem(
            context,
            icon: Icons.dashboard,
            title: 'Dashboard',
            route: AppRoutes.adminDashboard,
          ),
          _drawerItem(
            context,
            icon: Icons.inventory,
            title: 'Data Barang',
            route: AppRoutes.adminDataBarang,
          ),
          _drawerItem(
            context,
            icon: Icons.people,
            title: 'Data User',
            route: AppRoutes.adminDataUser,
          ),
          _drawerItem(
            context,
            icon: Icons.assignment,
            title: 'Peminjaman',
            route: AppRoutes.adminPeminjaman,
          ),
          _drawerItem(
            context,
            icon: Icons.assignment_return,
            title: 'Pengembalian',
            route: AppRoutes.adminPengembalian,
          ),
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
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: () {
        Navigator.pushReplacementNamed(context, route);
      },
    );
  }
}
