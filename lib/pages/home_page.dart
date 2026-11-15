import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../controllers/home_controller.dart';
import '../models/show_model.dart';
import 'detail_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeController controller = Get.put(HomeController());

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'NontonSkuy',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => controller.fetchShows(),
          ),
        ],
      ),
      body: Obx(() {
        // Loading 
        if (controller.isLoading.value) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(color: Colors.redAccent),
                SizedBox(height: 16),
                Text('Memuat data...', style: TextStyle(color: Colors.grey)),
              ],
            ),
          );
        }

        // Error 
        if (controller.errorMessage.value.isNotEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.wifi_off, size: 80, color: Colors.grey),
                const SizedBox(height: 16),
                Text(
                  controller.errorMessage.value,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => controller.fetchShows(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                  ),
                  child: const Text('Coba Lagi'),
                ),
              ],
            ),
          );
        }

        // Data Kosong 
        if (controller.shows.isEmpty) {
          return const Center(
            child: Text(
              'Tidak ada data show.',
              style: TextStyle(color: Colors.grey),
            ),
          );
        }

        // List View 
        return RefreshIndicator(
          color: Colors.redAccent,
          onRefresh: controller.fetchShows,
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            itemCount: controller.shows.length,
            itemBuilder: (context, index) {
              final ShowModel show = controller.shows[index];
              return _showCard(context, show);
            },
          ),
        );
      }),
    );
  }

  // Kartu Show 
  Widget _showCard(BuildContext context, ShowModel show) {
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
                          child: const Icon(
                            Icons.movie,
                            color: Colors.grey,
                          ),
                        ),
                      )
                    : Container(
                        color: const Color(0xFF1E1E1E),
                        child: const Icon(
                          Icons.movie,
                          color: Colors.grey,
                        ),
                      ),
              ),

              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
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

              // Ikon Panah 
              const Padding(
                padding: EdgeInsets.only(right: 8.0),
                child: Icon(
                  Icons.chevron_right,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}