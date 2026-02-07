import 'package:flutter/material.dart';
import 'package:pinjamdapur/screens/admin/widgets/admin_drawer.dart';
import 'package:pinjamdapur/screens/admin/widgets/info_card.dart';
import 'package:pinjamdapur/screens/admin/widgets/section_card.dart';

class DetailPengembalianScreen  extends StatelessWidget {
  const DetailPengembalianScreen ({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AdminDrawer(),
      backgroundColor: const Color(0xFFF3EED9),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF3EED9),
        elevation: 0,
        title: const Text(
          'Pengembalian',
          style: TextStyle(color: Colors.black),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            /// PROFIL PEMINJAM
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 28,
                    backgroundColor: Colors.purple,
                    child: Text(
                      'C',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Citra',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        'Pekerja rumah makan',
                        style: TextStyle(color: Colors.grey),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Spatula',
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            /// INFO TANGGAL
            const InfoCard(
              items: {
                'Tgl pinjam': '2 Januari 2026',
                'Rencana pengembalian': '6 Januari 2026',
                'Tgl pengembalian': '9 Januari 2026',
              },
            ),

            const SizedBox(height: 16),

            /// LAPORAN PEMINJAM
            const SectionCard(
              title: 'Laporan Kondisi (Peminjam)',
              headerColor: Color(0xFFFFB562),
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Rusak',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 4),
                  Text('Gagang spatula patah'),
                ],
              ),
            ),

            const SizedBox(height: 16),

            /// HASIL PENGECEKAN
            const SectionCard(
              title: 'Hasil Pengecekan Petugas',
              headerColor: Color(0xFF8CC084),
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Kondisi Akhir : Rusak'),
                  SizedBox(height: 8),
                  _DendaRow(label: 'Denda Keterlambatan', value: 'Rp 30.000'),
                  _DendaRow(label: 'Denda Kerusakan', value: 'Rp 15.000'),
                  Divider(),
                  _DendaRow(
                    label: 'Total Denda',
                    value: 'Rp 45.000',
                    isBold: true,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            /// STATUS ADMIN
            const SectionCard(
              title: 'Status Administrasi',
              headerColor: Color(0xFFFFB562),
              content: Chip(
                label: Text('Di Catat'),
                backgroundColor: Color(0xFFE0E0E0),
              ),
            ),

            const SizedBox(height: 24),

            /// BUTTON
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF8CC084),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
                onPressed: () {},
                child: const Text('Tandai Selesai'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DendaRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isBold;

  const _DendaRow({
    required this.label,
    required this.value,
    this.isBold = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(
            value,
            style: TextStyle(
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
