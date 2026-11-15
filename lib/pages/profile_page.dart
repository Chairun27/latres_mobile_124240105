import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../services/prefs_service.dart';
import 'login_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String _nim = '';
  bool _isLoading = true;

  final String _kesan = "Praktikum Mobile mantap, terima kasih untuk kakak-kakak asisten yang sudah sabar membimbing dan membantu kami walaupun kami sering ngantuk di lab :)";
  final String _pesan = "Semoga ilmunya berkah, bermanfaat, dan semoga kakak-kakak asisten dilancarkan untuk skripsinya sampai lulus. Aamiin";

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    // Mengambil NIM dari SharedPreferences
    final nim = await PrefsService.getLogin();
    setState(() {
      _nim = nim ?? 'Tidak diketahui';
      _isLoading = false;
    });
  }

  void _logout() async {
    // Hapus sesi login
    await PrefsService.logout();
    
    // Kembali ke halaman login dan hapus semua history navigasi (GetX) setelah logout 
    Get.offAll(() => const LoginPage());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Profile',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Colors.redAccent),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),

                  // Avatar 
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xFF1E1E1E),
                      border: Border.all(
                        color: Colors.redAccent,
                        width: 3,
                      ),
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.person,
                        size: 80,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Username 
                  const Text(
                    'Username',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _nim,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Kesan dan pesan 
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E1E1E),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey[800]!),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Kesan
                        Row(
                          children: const [
                            Text(
                              'Kesan',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _kesan,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                            height: 1.5,
                          ),
                          textAlign: TextAlign.justify,
                        ),
                        
                        const Divider(color: Colors.grey, height: 32),
                        
                        // Pesan
                        Row(
                          children: const [
                            Text(
                              'Pesan',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _pesan,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                            height: 1.5,
                          ),
                          textAlign: TextAlign.justify,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),

                  // Tombol logout 
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        // Dialog konfirmasi sebelum logout
                        Get.dialog(
                          AlertDialog(
                            backgroundColor: const Color(0xFF1E1E1E),
                            title: const Text(
                              'Konfirmasi Logout',
                              style: TextStyle(color: Colors.white),
                            ),
                            content: const Text(
                              'Apakah Anda Yakin Ingin Keluar dari Aplikasi NontonSkuy?',
                              style: TextStyle(color: Colors.grey),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Get.back(),
                                child: const Text(
                                  'Batal',
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  Get.back(); // Menutup dialog
                                  _logout();  // Jalankan fungsi logout
                                },
                                child: const Text(
                                  'Logout',
                                  style: TextStyle(
                                    color: Colors.redAccent,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                      icon: const Icon(Icons.logout, color: Colors.white),
                      label: const Text(
                        'Logout',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFE50914),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}