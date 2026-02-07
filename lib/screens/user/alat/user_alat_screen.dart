import 'package:flutter/material.dart';
import 'package:pinjamdapur/screens/admin/data_barang/services/barang_service.dart';
import 'package:pinjamdapur/screens/admin/data_barang/models/barang_model.dart';
import 'detail_alat_screen.dart';

class UserAlatScreen extends StatefulWidget {
  const UserAlatScreen({super.key});

  @override
  State<UserAlatScreen> createState() => _UserAlatScreenState();
}

class _UserAlatScreenState extends State<UserAlatScreen> {
  final BarangService _service = BarangService();
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
      backgroundColor: const Color(0xFFF3EED9),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF3EED9),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text('Daftar Alat', style: TextStyle(color: Colors.black)),
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
                hintText: 'Cari alat...',
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

          /// GRID ALAT
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
                              ? 'Belum ada alat'
                              : 'Alat tidak ditemukan',
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  )
                : GridView.builder(
                    padding: const EdgeInsets.all(12),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.75,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                        ),
                    itemCount: _filteredBarang.length,
                    itemBuilder: (context, index) {
                      final barang = _filteredBarang[index];
                      return GestureDetector(
                        onTap: () async {
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => DetailAlatScreen(barang: barang),
                            ),
                          );
                          if (result == true) {
                            _loadBarang();
                          }
                        },
                        child: Card(
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              /// FOTO
                              Expanded(
                                child: ClipRRect(
                                  borderRadius: const BorderRadius.vertical(
                                    top: Radius.circular(12),
                                  ),
                                  child: barang.fotoUrl != null
                                      ? Image.network(
                                          barang.fotoUrl!,
                                          width: double.infinity,
                                          fit: BoxFit.cover,
                                          errorBuilder:
                                              (context, error, stackTrace) {
                                                return Container(
                                                  color: Colors.grey[300],
                                                  child: const Icon(
                                                    Icons.image_not_supported,
                                                    size: 50,
                                                  ),
                                                );
                                              },
                                        )
                                      : Container(
                                          color: Colors.grey[300],
                                          child: const Icon(
                                            Icons.kitchen,
                                            size: 50,
                                          ),
                                        ),
                                ),
                              ),

                              /// INFO
                              Padding(
                                padding: const EdgeInsets.all(8),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      barang.namaBarang,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      barang.kategori ?? '-',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey[600],
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 4),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.inventory_2,
                                          size: 14,
                                          color: barang.isTersedia
                                              ? Colors.green
                                              : Colors.red,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          'Stok: ${barang.stok}',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: barang.isTersedia
                                                ? Colors.green
                                                : Colors.red,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
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
