// Fungsinya untuk menerjemahkan data JSON dari TVMaze menjadi objek dart yang rapi 
class ShowModel {
  final int id;
  final String name;
  final String? imageUrl;
  final String? originalImageUrl; 
  final double rating;
  final List<dynamic> genres;
  final String summary;

  ShowModel({
    required this.id,
    required this.name,
    this.imageUrl,
    this.originalImageUrl, 
    required this.rating,
    required this.genres,
    required this.summary,
  });

  // Mengubah JSON dari API menjadi objek ShowModel
  factory ShowModel.fromJson(Map<String, dynamic> json) {
    return ShowModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? 'No Title',
      imageUrl: json['image'] != null ? json['image']['medium'] : null,
      originalImageUrl: json['image'] != null ? json['image']['original'] : null, 
      rating: json['rating'] != null && json['rating']['average'] != null
        ? (json['rating']['average'] as num).toDouble()
        : 0.0,
      genres: json['genres'] ?? [],
      summary: json['summary'] ?? 'Tidak ada deskripsi.',
    );
  }

  // Mengubah objek menjadi Map untuk disimpan ke Hive saat difavoritkan
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'image': {'medium': imageUrl, 'original': originalImageUrl},
      'rating': {'average': rating},
      'genres': genres,
      'summary': summary,
    };
  }
}