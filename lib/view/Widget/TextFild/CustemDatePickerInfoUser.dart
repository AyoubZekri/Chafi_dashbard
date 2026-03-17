import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../core/constant/Colorapp.dart';

class CustemDatePickerInfoUser extends StatelessWidget {
  final String hintText;
  final String label;
  final TextEditingController? controller;

  const CustemDatePickerInfoUser({
    super.key,
    required this.hintText,
    required this.label,
    this.controller,
  });

  Future<void> _pickDate(BuildContext context) async {
    DateTime? initial;

    if (controller?.text.isNotEmpty == true) {
      initial = DateFormat('yyyy-MM-dd').parse(controller!.text);
    }

    final DateTime? picked = await showDialog(
      context: context,
      builder: (_) => ElegantDatePicker(initialDate: initial),
    );

    if (picked != null) {
      controller?.text = DateFormat('yyyy-MM-dd').format(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          readOnly: true,
          onTap: () => _pickDate(context),
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColor.black,
          ),
          decoration: InputDecoration(
            hintText: hintText,
            filled: true,
            fillColor: Colors.white,
            suffixIcon: const Icon(Icons.calendar_month, color: Colors.grey),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: AppColor.grey),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: AppColor.grey),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ],
    );
  }
}

class ElegantDatePicker extends StatefulWidget {
  final DateTime? initialDate;

  const ElegantDatePicker({super.key, this.initialDate});

  @override
  State<ElegantDatePicker> createState() => _ElegantDatePickerState();
}

class _ElegantDatePickerState extends State<ElegantDatePicker> {
  late DateTime currentMonth;
  DateTime? selectedDate;
  List<String> months = [
    "January",
    "February",
    "March",
    "April",
    "May",
    "June",
    "July",
    "August",
    "September",
    "October",
    "November",
    "December",
  ];

  String get monthName => months[currentMonth.month - 1];

  @override
  void initState() {
    super.initState();

    selectedDate = widget.initialDate;

    currentMonth = DateTime(
      selectedDate?.year ?? DateTime.now().year,
      selectedDate?.month ?? DateTime.now().month,
    );
  }

  /// ===== اختيار السنة =====
  Future<void> pickYear() async {
    int currentYear = DateTime.now().year;

    ScrollController controller = ScrollController(
      initialScrollOffset: (45 / 4) * 80,
    );

    final year = await showDialog<int>(
      context: context,
      builder: (_) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: SizedBox(
            height: 400,
            width: 300,
            child: GridView.builder(
              controller: controller,
              padding: const EdgeInsets.all(20),
              itemCount: 101,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                mainAxisExtent: 70,
              ),
              itemBuilder: (_, i) {
                int year = currentYear - 50 + i;

                bool selected = year == currentMonth.year;

                return GestureDetector(
                  onTap: () => Navigator.pop(context, year),
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: selected
                          ? AppColor.typography
                          : Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      "$year",
                      style: TextStyle(
                        color: selected ? Colors.white : Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );

    if (year != null) {
      setState(() {
        currentMonth = DateTime(year, currentMonth.month);
      });
    }
  }

  /// ===== اختيار الشهر =====
  Future<void> pickMonth() async {
    int currentM = currentMonth.month;

    final month = await showDialog<int>(
      context: context,
      builder: (_) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: SizedBox(
            height: 400,
            width: 300,
            child: GridView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: 12,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
              ),
              itemBuilder: (_, i) {
                int m = i + 1;

                bool selected = m == currentM;

                return GestureDetector(
                  onTap: () => Navigator.pop(context, m),
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: selected
                          ? AppColor.typography
                          : Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      months[i].tr,
                      style: TextStyle(
                        color: selected ? Colors.white : Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );

    if (month != null) {
      setState(() {
        currentMonth = DateTime(currentMonth.year, month);
      });
    }
  }

  /// ===== بناء الأيام =====
  List<Widget> buildDays() {
    final firstDay = DateTime(currentMonth.year, currentMonth.month, 1);
    final daysBefore = firstDay.weekday % 7;

    final daysInMonth = DateUtils.getDaysInMonth(
      currentMonth.year,
      currentMonth.month,
    );

    List<Widget> widgets = [];

    for (int i = 0; i < daysBefore; i++) {
      widgets.add(const SizedBox());
    }

    for (int i = 1; i <= daysInMonth; i++) {
      final date = DateTime(currentMonth.year, currentMonth.month, i);

      bool isSelected =
          selectedDate != null &&
          selectedDate!.year == date.year &&
          selectedDate!.month == date.month &&
          selectedDate!.day == date.day;

      widgets.add(
        GestureDetector(
          onTap: () {
            setState(() {
              selectedDate = date;
            });
          },
          child: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isSelected ? AppColor.typography : Colors.transparent,
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: AppColor.typography.withOpacity(.3),
                        blurRadius: 8,
                      ),
                    ]
                  : [],
            ),
            child: Text(
              "$i",
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.black87,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              ),
            ),
          ),
        ),
      );
    }

    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        padding: const EdgeInsets.all(20),
        width: 340,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            /// HEADER
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Select Date".tr,
                      style: TextStyle(
                        color: AppColor.typography,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    Row(
                      children: [
                        GestureDetector(
                          onTap: pickMonth,
                          child: Text(
                            monthName.tr,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),

                        const SizedBox(width: 6),

                        GestureDetector(
                          onTap: pickYear,
                          child: Text(
                            currentMonth.year.toString(),
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppColor.typography,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        setState(() {
                          currentMonth = DateTime(
                            currentMonth.year,
                            currentMonth.month - 1,
                          );
                        });
                      },
                      icon: const Icon(Icons.chevron_left),
                    ),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          currentMonth = DateTime(
                            currentMonth.year,
                            currentMonth.month + 1,
                          );
                        });
                      },
                      icon: const Icon(Icons.chevron_right),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 10),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Sun".tr, style: TextStyle(fontSize: 16)),
                Text("Mon".tr, style: TextStyle(fontSize: 16)),
                Text("Tue".tr, style: TextStyle(fontSize: 16)),
                Text("Wed".tr, style: TextStyle(fontSize: 16)),
                Text("Thu".tr, style: TextStyle(fontSize: 16)),
                Text("Fri".tr, style: TextStyle(fontSize: 16)),
                Text("Sat".tr, style: TextStyle(fontSize: 16)),
              ],
            ),

            const SizedBox(height: 10),

            GridView.count(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              crossAxisCount: 7,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              children: buildDays(),
            ),

            const SizedBox(height: 15),

            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text("Cancel".tr),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.typography,
                    foregroundColor: AppColor.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () => Navigator.pop(context, selectedDate),
                  child: Text("Select".tr),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
