import 'package:flutter/material.dart';

class PeminjamanCard extends StatelessWidget {
  final String initial;
  final Color initialColor;
  final String nama;
  final String barang;
  final String tanggal;
  final String status;

  const PeminjamanCard({
    super.key,
    required this.initial,
    required this.initialColor,
    required this.nama,
    required this.barang,
    required this.tanggal,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// AVATAR
          CircleAvatar(
            radius: 22,
            backgroundColor: initialColor,
            child: Text(
              initial,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),

          const SizedBox(width: 12),

          /// INFO
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      nama,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    _statusChip(status),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  barang,
                  style: const TextStyle(color: Colors.black87),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(
                      Icons.calendar_month_outlined,
                      size: 16,
                      color: Colors.grey,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      tanggal,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// STATUS CHIP
  Widget _statusChip(String status) {
    Color bgColor;
    Color textColor = Colors.white;

    switch (status) {
      case 'Selesai':
        bgColor = Colors.blue;
        break;
      case 'Disetujui':
        bgColor = Colors.green;
        break;
      case 'Dipending':
        bgColor = Colors.red;
        break;
      case 'Terlambat':
        bgColor = Colors.orange;
        break;
      default:
        bgColor = Colors.grey;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status,
        style: TextStyle(
          fontSize: 12,
          color: textColor,
        ),
      ),
    );
  }
}
