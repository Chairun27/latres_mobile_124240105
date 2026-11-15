import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../controllers/favorite_controller.dart';
import '../models/show_model.dart';
import 'detail_page.dart';

class FavoritePage extends StatelessWidget {
  const FavoritePage({super.key});

  @override
  Widget build(BuildContext context) {
    final FavoriteController controller = Get.put(FavoriteController());

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Daftar Favorite',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Obx(() {
        // Favorite Kosong 
        if (controller.favorites.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 16),
                const Text(
                  'Belum Ada Show Favorite',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Tambahkan dari Halaman Detail Show',
                  style: TextStyle(
                    fontSize: 13, 
                    color: Colors.grey),
                ),
              ],
            ),
          );
        }

        // List Show Favorite 
        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          itemCount: controller.favorites.length,
          itemBuilder: (context, index) {
            final ShowModel show = controller.favorites[index];
            return _favoriteCard(context, controller, show);
          },
        );
      }),
    );
  }

  // Show Favorite 
  Widget _favoriteCard(
    BuildContext context,
    FavoriteController controller,
    ShowModel show,
  ) {
    return GestureDetector(
      onTap: () {
        Get.to(() => DetailPage(showId: show.id, initialShow: show));
      },
      child: Card(
        margin: const EdgeInsets.only(bottom: 10),
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        clipBehavior: Clip.antiAlias,
        child: SizedBox(
          height: 110,
          child: Row(
            children: [
              // Gambar 
              SizedBox(
                width: 90,
                height: double.infinity,
                child: show.imageUrl != null
                    ? CachedNetworkImage(
                        imageUrl: show.imageUrl!,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Container(
                          color: const Color(0xFF1E1E1E),
                          child: const Center(
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.redAccent,
                            ),
                          ),
                        ),
                        errorWidget: (context, url, error) => Container(
                          color: const Color(0xFF1E1E1E),
                          child: const Icon(Icons.movie, color: Colors.grey),
                        ),
                      )
                    : Container(
                        color: const Color(0xFF1E1E1E),
                        child: const Icon(Icons.movie, color: Colors.grey),
                      ),
              ),

              // Info 
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Judul
                      Text(
                        show.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: Colors.white,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),

                      // Rating
                      Row(
                        children: [
                          const Icon(
                            Icons.star,
                            size: 16,
                            color: Colors.amber,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            show.rating > 0
                                ? show.rating.toStringAsFixed(1)
                                : 'N/A',
                            style: const TextStyle(
                              fontSize: 13,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // Tombol Hapus dari Favorite 
              IconButton(
                tooltip: 'Hapus dari favorit',
                icon: const Icon(
                  Icons.delete_outline,
                  color: Colors.redAccent,
                ),
                onPressed: () => _confirmDelete(context, controller, show),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Dialog Konfirmasi Hapus 
  void _confirmDelete(
    BuildContext context,
    FavoriteController controller,
    ShowModel show,
  ) {
    Get.dialog(
      AlertDialog(
        backgroundColor: const Color(0xFF1E1E1E),
        title: const Text(
          'Hapus dari Favorite?',
          style: TextStyle(color: Colors.white),
        ),
        content: Text(
          '"${show.name}" Akan Dihapus dari Daftar Favorite',
          style: const TextStyle(color: Colors.grey),
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
              Get.back(); 
              controller.removeFavorite(show.id);
            },
            child: const Text(
              'Hapus',
              style: TextStyle(
                color: Colors.redAccent,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}