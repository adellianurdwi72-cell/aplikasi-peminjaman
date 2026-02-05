import 'package:flutter/material.dart';

class BarangCard extends StatelessWidget {
  final String nama;
  final String status;

  const BarangCard({
    super.key,
    required this.nama,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(Icons.image),
        ),
        title: Text(nama),
        subtitle: Text(status),
        trailing: Icon(
          Icons.circle,
          size: 10,
          color: status == 'Tersedia' ? Colors.green : Colors.orange,
        ),
      ),
    );
  }
}
