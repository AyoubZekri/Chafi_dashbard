import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TablePaginationFooter extends StatelessWidget {
  final int currentPage;
  final int rowsPerPage;
  final int totalEntries;
  final int totalPages;
  final int currentFilteredLength;
  final VoidCallback onNext;
  final VoidCallback onPrevious;

  const TablePaginationFooter({
    super.key,
    required this.currentPage,
    required this.rowsPerPage,
    required this.totalEntries,
    required this.totalPages,
    required this.currentFilteredLength,
    required this.onNext,
    required this.onPrevious,
  });

  @override
  Widget build(BuildContext context) {
    int startEntry = totalEntries == 0 ? 0 : (currentPage * rowsPerPage) + 1;
    int endEntry = (currentPage * rowsPerPage) + currentFilteredLength;

    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "${'showing'.tr} $startEntry ${'to'.tr} $endEntry ${'of'.tr} $totalEntries ${'entries'.tr}",
            style: const TextStyle(color: Color(0xFF5A6A85), fontSize: 13),
          ),
          Row(
            children: [
              _pageButton(
                label: 'previous'.tr,
                onPressed: currentPage > 0 ? onPrevious : null,
              ),
              const SizedBox(width: 5),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF6269F2),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  "${currentPage + 1}",
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 5),
              _pageButton(
                label: 'next'.tr,
                onPressed: (currentPage + 1) < totalPages ? onNext : null,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _pageButton({required String label, VoidCallback? onPressed}) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        foregroundColor: onPressed == null
            ? Colors.grey
            : const Color(0xFF5A6A85),
        backgroundColor: Colors.grey.shade100,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      ),
      child: Text(label),
    );
  }
}