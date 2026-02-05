import 'package:flutter/material.dart';
import '../widgets/dashboard_card.dart';
import '../widgets/recent_loan_card.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3EED9),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF3EED9),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text(
          'Dashboard',
          style: TextStyle(color: Colors.black),
        ),
        actions: const [
          Icon(Icons.notifications_none),
          SizedBox(width: 16),
        ],
      ),

      /// DRAWER
      drawer: Drawer(
        child: Column(
          children: [
            /// DRAWER HEADER
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

            _drawerItem(Icons.dashboard, 'Dashboard'),
            _drawerItem(Icons.inventory_2_outlined, 'Data Barang'),
            _drawerItem(Icons.people_outline, 'Data User'),
            _drawerItem(Icons.assignment_outlined, 'Peminjaman'),
            _drawerItem(Icons.assignment_return_outlined, 'Pengembalian'),
            _drawerItem(Icons.logout, 'Keluar'),
          ],
        ),
      ),

      /// BODY
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// CARD SUMMARY
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                DashboardCard(title: 'Total Pinjaman', value: '35'),
                DashboardCard(title: 'Total Pengguna', value: '12'),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                DashboardCard(title: 'Barang Tersedia', value: '14'),
                DashboardCard(title: 'Barang Dipinjam', value: '5'),
              ],
            ),

            const SizedBox(height: 24),

            /// TITLE
            const Text(
              'Peminjaman Terbaru',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),

            /// LIST PEMINJAMAN
            const RecentLoanCard(
              name: 'Fani',
              item: 'Timbangan digital',
              status: 'Menunggu',
            ),
            const RecentLoanCard(
              name: 'Citra',
              item: 'Spatula',
              status: 'Disetujui',
            ),
            const RecentLoanCard(
              name: 'Budi',
              item: 'Oven',
              status: 'Disetujui',
            ),
            const RecentLoanCard(
              name: 'Hana',
              item: 'Cetakan kue',
              status: 'Menunggu',
            ),
            const RecentLoanCard(
              name: 'Dina',
              item: 'Whisk',
              status: 'Menunggu',
            ),
          ],
        ),
      ),
    );
  }

  /// ITEM DRAWER
  Widget _drawerItem(IconData icon, String title) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: () {},
    );
  }
}
