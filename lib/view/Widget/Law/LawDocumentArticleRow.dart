import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controller/LawDocumentArticleMixin.dart';
import '../../../data/model/TaxArticleModel.dart';
import '../TextFild/DropdownFild.dart';
import '../TextFild/SearchableDropdownFild.dart';

/// سطر قانون تابع: اختيار الملف ثم اختيار المادة التابعة له
class LawDocumentArticleRow extends StatelessWidget {
  final LawDocumentArticleMixin controller;
  final Map<String, dynamic> lawItem;
  final int index;

  const LawDocumentArticleRow({
    super.key,
    required this.controller,
    required this.lawItem,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final documents = controller.documents;
    final articles =
        (lawItem['articles'] as List<TaxArticleModel>?) ?? const [];
    final documentId = lawItem['document_id'];
    final articleId = lawItem['article_id'];
    final loadingArticles =
        documentId != null && articles.isEmpty && articleId != null;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Dropdownfild<int>(
            label: "الملف".tr,
            hintText: "إختر الملف".tr,
            items: documents
                .map(
                  (doc) => DropdownMenuItem<int>(
                    value: doc.id,
                    child: Text(
                      doc.localizedTitle,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 14),
                    ),
                  ),
                )
                .toList(),
            // القيمة يجب أن تكون ضمن العناصر، وإلا يرمي DropdownButton خطأ
            value: documents.any((d) => d.id == documentId) ? documentId : null,
            onChanged: (val) => controller.updateLawDocumentId(index, val),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: SearchableDropdownfild<int>(
            label: "المادة".tr,
            searchHint: "ابحث بالرقم أو التسمية".tr,
            searchText: (id) {
              final article = articles.firstWhere((a) => a.id == id);
              return '${article.label} ${article.labelEn ?? ''} ${article.number ?? ''}';
            },
            hintText: documentId == null
                ? "إختر الملف أولاً".tr
                : loadingArticles
                    ? "جاري التحميل...".tr
                    : "إختر المادة".tr,
            items: articles
                .map(
                  (article) => DropdownMenuItem<int>(
                    value: article.id,
                    child: Text(
                      article.localizedLabel,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 14),
                    ),
                  ),
                )
                .toList(),
            value: articles.any((a) => a.id == articleId) ? articleId : null,
            onChanged: (val) => controller.updateLawArticleId(index, val),
          ),
        ),
      ],
    );
  }
}
