import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../controllers/detail_controller.dart';
import '../models/show_model.dart';

class DetailPage extends StatefulWidget {
  final int showId;
  final ShowModel? initialShow;

  const DetailPage({
    super.key,
    required this.showId,
    this.initialShow,
  });

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  late final DetailController controller;
  late final String _tag;

  @override
  void initState() {
    super.initState();
    _tag = 'detail_${widget.showId}';

    if (Get.isRegistered<DetailController>(tag: _tag)) {
      Get.delete<DetailController>(tag: _tag);
    }

    controller = Get.put(
      DetailController(
        showId: widget.showId,
        initialShow: widget.initialShow,
      ),
      tag: _tag,
    );
  }

  @override
  void dispose() {
    Get.delete<DetailController>(tag: _tag);
    super.dispose();
  }

  // Hapus tag HTML dari summary
  String _stripHtml(String htmlText) {
    return htmlText
        .replaceAll(RegExp(r'<[^>]*>'), '')
        .replaceAll('&nbsp;', ' ')
        .replaceAll('&amp;', '&')
        .replaceAll('&lt;', '<')
        .replaceAll('&gt;', '>')
        .replaceAll('&quot;', '"')
        .replaceAll('&#39;', "'")
        .trim();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail'),
      ),
      body: Obx(() {
        // Loading 
        if (controller.isLoading.value && controller.show.value == null) {
          return const Center(
            child: CircularProgressIndicator(color: Colors.redAccent),
          );
        }

        // Error 
        if (controller.errorMessage.value.isNotEmpty && controller.show.value == null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 80, color: Colors.grey),
                const SizedBox(height: 16),
                Text(
                  controller.errorMessage.value,
                  style: const TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: controller.fetchDetail,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                  ),
                  child: const Text('Coba Lagi'),
                ),
              ],
            ),
          );
        }

        final show = controller.show.value;
        if (show == null) return const SizedBox.shrink();

        // Detail show 
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Gambar 
              Container(
                width: double.infinity,
                height: 340,
                color: const Color(0xFF1E1E1E),
                child: (show.originalImageUrl ?? show.imageUrl) != null
                    ? CachedNetworkImage(
                        imageUrl: show.originalImageUrl ?? show.imageUrl!,
                        fit: BoxFit.contain,
                        placeholder: (context, url) => const Center(
                          child: CircularProgressIndicator(
                            color: Colors.redAccent,
                          ),
                        ),
                        errorWidget: (context, url, error) => const Center(
                          child: Icon(
                            Icons.movie,
                            size: 80,
                            color: Colors.grey,
                          ),
                        ),
                      )
                    : const Center(
                        child: Icon(
                          Icons.movie,
                          size: 80,
                          color: Colors.grey,
                        ),
                      ),
              ),

              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Judul 
                    Text(
                      show.name,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Rating 
                    Row(
                      children: [
                        const Icon(
                          Icons.star,
                          size: 18,
                          color: Colors.amber,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          show.rating > 0
                              ? '${show.rating.toStringAsFixed(1)} / 10'
                              : 'Belum Ada Rating',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Genre 
                    if (show.genres.isNotEmpty) ...[
                      const Text(
                        'Genre',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8.0,
                        runSpacing: 8.0,
                        children: show.genres.map((genre) {
                          return Chip(
                            label: Text(
                              genre.toString(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                            backgroundColor: const Color(0xFF2A2A2A),
                            side: BorderSide(
                              color: Colors.redAccent.withValues(alpha: 0.5),
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 16),
                    ],

                    // Tombol favorite saja tanpa tombol nonton 
                    // SizedBox(
                    //   width: double.infinity,
                    //   height: 50,
                    //   child: ElevatedButton.icon(
                    //     onPressed: controller.toggleFavorite,
                    //     icon: Icon(
                    //       controller.isFavorite.value
                    //           ? Icons.favorite
                    //           : Icons.favorite_border,
                    //       color: Colors.white,
                    //     ),
                    //     label: Text(
                    //       controller.isFavorite.value
                    //           ? 'Hapus dari Favorit'
                    //           : 'Tambah ke Favorit',
                    //       style: const TextStyle(
                    //         fontSize: 16,
                    //         fontWeight: FontWeight.bold,
                    //       ),
                    //     ),
                    //     style: ElevatedButton.styleFrom(
                    //       backgroundColor: controller.isFavorite.value
                    //           ? Colors.grey[700]
                    //           : Colors.redAccent,
                    //       foregroundColor: Colors.white,
                    //       shape: RoundedRectangleBorder(
                    //         borderRadius: BorderRadius.circular(12),
                    //       ),
                    //     ),
                    //   ),
                    // ),
                    // const SizedBox(height: 24),

                    Row(
                      children: [
                        // Tombol Nonton 
                        Expanded(
                          child: SizedBox(
                            height: 50,
                            child: ElevatedButton.icon(
                              onPressed: () {
                                // Aksi dummy karena belum ada fitur video player
                                Get.snackbar(
                                  'Info',
                                  'Fitur Streaming Belum Tersedia',
                                  snackPosition: SnackPosition.BOTTOM,
                                  backgroundColor: Colors.white,
                                  colorText: Colors.black,
                                  margin: const EdgeInsets.all(12),
                                );
                              },
                              icon: const Icon(Icons.play_arrow, color: Colors.white),
                              label: const Text(
                                'Nonton',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFE50914), 
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12), 

                        // Tombol Favorit 
                        Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                            color: const Color(0xFF2A2A2A), 
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: controller.isFavorite.value 
                                ? Colors.redAccent 
                                : Colors.transparent, 
                              width: 1.5,
                            ),
                          ),
                          child: IconButton(
                            onPressed: controller.toggleFavorite,
                            icon: Icon(
                              controller.isFavorite.value
                                ? Icons.favorite
                                : Icons.favorite_border,
                              color: controller.isFavorite.value
                                ? Colors.redAccent
                                : Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Overview 
                    const Text(
                      'Overview',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _stripHtml(show.summary),
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                        height: 1.5,
                      ),
                      textAlign: TextAlign.justify,
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}