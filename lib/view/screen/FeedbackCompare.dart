import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/FeedbackCompareController.dart';
import '../../core/class/handlingview.dart';
import '../../core/constant/Colorapp.dart';

/// إحصائيات الآراء: كل سؤال بنسب اختياراته حسب الرأي المختار
class FeedbackCompare extends StatelessWidget {
  const FeedbackCompare({super.key});

  // ألوان الصفحة: لون واحد للبيانات (لون التطبيق)، والنصوص بدرجات محايدة
  static const Color _bar = AppColor.typography;
  static const Color _track = Color(0xFFEEF2F7);
  static const Color _ink = Color(0xFF1E293B);
  static const Color _muted = Color(0xFF64748B);
  static const Color _line = Color(0xFFE2E8F0);
  static const Color _page = Color(0xFFF3F5F9);

  @override
  Widget build(BuildContext context) {
    Get.put(FeedbackCompareController());

    return Scaffold(
      backgroundColor: _page,
      body: GetBuilder<FeedbackCompareController>(
        builder: (c) {
          return Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: Handlingview(
                    statusrequest: c.statusrequest,
                    widget: ListView(
                      children: [
                        _kpis(c),
                        const SizedBox(height: 20),
                        _questionsGrid(c),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // ============================ الأرقام ============================

  /// عدد المشاركين في كل نوع رأي (الكل، الأول، الثاني، الثالث)
  Widget _kpis(FeedbackCompareController c) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final perRow = constraints.maxWidth >= 900 ? 4 : 2;
        final width = (constraints.maxWidth - 16 * (perRow - 1)) / perRow;
        return Wrap(
          spacing: 16,
          runSpacing: 16,
          children: [
            for (final r in FeedbackCompareController.rounds)
              _kpi(
                width,
                Icons.how_to_vote_outlined,
                FeedbackCompareController.roundName(r),
                '${c.participants[r] ?? 0}',
                'مشارك'.tr,
                selected: c.selectedRound == r,
                onTap: () => c.selectRound(r),
              ),
          ],
        );
      },
    );
  }

  Widget _kpi(
    double width,
    IconData icon,
    String label,
    String value,
    String unit, {
    bool selected = false,
    VoidCallback? onTap,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        width: width,
        padding: const EdgeInsets.all(18),
        decoration: _cardDecoration().copyWith(
          border: Border.all(
            color: selected ? _bar : _line,
            width: selected ? 1.6 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: _bar.withOpacity(0.08),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: _bar),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: const TextStyle(fontSize: 13, color: _muted),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        value,
                        style: const TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: _ink,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Flexible(
                        child: Text(
                          unit,
                          style: const TextStyle(fontSize: 12, color: _muted),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================ الأسئلة ============================

  Widget _questionsGrid(FeedbackCompareController c) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final twoColumns = constraints.maxWidth >= 600;
        final width = twoColumns
            ? (constraints.maxWidth - 16) / 2
            : constraints.maxWidth;
        final questions = c.questions;
        return Wrap(
          spacing: 16,
          runSpacing: 16,
          children: [
            for (int i = 0; i < questions.length; i++)
              SizedBox(width: width, child: _questionCard(c, questions[i], i)),
          ],
        );
      },
    );
  }

  Widget _questionCard(
    FeedbackCompareController c,
    Map<String, dynamic> q,
    int index,
  ) {
    final number = c.questionNumber(q);
    final total = c.total(number);
    final top = c.topOption(q);
    final options = (q['options'] as List).cast<Map>();

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 32,
                height: 32,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: _bar,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '${index + 1}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  q['title'].toString(),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: _ink,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: _track,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '$total ${'إجابة'.tr}',
                  style: const TextStyle(
                    fontSize: 12,
                    color: _muted,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          if (total == 0)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Center(
                child: Text(
                  'لا توجد إجابات في هذا الرأي'.tr,
                  style: const TextStyle(color: _muted),
                ),
              ),
            )
          else
            for (final o in options)
              _optionBar(
                label: o['name'].toString(),
                count: c.count(number, o['id'] as int),
                percent: c.percent(number, o['id'] as int),
                total: total,
                isTop: o['id'] == top,
              ),
        ],
      ),
    );
  }

  /// سطر اختيار: التسمية والنسبة، ثم شريط أفقي بلون واحد
  Widget _optionBar({
    required String label,
    required int count,
    required double percent,
    required int total,
    required bool isTop,
  }) {
    return Tooltip(
      message:
          '$label: $count ${'من'.tr} $total '
          '(${percent.toStringAsFixed(1)}%)',
      waitDuration: const Duration(milliseconds: 250),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    label,
                    style: TextStyle(
                      fontSize: 14,
                      color: _ink,
                      fontWeight: isTop ? FontWeight.bold : FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  '${percent.toStringAsFixed(1)}%',
                  style: TextStyle(
                    fontSize: 14,
                    color: _ink,
                    fontWeight: isTop ? FontWeight.bold : FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 6),
                SizedBox(
                  width: 44,
                  child: Text(
                    '($count)',
                    textAlign: TextAlign.end,
                    style: const TextStyle(fontSize: 12, color: _muted),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            LayoutBuilder(
              builder: (context, constraints) {
                final w =
                    constraints.maxWidth * (percent / 100).clamp(0.0, 1.0);
                return Container(
                  height: 10,
                  alignment: AlignmentDirectional.centerStart,
                  decoration: BoxDecoration(
                    color: _track,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 400),
                    curve: Curves.easeOutCubic,
                    width: w,
                    decoration: BoxDecoration(
                      color: isTop ? _bar : _bar.withOpacity(0.72),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  BoxDecoration _cardDecoration() => BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(14),
    border: Border.all(color: _line),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.03),
        blurRadius: 8,
        offset: const Offset(0, 2),
      ),
    ],
  );
}
