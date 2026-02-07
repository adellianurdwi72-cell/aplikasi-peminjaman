import 'package:flutter/material.dart';
import 'package:pinjamdapur/screens/admin/widgets/admin_drawer.dart';
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

      /// DRAWER - Now using reusable AdminDrawer
      drawer: const AdminDrawer(),

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
}