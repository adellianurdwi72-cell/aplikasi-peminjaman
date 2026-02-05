import 'package:flutter/material.dart';

class UserTile extends StatelessWidget {
  final String name;
  final String email;
  final VoidCallback? onTap;

  const UserTile({
    super.key,
    required this.name,
    required this.email,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        onTap: onTap,
        leading: const CircleAvatar(
          backgroundColor: Colors.grey,
          child: Icon(Icons.person, color: Colors.white),
        ),
        title: Text(name),
        subtitle: Text(email),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(Icons.edit, size: 18, color: Colors.green),
            SizedBox(width: 10),
            Icon(Icons.delete, size: 18, color: Colors.red),
          ],
        ),
      ),
    );
  }
}
