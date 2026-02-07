import '../core/supabase_client.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Service untuk autentikasi pengguna
class AuthService {
  final SupabaseClient _client = supabase;

  /// Sign in dengan email dan password
  Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _client.auth.signInWithPassword(
        email: email,
        password: password,
      );
      return response;
    } catch (e) {
      print('❌ Error sign in: $e');
      rethrow;
    }
  }

  /// Sign up dengan email dan password
  Future<AuthResponse> signUp({
    required String email,
    required String password,
    Map<String, dynamic>? metadata,
  }) async {
    try {
      final response = await _client.auth.signUp(
        email: email,
        password: password,
        data: metadata,
      );
      return response;
    } catch (e) {
      print('❌ Error sign up: $e');
      rethrow;
    }
  }

  /// Sign out
  Future<void> signOut() async {
    try {
      await _client.auth.signOut();
    } catch (e) {
      print('❌ Error sign out: $e');
      rethrow;
    }
  }

  /// Mendapatkan user yang sedang login
  User? get currentUser => _client.auth.currentUser;

  /// Stream untuk mendengarkan perubahan auth state
  Stream<AuthState> get authStateChanges => _client.auth.onAuthStateChange;

  /// Cek apakah user sudah login
  bool get isSignedIn => currentUser != null;
}
