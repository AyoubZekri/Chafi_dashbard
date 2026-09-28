import 'package:get/get.dart';

import '../core/class/Statusrequest.dart';
import '../core/functions/handlingdatacontroller.dart';
import '../data/datasource/Remote/TaxArticlesData.dart';
import '../data/datasource/Remote/TaxSearchData.dart';
import '../data/model/TaxArticleModel.dart';
import '../data/model/TaxSearchModel.dart';

/// ربط كل قانون تابع بملف من "جبايتك" وبمادة من هذا الملف.
///
/// يُستعمل في شاشات إضافة/تعديل المؤسسات، الأنظمة الجبائية، الجزاءات والمقالات.
/// كل عنصر في [lawsList] يحمل document_id و article_id، وقائمة المواد المحملة
/// تحت المفتاح 'articles' (للعرض فقط، تُحذف قبل الإرسال عبر [lawsForRequest]).
mixin LawDocumentArticleMixin on GetxController {
  List<Map<String, dynamic>> get lawsList;

  final TaxSearchData taxSearchData = TaxSearchData(Get.find());
  final TaxArticlesData taxArticlesData = TaxArticlesData(Get.find());

  List<TaxSearchModel> documents = [];

  // مواد كل ملف تُجلب مرة واحدة فقط
  final Map<int, List<TaxArticleModel>> _articlesCache = {};

  Map<String, dynamic> newLawEntry() => {
        "law_id": null,
        "name_ar": "",
        "name_fr": "",
        "index_link": null,
        "document_id": null,
        "article_id": null,
        "articles": <TaxArticleModel>[],
      };

  Future<void> viewdataDocuments() async {
    var response = await taxSearchData.viewdata({});
    if (handlingData(response) == Statusrequest.success &&
        (response["status"] == 1 || response["status"] == true)) {
      List listdata = response['data'];
      documents = listdata.map((e) => TaxSearchModel.fromJson(e)).toList();
      update();
    }
  }

  Future<List<TaxArticleModel>> _articlesOf(int documentId) async {
    final cached = _articlesCache[documentId];
    if (cached != null) return cached;
    var response =
        await taxArticlesData.viewdata({"document_id": documentId.toString()});
    if (handlingData(response) == Statusrequest.success &&
        (response["status"] == 1 || response["status"] == true)) {
      List listdata = response['data'];
      final articles =
          listdata.map((e) => TaxArticleModel.fromJson(e)).toList();
      _articlesCache[documentId] = articles;
      return articles;
    }
    return [];
  }

  Future<void> updateLawDocumentId(int index, int? value) async {
    final law = lawsList[index];
    law['document_id'] = value;
    law['article_id'] = null;
    law['articles'] = <TaxArticleModel>[];
    update();
    if (value == null) return;

    final articles = await _articlesOf(value);
    // تجاهل النتيجة إذا غيّر المستخدم الملف أو حذف القانون أثناء التحميل
    if (index < lawsList.length &&
        identical(lawsList[index], law) &&
        law['document_id'] == value) {
      law['articles'] = articles;
      update();
    }
  }

  void updateLawArticleId(int index, int? value) {
    lawsList[index]['article_id'] = value;
    update();
  }

  /// عند التعديل: تحميل مواد الملف لكل قانون محفوظ مع الإبقاء على المادة المختارة
  Future<void> restoreLawArticles() async {
    for (final law in List<Map<String, dynamic>>.from(lawsList)) {
      final documentId = law['document_id'];
      if (documentId is! int) continue;
      law['articles'] = await _articlesOf(documentId);
    }
    update();
  }

  /// نسخة من القوانين بدون قائمة المواد (كائنات لا يمكن تحويلها إلى JSON)
  List<Map<String, dynamic>> get lawsForRequest => lawsList
      .map((law) => Map<String, dynamic>.from(law)..remove('articles'))
      .toList();

  /// قراءة document_id و article_id من قانون قادم من الباك اند
  static int? readId(dynamic value) =>
      value == null ? null : int.tryParse(value.toString());
}
