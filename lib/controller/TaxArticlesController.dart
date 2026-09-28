import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../core/class/Statusrequest.dart';
import '../core/functions/Snacpar copy.dart';
import '../core/functions/handlingdatacontroller.dart';
import '../data/datasource/Remote/TaxArticlesData.dart';
import '../data/datasource/Remote/TaxSearchData.dart';
import '../data/model/TaxArticleModel.dart';
import '../data/model/TaxSearchModel.dart';

class TaxArticlesController extends GetxController {
  final labelController = TextEditingController();
  final numberController = TextEditingController();
  final numberIntController = TextEditingController();
  final textController = TextEditingController();
  final labelEnController = TextEditingController();
  final textEnController = TextEditingController();
  final sortOrderController = TextEditingController();
  final pageStartController = TextEditingController();
  final pageEndController = TextEditingController();

  // قيم نافذة الإضافة/التعديل
  int? formDocumentId;
  String formPart = 'code';
  bool formIsRepealed = false;

  // جداول المادة في النافذة؛ لا تُرسل إلا إذا تم تعديلها
  // لأن الباك اند يحذف الجداول القديمة ويعيد إنشاءها عند إرسالها
  List<TaxArticleTable> formTables = [];
  bool tablesChanged = false;

  TaxArticlesData taxArticlesData = TaxArticlesData(Get.find());
  TaxSearchData taxSearchData = TaxSearchData(Get.find());
  GlobalKey<FormState> formState = GlobalKey<FormState>();
  Statusrequest statusrequest = Statusrequest.none;

  // الملفات (لفلتر المواد حسب الملف)
  List<TaxSearchModel> documents = [];
  int? selectedDocumentId;

  List<TaxArticleModel> data = [];
  List<TaxArticleModel> filteredData = [];
  String searchQuery = '';

  // Pagination properties
  int currentPage = 0;
  int rowsPerPage = 10;
  int get totalPages => (filteredData.length / rowsPerPage).ceil();
  List<TaxArticleModel> get pagedData {
    int start = currentPage * rowsPerPage;
    int end = start + rowsPerPage;
    return filteredData.sublist(
        start, end > filteredData.length ? filteredData.length : end);
  }

  Future<void> getDocuments() async {
    var response = await taxSearchData.viewdata({});
    if (handlingData(response) == Statusrequest.success &&
        (response["status"] == 1 || response["status"] == true)) {
      List listdata = response['data'];
      documents = listdata.map((e) => TaxSearchModel.fromJson(e)).toList();
    }
  }

  Future<void> viewdata() async {
    statusrequest = Statusrequest.loadeng;
    update();

    Map<String, dynamic> requestData = {};
    if (selectedDocumentId != null) {
      requestData["document_id"] = selectedDocumentId.toString();
    }

    var response = await taxArticlesData.viewdata(requestData);
    statusrequest = handlingData(response);

    if (statusrequest == Statusrequest.success) {
      if (response["status"] == 1 || response["status"] == true) {
        data.clear();
        List listdata = response['data'];
        data.addAll(listdata.map((e) => TaxArticleModel.fromJson(e)));
        applyFilter();
        if (data.isEmpty) {
          statusrequest = Statusrequest.failure;
        }
      } else {
        statusrequest = Statusrequest.failure;
      }
    }
    update();
  }

  void changeDocumentFilter(int? documentId) {
    selectedDocumentId = documentId;
    viewdata();
  }

  void clearForm() {
    labelController.clear();
    numberController.clear();
    numberIntController.clear();
    textController.clear();
    labelEnController.clear();
    textEnController.clear();
    sortOrderController.clear();
    pageStartController.clear();
    pageEndController.clear();
    formDocumentId = selectedDocumentId;
    formPart = 'code';
    formIsRepealed = false;
    formTables = [];
    tablesChanged = false;
  }

  void setEditData(TaxArticleModel item) {
    labelController.text = item.label;
    numberController.text = item.number ?? '';
    numberIntController.text = item.numberInt?.toString() ?? '';
    textController.text = item.text;
    labelEnController.text = item.labelEn ?? '';
    textEnController.text = item.textEn ?? '';
    sortOrderController.text = item.sortOrder.toString();
    pageStartController.text = item.pageStart?.toString() ?? '';
    pageEndController.text = item.pageEnd?.toString() ?? '';
    formDocumentId = item.documentId;
    formPart = item.part;
    formIsRepealed = item.isRepealed;
    formTables = item.tables.map((t) => t.copy()).toList();
    tablesChanged = false;
  }

  void addTable() {
    formTables.add(TaxArticleTable.empty());
    tablesChanged = true;
  }

  void removeTable(int index) {
    formTables.removeAt(index);
    tablesChanged = true;
  }

  void moveTable(int index, int newIndex) {
    if (newIndex < 0 || newIndex >= formTables.length) return;
    final table = formTables.removeAt(index);
    formTables.insert(newIndex, table);
    tablesChanged = true;
  }

  void markTablesChanged() {
    tablesChanged = true;
  }

  // الملاحظات لا تُرسل، فيحتفظ بها الباك اند كما هي عند التعديل
  Map<String, dynamic> _formData() {
    Map<String, dynamic> requestData = {
      "document_id": formDocumentId.toString(),
      "part": formPart,
      "label": labelController.text,
      "number": numberController.text.trim(),
      "number_int": numberIntController.text.trim(),
      "text": textController.text,
      "label_en": labelEnController.text.trim(),
      "text_en": textEnController.text,
      "is_repealed": formIsRepealed ? "1" : "0",
      "page_start": pageStartController.text.trim(),
      "page_end": pageEndController.text.trim(),
    };
    // sort_order غير قابل لـ null في قاعدة البيانات
    if (sortOrderController.text.trim().isNotEmpty) {
      requestData["sort_order"] = sortOrderController.text.trim();
    }
    if (tablesChanged) {
      requestData["tables"] = formTables
          .asMap()
          .entries
          .map((e) => e.value.toJson(e.key))
          .toList();
    }
    return requestData;
  }

  String _errorMessage(dynamic response, String fallback) {
    return response is Map && response["message"] != null
        ? response["message"].toString()
        : fallback.tr;
  }

  Future<void> adddata() async {
    if (!formState.currentState!.validate()) return;
    Get.back();
    statusrequest = Statusrequest.loadeng;
    update();

    var response = await taxArticlesData.adddata(_formData());
    statusrequest = handlingData(response);

    if (statusrequest == Statusrequest.success &&
        (response["status"] == 1 || response["status"] == true)) {
      clearForm();
      viewdata();
      showSnackbar("نجاح".tr, "تمت الإضافة بنجاح".tr, Colors.green);
    } else {
      viewdata();
      showSnackbar("خطأ".tr, _errorMessage(response, "فشلت الإضافة"), Colors.red);
    }
  }

  Future<void> editdata(int id) async {
    if (!formState.currentState!.validate()) return;
    Get.back();
    statusrequest = Statusrequest.loadeng;
    update();

    Map<String, dynamic> requestData = _formData();
    requestData["id"] = id.toString();

    var response = await taxArticlesData.editdata(requestData);
    statusrequest = handlingData(response);

    if (statusrequest == Statusrequest.success &&
        (response["status"] == 1 || response["status"] == true)) {
      clearForm();
      viewdata();
      showSnackbar("نجاح".tr, "تم التعديل بنجاح".tr, Colors.green);
    } else {
      viewdata();
      showSnackbar("خطأ".tr, _errorMessage(response, "فشل التعديل"), Colors.red);
    }
  }

  Future<void> deletData(int id) async {
    var response = await taxArticlesData.deletdata({"id": id.toString()});
    if (handlingData(response) == Statusrequest.success &&
        (response["status"] == 1 || response["status"] == true)) {
      data.removeWhere((element) => element.id == id);
      applyFilter();
      if (data.isEmpty) statusrequest = Statusrequest.failure;
      update();
      showSnackbar("نجاح".tr, "تم الحذف بنجاح".tr, Colors.green);
    } else {
      showSnackbar("خطأ".tr, "فشل الحذف".tr, Colors.red);
    }
  }

  void applyFilter() {
    final query = searchQuery.toLowerCase();
    if (query.isEmpty) {
      filteredData = List.from(data);
    } else {
      filteredData = data
          .where((element) =>
              element.label.toLowerCase().contains(query) ||
              (element.number ?? '').toLowerCase().contains(query) ||
              element.text.toLowerCase().contains(query))
          .toList();
    }
    currentPage = 0;
  }

  void filterData(String query) {
    searchQuery = query;
    applyFilter();
    update();
  }

  void nextPage() {
    if (currentPage < totalPages - 1) {
      currentPage++;
      update();
    }
  }

  void previousPage() {
    if (currentPage > 0) {
      currentPage--;
      update();
    }
  }

  // المواد كثيرة، لذلك نبدأ بأول ملف بدل جلب كل المواد دفعة واحدة
  Future<void> _init() async {
    statusrequest = Statusrequest.loadeng;
    update();
    await getDocuments();
    if (documents.isNotEmpty) selectedDocumentId = documents.first.id;
    await viewdata();
  }

  @override
  void onInit() {
    _init();
    super.onInit();
  }
}
