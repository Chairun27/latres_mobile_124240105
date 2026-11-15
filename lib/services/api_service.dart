// Fungsinya untuk mengambil data dari internet (TVMaze)
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/show_model.dart';

class ApiService {
  static const String baseUrl = 'https://api.tvmaze.com';

  // Mengambil daftar semua show 
  Future<List<ShowModel>> fetchShows() async {
    final response = await http.get(Uri.parse('$baseUrl/shows'));

    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      return body.map((dynamic item) => ShowModel.fromJson(item)).toList();
    } else {
      throw Exception('Gagal memuat data shows');
    }
  }

  // Mengambil detail show berdasarkan id 
  Future<ShowModel> fetchShowDetail(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/shows/$id'));

    if (response.statusCode == 200) {
      return ShowModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Gagal memuat detail show');
    }
  }
}