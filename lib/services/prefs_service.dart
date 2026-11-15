// Fungsinya untuk menyimpan NIM saat login dan menghapusnya saat logout (SharedPreferences) 
import 'package:shared_preferences/shared_preferences.dart';

class PrefsService {
  static const String _keyNim = 'nim_user';

  // Menyimpan NIM saat login berhasil
  static Future<void> saveLogin(String nim) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyNim, nim);
  }

  // Mengambil NIM (untuk cek apakah user sudah login)
  static Future<String?> getLogin() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyNim);
  }

  // Menghapus sesi (untuk logout)
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyNim);
  }
}