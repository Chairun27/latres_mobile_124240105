import 'package:flutter/material.dart'; 
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import '../models/show_model.dart';
import '../services/api_service.dart';

class DetailController extends GetxController {
  final ApiService _apiService = ApiService();
  final int showId;
  final ShowModel? initialShow;

  DetailController({required this.showId, this.initialShow});

  // State reaktif 
  var isLoading = true.obs;
  var show = Rxn<ShowModel>(); 
  var isFavorite = false.obs;
  var errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    if (initialShow != null) {
      show.value = initialShow;
    }
    fetchDetail();
    checkFavorite();
  }

  // Fetch detail dari API 
  Future<void> fetchDetail() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      final result = await _apiService.fetchShowDetail(showId);
      show.value = result;
    } catch (e) {
      if (show.value == null) {
        errorMessage.value = 'Gagal memuat detail show.';
      }
    } finally {
      isLoading.value = false;
    }
  }

  // Cek apakah sudah favorite 
  void checkFavorite() {
    final box = Hive.box('favorites');
    isFavorite.value = box.containsKey(showId);
  }

  // Toggle untuk favorite 
  void toggleFavorite() {
    if (show.value == null) return;
    final box = Hive.box('favorites');

    if (box.containsKey(showId)) {
      box.delete(showId);
      isFavorite.value = false;
      Get.snackbar(
        'Dihapus',
        'Show Dihapus dari Daftar Favorite',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.red.withValues(alpha: 0.9),
        colorText: Colors.white,
        margin: const EdgeInsets.all(12),
      );
    } else {
      box.put(showId, show.value!.toJson());
      isFavorite.value = true;
      Get.snackbar(
        'Ditambahkan',
        'Show Ditambahkan ke Favorite',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.green.withValues(alpha: 0.9),
        colorText: Colors.white,
        margin: const EdgeInsets.all(12),
      );
    }
  }
}