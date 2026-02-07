import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pinjamdapur/screens/admin/data_barang/models/barang_model.dart';
import 'package:pinjamdapur/services/peminjaman_service.dart';
import 'package:pinjamdapur/utils/validators/validators.dart';
import 'package:pinjamdapur/core/supabase_client.dart';

class AjukanPeminjamanScreen extends StatefulWidget {
  final Barang barang;

  const AjukanPeminjamanScreen({super.key, required this.barang});

  @override
  State<AjukanPeminjamanScreen> createState() => _AjukanPeminjamanScreenState();
}

class _AjukanPeminjamanScreenState extends State<AjukanPeminjamanScreen> {
  final _formKey = GlobalKey<FormState>();
  final _jumlahController = TextEditingController();
  final _keteranganController = TextEditingController();
  final PeminjamanService _service = PeminjamanService();

  DateTime? _tanggalPinjam;
  DateTime? _tanggalKembali;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Default tanggal pinjam = besok
    _tanggalPinjam = DateTime.now().add(const Duration(days: 1));
    // Default tanggal kembali = 3 hari setelah pinjam
    _tanggalKembali = _tanggalPinjam!.add(const Duration(days: 3));
  }

  @override
  void dispose() {
    _jumlahController.dispose();
    _keteranganController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context, bool isPinjam) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isPinjam
          ? (_tanggalPinjam ?? DateTime.now())
          : (_tanggalKembali ?? DateTime.now().add(const Duration(days: 1))),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 30)),
    );

    if (picked != null) {
      setState(() {
        if (isPinjam) {
          _tanggalPinjam = picked;
          // Auto adjust tanggal kembali jika lebih awal dari tanggal pinjam
          if (_tanggalKembali != null &&
              _tanggalKembali!.isBefore(_tanggalPinjam!)) {
            _tanggalKembali = _tanggalPinjam!.add(const Duration(days: 1));
          }
        } else {
          _tanggalKembali = picked;
        }
      });
    }
  }

  Future<void> _submitPeminjaman() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // Validasi tanggal
    final tanggalPinjamError = PeminjamanValidator.validateTanggalPinjam(
      _tanggalPinjam,
    );
    if (tanggalPinjamError != null) {
      _showSnackBar(tanggalPinjamError, isError: true);
      return;
    }

    final tanggalKembaliError = PeminjamanValidator.validateTanggalKembali(
      _tanggalKembali,
      _tanggalPinjam,
    );
    if (tanggalKembaliError != null) {
      _showSnackBar(tanggalKembaliError, isError: true);
      return;
    }

    setState(() => _isLoading = true);

    try {
      final userId = supabase.auth.currentUser?.id;
      if (userId == null) {
        throw Exception('User tidak login');
      }

      // Cek stok tersedia
      final jumlah = int.parse(_jumlahController.text);
      final stokTersedia = await _service.cekStokTersedia(
        widget.barang.barangId,
        jumlah,
      );

      if (!stokTersedia) {
        throw Exception('Stok tidak mencukupi');
      }

      // Ajukan peminjaman
      await _service.ajukanPeminjaman(
        userId: userId,
        barangId: widget.barang.barangId,
        tanggalPinjam: _tanggalPinjam!,
        tanggalKembali: _tanggalKembali!,
        jumlah: jumlah,
        keterangan: _keteranganController.text.trim().isEmpty
            ? null
            : _keteranganController.text.trim(),
      );

      _showSnackBar('Peminjaman berhasil diajukan');

      // Kembali dengan result true
      if (mounted) {
        Navigator.pop(context, true);
      }
    } catch (e) {
      _showSnackBar('Gagal mengajukan peminjaman: $e', isError: true);
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
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd MMMM yyyy', 'id_ID');

    return Scaffold(
      backgroundColor: const Color(0xFFF3EED9),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF3EED9),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text(
          'Ajukan Peminjaman',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            /// INFO BARANG
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    if (widget.barang.fotoUrl != null)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          widget.barang.fotoUrl!,
                          width: 60,
                          height: 60,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              width: 60,
                              height: 60,
                              color: Colors.grey[300],
                              child: const Icon(Icons.image_not_supported),
                            );
                          },
                        ),
                      )
                    else
                      Container(
                        width: 60,
                        height: 60,
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
                            widget.barang.namaBarang,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            widget.barang.kategori ?? '-',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                          Text(
                            'Stok tersedia: ${widget.barang.stok}',
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            /// FORM
            const Text(
              'Detail Peminjaman',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            /// JUMLAH
            TextFormField(
              controller: _jumlahController,
              keyboardType: TextInputType.number,
              validator: (value) =>
                  PeminjamanValidator.validateJumlah(value, widget.barang.stok),
              decoration: InputDecoration(
                labelText: 'Jumlah',
                hintText: 'Masukkan jumlah yang ingin dipinjam',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 12),

            /// TANGGAL PINJAM
            InkWell(
              onTap: () => _selectDate(context, true),
              child: InputDecorator(
                decoration: InputDecoration(
                  labelText: 'Tanggal Pinjam',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  suffixIcon: const Icon(Icons.calendar_today),
                ),
                child: Text(
                  _tanggalPinjam != null
                      ? dateFormat.format(_tanggalPinjam!)
                      : 'Pilih tanggal',
                ),
              ),
            ),
            const SizedBox(height: 12),

            /// TANGGAL KEMBALI
            InkWell(
              onTap: () => _selectDate(context, false),
              child: InputDecorator(
                decoration: InputDecoration(
                  labelText: 'Tanggal Kembali',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  suffixIcon: const Icon(Icons.calendar_today),
                ),
                child: Text(
                  _tanggalKembali != null
                      ? dateFormat.format(_tanggalKembali!)
                      : 'Pilih tanggal',
                ),
              ),
            ),
            const SizedBox(height: 12),

            /// KETERANGAN
            TextFormField(
              controller: _keteranganController,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: 'Keterangan (Opsional)',
                hintText: 'Tambahkan keterangan jika diperlukan',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 24),

            /// INFO DURASI
            if (_tanggalPinjam != null && _tanggalKembali != null)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.info_outline, color: Colors.blue),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Durasi peminjaman: ${_tanggalKembali!.difference(_tanggalPinjam!).inDays} hari',
                        style: const TextStyle(color: Colors.blue),
                      ),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 24),

            /// BUTTON SUBMIT
            SizedBox(
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFF2B66D),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: _isLoading ? null : _submitPeminjaman,
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Text(
                        'Ajukan Peminjaman',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
