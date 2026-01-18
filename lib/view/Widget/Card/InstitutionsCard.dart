import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class InstitutionsCard extends StatelessWidget {
  final String title;
  final String info;
  final bool isActiveCalculator;
  final bool isActiveLaw;
  final bool buttomcare;
  final String creationDate;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const InstitutionsCard({
    super.key,
    required this.title,
    required this.info,
    required this.isActiveCalculator,
    required this.isActiveLaw,
    required this.creationDate,
    this.onEdit,
    this.onDelete,
    this.buttomcare = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header: ثلاث نقاط مع PopupMenuButton
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                onSelected: (value) {
                  if (value == 'edit') {
                    if (onEdit != null) onEdit!();
                  } else if (value == 'delete') {
                    if (onDelete != null) onDelete!();
                  }
                },
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 'edit',
                    child: Row(
                      children: const [
                        Icon(
                          CupertinoIcons.pencil,
                          size: 16,
                          color: Colors.blue,
                        ),
                        SizedBox(width: 6),
                        Text(
                          'Edit',
                          style: TextStyle(color: Colors.blue, fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: const [
                        Icon(CupertinoIcons.trash, size: 16, color: Colors.red),
                        SizedBox(width: 6),
                        Text(
                          'Delete',
                          style: TextStyle(color: Colors.red, fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),

          // عنوان الكارد
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 12),

          // محتوى الكارد
          Text(
            info,
            style: const TextStyle(fontSize: 13, color: Colors.black87),
          ),
          if (buttomcare == true) ...[
            const Spacer(),
            const Divider(height: 30),
            _dataRow('calculator'.tr, isActiveCalculator),
            const SizedBox(height: 8),
            _dataRow('law'.tr, isActiveLaw),
            const Divider(height: 20),
            Text(
              '${"created_at".tr} : $creationDate',
              style: TextStyle(color: Colors.grey.shade400, fontSize: 11),
            ),
          ],
        ],
      ),
    );
  }

  Widget _dataRow(String label, bool status) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: Colors.grey)),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
          decoration: BoxDecoration(
            color: status ? const Color(0xFFE6F6F4) : const Color(0xFFF6E6E6),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            status ? 'active' : 'inactive',
            style: TextStyle(
              color: status ? const Color(0xFF00A78E) : Colors.red,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
