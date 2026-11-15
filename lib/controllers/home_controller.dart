import 'package:get/get.dart';
import '../models/show_model.dart';
import '../services/api_service.dart';

class HomeController extends GetxController {
  final ApiService _apiService = ApiService();

  var isLoading = true.obs;
  var shows = <ShowModel>[].obs;
  var errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchShows(); 
  }

  Future<void> fetchShows() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final result = await _apiService.fetchShows();
      shows.value = result;
    } catch (e) {
      errorMessage.value = 'Gagal memuat data. Periksa koneksi internet kamu.';
    } finally {
      isLoading.value = false;
    }
  }
}