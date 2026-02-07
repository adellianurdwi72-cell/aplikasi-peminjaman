import 'package:flutter/material.dart';
import 'package:pinjamdapur/screens/admin/data_barang/models/barang_model.dart';
import '../peminjaman/ajukan_peminjaman_screen.dart';

class DetailAlatScreen extends StatelessWidget {
  final Barang barang;

  const DetailAlatScreen({super.key, required this.barang});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3EED9),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF3EED9),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text('Detail Alat', style: TextStyle(color: Colors.black)),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// FOTO
            if (barang.fotoUrl != null)
              Image.network(
                barang.fotoUrl!,
                width: double.infinity,
                height: 300,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: double.infinity,
                    height: 300,
                    color: Colors.grey[300],
                    child: const Icon(Icons.image_not_supported, size: 80),
                  );
                },
              )
            else
              Container(
                width: double.infinity,
                height: 300,
                color: Colors.grey[300],
                child: const Icon(Icons.kitchen, size: 80),
              ),

            /// INFO
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// NAMA
                  Text(
                    barang.namaBarang,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),

                  /// KATEGORI
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF2B66D),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      barang.kategori ?? 'Lainnya',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  /// STOK
                  Row(
                    children: [
                      const Icon(Icons.inventory_2, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        'Stok Tersedia: ${barang.stok}',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: barang.isTersedia ? Colors.green : Colors.red,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  /// STATUS
                  Row(
                    children: [
                      const Icon(Icons.info_outline, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        'Status: ${barang.status}',
                        style: TextStyle(
                          fontSize: 16,
                          color: barang.isTersedia ? Colors.green : Colors.red,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  /// KONDISI
                  Row(
                    children: [
                      const Icon(Icons.check_circle_outline, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        'Kondisi: ${barang.kondisi}',
                        style: TextStyle(
                          fontSize: 16,
                          color: barang.isKondisiBaik
                              ? Colors.green
                              : Colors.orange,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  /// KETERANGAN
                  if (barang.keterangan != null &&
                      barang.keterangan!.isNotEmpty) ...[
                    const Text(
                      'Keterangan:',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      barang.keterangan!,
                      style: const TextStyle(fontSize: 14),
                    ),
                    const SizedBox(height: 24),
                  ],

                  /// BUTTON AJUKAN PEMINJAMAN
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: barang.isTersedia
                            ? const Color(0xFFF2B66D)
                            : Colors.grey,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: barang.isTersedia
                          ? () async {
                              final result = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      AjukanPeminjamanScreen(barang: barang),
                                ),
                              );
                              if (result == true && context.mounted) {
                                Navigator.pop(context, true);
                              }
                            }
                          : null,
                      icon: const Icon(Icons.add_shopping_cart),
                      label: Text(
                        barang.isTersedia ? 'Ajukan Peminjaman' : 'Stok Habis',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
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
