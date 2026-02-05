import 'package:flutter/material.dart';
import 'package:pinjamdapur/screens/admin/widgets/admin_drawer.dart';
import 'package:pinjamdapur/screens/admin/widgets/user_tile.dart';
import 'user_profile_screen.dart';

class DataUserScreen extends StatelessWidget {
  const DataUserScreen({super.key});

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
          'Data User',
          style: TextStyle(color: Colors.black),
        ),
        actions: const [
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
                hintText: 'Cari Pengguna...',
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

            /// ADMIN
            _sectionTitle('Admin'),
            UserTile(
              name: 'Raib',
              email: 'admin@gmail.com',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const UserProfileScreen(
                      name: 'Raib',
                      email: 'admin@gmail.com',
                      role: 'Admin',
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 16),

            /// PETUGAS
            _sectionTitle('Petugas'),
            UserTile(
              name: 'Seli',
              email: 'petugas@gmail.com',
              onTap: () {},
            ),

            const SizedBox(height: 16),

            /// ANGGOTA
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _sectionTitle('Anggota'),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {},
                ),
              ],
            ),

            Expanded(
              child: ListView(
                children: const [
                  UserTile(name: 'Eko', email: 'eko@gmail.com'),
                  UserTile(name: 'Citra', email: 'citra@gmail.com'),
                  UserTile(name: 'Dina', email: 'dina@gmail.com'),
                  UserTile(name: 'Budi', email: 'budi@gmail.com'),
                  UserTile(name: 'Fani', email: 'fani@gmail.com'),
                  UserTile(name: 'Gilang', email: 'gilang@gmail.com'),
                  UserTile(name: 'Ali', email: 'ali@gmail.com'),
                  UserTile(name: 'Hana', email: 'hana@gmail.com'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
