import 'package:flutter/material.dart';
import 'package:pinjamdapur/screens/admin/widgets/admin_drawer.dart';
import 'package:pinjamdapur/screens/admin/widgets/peminjaman_card.dart';

class PeminjamanScreen extends StatelessWidget {
  const PeminjamanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AdminDrawer(),
      backgroundColor: const Color(0xFFF3EED9),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF3EED9),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text(
          'Peminjaman',
          style: TextStyle(color: Colors.black),
        ),
        actions: const [
          CircleAvatar(
            radius: 16,
            backgroundColor: Colors.grey,
            child: Icon(Icons.person, size: 18, color: Colors.white),
          ),
          SizedBox(width: 8),
          Icon(Icons.notifications_none),
          SizedBox(width: 16),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            /// SEARCH
            TextField(
              decoration: InputDecoration(
                hintText: 'Cari Peminjam...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            const SizedBox(height: 20),

            /// LIST PEMINJAMAN
            Expanded(
              child: ListView(
                children: const [
                  PeminjamanCard(
                    initial: 'H',
                    initialColor: Color(0xFF90CAF9),
                    nama: 'Hana',
                    barang: 'Cetakan Kue',
                    tanggal: '8-12 Januari 2026',
                    status: 'Selesai',
                  ),
                  PeminjamanCard(
                    initial: 'F',
                    initialColor: Color(0xFFA5D6A7),
                    nama: 'Fani',
                    barang: 'Timbangan Digital',
                    tanggal: '6-10 Januari 2026',
                    status: 'Disetujui',
                  ),
                  PeminjamanCard(
                    initial: 'B',
                    initialColor: Color(0xFFEF9A9A),
                    nama: 'Budi',
                    barang: 'Oven',
                    tanggal: '2-6 Januari 2026',
                    status: 'Dipending',
                  ),
                  PeminjamanCard(
                    initial: 'C',
                    initialColor: Color(0xFFFFCC80),
                    nama: 'Citra',
                    barang: 'Spatula',
                    tanggal: '3-9 Januari 2026',
                    status: 'Terlambat',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
