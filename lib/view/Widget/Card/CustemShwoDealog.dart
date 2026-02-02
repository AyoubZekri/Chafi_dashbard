import 'package:flutter/material.dart';

class ReportPostDialogContent extends StatelessWidget {
  final String title;
  final String description;
  final String imageUrl;
  final String createdAt;

  const ReportPostDialogContent({
    super.key,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.createdAt,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // الصورة
        ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
          child: Image.network(
            imageUrl,
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

              const SizedBox(height: 20),
              const Divider(),

              // التاريخ
              Text(
                'تاريخ النشر : $createdAt',
                style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
