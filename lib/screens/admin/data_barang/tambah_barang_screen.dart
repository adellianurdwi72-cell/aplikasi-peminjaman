import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pinjamdapur/screens/admin/data_barang/services/barang_service.dart';
import 'package:pinjamdapur/screens/admin/data_barang/models/barang_model.dart';
import 'package:pinjamdapur/services/storage_service.dart';
import 'package:pinjamdapur/utils/validators/validators.dart';

class TambahBarangScreen extends StatefulWidget {
  final Barang? barang; // Untuk mode edit

  const TambahBarangScreen({super.key, this.barang});

  @override
  State<TambahBarangScreen> createState() => _TambahBarangScreenState();
}

class _TambahBarangScreenState extends State<TambahBarangScreen> {
  final _formKey = GlobalKey<FormState>();
  final _namaController = TextEditingController();
  final _kategoriController = TextEditingController();
  final _keteranganController = TextEditingController();
  final _stokController = TextEditingController();

  final BarangService _barangService = BarangService();
  final StorageService _storageService = StorageService();
  final ImagePicker _picker = ImagePicker();

  File? _selectedImage;
  String? _existingFotoUrl;
  bool _isLoading = false;
  bool _isEditMode = false;

  @override
  void initState() {
    super.initState();
    _isEditMode = widget.barang != null;

    if (_isEditMode) {
      _namaController.text = widget.barang!.namaBarang;
      _kategoriController.text = widget.barang!.kategori ?? '';
      _keteranganController.text = widget.barang!.keterangan ?? '';
      _stokController.text = widget.barang!.stok.toString();
      _existingFotoUrl = widget.barang!.fotoUrl;
    }
  }

  @override
  void dispose() {
    _namaController.dispose();
    _kategoriController.dispose();
    _keteranganController.dispose();
    _stokController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );

      if (image != null) {
        final file = File(image.path);

        // Validasi foto
        final error = BarangValidator.validateFoto(file);
        if (error != null) {
          _showSnackBar(error, isError: true);
          return;
        }

        setState(() {
          _selectedImage = file;
        });
      }
    } catch (e) {
      _showSnackBar('Gagal memilih foto: $e', isError: true);
    }
  }

  Future<void> _simpanBarang() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isLoading = true);

    try {
      String? fotoUrl = _existingFotoUrl;

      // Upload foto jika ada foto baru
      if (_selectedImage != null) {
        // Hapus foto lama jika ada
        if (_existingFotoUrl != null) {
          final oldFileName = _storageService.extractFileNameFromUrl(
            _existingFotoUrl,
          );
          if (oldFileName != null) {
            await _storageService.deleteFoto(oldFileName);
          }
        }

        // Upload foto baru
        final fileName =
            '${DateTime.now().millisecondsSinceEpoch}_${_namaController.text.replaceAll(' ', '_')}.jpg';
        fotoUrl = await _storageService.uploadFoto(_selectedImage!, fileName);
      }

      if (_isEditMode) {
        // Update barang
        await _barangService.updateBarang(widget.barang!.barangId, {
          'nama_barang': _namaController.text.trim(),
          'kategori': _kategoriController.text.trim(),
          'keterangan': _keteranganController.text.trim(),
          'stok': int.parse(_stokController.text),
          if (fotoUrl != null) 'foto_url': fotoUrl,
        });
        _showSnackBar('Barang berhasil diupdate');
      } else {
        // Insert barang baru
        await _barangService.insertBarang(
          nama: _namaController.text.trim(),
          kategori: _kategoriController.text.trim(),
          keterangan: _keteranganController.text.trim(),
          stok: int.parse(_stokController.text),
          fotoUrl: fotoUrl,
        );
        _showSnackBar('Barang berhasil ditambahkan');
      }

      // Kembali dengan result true untuk trigger refresh
      if (mounted) {
        Navigator.pop(context, true);
      }
    } catch (e) {
      _showSnackBar('Gagal menyimpan barang: $e', isError: true);
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
    return Scaffold(
      backgroundColor: const Color(0xFFF3EED9),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF3EED9),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        title: Text(
          _isEditMode ? 'Edit Data Barang' : 'Tambah Data Barang',
          style: const TextStyle(color: Colors.black),
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            /// UPLOAD GAMBAR
            GestureDetector(
              onTap: _pickImage,
              child: Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.white,
                ),
                child: _selectedImage != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.file(_selectedImage!, fit: BoxFit.cover),
                      )
                    : _existingFotoUrl != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          _existingFotoUrl!,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(
                              Icons.add_photo_alternate_outlined,
                              size: 60,
                              color: Colors.grey,
                            );
                          },
                        ),
                      )
                    : const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.add_photo_alternate_outlined,
                            size: 60,
                            color: Colors.grey,
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Tap untuk upload foto',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
              ),
            ),
            const SizedBox(height: 20),

            /// FORM INPUTS
            _buildTextFormField(
              'Nama Barang',
              _namaController,
              validator: BarangValidator.validateNama,
            ),
            _buildTextFormField(
              'Kategori',
              _kategoriController,
              validator: BarangValidator.validateKategori,
            ),
            _buildTextFormField(
              'Keterangan',
              _keteranganController,
              maxLines: 3,
              validator: BarangValidator.validateKeterangan,
            ),
            _buildTextFormField(
              'Jumlah Stok',
              _stokController,
              keyboardType: TextInputType.number,
              validator: BarangValidator.validateStok,
            ),

            const SizedBox(height: 20),

            /// BUTTONS
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: _isLoading ? null : () => Navigator.pop(context),
                    child: const Text('Batal'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFF2B66D),
                    ),
                    onPressed: _isLoading ? null : _simpanBarang,
                    child: _isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : const Text('Simpan'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextFormField(
    String hint,
    TextEditingController controller, {
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        maxLines: maxLines,
        validator: validator,
        decoration: InputDecoration(
          hintText: hint,
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.red),
          ),
        ),
      ),
    );
  }
}
