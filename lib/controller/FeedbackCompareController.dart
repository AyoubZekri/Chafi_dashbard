import 'package:get/get.dart';

import '../core/class/Statusrequest.dart';
import '../core/constant/FeedbackQuestions.dart';
import '../core/functions/handlingdatacontroller.dart';
import '../data/datasource/Remote/FeedbackCompareData.dart';

/// إحصائيات آراء المستخدمين: كل سؤال بنسب اختياراته،
/// حسب الرأي الأول أو الثاني أو الثالث أو آخر رأي لكل مستخدم
class FeedbackCompareController extends GetxController {
  FeedbackCompareData data = FeedbackCompareData(Get.find());
  Statusrequest statusrequest = Statusrequest.none;

  /// 'latest' = الكل (آخر رأي لكل مستخدم)
  static const List<String> rounds = ['latest', '1', '2', '3'];

  static String roundName(String round) => {
    'latest': 'الكل', // آخر رأي لكل مستخدم
    '1': 'الرأي الأول',
    '2': 'الرأي الثاني',
    '3': 'الرأي الثالث',
  }[round]!.tr;

  String selectedRound = 'latest';

  int users = 0;
  Map<String, int> participants = {};

  /// إحصائيات كل سؤال كما يرجعها السيرفر، مفهرسة برقم السؤال
  Map<int, Map> stats = {};

  List<Map<String, dynamic>> get questions => feedbackQuestions();

  Future<void> viewdata() async {
    statusrequest = Statusrequest.loadeng;
    update();

    final response = await data.viewdata({});
    statusrequest = handlingData(response);

    if (statusrequest == Statusrequest.success) {
      if (response["status"] == 1 || response["status"] == true) {
        final body = _map(response['data']);
        users = _int(body['users']);
        participants = {
          for (final r in rounds) r: _int(_map(body['participants'])[r]),
        };
        stats = {
          for (final q in (body['questions'] is List ? body['questions'] : []))
            _int(q['question']): _map(q),
        };
        if (users == 0) statusrequest = Statusrequest.failure;
      } else {
        statusrequest = Statusrequest.failure;
      }
    }
    update();
  }

  void selectRound(String round) {
    selectedRound = round;
    update();
  }

  // ======================= قراءة الإحصائيات =======================

  int get roundParticipants => participants[selectedRound] ?? 0;

  /// رقم السؤال من رمز أول اختيار فيه (11 → 1)
  int questionNumber(Map<String, dynamic> question) =>
      (question['options'] as List).first['id'] ~/ 10;

  Map _round(int question) =>
      _map(_map(_map(stats[question])['rounds'])[selectedRound]);

  int total(int question) => _int(_round(question)['total']);

  int count(int question, int option) =>
      _int(_map(_round(question)['options'])['$option']);

  double percent(int question, int option) {
    final t = total(question);
    return t == 0 ? 0 : count(question, option) * 100 / t;
  }

  /// الاختيار الأكثر إجابة في السؤال (null إذا لا إجابات)
  int? topOption(Map<String, dynamic> question) {
    final number = questionNumber(question);
    int? best;
    int bestCount = 0;
    for (final o in question['options'] as List) {
      final c = count(number, o['id'] as int);
      if (c > bestCount) {
        best = o['id'] as int;
        bestCount = c;
      }
    }
    return best;
  }

  // PHP يرسل المصفوفة الفارغة كـ [] وليس {}، فنعاملها كخريطة فارغة
  static Map _map(dynamic v) => v is Map ? v : const {};

  static int _int(dynamic v) => v == null ? 0 : int.tryParse(v.toString()) ?? 0;

  @override
  void onInit() {
    viewdata();
    super.onInit();
  }
}
