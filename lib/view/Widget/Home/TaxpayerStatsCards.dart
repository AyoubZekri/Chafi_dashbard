import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constant/Colorapp.dart';

/// بيانان في الصفحة الرئيسية: توزيع المستخدمين حسب صفة المكلف بالضريبة،
/// والمؤسسات المسجلة في الإدارة الجبائية
class TaxpayerStatsCards extends StatelessWidget {
  final Map<String, int> taxpayerTypes;
  final Map<String, int> taxRegistration;

  const TaxpayerStatsCards({
    super.key,
    required this.taxpayerTypes,
    required this.taxRegistration,
  });

  static const List<String> enterprises = [
    'startup',
    'micro_enterprise',
    'other_enterprise',
  ];
  static const List<String> individuals = [
    'student',
    'researcher',
    'tax_interested',
    'private_accountant',
    'public_accountant',
  ];

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final types = _TaxpayerTypesCard(counts: taxpayerTypes);
      final registration = _RegistrationCard(counts: taxRegistration);
      if (constraints.maxWidth < 900) {
        return Column(
          children: [types, const SizedBox(height: 20), registration],
        );
      }
      // البطاقتان بنفس العرض ونفس الطول
      return IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(child: types),
            const SizedBox(width: 20),
            Expanded(child: registration),
          ],
        ),
      );
    });
  }
}

// ============================ ألوان وعناصر مشتركة ============================

class _C {
  static const bar = AppColor.typography;
  static const track = Color(0xFFF1F5F9);
  static const title = Color(0xFF2D3748);
  static const ink = Color(0xFF1E293B);
  static const muted = Color(0xFF64748B);
  static const faint = Color(0xFF94A3B8);
  static const line = Color(0xFFEDF2F7);

  // ألوان فئوية قابلة للتمييز لعمى الألوان
  static const registered = Color(0xFF2A78D6);
  static const notRegistered = Color(0xFFEB6834);
  static const third = Color(0xFF14A38B);
}

/// إطار البطاقة: أيقونة، عنوان، وشارة الإجمالي
class _Card extends StatelessWidget {
  final IconData icon;
  final String title;
  final String badge;
  final Widget child;

  const _Card({
    required this.icon,
    required this.title,
    required this.badge,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: _C.bar.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: _C.bar, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: _C.title,
                  ),
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: _C.track,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  badge,
                  style: const TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                    color: _C.ink,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Divider(height: 1, color: _C.line),
          const SizedBox(height: 20),
          child,
        ],
      ),
    );
  }
}

// ============================ صفة المكلف بالضريبة ============================

class _TaxpayerTypesCard extends StatelessWidget {
  final Map<String, int> counts;

  const _TaxpayerTypesCard({required this.counts});

  int _count(String type) => counts[type] ?? 0;

  @override
  Widget build(BuildContext context) {
    // من اختاروا صفة فقط ("غير محدد" لا يظهر ولا يدخل في النسب)
    final total = [
      ...TaxpayerStatsCards.enterprises,
      ...TaxpayerStatsCards.individuals,
    ].map(_count).fold<int>(0, (a, b) => a + b);
    List<String> sorted(List<String> types) =>
        [...types]..sort((a, b) => _count(b).compareTo(_count(a)));
    // المؤسسات بترتيب ثابت: ناشئة، مصغرة، أخرى
    const ent = TaxpayerStatsCards.enterprises;
    final ind = sorted(TaxpayerStatsCards.individuals);
    // طول الشريط نسبةً لأكبر قيمة، والنسبة المكتوبة من الإجمالي
    final maxCount = [...ent, ...ind]
        .map(_count)
        .fold<int>(0, (a, b) => a > b ? a : b);

    Widget groupHeader(String title, List<String> types) {
      final sum = types.map(_count).fold<int>(0, (a, b) => a + b);
      return Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Row(
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: _C.faint,
              ),
            ),
            const SizedBox(width: 8),
            const Expanded(child: Divider(color: _C.line)),
            const SizedBox(width: 8),
            Text(
              '$sum',
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: _C.faint,
              ),
            ),
          ],
        ),
      );
    }

    Widget bar(String type) => _BarRow(
          label: 'taxpayer_$type'.tr,
          count: _count(type),
          total: total,
          maxCount: maxCount,
          color: _C.bar,
        );

    return _Card(
      icon: Icons.badge_outlined,
      title: 'المكلفون بالضريبة'.tr,
      badge: '$total ${'مستخدم'.tr}',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          groupHeader('المؤسسات'.tr, ent),
          for (final t in ent) bar(t),
          const SizedBox(height: 8),
          groupHeader('الأفراد والمهنيون'.tr, ind),
          for (final t in ind) bar(t),
        ],
      ),
    );
  }
}

class _BarRow extends StatelessWidget {
  final String label;
  final int count;
  final int total;
  final int maxCount;
  final Color color;

  const _BarRow({
    required this.label,
    required this.count,
    required this.total,
    required this.maxCount,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final percent = total == 0 ? 0.0 : count * 100 / total;
    final factor = maxCount == 0 ? 0.0 : count / maxCount;
    return Tooltip(
      message: '$label: $count (${percent.toStringAsFixed(1)}%)',
      child: Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Row(
          children: [
            SizedBox(
              width: 160,
              child: Text(
                label,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 13.5,
                  color: _C.ink,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Container(
                height: 12,
                alignment: AlignmentDirectional.centerStart,
                decoration: BoxDecoration(
                  color: _C.track,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0, end: factor.clamp(0.0, 1.0)),
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeOutCubic,
                  builder: (context, f, _) => FractionallySizedBox(
                    widthFactor: f,
                    child: Container(
                      decoration: BoxDecoration(
                        color: color,
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 14),
            SizedBox(
              width: 36,
              child: Text(
                '$count',
                textAlign: TextAlign.end,
                style: const TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.bold,
                  color: _C.ink,
                ),
              ),
            ),
            SizedBox(
              width: 52,
              child: Text(
                '${percent.toStringAsFixed(1)}%',
                textAlign: TextAlign.end,
                style: const TextStyle(fontSize: 12, color: _C.muted),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================ التسجيل في الإدارة الجبائية ============================

class _RegistrationCard extends StatelessWidget {
  final Map<String, int> counts;

  const _RegistrationCard({required this.counts});

  @override
  Widget build(BuildContext context) {
    return _DonutCard(
      icon: Icons.account_balance_outlined,
      title: 'التسجيل في الإدارة الجبائية'.tr,
      unit: 'مؤسسة'.tr,
      parts: [
        ('مسجل في الإدارة الجبائية'.tr, counts['registered'] ?? 0,
            _C.registered),
        ('غير مسجل'.tr, counts['not_registered'] ?? 0, _C.notRegistered),
      ],
    );
  }
}

/// بطاقة دائرة (Donut): الوسط يعرض نسبة الجزء الأول أو الجزء تحت الفأرة،
/// وتحتها قائمة الأجزاء بالعدد والنسبة
class _DonutCard extends StatefulWidget {
  final IconData icon;
  final String title;
  final String unit;
  final List<(String, int, Color)> parts;

  const _DonutCard({
    required this.icon,
    required this.title,
    required this.unit,
    required this.parts,
  });

  @override
  State<_DonutCard> createState() => _DonutCardState();
}

class _DonutCardState extends State<_DonutCard> {
  int? hovered;

  void _hover(int? i) {
    if (i != hovered) setState(() => hovered = i);
  }

  @override
  Widget build(BuildContext context) {
    final parts = widget.parts;
    final total = parts.fold<int>(0, (a, p) => a + p.$2);
    double pct(int v) => total == 0 ? 0 : v * 100 / total;

    // الوسط: الجزء الأكبر افتراضياً، أو الجزء الذي تمر عليه الفأرة
    int largest = 0;
    for (int i = 1; i < parts.length; i++) {
      if (parts[i].$2 > parts[largest].$2) largest = i;
    }
    final focus = hovered ?? largest;

    return _Card(
      icon: widget.icon,
      title: widget.title,
      badge: '$total ${widget.unit}',
      child: Column(
        children: [
          SizedBox(
            height: 210,
            child: total == 0
                ? Center(
                    child: Text('لا توجد بيانات'.tr,
                        style: const TextStyle(color: _C.muted)),
                  )
                : Stack(
                    alignment: Alignment.center,
                    children: [
                      PieChart(
                        PieChartData(
                          startDegreeOffset: -90,
                          sectionsSpace: 2,
                          centerSpaceRadius: 64,
                          pieTouchData: PieTouchData(
                            touchCallback: (event, response) {
                              final i = response
                                  ?.touchedSection?.touchedSectionIndex;
                              _hover(event.isInterestedForInteractions &&
                                      i != null &&
                                      i >= 0
                                  ? i
                                  : null);
                            },
                          ),
                          sections: [
                            for (int i = 0; i < parts.length; i++)
                              PieChartSectionData(
                                value: parts[i].$2.toDouble(),
                                color: parts[i].$3,
                                radius: hovered == i ? 28 : 22,
                                showTitle: false,
                              ),
                          ],
                        ),
                        swapAnimationDuration:
                            const Duration(milliseconds: 250),
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '${pct(parts[focus].$2).toStringAsFixed(0)}%',
                            style: const TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              color: _C.ink,
                              height: 1.1,
                            ),
                          ),
                          const SizedBox(height: 2),
                          SizedBox(
                            width: 110,
                            child: Text(
                              parts[focus].$1,
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              style: const TextStyle(
                                  fontSize: 12, color: _C.muted),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
          ),
          const SizedBox(height: 16),
          for (int i = 0; i < parts.length; i++)
            MouseRegion(
              onEnter: (_) => _hover(i),
              onExit: (_) => _hover(null),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                margin: const EdgeInsets.only(bottom: 6),
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                decoration: BoxDecoration(
                  color: hovered == i ? _C.track : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        color: parts[i].$3,
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(parts[i].$1,
                          style:
                              const TextStyle(fontSize: 13.5, color: _C.ink)),
                    ),
                    Text(
                      '${parts[i].$2}',
                      style: const TextStyle(
                        fontSize: 13.5,
                        fontWeight: FontWeight.bold,
                        color: _C.ink,
                      ),
                    ),
                    SizedBox(
                      width: 56,
                      child: Text(
                        '${pct(parts[i].$2).toStringAsFixed(1)}%',
                        textAlign: TextAlign.end,
                        style:
                            const TextStyle(fontSize: 12, color: _C.muted),
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// ======================= طبيعة الشخص والنظام الجبائي =======================

/// للمسجلين في الإدارة الجبائية: توزيعهم حسب طبيعة الشخص وحسب النظام الجبائي
/// ("غير محدد" لمن سجلوا قبل إضافة الحقلين لا يظهر ولا يدخل في النسب)
class RegisteredProfileCards extends StatelessWidget {
  final Map<String, int> personTypes;
  final Map<String, int> taxSystems;

  const RegisteredProfileCards({
    super.key,
    required this.personTypes,
    required this.taxSystems,
  });

  @override
  Widget build(BuildContext context) {
    final person = _DonutCard(
      icon: Icons.person_outline,
      title: 'طبيعة الشخص'.tr,
      unit: 'مسجل'.tr,
      parts: [
        ('شخص طبيعي'.tr, personTypes['natural'] ?? 0, _C.registered),
        ('شخص معنوي'.tr, personTypes['legal'] ?? 0, _C.notRegistered),
      ],
    );
    final system = _DonutCard(
      icon: Icons.account_tree_outlined,
      title: 'النظام الجبائي'.tr,
      unit: 'مسجل'.tr,
      parts: [
        ('النظام الحقيقي'.tr, taxSystems['real'] ?? 0, _C.registered),
        ('النظام الجزافي'.tr, taxSystems['flat_rate'] ?? 0, _C.notRegistered),
        ('النظام المبسط'.tr, taxSystems['simplified'] ?? 0, _C.third),
      ],
    );
    return LayoutBuilder(builder: (context, constraints) {
      if (constraints.maxWidth < 900) {
        return Column(children: [person, const SizedBox(height: 20), system]);
      }
      return IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(child: person),
            const SizedBox(width: 20),
            Expanded(child: system),
          ],
        ),
      );
    });
  }
}

// ============================ سنوات التسجيل ============================

/// فترة من سنوات التسجيل وعدد المسجلين فيها (من السيرفر)
class RegistrationYearPeriod {
  final String label;
  final int total;

  const RegistrationYearPeriod({required this.label, required this.total});

  factory RegistrationYearPeriod.fromJson(Map json) => RegistrationYearPeriod(
        label: json['label']?.toString() ?? '',
        total: int.tryParse(json['total']?.toString() ?? '') ?? 0,
      );

  static List<RegistrationYearPeriod> fromList(dynamic list) => list is List
      ? [
          for (final e in list)
            if (e is Map) RegistrationYearPeriod.fromJson(e),
        ]
      : const [];
}

/// أعمدة: عدد المسجلين في الإدارة الجبائية حسب سنة التسجيل.
/// السنوات القديمة مجمعة في فترات، ومن 2020 كل سنة عمود
class RegistrationYearsChart extends StatelessWidget {
  final List<RegistrationYearPeriod> periods;

  const RegistrationYearsChart({super.key, required this.periods});

  @override
  Widget build(BuildContext context) {
    final total = periods.fold<int>(0, (a, p) => a + p.total);
    final maxCount = periods.fold<int>(0, (a, p) => a > p.total ? a : p.total);
    // سقف المحور: أكبر قيمة + هامش، ومضاعف لخطوة الشبكة
    final step = maxCount <= 5 ? 1.0 : (maxCount / 5).ceilToDouble();
    final maxY = ((maxCount / step).ceil() + 1) * step;

    return _Card(
      icon: Icons.bar_chart_rounded,
      title: "سنوات التسجيل في الإدارة الجبائية".tr,
      badge: "$total ${"مسجل".tr}",
      child: SizedBox(
        height: 300,
        child: total == 0
            ? Center(
                child: Text(
                  "لا توجد بيانات لعرضها".tr,
                  style: const TextStyle(color: _C.muted, fontSize: 14),
                ),
              )
            : BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: maxY,
                  barTouchData: BarTouchData(
                    touchTooltipData: BarTouchTooltipData(
                      tooltipBgColor: _C.title,
                      getTooltipItem: (group, groupIndex, rod, rodIndex) {
                        final p = periods[group.x];
                        return BarTooltipItem(
                          "${p.label}\n",
                          const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                          children: [
                            TextSpan(
                              text: "${p.total} ${"مسجل".tr}",
                              style: const TextStyle(
                                color: Color(0xFFCBD5E1),
                                fontSize: 12,
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 32,
                        getTitlesWidget: (value, meta) => SideTitleWidget(
                          axisSide: meta.axisSide,
                          space: 8,
                          child: Text(
                            periods[value.toInt()].label,
                            style: const TextStyle(
                              color: _C.muted,
                              fontWeight: FontWeight.w600,
                              fontSize: 11,
                            ),
                          ),
                        ),
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 36,
                        interval: step,
                        getTitlesWidget: (value, meta) => Text(
                          value.toInt().toString(),
                          style: const TextStyle(color: _C.faint, fontSize: 12),
                        ),
                      ),
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  gridData: FlGridData(
                    drawVerticalLine: false,
                    horizontalInterval: step,
                    getDrawingHorizontalLine: (value) =>
                        const FlLine(color: _C.line, strokeWidth: 1),
                  ),
                  borderData: FlBorderData(show: false),
                  barGroups: [
                    for (int i = 0; i < periods.length; i++)
                      BarChartGroupData(
                        x: i,
                        barRods: [
                          BarChartRodData(
                            toY: periods[i].total.toDouble(),
                            color: _C.bar,
                            width: 22,
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(6),
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
      ),
    );
  }
}
