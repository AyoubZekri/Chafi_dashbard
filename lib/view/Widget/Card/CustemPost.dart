import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ReportPostCard extends StatelessWidget {
  final String title;
  final String description;
  final String imageUrl;
  final String createdAt;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final VoidCallback? onShwo;

  const ReportPostCard({
    super.key,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.createdAt,
    this.onEdit,
    this.onDelete,
    this.onShwo,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // الصورة
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: Image.asset(
              imageUrl,
              height: 180,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                height: 180,
                color: Colors.grey.shade200,
                child: const Icon(Icons.image, size: 40, color: Colors.grey),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    PopupMenuButton<String>(
                      icon: const Icon(Icons.more_vert, size: 20),
                      onSelected: (value) {
                        if (value == 'edit' && onEdit != null) onEdit!();
                        if (value == 'delete' && onDelete != null) onDelete!();
                        if (value == 'Shwo' && onShwo != null) onShwo!();
                      },
                      itemBuilder: (_) => const [
                        PopupMenuItem(
                          value: 'Shwo',
                          child: Row(
                            children: [
                              Icon(
                                CupertinoIcons.pencil,
                                size: 16,
                                color: Colors.blue,
                              ),
                              SizedBox(width: 6),
                              Text('Shwo'),
                            ],
                          ),
                        ),
                        PopupMenuItem(
                          value: 'edit',
                          child: Row(
                            children: [
                              Icon(
                                CupertinoIcons.pencil,
                                size: 16,
                                color: Colors.blue,
                              ),
                              SizedBox(width: 6),
                              Text('Edit'),
                            ],
                          ),
                        ),
                        PopupMenuItem(
                          value: 'delete',
                          child: Row(
                            children: [
                              Icon(
                                CupertinoIcons.trash,
                                size: 16,
                                color: Colors.red,
                              ),
                              SizedBox(width: 6),
                              Text('Delete'),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                // النص
                Text(
                  description,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 13, color: Colors.black87),
                ),
              ],
            ),
          ),
          Spacer(),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.only(bottom: 16, left: 16, right: 16),
            child: Text(
              '${"created_at".tr} : $createdAt',
              style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
            ),
          ),
        ],
      ),
    );
  }
}
