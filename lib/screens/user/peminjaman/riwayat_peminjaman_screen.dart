import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pinjamdapur/services/peminjaman_service.dart';
import 'package:pinjamdapur/screens/admin/peminjaman/models/peminjaman_model.dart';
import 'package:pinjamdapur/core/supabase_client.dart';
import 'pengembalian_screen.dart';

class RiwayatPeminjamanScreen extends StatefulWidget {
  const RiwayatPeminjamanScreen({super.key});

  @override
  State<RiwayatPeminjamanScreen> createState() =>
      _RiwayatPeminjamanScreenState();
}

class _RiwayatPeminjamanScreenState extends State<RiwayatPeminjamanScreen> {
  final PeminjamanService _service = PeminjamanService();
  List<Peminjaman> _peminjaman = [];
  String? _selectedStatus;
  bool _isLoading = true;

  final List<String> _statusList = [
    'PENDING',
    'DIPINJAM',
    'DIKEMBALIKAN',
    'TERLAMBAT',
    'DITOLAK',
  ];

  @override
  void initState() {
    super.initState();
    _loadPeminjaman();
  }

  Future<void> _loadPeminjaman() async {
    setState(() => _isLoading = true);

    try {
      final userId = supabase.auth.currentUser?.id;
      if (userId == null) {
        throw Exception('User tidak login');
      }

      final response = await _service.getPeminjamanByUser(userId);
      _peminjaman = response.map((json) => Peminjaman.fromJson(json)).toList();

      // Filter by status if selected
      if (_selectedStatus != null) {
        _peminjaman = _peminjaman
            .where((p) => p.status.toUpperCase() == _selectedStatus)
            .toList();
      }
    } catch (e) {
      _showSnackBar('Gagal memuat data: $e', isError: true);
    } finally {
      setState(() => _isLoading = false);
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
    final dateFormat = DateFormat('dd MMM yyyy', 'id_ID');

    return Scaffold(
      backgroundColor: const Color(0xFFF3EED9),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF3EED9),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text(
          'Riwayat Peminjaman',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Column(
        children: [
          /// FILTER STATUS
          SizedBox(
            height: 50,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              children: [
                FilterChip(
                  label: const Text('Semua'),
                  selected: _selectedStatus == null,
                  onSelected: (selected) {
                    setState(() => _selectedStatus = null);
                    _loadPeminjaman();
                  },
                ),
                const SizedBox(width: 8),
                ..._statusList.map((status) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: FilterChip(
                      label: Text(status),
                      selected: _selectedStatus == status,
                      onSelected: (selected) {
                        setState(() {
                          _selectedStatus = selected ? status : null;
                        });
                        _loadPeminjaman();
                      },
                    ),
                  );
                }),
              ],
            ),
          ),

          const SizedBox(height: 8),

          /// LIST PEMINJAMAN
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _peminjaman.isEmpty
                ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.inbox, size: 80, color: Colors.grey),
                        SizedBox(height: 16),
                        Text(
                          'Belum ada riwayat peminjaman',
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      ],
                    ),
                  )
                : RefreshIndicator(
                    onRefresh: _loadPeminjaman,
                    child: ListView.builder(
                      padding: const EdgeInsets.all(12),
                      itemCount: _peminjaman.length,
                      itemBuilder: (context, index) {
                        final pinjam = _peminjaman[index];
                        final fotoUrl =
                            pinjam.barangData?['foto_url'] as String?;

                        return Card(
                          margin: const EdgeInsets.only(bottom: 12),
                          child: ListTile(
                            leading: fotoUrl != null
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.network(
                                      fotoUrl,
                                      width: 60,
                                      height: 60,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                            return Container(
                                              width: 60,
                                              height: 60,
                                              color: Colors.grey[300],
                                              child: const Icon(
                                                Icons.image_not_supported,
                                              ),
                                            );
                                          },
                                    ),
                                  )
                                : Container(
                                    width: 60,
                                    height: 60,
                                    decoration: BoxDecoration(
                                      color: Colors.grey[300],
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: const Icon(Icons.kitchen),
                                  ),
                            title: Text(
                              pinjam.namaBarang,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Jumlah: ${pinjam.jumlah} unit'),
                                Text(
                                  '${dateFormat.format(pinjam.tanggalPinjam)} - ${dateFormat.format(pinjam.tanggalKembali)}',
                                ),
                                const SizedBox(height: 4),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: pinjam.statusColor,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    pinjam.status,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            trailing: pinjam.status.toUpperCase() == 'DIPINJAM'
                                ? IconButton(
                                    icon: const Icon(
                                      Icons.assignment_return,
                                      color: Colors.green,
                                    ),
                                    onPressed: () async {
                                      final result = await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => PengembalianScreen(
                                            peminjaman: pinjam,
                                          ),
                                        ),
                                      );
                                      if (result == true) {
                                        _loadPeminjaman();
                                      }
                                    },
                                    tooltip: 'Kembalikan',
                                  )
                                : null,
                          ),
                        );
                      },
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
