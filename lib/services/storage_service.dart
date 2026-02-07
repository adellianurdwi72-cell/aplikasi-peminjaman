import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../core/supabase_client.dart';

/// Service untuk mengelola upload dan delete foto ke Supabase Storage
class StorageService {
  final SupabaseClient _client = supabase;
  static const String bucketName = 'alat-photos';

  /// Upload foto ke Supabase Storage
  ///
  /// [file] - File foto yang akan diupload
  /// [fileName] - Nama file (gunakan unique name, misal: timestamp_originalname)
  ///
  /// Returns: Public URL dari foto yang diupload
  ///
  /// Contoh:
  /// ```dart
  /// final url = await StorageService().uploadFoto(
  ///   imageFile,
  ///   '${DateTime.now().millisecondsSinceEpoch}_photo.jpg',
  /// );
  /// ```
  Future<String> uploadFoto(File file, String fileName) async {
    try {
      // Upload file ke bucket
      await _client.storage
          .from(bucketName)
          .upload(
            fileName,
            file,
            fileOptions: const FileOptions(cacheControl: '3600', upsert: false),
          );

      // Dapatkan public URL
      final url = _client.storage.from(bucketName).getPublicUrl(fileName);

      print('✅ Foto berhasil diupload: $url');
      return url;
    } catch (e) {
      print('❌ Error upload foto: $e');
      rethrow;
    }
  }

  /// Delete foto dari Supabase Storage
  ///
  /// [fileName] - Nama file yang akan dihapus
  ///
  /// Contoh:
  /// ```dart
  /// await StorageService().deleteFoto('1234567890_photo.jpg');
  /// ```
  Future<void> deleteFoto(String fileName) async {
    try {
      await _client.storage.from(bucketName).remove([fileName]);
      print('✅ Foto berhasil dihapus: $fileName');
    } catch (e) {
      print('❌ Error delete foto: $e');
      rethrow;
    }
  }

  /// Mendapatkan public URL dari foto
  ///
  /// [fileName] - Nama file
  ///
  /// Returns: Public URL
  String getFotoUrl(String fileName) {
    return _client.storage.from(bucketName).getPublicUrl(fileName);
  }

  /// Extract nama file dari URL
  ///
  /// Contoh: https://xxx.supabase.co/storage/v1/object/public/alat-photos/123_photo.jpg
  /// Returns: 123_photo.jpg
  String? extractFileNameFromUrl(String? url) {
    if (url == null || url.isEmpty) return null;

    try {
      final uri = Uri.parse(url);
      final pathSegments = uri.pathSegments;

      // Path format: storage/v1/object/public/bucket-name/file-name
      if (pathSegments.length >= 6 && pathSegments[5].isNotEmpty) {
        return pathSegments[5];
      }
      return null;
    } catch (e) {
      print('❌ Error extract filename: $e');
      return null;
    }
  }

  /// Validasi ukuran file (max 5MB)
  bool validateFileSize(File file, {int maxSizeInMB = 5}) {
    final fileSizeInBytes = file.lengthSync();
    final fileSizeInMB = fileSizeInBytes / (1024 * 1024);
    return fileSizeInMB <= maxSizeInMB;
  }

  /// Validasi format file (hanya jpg, jpeg, png)
  bool validateFileFormat(String fileName) {
    final extension = fileName.toLowerCase().split('.').last;
    return ['jpg', 'jpeg', 'png'].contains(extension);
  }
}
