import 'package:flutter/material.dart';

class RecentLoanCard extends StatelessWidget {
  final String name;
  final String item;
  final String status;

  const RecentLoanCard({
    super.key,
    required this.name,
    required this.item,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(name),
        subtitle: Text('Barang: $item\nStatus: $status'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              onPressed: () {},
              child: const Text('Setujui'),
            ),
            const SizedBox(width: 8),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              child: const Text('Tolak'),
            ),
          ],
        ),
      ),
    );
  }
}
