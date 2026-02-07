class Barang {
  final String barangId;
  final String namaBarang;
  final String? kategori;
  final String? keterangan;
  final int stok;
  final String kondisi;
  final String status;
  final String? fotoUrl;

  Barang({
    required this.barangId,
    required this.namaBarang,
    this.kategori,
    this.keterangan,
    required this.stok,
    this.kondisi = 'BAIK',
    this.status = 'TERSEDIA',
    this.fotoUrl,
  });

  /// Create Barang from JSON
  factory Barang.fromJson(Map<String, dynamic> json) {
    return Barang(
      barangId: json['barang_id'] as String,
      namaBarang: json['nama_barang'] as String,
      kategori: json['kategori'] as String?,
      keterangan: json['keterangan'] as String?,
      stok: json['stok'] as int,
      kondisi: json['kondisi'] as String? ?? 'BAIK',
      status: json['status'] as String? ?? 'TERSEDIA',
      fotoUrl: json['foto_url'] as String?,
    );
  }

  /// Convert Barang to JSON
  Map<String, dynamic> toJson() {
    return {
      'barang_id': barangId,
      'nama_barang': namaBarang,
      'kategori': kategori,
      'keterangan': keterangan,
      'stok': stok,
      'kondisi': kondisi,
      'status': status,
      'foto_url': fotoUrl,
    };
  }

  /// Copy with method for immutability
  Barang copyWith({
    String? barangId,
    String? namaBarang,
    String? kategori,
    String? keterangan,
    int? stok,
    String? kondisi,
    String? status,
    String? fotoUrl,
  }) {
    return Barang(
      barangId: barangId ?? this.barangId,
      namaBarang: namaBarang ?? this.namaBarang,
      kategori: kategori ?? this.kategori,
      keterangan: keterangan ?? this.keterangan,
      stok: stok ?? this.stok,
      kondisi: kondisi ?? this.kondisi,
      status: status ?? this.status,
      fotoUrl: fotoUrl ?? this.fotoUrl,
    );
  }

  /// Check if barang tersedia
  bool get isTersedia => status == 'TERSEDIA' && stok > 0;

  /// Check if kondisi baik
  bool get isKondisiBaik => kondisi == 'BAIK';

  @override
  String toString() {
    return 'Barang(id: $barangId, nama: $namaBarang, stok: $stok, status: $status)';
  }
}
