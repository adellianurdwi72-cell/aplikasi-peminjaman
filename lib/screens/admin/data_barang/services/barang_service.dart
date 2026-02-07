import '../../../../core/supabase_client.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Service untuk mengelola operasi CRUD barang/alat
class BarangService {
  final SupabaseClient _client = supabase;
  static const String tableName = 'barang';

  /// Mengambil semua data barang
  Future<List<Map<String, dynamic>>> getAllBarang() async {
    try {
      final response = await _client.from(tableName).select();
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      print('❌ Error getting all barang: $e');
      rethrow;
    }
  }

  /// Mengambil barang berdasarkan ID
  Future<Map<String, dynamic>?> getBarangById(String id) async {
    try {
      final response = await _client
          .from(tableName)
          .select()
          .eq('barang_id', id)
          .maybeSingle();
      return response;
    } catch (e) {
      print('❌ Error getting barang by ID: $e');
      rethrow;
    }
  }

  /// Mengambil barang berdasarkan status
  Future<List<Map<String, dynamic>>> getBarangByStatus(String status) async {
    try {
      final response = await _client
          .from(tableName)
          .select()
          .eq('status', status);
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      print('❌ Error getting barang by status: $e');
      rethrow;
    }
  }

  /// Insert barang baru
  Future<Map<String, dynamic>> insertBarang({
    required String nama,
    required String kategori,
    required String keterangan,
    required int stok,
    String? fotoUrl,
  }) async {
    try {
      // Generate ID unik
      final barangId = 'B${DateTime.now().millisecondsSinceEpoch}';

      final data = {
        'barang_id': barangId,
        'nama_barang': nama,
        'kategori': kategori,
        'keterangan': keterangan,
        'stok': stok,
        'foto_url': fotoUrl,
        'kondisi': 'BAIK',
        'status': 'TERSEDIA',
      };

      final response = await _client
          .from(tableName)
          .insert(data)
          .select()
          .single();

      print('✅ Barang berhasil ditambahkan: $nama');
      return response;
    } catch (e) {
      print('❌ Error insert barang: $e');
      rethrow;
    }
  }

  /// Update barang
  Future<Map<String, dynamic>> updateBarang(
    String id,
    Map<String, dynamic> data,
  ) async {
    try {
      final response = await _client
          .from(tableName)
          .update(data)
          .eq('barang_id', id)
          .select()
          .single();

      print('✅ Barang berhasil diupdate: $id');
      return response;
    } catch (e) {
      print('❌ Error update barang: $e');
      rethrow;
    }
  }

  /// Delete barang
  Future<void> deleteBarang(String id) async {
    try {
      await _client.from(tableName).delete().eq('barang_id', id);
      print('✅ Barang berhasil dihapus: $id');
    } catch (e) {
      print('❌ Error delete barang: $e');
      rethrow;
    }
  }

  /// Update stok barang
  ///
  /// [id] - ID barang
  /// [jumlah] - Jumlah perubahan stok (positif untuk tambah, negatif untuk kurang)
  Future<void> updateStok(String id, int jumlah) async {
    try {
      // Ambil stok saat ini
      final barang = await getBarangById(id);
      if (barang == null) {
        throw Exception('Barang tidak ditemukan');
      }

      final stokSekarang = barang['stok'] as int;
      final stokBaru = stokSekarang + jumlah;

      if (stokBaru < 0) {
        throw Exception('Stok tidak mencukupi');
      }

      // Update stok
      await _client
          .from(tableName)
          .update({
            'stok': stokBaru,
            'status': stokBaru > 0 ? 'TERSEDIA' : 'DIPINJAM',
          })
          .eq('barang_id', id);

      print('✅ Stok barang diupdate: $id, stok baru: $stokBaru');
    } catch (e) {
      print('❌ Error update stok: $e');
      rethrow;
    }
  }

  /// Cek ketersediaan stok
  Future<bool> cekStokTersedia(String id, int jumlah) async {
    try {
      final barang = await getBarangById(id);
      if (barang == null) return false;

      final stok = barang['stok'] as int;
      return stok >= jumlah;
    } catch (e) {
      print('❌ Error cek stok: $e');
      return false;
    }
  }

  /// Search barang berdasarkan nama
  Future<List<Map<String, dynamic>>> searchBarang(String keyword) async {
    try {
      final response = await _client
          .from(tableName)
          .select()
          .ilike('nama_barang', '%$keyword%');
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      print('❌ Error search barang: $e');
      rethrow;
    }
  }
}
