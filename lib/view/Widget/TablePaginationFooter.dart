import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/constant/Colorapp.dart';

class TablePaginationFooter extends StatefulWidget {
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
  State<TablePaginationFooter> createState() => _TablePaginationFooterState();
}

class _TablePaginationFooterState extends State<TablePaginationFooter> {
  @override
  Widget build(BuildContext context) {
    int startEntry = widget.totalEntries == 0
        ? 0
        : (widget.currentPage * widget.rowsPerPage) + 1;
    int endEntry =
        (widget.currentPage * widget.rowsPerPage) +
        widget.currentFilteredLength;

    return LayoutBuilder(
      builder: (context, constraints) {
        bool isMobile = constraints.maxWidth < 330;
        return Padding(
          padding: const EdgeInsets.only(top: 20),
          child: Row(
            mainAxisAlignment: isMobile
                ? MainAxisAlignment.center
                : MainAxisAlignment.spaceBetween,
            children: [
              if (!isMobile)
                Text(
                  "${'showing'.tr} $startEntry ${'to'.tr} $endEntry ${'of'.tr} ${widget.totalEntries} ${'entries'.tr}",
                  style: const TextStyle(
                    color: Color(0xFF5A6A85),
                    fontSize: 13,
                  ),
                ),
              Row(
                children: [
                  _pageButton(
                    label: 'previous'.tr,
                    onPressed: widget.currentPage > 0
                        ? widget.onPrevious
                        : null,
                  ),
                  const SizedBox(width: 5),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 1,
                    ),
                    decoration: BoxDecoration(
                      color: AppColor.typography,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      "${widget.currentPage + 1}",
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 5),
                  _pageButton(
                    label: 'next'.tr,
                    onPressed: (widget.currentPage + 1) < widget.totalPages
                        ? widget.onNext
                        : null,
                  ),
                ],
              ),
            ],
          ),
        );
      },
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
