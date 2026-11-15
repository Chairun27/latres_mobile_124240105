import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import '../models/show_model.dart';

class FavoriteController extends GetxController {
  final box = Hive.box('favorites');

  // State reaktif otomatis update saat box berubah
  var favorites = <ShowModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadFavorites();

    // Kalau box berubah (dari Home/Detail/Favorites) ada reload
    box.watch().listen((_) => loadFavorites());
  }

  // Load data dari hive 
  void loadFavorites() {
    final List<ShowModel> loaded = [];

    for (var key in box.keys) {
      final data = box.get(key);
      if (data != null) {
        try {
          // Konversi map dari hive ke ShowModel
          loaded.add(_fromHive(key as int, Map<dynamic, dynamic>.from(data)));
        } catch (e) {
          debugPrint('Error load favorite: $e');
        }
      }
    }

    favorites.value = loaded;
  }

  ShowModel _fromHive(int id, Map<dynamic, dynamic> data) {
    final image = data['image'] ?? {};
    final rating = data['rating'] ?? {};
    final genresRaw = data['genres'];

    return ShowModel(
      id: id,
      name: data['name']?.toString() ?? 'No Title',
      imageUrl: image['medium']?.toString(),
      originalImageUrl: image['original']?.toString(),
      rating: (rating['average'] as num?)?.toDouble() ?? 0.0,
      genres: genresRaw is List ? genresRaw.toList() : [],
      summary: data['summary']?.toString() ?? 'Tidak ada deskripsi.',
    );
  }

  // Hapus dari favorite 
  void removeFavorite(int id) {
    box.delete(id);
    loadFavorites();

    Get.snackbar(
      'Dihapus',
      'Show Berhasil Dihapus dari Favorite',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
      backgroundColor: Colors.red,
      colorText: Colors.white,
      margin: const EdgeInsets.all(12),
    );
  }
}