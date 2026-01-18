import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import '../../core/constant/Colorapp.dart';

class PdfSearchPage extends StatefulWidget {
  final String url;
  final int? initialPage;

  const PdfSearchPage({super.key, required this.url, this.initialPage});

  @override
  State<PdfSearchPage> createState() => _PdfSearchPageState();
}

class _PdfSearchPageState extends State<PdfSearchPage> {
  final PdfViewerController _pdfController = PdfViewerController();
  PdfTextSearchResult _searchResult = PdfTextSearchResult();
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    if (widget.initialPage != null && widget.initialPage! > 0) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _pdfController.jumpToPage(widget.initialPage!);
      });
    }
  }

  void _searchText() {
    if (_searchController.text.isEmpty) return;
    _searchResult = _pdfController.searchText(_searchController.text);
    setState(() {});
  }

  void _nextInstance() {
    if (_searchResult.hasResult) {
      _searchResult.nextInstance();
      setState(() {});
    }
  }

  void _previousInstance() {
    if (_searchResult.hasResult) {
      _searchResult.previousInstance();
      setState(() {});
    }
  }

  String _resultText() {
    if (!_searchResult.hasResult || _searchResult.totalInstanceCount == 0) {
      return "0 / 0";
    }
    return "${_searchResult.currentInstanceIndex + 1} / ${_searchResult.totalInstanceCount}";
  }

  void _showJumpToPageDialog() {
    final TextEditingController _pageController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppColor.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text(
            "اذهب إلى الصفحة",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColor.typography,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          content: TextField(
            controller: _pageController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              hintText: "أدخل رقم الصفحة",
              hintStyle: TextStyle(color: Colors.grey[400]),
              filled: true,
              fillColor: Colors.grey[100],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(
                vertical: 12,
                horizontal: 16,
              ),
            ),
            style: const TextStyle(fontSize: 16, color: Colors.black87),
          ),
          actionsPadding: const EdgeInsets.only(right: 10, bottom: 10),
          actions: [
            TextButton(
              style: TextButton.styleFrom(foregroundColor: Colors.grey[700]),
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("إلغاء"),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColor.typography,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  final int? page = int.tryParse(_pageController.text);
                  if (page != null && page > 0) {
                    _pdfController.jumpToPage(page);
                  }
                  Navigator.of(context).pop();
                },
                child: const Text("اذهب"),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      appBar: AppBar(
        title: !_isSearching
            ? const Text('PDF Viewer')
            : TextField(
                controller: _searchController,
                autofocus: true,
                decoration: const InputDecoration(
                  hintText: 'ابحث داخل الملف...',
                  border: InputBorder.none,
                  hintStyle: TextStyle(color: Colors.white54),
                ),
                style: const TextStyle(color: Colors.black, fontSize: 19),
                onSubmitted: (_) => _searchText(),
              ),
        actions: [
          if (!_isSearching)
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                setState(() {
                  _isSearching = true;
                });
              },
            )
          else ...[
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                setState(() {
                  _isSearching = false;
                  _searchController.clear();
                  _searchResult.clear();
                });
              },
            ),
            if (_searchResult.hasResult)
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: Text(
                    _resultText(),
                    style: const TextStyle(fontSize: 16, color: Colors.black),
                  ),
                ),
              ),
            IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: _previousInstance,
            ),
            IconButton(
              icon: const Icon(Icons.arrow_forward),
              onPressed: _nextInstance,
            ),
          ],
          // زر الانتقال للصفحة مع ستايل شافي
          IconButton(
            icon: const Icon(Icons.menu_book),
            tooltip: "اذهب إلى الصفحة",
            onPressed: _showJumpToPageDialog,
          ),
        ],
      ),
      body: SfPdfViewer.network(
        widget.url,
        controller: _pdfController,
        enableTextSelection: true,
      ),
    );
  }
}
