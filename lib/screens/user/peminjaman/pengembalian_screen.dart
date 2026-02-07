import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pinjamdapur/services/peminjaman_service.dart';
import 'package:pinjamdapur/screens/admin/peminjaman/models/peminjaman_model.dart';

class PengembalianScreen extends StatefulWidget {
  final Peminjaman peminjaman;

  const PengembalianScreen({super.key, required this.peminjaman});

  @override
  State<PengembalianScreen> createState() => _PengembalianScreenState();
}

class _PengembalianScreenState extends State<PengembalianScreen> {
  final PeminjamanService _service = PeminjamanService();
  String _kondisi = 'BAIK';
  bool _isLoading = false;

  Future<void> _kembalikan() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Konfirmasi Pengembalian'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Yakin ingin mengembalikan ${widget.peminjaman.namaBarang}?'),
            const SizedBox(height: 8),
            Text('Jumlah: ${widget.peminjaman.jumlah} unit'),
            Text('Kondisi: $_kondisi'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Ya, Kembalikan'),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    setState(() => _isLoading = true);

    try {
      // Hitung denda jika terlambat
      int denda = 0;
      if (widget.peminjaman.isTerlambat) {
        final hariTerlambat = DateTime.now()
            .difference(widget.peminjaman.tanggalKembali)
            .inDays;
        denda = hariTerlambat * 5000; // Rp 5.000 per hari
      }

      // Tambah denda jika kondisi rusak
      if (_kondisi == 'RUSAK') {
        denda += 50000; // Rp 50.000 untuk kerusakan
      }

      await _service.kembalikanAlat(
        pinjamId: widget.peminjaman.pinjamId,
        barangId: widget.peminjaman.barangId,
        jumlah: widget.peminjaman.jumlah,
        kondisi: _kondisi,
        denda: denda,
      );

      _showSnackBar(
        denda > 0
            ? 'Alat berhasil dikembalikan. Denda: Rp ${NumberFormat('#,###', 'id_ID').format(denda)}'
            : 'Alat berhasil dikembalikan',
      );

      if (mounted) {
        Navigator.pop(context, true);
      }
    } catch (e) {
      _showSnackBar('Gagal mengembalikan alat: $e', isError: true);
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd MMMM yyyy', 'id_ID');
    final fotoUrl = widget.peminjaman.barangData?['foto_url'] as String?;

    return Scaffold(
      backgroundColor: const Color(0xFFF3EED9),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF3EED9),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text(
          'Pengembalian Alat',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          /// INFO BARANG
          Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  if (fotoUrl != null)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        fotoUrl,
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            width: 80,
                            height: 80,
                            color: Colors.grey[300],
                            child: const Icon(Icons.image_not_supported),
                          );
                        },
                      ),
                    )
                  else
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.kitchen),
                    ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.peminjaman.namaBarang,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text('Jumlah: ${widget.peminjaman.jumlah} unit'),
                        Text(
                          'Pinjam: ${dateFormat.format(widget.peminjaman.tanggalPinjam)}',
                        ),
                        Text(
                          'Kembali: ${dateFormat.format(widget.peminjaman.tanggalKembali)}',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          /// WARNING JIKA TERLAMBAT
          if (widget.peminjaman.isTerlambat)
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.red[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.red),
              ),
              child: Row(
                children: [
                  const Icon(Icons.warning, color: Colors.red),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Terlambat!',
                          style: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Denda: Rp ${NumberFormat('#,###', 'id_ID').format(DateTime.now().difference(widget.peminjaman.tanggalKembali).inDays * 5000)}',
                          style: const TextStyle(color: Colors.red),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          const SizedBox(height: 20),

          /// KONDISI BARANG
          const Text(
            'Kondisi Barang',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Card(
            child: Column(
              children: [
                RadioListTile<String>(
                  title: const Text('Baik'),
                  subtitle: const Text('Tidak ada kerusakan'),
                  value: 'BAIK',
                  groupValue: _kondisi,
                  onChanged: (value) {
                    setState(() => _kondisi = value!);
                  },
                ),
                RadioListTile<String>(
                  title: const Text('Rusak'),
                  subtitle: const Text('Ada kerusakan (denda Rp 50.000)'),
                  value: 'RUSAK',
                  groupValue: _kondisi,
                  onChanged: (value) {
                    setState(() => _kondisi = value!);
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          /// INFO DENDA
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blue[50],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Informasi Denda',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 8),
                const Text('• Keterlambatan: Rp 5.000/hari'),
                const Text('• Kerusakan: Rp 50.000'),
                const SizedBox(height: 8),
                if (widget.peminjaman.isTerlambat || _kondisi == 'RUSAK')
                  Text(
                    'Total Denda: Rp ${NumberFormat('#,###', 'id_ID').format((widget.peminjaman.isTerlambat ? DateTime.now().difference(widget.peminjaman.tanggalKembali).inDays * 5000 : 0) + (_kondisi == 'RUSAK' ? 50000 : 0))}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                      fontSize: 16,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          /// BUTTON KEMBALIKAN
          SizedBox(
            height: 50,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: _isLoading ? null : _kembalikan,
              icon: _isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : const Icon(Icons.assignment_return),
              label: const Text(
                'Kembalikan Alat',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
