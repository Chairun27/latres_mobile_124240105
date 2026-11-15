import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'pages/login_page.dart'; 

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Inisialisasi Hive untuk database lokal (Favorit)
  await Hive.initFlutter();
  // Membuka Box Hive dengan nama 'favorites'
  await Hive.openBox('favorites');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Menggunakan GetMaterialApp agar GetX (Routing & State) berfungsi
    return GetMaterialApp(
      title: 'NontonSkuy',
      debugShowCheckedModeBanner: false,
      
      // Dark Mode 
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.redAccent,
        scaffoldBackgroundColor: const Color(0xFF121212), 
        colorScheme: const ColorScheme.dark(
          primary: Colors.redAccent,
          secondary: Colors.redAccent,
        ),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          // backgroundColor: Color(0xFFB71C1C), 
          // backgroundColor: Color(0xFFE50914), 
          backgroundColor: Colors.black,
          foregroundColor: Colors.white, 
          elevation: 0,
          centerTitle: true,
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ), 
        ),
      ),
      
      home: const LoginPage(),
    );
  }
}