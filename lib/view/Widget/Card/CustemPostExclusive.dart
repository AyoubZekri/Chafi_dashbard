import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Custempostexclusive extends StatelessWidget {
  final String imageUrl;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final VoidCallback? onShwo;

  const Custempostexclusive({
    super.key,
    required this.imageUrl,
    this.onEdit,
    this.onDelete,
    this.onShwo,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onShwo,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Stack(
          fit: StackFit.expand, // ← هذا هو السر
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                imageUrl,
                fit: BoxFit.cover, // تملأ الكارد كامل
                errorBuilder: (_, __, ___) => Container(
                  color: Colors.grey.shade200,
                  child: const Icon(Icons.image, size: 40, color: Colors.grey),
                ),
              ),
            ),

            Positioned(
              top: 8,
              left: 8,
              child: PopupMenuButton<String>(
                icon: const Icon(
                  Icons.more_vert,
                  size: 20,
                  color: Colors.white,
                ),
                onSelected: (value) {
                  if (value == 'edit' && onEdit != null) onEdit!();
                  if (value == 'delete' && onDelete != null) onDelete!();
                },
                itemBuilder: (_) => const [
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
                        Icon(CupertinoIcons.trash, size: 16, color: Colors.red),
                        SizedBox(width: 6),
                        Text('Delete'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
