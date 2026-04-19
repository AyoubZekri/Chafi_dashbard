import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ReportPostDialogContent extends StatelessWidget {
  final String title;
  final String description;
  final String? imageUrl;
  final String createdAt;
  final String? calcul;
  final List<dynamic>? laws;

  const ReportPostDialogContent({
    super.key,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.createdAt,
    this.calcul,
    this.laws,
  });

  @override
  Widget build(BuildContext context) {
    final hasImage =
        imageUrl != null && imageUrl!.isNotEmpty && imageUrl != "null";
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (hasImage)
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: Image.network(
              imageUrl!,
              height: 300,
              width: double.infinity,
              fit: BoxFit.contain,
            ),
          ),

        Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // العنوان
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 12),

              // النص كامل (بدون maxLines)
              Text(
                description,
                style: const TextStyle(
                  fontSize: 14,
                  height: 1.6,
                  color: Colors.black87,
                ),
              ),

              if (calcul != null && calcul!.isNotEmpty) ...[
                const SizedBox(height: 20),
                const Divider(),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Icon(Icons.calculate_outlined, color: Colors.blueAccent, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      "calculator".tr,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.blue.shade100),
                  ),
                  child: Text(
                    calcul!.tr,
                    style: TextStyle(color: Colors.blue.shade900, fontSize: 13, fontWeight: FontWeight.w500),
                  ),
                ),
              ],

              if (laws != null && laws!.isNotEmpty) ...[
                const SizedBox(height: 20),
                const Divider(),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Icon(Icons.gavel_outlined, color: Colors.orangeAccent, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      "laws".tr,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: laws!.map((law) {
                    final lawName = Get.locale?.languageCode == 'ar'
                        ? (law['name_ar'] ?? "law_item_title".tr)
                        : (law['name_fr'] ?? "law_item_title".tr);
                    
                    return IntrinsicWidth(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.orange.shade50.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.orange.shade100),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.description_outlined, size: 14, color: Colors.orangeAccent),
                            const SizedBox(width: 8),
                            Flexible(
                              child: Text(
                                lawName,
                                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                              ),
                            ),
                            if (law['index_link'] != null) ...[
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8),
                                child: Text("|", style: TextStyle(color: Colors.orange.shade200)),
                              ),
                              Text(
                                "P. ${law['index_link']}",
                                style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.orange.shade900),
                              ),
                            ],
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],

              const SizedBox(height: 20),
              const Divider(),

              // التاريخ
              Text(
                '${"created_at".tr} : $createdAt',
                style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
