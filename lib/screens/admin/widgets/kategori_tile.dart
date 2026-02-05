import 'package:flutter/material.dart';

class KategoriTile extends StatelessWidget {
  final String title;
  final bool isActive;
  final VoidCallback onTap;

  const KategoriTile({
    super.key,
    required this.title,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFFF2B66D) : Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          title,
          style: const TextStyle(fontSize: 13),
        ),
      ),
    );
  }
}
