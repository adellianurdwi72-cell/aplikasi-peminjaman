import '../core/supabase_client.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Service untuk mengelola peminjaman dan pengembalian
class PeminjamanService {
  final SupabaseClient _client = supabase;
  static const String tableName = 'peminjaman';
  static const String pengembalianTable = 'pengembalian';

  /// Mengambil semua data peminjaman dengan join ke users dan barang
  Future<List<Map<String, dynamic>>> getAllPeminjaman() async {
    try {
      final response = await _client
          .from(tableName)
          .select('''
        *,
        users:user_id (nama, email),
        barang:barang_id (nama_barang, kategori)
      ''')
          .order('tanggal_pinjam', ascending: false);

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      print('❌ Error getting all peminjaman: $e');
      rethrow;
    }
  }

  /// Mengambil peminjaman berdasarkan user ID
  Future<List<Map<String, dynamic>>> getPeminjamanByUser(String userId) async {
    try {
      final response = await _client
          .from(tableName)
          .select('''
        *,
        barang:barang_id (nama_barang, kategori, foto_url)
      ''')
          .eq('user_id', userId)
          .order('tanggal_pinjam', ascending: false);

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      print('❌ Error getting peminjaman by user: $e');
      rethrow;
    }
  }

  /// Mengambil peminjaman berdasarkan status
  Future<List<Map<String, dynamic>>> getPeminjamanByStatus(
    String status,
  ) async {
    try {
      final response = await _client
          .from(tableName)
          .select('''
        *,
        users:user_id (nama, email),
        barang:barang_id (nama_barang, kategori)
      ''')
          .eq('status', status)
          .order('tanggal_pinjam', ascending: false);

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      print('❌ Error getting peminjaman by status: $e');
      rethrow;
    }
  }

  /// Mengambil detail peminjaman berdasarkan ID
  Future<Map<String, dynamic>?> getPeminjamanById(String id) async {
    try {
      final response = await _client
          .from(tableName)
          .select('''
        *,
        users:user_id (nama, email),
        barang:barang_id (nama_barang, kategori, foto_url)
      ''')
          .eq('pinjam_id', id)
          .maybeSingle();

      return response;
    } catch (e) {
      print('❌ Error getting peminjaman by ID: $e');
      rethrow;
    }
  }

  /// Ajukan peminjaman baru
  Future<Map<String, dynamic>> ajukanPeminjaman({
    required String userId,
    required String barangId,
    required DateTime tanggalPinjam,
    required DateTime tanggalKembali,
    required int jumlah,
    String? keterangan,
  }) async {
    try {
      // Generate ID unik
      final pinjamId = 'P${DateTime.now().millisecondsSinceEpoch}';

      final data = {
        'pinjam_id': pinjamId,
        'user_id': userId,
        'barang_id': barangId,
        'tanggal_pinjam': tanggalPinjam.toIso8601String().split('T')[0],
        'tanggal_kembali': tanggalKembali.toIso8601String().split('T')[0],
        'jumlah': jumlah,
        'keterangan': keterangan,
        'status': 'PENDING',
      };

      final response = await _client
          .from(tableName)
          .insert(data)
          .select()
          .single();

      print('✅ Peminjaman berhasil diajukan: $pinjamId');
      return response;
    } catch (e) {
      print('❌ Error ajukan peminjaman: $e');
      rethrow;
    }
  }

  /// Approve peminjaman (admin/petugas)
  Future<void> approvePeminjaman(
    String pinjamId,
    String barangId,
    int jumlah,
  ) async {
    try {
      // Update status peminjaman
      await _client
          .from(tableName)
          .update({'status': 'DIPINJAM'})
          .eq('pinjam_id', pinjamId);

      // Kurangi stok barang
      final barang = await _client
          .from('barang')
          .select('stok')
          .eq('barang_id', barangId)
          .single();

      final stokBaru = (barang['stok'] as int) - jumlah;

      await _client
          .from('barang')
          .update({
            'stok': stokBaru,
            'status': stokBaru > 0 ? 'TERSEDIA' : 'DIPINJAM',
          })
          .eq('barang_id', barangId);

      print('✅ Peminjaman disetujui: $pinjamId');
    } catch (e) {
      print('❌ Error approve peminjaman: $e');
      rethrow;
    }
  }

  /// Reject peminjaman (admin/petugas)
  Future<void> rejectPeminjaman(String pinjamId) async {
    try {
      await _client
          .from(tableName)
          .update({'status': 'DITOLAK'})
          .eq('pinjam_id', pinjamId);

      print('✅ Peminjaman ditolak: $pinjamId');
    } catch (e) {
      print('❌ Error reject peminjaman: $e');
      rethrow;
    }
  }

  /// Kembalikan alat
  Future<void> kembalikanAlat({
    required String pinjamId,
    required String barangId,
    required int jumlah,
    String kondisi = 'BAIK',
    int denda = 0,
  }) async {
    try {
      // Generate ID pengembalian
      final kembaliId = 'K${DateTime.now().millisecondsSinceEpoch}';

      // Insert data pengembalian
      await _client.from(pengembalianTable).insert({
        'kembali_id': kembaliId,
        'pinjam_id': pinjamId,
        'tanggal_dikembalikan': DateTime.now().toIso8601String().split('T')[0],
        'kondisi_barang': kondisi,
        'denda': denda,
      });

      // Update status peminjaman
      await _client
          .from(tableName)
          .update({'status': 'DIKEMBALIKAN'})
          .eq('pinjam_id', pinjamId);

      // Kembalikan stok barang
      final barang = await _client
          .from('barang')
          .select('stok')
          .eq('barang_id', barangId)
          .single();

      final stokBaru = (barang['stok'] as int) + jumlah;

      await _client
          .from('barang')
          .update({'stok': stokBaru, 'status': 'TERSEDIA'})
          .eq('barang_id', barangId);

      print('✅ Alat berhasil dikembalikan: $pinjamId');
    } catch (e) {
      print('❌ Error kembalikan alat: $e');
      rethrow;
    }
  }

  /// Cek apakah stok tersedia untuk peminjaman
  Future<bool> cekStokTersedia(String barangId, int jumlah) async {
    try {
      final barang = await _client
          .from('barang')
          .select('stok')
          .eq('barang_id', barangId)
          .single();

      final stok = barang['stok'] as int;
      return stok >= jumlah;
    } catch (e) {
      print('❌ Error cek stok: $e');
      return false;
    }
  }

  /// Update status peminjaman yang terlambat
  Future<void> updateStatusTerlambat() async {
    try {
      final today = DateTime.now().toIso8601String().split('T')[0];

      await _client
          .from(tableName)
          .update({'status': 'TERLAMBAT'})
          .lt('tanggal_kembali', today)
          .eq('status', 'DIPINJAM');

      print('✅ Status terlambat diupdate');
    } catch (e) {
      print('❌ Error update status terlambat: $e');
      rethrow;
    }
  }

  /// Search peminjaman berdasarkan nama user
  Future<List<Map<String, dynamic>>> searchPeminjaman(String keyword) async {
    try {
      final response = await _client
          .from(tableName)
          .select('''
        *,
        users:user_id (nama, email),
        barang:barang_id (nama_barang, kategori)
      ''')
          .ilike('users.nama', '%$keyword%');

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      print('❌ Error search peminjaman: $e');
      rethrow;
    }
  }
}
