import 'package:flutter/material.dart';

class Peminjaman {
  final String pinjamId;
  final String userId;
  final String barangId;
  final DateTime tanggalPinjam;
  final DateTime tanggalKembali;
  final int jumlah;
  final String status;
  final String? keterangan;

  // Relasi (dari join query)
  final Map<String, dynamic>? userData;
  final Map<String, dynamic>? barangData;

  Peminjaman({
    required this.pinjamId,
    required this.userId,
    required this.barangId,
    required this.tanggalPinjam,
    required this.tanggalKembali,
    required this.jumlah,
    this.status = 'PENDING',
    this.keterangan,
    this.userData,
    this.barangData,
  });

  /// Create Peminjaman from JSON
  factory Peminjaman.fromJson(Map<String, dynamic> json) {
    return Peminjaman(
      pinjamId: json['pinjam_id'] as String,
      userId: json['user_id'] as String,
      barangId: json['barang_id'] as String,
      tanggalPinjam: DateTime.parse(json['tanggal_pinjam'] as String),
      tanggalKembali: DateTime.parse(json['tanggal_kembali'] as String),
      jumlah: json['jumlah'] as int? ?? 1,
      status: json['status'] as String? ?? 'PENDING',
      keterangan: json['keterangan'] as String?,
      userData: json['users'] as Map<String, dynamic>?,
      barangData: json['barang'] as Map<String, dynamic>?,
    );
  }

  /// Convert Peminjaman to JSON
  Map<String, dynamic> toJson() {
    return {
      'pinjam_id': pinjamId,
      'user_id': userId,
      'barang_id': barangId,
      'tanggal_pinjam': tanggalPinjam.toIso8601String().split('T')[0],
      'tanggal_kembali': tanggalKembali.toIso8601String().split('T')[0],
      'jumlah': jumlah,
      'status': status,
      'keterangan': keterangan,
    };
  }

  /// Copy with method
  Peminjaman copyWith({
    String? pinjamId,
    String? userId,
    String? barangId,
    DateTime? tanggalPinjam,
    DateTime? tanggalKembali,
    int? jumlah,
    String? status,
    String? keterangan,
    Map<String, dynamic>? userData,
    Map<String, dynamic>? barangData,
  }) {
    return Peminjaman(
      pinjamId: pinjamId ?? this.pinjamId,
      userId: userId ?? this.userId,
      barangId: barangId ?? this.barangId,
      tanggalPinjam: tanggalPinjam ?? this.tanggalPinjam,
      tanggalKembali: tanggalKembali ?? this.tanggalKembali,
      jumlah: jumlah ?? this.jumlah,
      status: status ?? this.status,
      keterangan: keterangan ?? this.keterangan,
      userData: userData ?? this.userData,
      barangData: barangData ?? this.barangData,
    );
  }

  /// Get nama user dari userData
  String get namaUser => userData?['nama'] as String? ?? 'Unknown';

  /// Get nama barang dari barangData
  String get namaBarang => barangData?['nama_barang'] as String? ?? 'Unknown';

  /// Get status color
  Color get statusColor {
    switch (status.toUpperCase()) {
      case 'PENDING':
        return Colors.orange;
      case 'DIPINJAM':
        return Colors.blue;
      case 'DIKEMBALIKAN':
        return Colors.green;
      case 'TERLAMBAT':
        return Colors.red;
      case 'DITOLAK':
        return Colors.grey;
      default:
        return Colors.grey;
    }
  }

  /// Check if terlambat
  bool get isTerlambat {
    return DateTime.now().isAfter(tanggalKembali) &&
        (status == 'DIPINJAM' || status == 'PENDING');
  }

  /// Get durasi peminjaman (dalam hari)
  int get durasiHari {
    return tanggalKembali.difference(tanggalPinjam).inDays;
  }

  @override
  String toString() {
    return 'Peminjaman(id: $pinjamId, user: $namaUser, barang: $namaBarang, status: $status)';
  }
}
