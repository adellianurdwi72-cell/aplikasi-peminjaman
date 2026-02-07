/// Konfigurasi Supabase
///
/// PENTING: Ganti nilai-nilai di bawah ini dengan kredensial Supabase Anda
/// Dapatkan dari: https://app.supabase.com/project/_/settings/api
class SupabaseConfig {
  // TODO: Ganti dengan Supabase Project URL Anda
  // Contoh: https://xyzcompany.supabase.co
  static const String supabaseUrl = 'YOUR_SUPABASE_URL_HERE';

  // TODO: Ganti dengan Supabase Anon Key Anda
  // Contoh: eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
  static const String supabaseAnonKey = 'YOUR_SUPABASE_ANON_KEY_HERE';

  // Validasi konfigurasi
  static bool get isConfigured {
    return supabaseUrl != 'YOUR_SUPABASE_URL_HERE' &&
        supabaseAnonKey != 'YOUR_SUPABASE_ANON_KEY_HERE' &&
        supabaseUrl.isNotEmpty &&
        supabaseAnonKey.isNotEmpty;
  }
}
