import 'dart:ui';

import 'package:chafi_dashboard/controller/DashboardHomeController.dart';
import 'package:chafi_dashboard/core/constant/Colorapp.dart';
import 'package:chafi_dashboard/view/screen/application/Addapp.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:get/get.dart'; // ستحتاج لإضافتها في pubspec.yaml

class DashboardHome extends StatelessWidget {
  const DashboardHome({super.key});
  @override
  Widget build(BuildContext context) {
    Get.create(() => Dashboardhomecontroller());
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 243, 243, 243),
      body: GetBuilder<Dashboardhomecontroller>(
        builder: (controller) {
          return ScrollConfiguration(
            behavior: const ScrollBehavior().copyWith(
              scrollbars: true,
              dragDevices: {
                PointerDeviceKind.touch,
                PointerDeviceKind.mouse, // هنا نضيف دعم الفأرة
              },
            ),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. كارد ترحيبي على طول الشاشة
                  _buildWelcomeCard(),

                  const SizedBox(height: 30),

                  // 2. إحصائيات سريعة (المستخدمين والدخول)
                  Row(
                    children: [
                      Expanded(
                        child: _buildStatCard(
                          "total_users".tr,
                          "${controller.data.isNotEmpty ? controller.data[0].user : 0}",
                          Icons.people,
                          Colors.blue,
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: _buildStatCard2(
                          "الدخول اليوم".tr,
                          "${controller.data.isNotEmpty ? controller.data[0].totalUsersEntertoday : 0}",
                          "${controller.data.isNotEmpty ? controller.data[0].totalGuestsEntertoday : 0}",
                          Colors.blue,
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: _buildStatCard2(
                          "الدخول الإجمالي".tr,
                          "${controller.data.isNotEmpty ? controller.data[0].totalUsersEnter : 0}",
                          "${controller.data.isNotEmpty ? controller.data[0].totalGuestsEnter : 0}",
                          Colors.grey,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: _buildChartSection(
                          realCount: controller.data.isNotEmpty
                              ? controller.data[0].tax3Hakiki
                              : 0,
                          jzafiCount: controller.data.isNotEmpty
                              ? controller.data[0].tax1Jazafi
                              : 0,
                          simpleCount: controller.data.isNotEmpty
                              ? controller.data[0].tax2Mobassat
                              : 0,
                          realPercent: controller.data.isNotEmpty
                              ? controller.data[0].tax3
                              : 0,
                          jzafiPercent: controller.data.isNotEmpty
                              ? controller.data[0].tax1
                              : 0,
                          simplePercent: controller.data.isNotEmpty
                              ? controller.data[0].tax2
                              : 0,
                        ),
                      ),

                      SizedBox(width: 20),
                      Expanded(
                        child: _buildPieChartSection(
                          realCount: controller.data.isNotEmpty
                              ? controller.data[0].tax3Hakiki
                              : 0,
                          jzafiCount: controller.data.isNotEmpty
                              ? controller.data[0].tax1Jazafi
                              : 0,
                          simpleCount: controller.data.isNotEmpty
                              ? controller.data[0].tax2Mobassat
                              : 0,
                          realPercent: controller.data.isNotEmpty
                              ? controller.data[0].tax3
                              : 0,
                          jzafiPercent: controller.data.isNotEmpty
                              ? controller.data[0].tax1
                              : 0,
                          simplePercent: controller.data.isNotEmpty
                              ? controller.data[0].tax2
                              : 0,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // ويدجت الكارد الترحيبي
  Widget _buildWelcomeCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0EA5E9), Color(0xFF0369A1)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "welcome_back_admin".tr,
            style: TextStyle(
              color: Colors.white,
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            "dashboard_subtitle".tr,
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  // ويدجت بطاقة الإحصائيات
  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      height: 140,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start, // الوسط أفقياً
        crossAxisAlignment: CrossAxisAlignment.center, // الوسط عمودياً
        children: [
          CircleAvatar(
            backgroundColor: color.withOpacity(0.1),
            child: Icon(icon, color: color),
          ),
          const SizedBox(width: 15),
          Column(
            mainAxisAlignment: MainAxisAlignment.center, // وسط المحتوى عمودياً
            crossAxisAlignment: CrossAxisAlignment.start, // وسط المحتوى أفقياً
            children: [
              Text(
                title,
                style: const TextStyle(color: Colors.grey, fontSize: 14),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard2(
    String title,
    String usersValue,
    String guestsValue,
    Color color,
  ) {
    return Container(
      height: 140,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// العنوان
          Row(
            children: [
              Container(
                width: 5,
                height: 12,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              const SizedBox(width: 6),
              Text(
                title,
                style: const TextStyle(color: Colors.grey, fontSize: 14),
              ),
            ],
          ),

          const SizedBox(height: 15),

          /// الإحصائيات
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              /// المستخدمون
              Column(
                children: [
                  Text(
                    "مستخدمون".tr,
                    style: const TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    usersValue,
                    style: const TextStyle(
                      color: AppColor.primarycolor,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),

              /// الخط الفاصل
              Container(width: 1, height: 40, color: Colors.grey.shade300),

              /// الضيوف
              Column(
                children: [
                  Text(
                    "ضيوف".tr,
                    style: const TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    guestsValue,
                    style: const TextStyle(
                      color: AppColor.black,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPieChartSection({
    required double realPercent,
    required int realCount,
    required double jzafiPercent,
    required int jzafiCount,
    required double simplePercent,
    required int simpleCount,
  }) {
    return Container(
      height: 400,
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "logs_analysis_by_system".tr,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2D3748),
            ),
          ),

          const SizedBox(height: 20),

          Expanded(
            child: Row(
              children: [
                /// Chart
                Expanded(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      PieChart(
                        PieChartData(
                          sectionsSpace: 3,
                          centerSpaceRadius: 65,
                          sections: [
                            PieChartSectionData(
                              value: realPercent,
                              title: "${realPercent.toInt()}%",
                              radius: 80,
                              gradient: const LinearGradient(
                                colors: [Color(0xFF6269F2), Color(0xFF8B91FF)],
                              ),
                              titleStyle: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            PieChartSectionData(
                              value: jzafiPercent,
                              title: "${jzafiPercent.toInt()}%",
                              radius: 80,
                              gradient: const LinearGradient(
                                colors: [Color(0xFFFFAD5F), Color(0xFFFF7D05)],
                              ),
                              titleStyle: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            PieChartSectionData(
                              value: simplePercent,
                              title: "${simplePercent.toInt()}%",
                              radius: 80,
                              gradient: const LinearGradient(
                                colors: [Color(0xFFAC54F1), Color(0xFFD483FF)],
                              ),
                              titleStyle: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),

                      /// center title
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "total".tr,
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            "${realCount + jzafiCount + simpleCount}",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 22,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 20),

                /// Legend
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _legendItem(
                      color1: const Color(0xFF6269F2),
                      color2: const Color(0xFF8B91FF),
                      title: "system_real".tr,
                      percent: realPercent,
                      count: realCount,
                    ),

                    const SizedBox(height: 12),

                    _legendItem(
                      color1: const Color(0xFFFFAD5F),
                      color2: const Color(0xFFFF7D05),
                      title: "system_partial".tr,
                      percent: jzafiPercent,
                      count: jzafiCount,
                    ),

                    const SizedBox(height: 12),

                    _legendItem(
                      color1: const Color(0xFFAC54F1),
                      color2: const Color(0xFFD483FF),
                      title: "system_simplified".tr,
                      percent: simplePercent,
                      count: simpleCount,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChartSection({
    required double realPercent,
    required int realCount,
    required double jzafiPercent,
    required int jzafiCount,
    required double simplePercent,
    required int simpleCount,
  }) {
    return Container(
      height: 400,
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "logs_analysis_by_system".tr,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2D3748),
            ),
          ),
          const SizedBox(height: 30),
          Expanded(
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: 100,
                barTouchData: BarTouchData(
                  touchTooltipData: BarTouchTooltipData(
                    tooltipBgColor: const Color(0xFF2D3748),
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      List<String> labels = [
                        "system_real".tr,
                        "system_partial".tr,
                        "system_simplified".tr,
                      ];
                      List<String> values = [
                        "$realPercent% - $realCount ${"records_count".tr}",
                        "$jzafiPercent% - $jzafiCount ${"records_count".tr}",
                        "$simplePercent% - $simpleCount ${"records_count".tr}",
                      ];
                      return BarTooltipItem(
                        "${labels[group.x]}\n",
                        const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                        children: [
                          TextSpan(
                            text: values[group.x],
                            style: const TextStyle(
                              color: Color(0xFF8B91FF),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
                titlesData: FlTitlesData(
                  show: true,
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 30,
                      getTitlesWidget: (value, meta) {
                        List<String> titles = [
                          "system_real".tr,
                          "system_partial".tr,
                          "system_simplified".tr,
                        ];
                        return SideTitleWidget(
                          axisSide: meta.axisSide,
                          space: 10,
                          child: Text(
                            titles[value.toInt()],
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          "${value.toInt()}",
                          style: TextStyle(
                            color: Colors.grey.shade400,
                            fontSize: 12,
                          ),
                        );
                      },
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
                  show: true,
                  drawVerticalLine: false,
                  getDrawingHorizontalLine: (value) =>
                      FlLine(color: Colors.grey.shade100, strokeWidth: 1),
                ),
                borderData: FlBorderData(show: false),
                barGroups: [
                  _makeGroupData(0, realPercent, const [
                    Color(0xFF6269F2),
                    Color(0xFF8B91FF),
                  ]),
                  _makeGroupData(1, jzafiPercent, const [
                    Color(0xFFFFAD5F),
                    Color(0xFFFF7D05),
                  ]),
                  _makeGroupData(2, simplePercent, const [
                    Color(0xFFAC54F1),
                    Color(0xFFD483FF),
                  ]),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _legendItem({
    required Color color1,
    required Color color2,
    required String title,
    required double percent,
    required int count,
  }) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [color1, color2]),
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
            Text(
              "${percent.toInt()}%  •  $count",
              style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
            ),
          ],
        ),
      ],
    );
  }

  BarChartGroupData _makeGroupData(
    int x,
    double y,
    List<Color> gradientColors,
  ) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          gradient: LinearGradient(
            colors: gradientColors,
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
          ),
          width: 25,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(6),
            topRight: Radius.circular(6),
          ),
          backDrawRodData: BackgroundBarChartRodData(
            show: true,
            toY: 100,
            color: const Color(0xFFF7FAFC),
          ),
        ),
      ],
    );
  }
}
