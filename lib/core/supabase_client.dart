import 'package:supabase_flutter/supabase_flutter.dart';
import 'supabase_config.dart';

/// Supabase Client Singleton
///
/// Menyediakan akses ke Supabase client di seluruh aplikasi
class SupabaseClientManager {
  static SupabaseClient? _client;

  /// Inisialisasi Supabase
  ///
  /// Harus dipanggil sebelum menggunakan client
  static Future<void> initialize() async {
    if (!SupabaseConfig.isConfigured) {
      throw Exception(
        'Supabase belum dikonfigurasi! '
        'Silakan isi kredensial di lib/core/supabase_config.dart',
      );
    }

    try {
      await Supabase.initialize(
        url: SupabaseConfig.supabaseUrl,
        anonKey: SupabaseConfig.supabaseAnonKey,
      );
      _client = Supabase.instance.client;
      print('✅ Supabase berhasil diinisialisasi');
    } catch (e) {
      print('❌ Error inisialisasi Supabase: $e');
      rethrow;
    }
  }

  /// Mendapatkan instance Supabase client
  static SupabaseClient get client {
    if (_client == null) {
      throw Exception(
        'Supabase belum diinisialisasi! '
        'Panggil SupabaseClientManager.initialize() terlebih dahulu',
      );
    }
    return _client!;
  }

  /// Shortcut untuk mengakses Supabase client
  static SupabaseClient get instance => client;
}

/// Shortcut global untuk mengakses Supabase client
SupabaseClient get supabase => SupabaseClientManager.client;
