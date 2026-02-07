import 'dart:io';

/// Validator untuk form barang/alat
class BarangValidator {
  /// Validasi nama barang
  static String? validateNama(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Nama barang tidak boleh kosong';
    }
    if (value.trim().length < 3) {
      return 'Nama barang minimal 3 karakter';
    }
    return null;
  }

  /// Validasi kategori
  static String? validateKategori(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Kategori tidak boleh kosong';
    }
    return null;
  }

  /// Validasi stok
  static String? validateStok(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Stok tidak boleh kosong';
    }

    final stok = int.tryParse(value);
    if (stok == null) {
      return 'Stok harus berupa angka';
    }

    if (stok < 0) {
      return 'Stok tidak boleh negatif';
    }

    return null;
  }

  /// Validasi keterangan (optional, tapi jika diisi minimal 10 karakter)
  static String? validateKeterangan(String? value) {
    if (value != null && value.trim().isNotEmpty && value.trim().length < 10) {
      return 'Keterangan minimal 10 karakter';
    }
    return null;
  }

  /// Validasi foto file
  static String? validateFoto(File? file) {
    if (file == null) {
      return null; // Foto optional
    }

    // Cek ukuran file (max 5MB)
    final fileSizeInBytes = file.lengthSync();
    final fileSizeInMB = fileSizeInBytes / (1024 * 1024);

    if (fileSizeInMB > 5) {
      return 'Ukuran foto maksimal 5MB';
    }

    // Cek format file
    final extension = file.path.toLowerCase().split('.').last;
    if (!['jpg', 'jpeg', 'png'].contains(extension)) {
      return 'Format foto harus JPG, JPEG, atau PNG';
    }

    return null;
  }
}

/// Validator untuk form peminjaman
class PeminjamanValidator {
  /// Validasi jumlah peminjaman
  static String? validateJumlah(String? value, int stokTersedia) {
    if (value == null || value.trim().isEmpty) {
      return 'Jumlah tidak boleh kosong';
    }

    final jumlah = int.tryParse(value);
    if (jumlah == null) {
      return 'Jumlah harus berupa angka';
    }

    if (jumlah <= 0) {
      return 'Jumlah harus lebih dari 0';
    }

    if (jumlah > stokTersedia) {
      return 'Jumlah melebihi stok tersedia ($stokTersedia)';
    }

    return null;
  }

  /// Validasi tanggal pinjam
  static String? validateTanggalPinjam(DateTime? tanggal) {
    if (tanggal == null) {
      return 'Tanggal pinjam tidak boleh kosong';
    }

    // Tanggal pinjam tidak boleh lebih dari 30 hari ke depan
    final maxDate = DateTime.now().add(const Duration(days: 30));
    if (tanggal.isAfter(maxDate)) {
      return 'Tanggal pinjam maksimal 30 hari ke depan';
    }

    return null;
  }

  /// Validasi tanggal kembali
  static String? validateTanggalKembali(
    DateTime? tanggalKembali,
    DateTime? tanggalPinjam,
  ) {
    if (tanggalKembali == null) {
      return 'Tanggal kembali tidak boleh kosong';
    }

    if (tanggalPinjam == null) {
      return 'Pilih tanggal pinjam terlebih dahulu';
    }

    // Tanggal kembali harus setelah atau sama dengan tanggal pinjam
    if (tanggalKembali.isBefore(tanggalPinjam)) {
      return 'Tanggal kembali harus setelah tanggal pinjam';
    }

    // Durasi maksimal peminjaman 14 hari
    final durasi = tanggalKembali.difference(tanggalPinjam).inDays;
    if (durasi > 14) {
      return 'Durasi peminjaman maksimal 14 hari';
    }

    return null;
  }
}
