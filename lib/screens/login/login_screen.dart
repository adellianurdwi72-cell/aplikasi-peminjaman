import 'package:flutter/material.dart';
import '../admin/dashboard/admin_dashboard_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String selectedRole = 'admin';

  final List<String> roles = [
    'admin',
    'petugas',
    'anggota',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3EED9), // warna background krem
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const SizedBox(height: 80),

              /// LOGO
              Image.asset(
                'assets/images/logo.png',
                width: 140,
              ),

              const SizedBox(height: 24),

              /// TEXT SELAMAT DATANG
              const Text(
                'Selamat Datang!',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Silahkan masuk untuk melanjutkan.',
                style: TextStyle(color: Colors.black54),
              ),

              const SizedBox(height: 32),

              /// CARD LOGIN
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFFB7D1A3), // hijau muda
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Login',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),

                    /// DROPDOWN PENGGUNA
                    DropdownButtonFormField<String>(
                      value: selectedRole,
                      items: roles
                          .map(
                            (role) => DropdownMenuItem(
                              value: role,
                              child: Text(role.capitalize()),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedRole = value!;
                        });
                      },
                      decoration: _inputDecoration(
                        hint: 'Pengguna',
                        icon: Icons.person_outline,
                      ),
                    ),

                    const SizedBox(height: 14),

                    /// EMAIL
                    TextField(
                      decoration: _inputDecoration(
                        hint: 'Email',
                        icon: Icons.email_outlined,
                      ),
                    ),

                    const SizedBox(height: 14),

                    /// PASSWORD
                    TextField(
                      obscureText: true,
                      decoration: _inputDecoration(
                        hint: 'Kata Sandi',
                        icon: Icons.lock_outline,
                      ),
                    ),

                    const SizedBox(height: 10),

                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        'Forgot Password',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    /// BUTTON MASUK
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFF2B66D), // kuning
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        onPressed: () {
                          if (selectedRole == 'admin') {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    const AdminDashboardScreen(),
                              ),
                            );
                          }
                        },
                        child: const Text(
                          'Masuk',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// DEKORASI INPUT
  InputDecoration _inputDecoration({
    required String hint,
    required IconData icon,
  }) {
    return InputDecoration(
      hintText: hint,
      prefixIcon: Icon(icon),
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: BorderSide.none,
      ),
      contentPadding: const EdgeInsets.symmetric(vertical: 14),
    );
  }
}

/// EXTENSION UNTUK CAPITALIZE TEXT
extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}
