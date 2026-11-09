import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controller/DashboardHomeController.dart';
import '../../../core/constant/Colorapp.dart';
import '../../../data/model/DashboardStats.dart';
import '../TablePaginationFooter.dart';

/// إحصائيات الدخول حسب الولاية: فلتر الإقليم (قائمة منسدلة) والبحث،
/// وكل ولاية برمزها وإقليمها وعدد الدخول ونصيبها من المجموع
class StateStatsCard extends StatelessWidget {
  final Dashboardhomecontroller controller;

  const StateStatsCard({super.key, required this.controller});

  // الأقاليم كما في wilayas.json (0 = الكل)
  static const _regions = <(int, String)>[
    (0, 'الكل'),
    (1, 'الشمال'),
    (2, 'الهضاب العليا'),
    (3, 'الجنوب'),
  ];

  static String regionName(int region) =>
      region >= 1 && region <= 3 ? _regions[region].$2.tr : 'غير محدد'.tr;

  @override
  Widget build(BuildContext context) {
    final allTotal = controller.regionTotal(0);
    return Container(
      height: 520,
      padding: const EdgeInsets.all(20),
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
          _header(),
          const SizedBox(height: 16),
          _toolbar(),
          const SizedBox(height: 14),
          _columnsHeader(),
          Expanded(
            child: controller.pagedData.isEmpty
                ? Center(
                    child: Text(
                      'لا توجد بيانات'.tr,
                      style: const TextStyle(color: _C.muted),
                    ),
                  )
                : ListView.separated(
                    itemCount: controller.pagedData.length,
                    separatorBuilder: (_, __) =>
                        const Divider(height: 1, color: _C.line),
                    itemBuilder: (context, i) =>
                        _row(controller.pagedData[i], allTotal),
                  ),
          ),
          TablePaginationFooter(
            currentPage: controller.currentPage,
            rowsPerPage: controller.rowsPerPage,
            totalEntries: controller.filteredData.length,
            totalPages: controller.totalPages,
            currentFilteredLength: controller.pagedData.length,
            onNext: controller.nextPage,
            onPrevious: controller.previousPage,
          ),
        ],
      ),
    );
  }

  Widget _header() {
    return Row(
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: AppColor.typography.withOpacity(0.08),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(
            Icons.map_outlined,
            color: AppColor.typography,
            size: 22,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            'إحصائيات الدخول'.tr,
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: _C.title,
            ),
          ),
        ),
      ],
    );
  }

  Widget _toolbar() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final region = _regionDropdown();
        final wilaya = _WilayaDropdown(controller: controller);
        if (constraints.maxWidth < 420) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [region, const SizedBox(height: 10), wilaya],
          );
        }
        return Row(
          children: [
            SizedBox(width: 220, child: region),
            const SizedBox(width: 12),
            Expanded(child: wilaya),
          ],
        );
      },
    );
  }

  /// قائمة الأقاليم: الاسم وعدد الدخول فيه
  Widget _regionDropdown() {
    Widget item((int, String) r, {bool selected = false}) => Row(
      children: [
        Expanded(
          child: Text(
            r.$2.tr,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 13.5,
              fontWeight: selected ? FontWeight.bold : FontWeight.w500,
              color: _C.ink,
            ),
          ),
        ),
        Text(
          '${controller.regionTotal(r.$1)}',
          style: const TextStyle(fontSize: 12, color: _C.muted),
        ),
      ],
    );

    return DropdownButtonHideUnderline(
      child: DropdownButton2<int>(
        isExpanded: true,
        value: controller.selectedRegion,
        onChanged: (v) => controller.changeRegion(v ?? 0),
        items: [
          for (final r in _regions)
            DropdownMenuItem<int>(value: r.$1, child: item(r)),
        ],
        selectedItemBuilder: (context) => [
          for (final r in _regions) item(r, selected: true),
        ],
        buttonStyleData: ButtonStyleData(
          height: 42,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: _C.track,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: _C.line),
          ),
        ),
        iconStyleData: const IconStyleData(
          icon: Icon(Icons.keyboard_arrow_down_rounded),
          iconSize: 22,
          iconEnabledColor: _C.muted,
        ),
        dropdownStyleData: DropdownStyleData(
          elevation: 6,
          offset: const Offset(0, -4),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        menuItemStyleData: const MenuItemStyleData(
          height: 44,
          padding: EdgeInsets.symmetric(horizontal: 14),
        ),
      ),
    );
  }

  // توزيع الأعمدة (نفسه في العناوين والسطور حتى تتطابق): الرمز، الولاية،
  // مستخدمون، ضيوف، اليوم، النسبة
  static const _flex = [2, 5, 3, 3, 3, 5];

  /// سطر بالأعمدة الستة؛ الولاية والنسبة من البداية والباقي في الوسط
  static Widget _cells(List<Widget> cells) {
    return Row(
      children: [
        for (int i = 0; i < cells.length; i++)
          Expanded(
            flex: _flex[i],
            child: Align(
              alignment: i == 1 || i == 5
                  ? AlignmentDirectional.centerStart
                  : Alignment.center,
              child: cells[i],
            ),
          ),
      ],
    );
  }

  Widget _columnsHeader() {
    Widget label(String text) => Text(
      text.tr,
      overflow: TextOverflow.ellipsis,
      style: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.bold,
        color: _C.faint,
      ),
    );
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(10),
      ),
      child: _cells([
        label('الرمز'),
        label('الولاية'),
        label('مستخدمون'),
        label('ضيوف'),
        label('اليوم'),
        label('النسبة'),
      ]),
    );
  }

  Widget _row(StateStats s, int allTotal) {
    final isFrench = Get.locale?.languageCode == 'fr';
    final name = s.code.isEmpty
        ? 'غير محدد'.tr
        : (isFrench && s.stateFr.isNotEmpty ? s.stateFr : s.state);
    final total = s.totalUser + s.totalG;
    final today = s.dailyUser + s.dailyG;
    final share = allTotal == 0 ? 0.0 : total / allTotal;

    Widget number(int v, {bool bold = false}) => Text(
      '$v',
      style: TextStyle(
        fontSize: 13.5,
        fontWeight: bold ? FontWeight.bold : FontWeight.w500,
        color: _C.ink,
      ),
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: _cells([
        Container(
          width: 42,
          height: 30,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: _C.track,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            s.code.isEmpty ? '—' : s.code,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: _C.ink,
            ),
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              name,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 13.5,
                fontWeight: FontWeight.w600,
                color: _C.ink,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              regionName(s.region),
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 11, color: _C.muted),
            ),
          ],
        ),
        number(s.totalUser, bold: true),
        number(s.totalG),
        number(today),
        // نصيب الولاية من مجموع الدخول
        Row(
          children: [
            Expanded(
              child: Container(
                height: 8,
                alignment: AlignmentDirectional.centerStart,
                decoration: BoxDecoration(
                  color: _C.track,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: FractionallySizedBox(
                  widthFactor: share.clamp(0.0, 1.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColor.typography,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            SizedBox(
              width: 46,
              child: Text(
                '${(share * 100).toStringAsFixed(1)}%',
                textAlign: TextAlign.end,
                style: const TextStyle(fontSize: 11.5, color: _C.muted),
              ),
            ),
          ],
        ),
      ]),
    );
  }
}

/// فلتر الولاية: قائمة منسدلة بالرمز والاسم وعدد الدخول، مع بحث داخلها
class _WilayaDropdown extends StatefulWidget {
  final Dashboardhomecontroller controller;

  const _WilayaDropdown({required this.controller});

  @override
  State<_WilayaDropdown> createState() => _WilayaDropdownState();
}

class _WilayaDropdownState extends State<_WilayaDropdown> {
  final searchController = TextEditingController();

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  String _name(StateStats s) =>
      Get.locale?.languageCode == 'fr' && s.stateFr.isNotEmpty
      ? s.stateFr
      : s.state;

  Widget _item(String code, String name, int count, {bool selected = false}) {
    return Row(
      children: [
        if (code.isNotEmpty) ...[
          SizedBox(
            width: 26,
            child: Text(
              code,
              style: const TextStyle(
                fontSize: 12.5,
                fontWeight: FontWeight.bold,
                color: _C.muted,
              ),
            ),
          ),
          const SizedBox(width: 6),
        ],
        Expanded(
          child: Text(
            name,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 13.5,
              fontWeight: selected ? FontWeight.bold : FontWeight.w500,
              color: _C.ink,
            ),
          ),
        ),
        Text('$count', style: const TextStyle(fontSize: 12, color: _C.muted)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final c = widget.controller;
    final options = c.wilayaOptions;
    final all = ('', 'كل الولايات'.tr, c.regionTotal(c.selectedRegion));
    final entries = [
      all,
      for (final s in options) (s.code, _name(s), s.totalUser + s.totalG),
    ];

    return DropdownButtonHideUnderline(
      child: DropdownButton2<String>(
        isExpanded: true,
        value: c.selectedWilaya,
        onChanged: (v) => c.changeWilaya(v ?? ''),
        items: [
          for (final e in entries)
            DropdownMenuItem<String>(
              value: e.$1,
              child: _item(e.$1, e.$2, e.$3),
            ),
        ],
        selectedItemBuilder: (context) => [
          for (final e in entries) _item(e.$1, e.$2, e.$3, selected: true),
        ],
        buttonStyleData: ButtonStyleData(
          height: 42,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: _C.track,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: _C.line),
          ),
        ),
        iconStyleData: const IconStyleData(
          icon: Icon(Icons.keyboard_arrow_down_rounded),
          iconSize: 22,
          iconEnabledColor: _C.muted,
        ),
        dropdownStyleData: DropdownStyleData(
          maxHeight: 360,
          elevation: 6,
          offset: const Offset(0, -4),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        menuItemStyleData: const MenuItemStyleData(
          height: 42,
          padding: EdgeInsets.symmetric(horizontal: 14),
        ),
        // بحث داخل القائمة بالاسم (عربي/فرنسي) أو الرقم
        dropdownSearchData: DropdownSearchData(
          searchController: searchController,
          searchInnerWidgetHeight: 56,
          searchInnerWidget: Padding(
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 4),
            child: TextField(
              controller: searchController,
              autofocus: true,
              style: const TextStyle(fontSize: 13.5),
              decoration: InputDecoration(
                isDense: true,
                hintText: 'search'.tr,
                prefixIcon: const Icon(Icons.search, size: 20),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 10,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
          searchMatchFn: (item, query) {
            final q = query.trim().toLowerCase();
            if (q.isEmpty || item.value == '') return true;
            final s = options.firstWhereOrNull((o) => o.code == item.value);
            return s != null &&
                (s.code.contains(q) ||
                    s.state.toLowerCase().contains(q) ||
                    s.stateFr.toLowerCase().contains(q));
          },
        ),
        // تفريغ البحث عند إغلاق القائمة
        onMenuStateChange: (open) {
          if (!open) searchController.clear();
        },
      ),
    );
  }
}

class _C {
  static const track = Color(0xFFF1F5F9);
  static const title = Color(0xFF2D3748);
  static const ink = Color(0xFF1E293B);
  static const muted = Color(0xFF64748B);
  static const faint = Color(0xFF94A3B8);
  static const line = Color(0xFFEDF2F7);
}
