import '../core/supabase_client.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Service untuk operasi database
class DatabaseService {
  final SupabaseClient _client = supabase;

  // ==================== CRUD Operations ====================

  /// Mengambil data dari tabel
  ///
  /// Contoh:
  /// ```dart
  /// final items = await DatabaseService().getAll('items');
  /// ```
  Future<List<Map<String, dynamic>>> getAll(String tableName) async {
    try {
      final response = await _client.from(tableName).select();
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      print('❌ Error getting data from $tableName: $e');
      rethrow;
    }
  }

  /// Mengambil data dengan filter
  ///
  /// Contoh:
  /// ```dart
  /// final activeItems = await DatabaseService().getWhere(
  ///   'items',
  ///   column: 'status',
  ///   value: 'active',
  /// );
  /// ```
  Future<List<Map<String, dynamic>>> getWhere(
    String tableName, {
    required String column,
    required dynamic value,
  }) async {
    try {
      final response = await _client.from(tableName).select().eq(column, value);
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      print('❌ Error getting filtered data from $tableName: $e');
      rethrow;
    }
  }

  /// Mengambil satu data berdasarkan ID
  ///
  /// Contoh:
  /// ```dart
  /// final item = await DatabaseService().getById('items', 1);
  /// ```
  Future<Map<String, dynamic>?> getById(String tableName, dynamic id) async {
    try {
      final response = await _client
          .from(tableName)
          .select()
          .eq('id', id)
          .maybeSingle();
      return response;
    } catch (e) {
      print('❌ Error getting data by ID from $tableName: $e');
      rethrow;
    }
  }

  /// Insert data baru
  ///
  /// Contoh:
  /// ```dart
  /// await DatabaseService().insert('items', {
  ///   'name': 'Panci',
  ///   'quantity': 5,
  /// });
  /// ```
  Future<Map<String, dynamic>> insert(
    String tableName,
    Map<String, dynamic> data,
  ) async {
    try {
      final response = await _client
          .from(tableName)
          .insert(data)
          .select()
          .single();
      return response;
    } catch (e) {
      print('❌ Error inserting data to $tableName: $e');
      rethrow;
    }
  }

  /// Update data
  ///
  /// Contoh:
  /// ```dart
  /// await DatabaseService().update('items', 1, {
  ///   'quantity': 10,
  /// });
  /// ```
  Future<Map<String, dynamic>> update(
    String tableName,
    dynamic id,
    Map<String, dynamic> data,
  ) async {
    try {
      final response = await _client
          .from(tableName)
          .update(data)
          .eq('id', id)
          .select()
          .single();
      return response;
    } catch (e) {
      print('❌ Error updating data in $tableName: $e');
      rethrow;
    }
  }

  /// Delete data
  ///
  /// Contoh:
  /// ```dart
  /// await DatabaseService().delete('items', 1);
  /// ```
  Future<void> delete(String tableName, dynamic id) async {
    try {
      await _client.from(tableName).delete().eq('id', id);
    } catch (e) {
      print('❌ Error deleting data from $tableName: $e');
      rethrow;
    }
  }

  // ==================== Real-time Subscriptions ====================

  /// Subscribe ke perubahan data real-time
  ///
  /// Contoh:
  /// ```dart
  /// DatabaseService().subscribe('items', (payload) {
  ///   print('Data changed: $payload');
  /// });
  /// ```
  RealtimeChannel subscribe(
    String tableName,
    void Function(PostgresChangePayload payload) callback,
  ) {
    return _client
        .channel('public:$tableName')
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: tableName,
          callback: callback,
        )
        .subscribe();
  }
}
