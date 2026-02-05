import 'package:flutter/material.dart';
import 'package:pinjamdapur/screens/admin/widgets/admin_drawer.dart';
import 'tambah_barang_screen.dart';
import '/screens/admin/widgets/kategori_tile.dart';
import '/screens/admin/widgets/barang_card.dart';

class DataBarangScreen extends StatefulWidget {
  const DataBarangScreen({super.key});

  @override
  State<DataBarangScreen> createState() => _DataBarangScreenState();
}

class _DataBarangScreenState extends State<DataBarangScreen> {
  String selectedKategori = 'Peralatan Dasar Dapur';

  final List<String> kategoriList = [
    'Peralatan Dasar Dapur',
    'Peralatan Masak',
    'Peralatan Elektronik',
    'Peralatan Baking',
  ];

  final Map<String, List<Map<String, String>>> dataBarang = {
    'Peralatan Dasar Dapur': [
      {'nama': 'Pisau', 'status': 'Tersedia'},
      {'nama': 'Talenan', 'status': 'Tersedia'},
      {'nama': 'Whisk', 'status': 'Dipinjam'},
    ],
    'Peralatan Masak': [
      {'nama': 'Panci', 'status': 'Tersedia'},
      {'nama': 'Wajan', 'status': 'Tersedia'},
    ],
    'Peralatan Elektronik': [
      {'nama': 'Mixer', 'status': 'Tersedia'},
      {'nama': 'Oven', 'status': 'Dipinjam'},
    ],
    'Peralatan Baking': [
      {'nama': 'Cetakan Kue', 'status': 'Tersedia'},
    ],
  };

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
          'Data Barang',
          style: TextStyle(color: Colors.black),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFFF2B66D),
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const TambahBarangScreen(),
            ),
          );
        },
      ),
      body: Row(
        children: [
          /// KATEGORI
          Container(
            width: 160,
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: kategoriList.map((kategori) {
                return KategoriTile(
                  title: kategori,
                  isActive: selectedKategori == kategori,
                  onTap: () {
                    setState(() {
                      selectedKategori = kategori;
                    });
                  },
                );
              }).toList(),
            ),
          ),

          /// LIST BARANG
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(12),
              children: dataBarang[selectedKategori]!
                  .map(
                    (barang) => BarangCard(
                      nama: barang['nama']!,
                      status: barang['status']!,
                    ),
                  )
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}
