import 'package:flutter/material.dart';
import 'package:pinjamdapur/screens/admin/widgets/admin_drawer.dart';
import 'package:pinjamdapur/screens/admin/data_barang/services/barang_service.dart';
import 'package:pinjamdapur/screens/admin/data_barang/models/barang_model.dart';
import 'package:pinjamdapur/services/storage_service.dart';
import 'tambah_barang_screen.dart';

class DataBarangScreen extends StatefulWidget {
  const DataBarangScreen({super.key});

  @override
  State<DataBarangScreen> createState() => _DataBarangScreenState();
}

class _DataBarangScreenState extends State<DataBarangScreen> {
  final BarangService _service = BarangService();
  final StorageService _storageService = StorageService();
  final TextEditingController _searchController = TextEditingController();

  List<Barang> _allBarang = [];
  List<Barang> _filteredBarang = [];
  String? _selectedKategori;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadBarang();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadBarang() async {
    setState(() => _isLoading = true);

    try {
      final response = await _service.getAllBarang();
      _allBarang = response.map((json) => Barang.fromJson(json)).toList();
      _filterBarang();
    } catch (e) {
      _showSnackBar('Gagal memuat data: $e', isError: true);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _filterBarang() {
    setState(() {
      _filteredBarang = _allBarang.where((barang) {
        final matchKategori =
            _selectedKategori == null || barang.kategori == _selectedKategori;
        final matchSearch =
            _searchController.text.isEmpty ||
            barang.namaBarang.toLowerCase().contains(
              _searchController.text.toLowerCase(),
            );
        return matchKategori && matchSearch;
      }).toList();
    });
  }

  Future<void> _navigateToTambah({Barang? barang}) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => TambahBarangScreen(barang: barang)),
    );

    if (result == true) {
      _loadBarang();
    }
  }

  Future<void> _deleteBarang(Barang barang) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Konfirmasi Hapus'),
        content: Text('Yakin ingin menghapus ${barang.namaBarang}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        // Hapus foto jika ada
        if (barang.fotoUrl != null) {
          final fileName = _storageService.extractFileNameFromUrl(
            barang.fotoUrl,
          );
          if (fileName != null) {
            await _storageService.deleteFoto(fileName);
          }
        }

        // Hapus barang
        await _service.deleteBarang(barang.barangId);
        _showSnackBar('Barang berhasil dihapus');
        _loadBarang();
      } catch (e) {
        _showSnackBar('Gagal menghapus barang: $e', isError: true);
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

  List<String> get _kategoriList {
    final kategoriSet = _allBarang
        .map((b) => b.kategori ?? 'Lainnya')
        .toSet()
        .toList();
    kategoriSet.sort();
    return kategoriSet;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AdminDrawer(),
      backgroundColor: const Color(0xFFF3EED9),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF3EED9),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text('Data Barang', style: TextStyle(color: Colors.black)),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFFF2B66D),
        child: const Icon(Icons.add),
        onPressed: () => _navigateToTambah(),
      ),
      body: Column(
        children: [
          /// SEARCH BAR
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: _searchController,
              onChanged: (_) => _filterBarang(),
              decoration: InputDecoration(
                hintText: 'Cari barang...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          /// KATEGORI FILTER CHIPS
          if (_kategoriList.isNotEmpty)
            SizedBox(
              height: 50,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                children: [
                  FilterChip(
                    label: const Text('Semua'),
                    selected: _selectedKategori == null,
                    onSelected: (selected) {
                      setState(() => _selectedKategori = null);
                      _filterBarang();
                    },
                  ),
                  const SizedBox(width: 8),
                  ..._kategoriList.map((kategori) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: FilterChip(
                        label: Text(kategori),
                        selected: _selectedKategori == kategori,
                        onSelected: (selected) {
                          setState(() {
                            _selectedKategori = selected ? kategori : null;
                          });
                          _filterBarang();
                        },
                      ),
                    );
                  }),
                ],
              ),
            ),

          const SizedBox(height: 8),

          /// LIST BARANG
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _filteredBarang.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.inbox, size: 80, color: Colors.grey),
                        const SizedBox(height: 16),
                        Text(
                          _searchController.text.isEmpty
                              ? 'Belum ada barang'
                              : 'Barang tidak ditemukan',
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: _filteredBarang.length,
                    itemBuilder: (context, index) {
                      final barang = _filteredBarang[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: ListTile(
                          leading: barang.fotoUrl != null
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.network(
                                    barang.fotoUrl!,
                                    width: 60,
                                    height: 60,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
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
                                  child: const Icon(Icons.image),
                                ),
                          title: Text(
                            barang.namaBarang,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Kategori: ${barang.kategori ?? '-'}'),
                              Text('Stok: ${barang.stok}'),
                              Text(
                                'Status: ${barang.status}',
                                style: TextStyle(
                                  color: barang.isTersedia
                                      ? Colors.green
                                      : Colors.red,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          trailing: PopupMenuButton(
                            itemBuilder: (context) => [
                              const PopupMenuItem(
                                value: 'edit',
                                child: Row(
                                  children: [
                                    Icon(Icons.edit, size: 20),
                                    SizedBox(width: 8),
                                    Text('Edit'),
                                  ],
                                ),
                              ),
                              const PopupMenuItem(
                                value: 'delete',
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.delete,
                                      size: 20,
                                      color: Colors.red,
                                    ),
                                    SizedBox(width: 8),
                                    Text(
                                      'Hapus',
                                      style: TextStyle(color: Colors.red),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                            onSelected: (value) {
                              if (value == 'edit') {
                                _navigateToTambah(barang: barang);
                              } else if (value == 'delete') {
                                _deleteBarang(barang);
                              }
                            },
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
