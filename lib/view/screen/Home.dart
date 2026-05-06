import 'dart:ui';

import 'package:chafi_dashboard/controller/DashboardHomeController.dart';
import 'package:chafi_dashboard/core/constant/Colorapp.dart';
import 'package:chafi_dashboard/data/model/DashboardStats.dart';
import 'package:chafi_dashboard/view/Widget/TextFild/SearchFild.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:get/get.dart';

import '../Widget/TablePaginationFooter.dart'; // ستحتاج لإضافتها في pubspec.yaml

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
                  LayoutBuilder(
                    builder: (context, constraints) {
                      bool isMobile = constraints.maxWidth < 800;
                      if (isMobile) {
                        return Column(
                          children: [
                            _buildStatCard(
                              "total_users".tr,
                              "${controller.data.isNotEmpty ? controller.data[0].user : 0}",
                              Icons.people,
                              Colors.blue,
                            ),
                            const SizedBox(height: 20),
                            _buildStatCard2(
                              "الدخول اليوم".tr,
                              "${controller.data.isNotEmpty ? controller.data[0].totalUsersEntertoday : 0}",
                              "${controller.data.isNotEmpty ? controller.data[0].totalGuestsEntertoday : 0}",
                              Colors.blue,
                            ),
                            const SizedBox(height: 20),
                            _buildStatCard2(
                              "الدخول الإجمالي".tr,
                              "${controller.data.isNotEmpty ? controller.data[0].totalUsersEnter : 0}",
                              "${controller.data.isNotEmpty ? controller.data[0].totalGuestsEnter : 0}",
                              Colors.grey,
                            ),
                          ],
                        );
                      }
                      return Row(
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
                      );
                    },
                  ),

                  const SizedBox(height: 20),
                  LayoutBuilder(
                    builder: (context, constraints) {
                      bool isMobile = constraints.maxWidth < 800;
                      if (isMobile) {
                        return Column(
                          children: [
                            _buildChartSection(
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
                            const SizedBox(height: 20),
                            _buildStateStatisticsTable(controller),
                          ],
                        );
                      }
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
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
                          const SizedBox(width: 20),
                          Expanded(
                            child: _buildStateStatisticsTable(controller),
                          ),
                        ],
                      );
                    },
                  ),

                  const SizedBox(height: 20),
                  _buildServiceStatsGrid(controller),
                  const SizedBox(height: 20),
                  _buildAdvancedCharts(controller),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildAdvancedCharts(Dashboardhomecontroller controller) {
    return LayoutBuilder(
      builder: (context, constraints) {
        bool isMobile = constraints.maxWidth < 1000;
        if (isMobile) {
          return Column(
            children: [
              _buildUsersGuestsChart(controller),
              const SizedBox(height: 20),
              _buildDetailedStatsChart(controller),
            ],
          );
        }
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: _buildUsersGuestsChart(controller)),
            const SizedBox(width: 20),
            Expanded(child: _buildDetailedStatsChart(controller)),
          ],
        );
      },
    );
  }

  Widget _buildUsersGuestsChart(Dashboardhomecontroller controller) {
    var dataPoints = controller.currentUsersGuestsData;
    return Container(
      height: 450,
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "user_guest_chart_title".tr,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2D3748),
                ),
              ),
              Row(
                children: [
                  _buildFilterBtn(
                    "daily".tr,
                    "daily",
                    controller.usersGuestsFilter,
                    controller.changeUsersGuestsFilter,
                  ),
                  const SizedBox(width: 5),
                  _buildFilterBtn(
                    "weekly".tr,
                    "weekly",
                    controller.usersGuestsFilter,
                    controller.changeUsersGuestsFilter,
                  ),
                  const SizedBox(width: 5),
                  _buildFilterBtn(
                    "monthly".tr,
                    "monthly",
                    controller.usersGuestsFilter,
                    controller.changeUsersGuestsFilter,
                  ),
                  const SizedBox(width: 5),
                  _buildFilterBtn(
                    "yearly".tr,
                    "yearly",
                    controller.usersGuestsFilter,
                    controller.changeUsersGuestsFilter,
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 30),
          Expanded(
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  getDrawingHorizontalLine: (value) =>
                      FlLine(color: Colors.grey.shade100, strokeWidth: 1),
                ),
                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 45,
                      interval: 1,
                      getTitlesWidget: (value, meta) {
                        if (dataPoints.isEmpty ||
                            value.toInt() < 0 ||
                            value.toInt() >= dataPoints.length) {
                          return const SizedBox();
                        }
                        String date = dataPoints[value.toInt()].date;
                        // تبسيط التاريخ للعرض: YYYY-MM-DD -> MM-DD
                        String label = date.contains('-') && date.length >= 10
                            ? date.split('-').skip(1).join('-')
                            : date;

                        return SideTitleWidget(
                          axisSide: meta.axisSide,
                          space: 10,
                          angle: -0.5,
                          child: Text(
                            label,
                            style: TextStyle(
                              color: Colors.grey.shade500,
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
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
                      getTitlesWidget: (value, meta) => Text(
                        value.toInt().toString(),
                        style: TextStyle(
                          color: Colors.grey.shade400,
                          fontSize: 10,
                        ),
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
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    spots: dataPoints.asMap().entries.map((e) {
                      return FlSpot(
                        e.key.toDouble(),
                        e.value.usersCount.toDouble(),
                      );
                    }).toList(),
                    isCurved: false,
                    color: AppColor.primarycolor,
                    barWidth: 3,
                    isStrokeCapRound: true,
                    dotData: FlDotData(
                      show: true,
                      getDotPainter: (spot, percent, barData, index) =>
                          FlDotCirclePainter(
                            radius: 3,
                            color: Colors.white,
                            strokeWidth: 2,
                            strokeColor: AppColor.primarycolor,
                          ),
                    ),
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        colors: [
                          AppColor.primarycolor.withOpacity(0.2),
                          AppColor.primarycolor.withOpacity(0.0),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                  LineChartBarData(
                    spots: dataPoints.asMap().entries.map((e) {
                      return FlSpot(
                        e.key.toDouble(),
                        e.value.guestsCount.toDouble(),
                      );
                    }).toList(),
                    isCurved: false,
                    color: Colors.grey,
                    barWidth: 3,
                    isStrokeCapRound: true,
                    dotData: FlDotData(
                      show: true,
                      getDotPainter: (spot, percent, barData, index) =>
                          FlDotCirclePainter(
                            radius: 3,
                            color: Colors.white,
                            strokeWidth: 2,
                            strokeColor: Colors.grey,
                          ),
                    ),
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        colors: [
                          Colors.grey.withOpacity(0.2),
                          Colors.grey.withOpacity(0.0),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildLegendItem("مستخدمون".tr, AppColor.primarycolor),
              const SizedBox(width: 20),
              _buildLegendItem("ضيوف".tr, Colors.grey),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDetailedStatsChart(Dashboardhomecontroller controller) {
    var dataPoints = controller.currentStatsData;
    return Container(
      height: 450,
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "service_usage_chart_title".tr,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2D3748),
                ),
              ),
              Row(
                children: [
                  _buildFilterBtn(
                    "daily".tr,
                    "daily",
                    controller.statsFilter,
                    controller.changeStatsFilter,
                  ),
                  const SizedBox(width: 5),
                  _buildFilterBtn(
                    "weekly".tr,
                    "weekly",
                    controller.statsFilter,
                    controller.changeStatsFilter,
                  ),
                  const SizedBox(width: 5),
                  _buildFilterBtn(
                    "monthly".tr,
                    "monthly",
                    controller.statsFilter,
                    controller.changeStatsFilter,
                  ),
                  const SizedBox(width: 5),
                  _buildFilterBtn(
                    "yearly".tr,
                    "yearly",
                    controller.statsFilter,
                    controller.changeStatsFilter,
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 30),
          Expanded(
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  getDrawingHorizontalLine: (value) =>
                      FlLine(color: Colors.grey.shade100, strokeWidth: 1),
                ),
                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 45,
                      interval: 1,
                      getTitlesWidget: (value, meta) {
                        if (dataPoints.isEmpty ||
                            value.toInt() < 0 ||
                            value.toInt() >= dataPoints.length) {
                          return const SizedBox();
                        }
                        String date = dataPoints[value.toInt()].date;
                        // تبسيط التاريخ للعرض: YYYY-MM-DD -> MM-DD
                        String label = date.contains('-') && date.length >= 10
                            ? date.split('-').skip(1).join('-')
                            : date;

                        return SideTitleWidget(
                          axisSide: meta.axisSide,
                          space: 10,
                          angle: -0.5,
                          child: Text(
                            label,
                            style: TextStyle(
                              color: Colors.grey.shade500,
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
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
                      getTitlesWidget: (value, meta) => Text(
                        value.toInt().toString(),
                        style: TextStyle(
                          color: Colors.grey.shade400,
                          fontSize: 10,
                        ),
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
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  _buildLineBar(
                    dataPoints.asMap().entries.map((e) {
                      return FlSpot(e.key.toDouble(), e.value.type1.toDouble());
                    }).toList(),
                    Colors.blue,
                  ),
                  _buildLineBar(
                    dataPoints.asMap().entries.map((e) {
                      return FlSpot(e.key.toDouble(), e.value.type2.toDouble());
                    }).toList(),
                    Colors.orange,
                  ),
                  _buildLineBar(
                    dataPoints.asMap().entries.map((e) {
                      return FlSpot(e.key.toDouble(), e.value.type3.toDouble());
                    }).toList(),
                    Colors.purple,
                  ),
                  _buildLineBar(
                    dataPoints.asMap().entries.map((e) {
                      return FlSpot(e.key.toDouble(), e.value.type4.toDouble());
                    }).toList(),
                    Colors.green,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 15,
            runSpacing: 5,
            alignment: WrapAlignment.center,
            children: [
              _buildLegendItem("institutions".tr, Colors.blue),
              _buildLegendItem("tax_systems".tr, Colors.orange),
              _buildLegendItem("card".tr, Colors.purple),
              _buildLegendItem("calculators".tr, Colors.green),
            ],
          ),
        ],
      ),
    );
  }

  LineChartBarData _buildLineBar(List<FlSpot> spots, Color color) {
    return LineChartBarData(
      spots: spots,
      isCurved: false,
      color: color,
      barWidth: 3,
      isStrokeCapRound: true,
      dotData: FlDotData(
        show: true,
        getDotPainter: (spot, percent, barData, index) => FlDotCirclePainter(
          radius: 2,
          color: Colors.white,
          strokeWidth: 2,
          strokeColor: color,
        ),
      ),
      belowBarData: BarAreaData(
        show: true,
        gradient: LinearGradient(
          colors: [color.withOpacity(0.15), color.withOpacity(0.0)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
    );
  }

  Widget _buildFilterBtn(
    String label,
    String value,
    String current,
    Function(String) onTap,
  ) {
    bool isSelected = value == current;
    return InkWell(
      onTap: () => onTap(value),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: isSelected ? AppColor.primarycolor : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.grey.shade600,
            fontSize: 11,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 5),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    );
  }

  Widget _buildServiceStatsGrid(Dashboardhomecontroller controller) {
    var stats = controller.data.isNotEmpty ? controller.data[0] : null;

    return LayoutBuilder(
      builder: (context, constraints) {
        bool isMobile = constraints.maxWidth < 800;
        return GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: isMobile ? 2 : 4,
          crossAxisSpacing: 15,
          mainAxisSpacing: 15,
          childAspectRatio: isMobile ? 1.3 : 2.2,
          children: [
            _buildStatCard3(
              "institutions".tr,
              "${stats?.dailyIns ?? 0}",
              "${stats?.totalIns ?? 0}",
              Colors.blue,
            ),
            _buildStatCard3(
              "tax_systems".tr,
              "${stats?.dailyTax ?? 0}",
              "${stats?.totalTax ?? 0}",
              Colors.orange,
            ),
            _buildStatCard3(
              "card".tr,
              "${stats?.dailyCard ?? 0}",
              "${stats?.totalCard ?? 0}",
              Colors.purple,
            ),
            _buildStatCard3(
              "calculators".tr,
              "${stats?.dailyCal ?? 0}",
              "${stats?.totalCal ?? 0}",
              Colors.green,
            ),
          ],
        );
      },
    );
  }

  Widget _buildStatCard3(
    String title,
    String dailyValue,
    String totalValue,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: Colors.grey.shade100, width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              color: Colors.grey.shade500,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildSimpleStat("daily_access".tr, dailyValue, color, 16),
              _buildSimpleStat(
                "total_access".tr,
                totalValue,
                Colors.black87,
                16,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSimpleStat(
    String label,
    String value,
    Color color,
    double fontSize,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            value,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: fontSize,
            ),
          ),
        ),
        Text(label, style: TextStyle(color: Colors.grey.shade400, fontSize: 9)),
      ],
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
      height: 150,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
        border: Border.all(color: color.withOpacity(0.1), width: 1.5),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(width: 20),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: Colors.grey.shade500,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1A202C),
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
      height: 150,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
        border: Border.all(color: Colors.grey.shade100, width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Container(
                width: 4,
                height: 14,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 10),
              Text(
                title,
                style: TextStyle(
                  color: Colors.grey.shade500,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildMiniStat("مستخدمون".tr, usersValue, AppColor.primarycolor),
              Container(width: 1, height: 30, color: Colors.grey.shade100),
              _buildMiniStat("ضيوف".tr, guestsValue, Colors.black87),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMiniStat(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            color: color,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(color: Colors.grey.shade400, fontSize: 11),
        ),
      ],
    );
  }

  Widget _buildStateStatisticsTable(Dashboardhomecontroller controller) {
    final horizontalController = ScrollController();
    return Container(
      height: 400,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.withOpacity(0.1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Table Header Section
          Padding(
            padding: const EdgeInsets.only(
              top: 5,
              bottom: 10,
              left: 5,
              right: 5,
            ),
            child: LayoutBuilder(
              builder: (context, constraints) {
                bool isMobile = constraints.maxWidth < 330;
                return isMobile
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "إحصائيات الدخول".tr,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF191C1E),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "عدد الخول حسب كل ولاية".tr,
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 30),

                          // هذا هو المهم
                          Center(
                            child: Container(
                              width: 170,
                              child: SearchField(
                                onChanged: controller.filterData,
                                hint: "search".tr,
                                vertical: 2,
                                isDense: true,
                              ),
                            ),
                          ),
                        ],
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "إحصائيات الدخول".tr,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF191C1E),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "عدد الخول حسب كل ولاية".tr,
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            width: 170,
                            child: SearchField(
                              onChanged: controller.filterData,
                              hint: "search".tr,
                              vertical: 2,
                              isDense: true,
                            ),
                          ),
                        ],
                      );
              },
            ),
          ),

          Expanded(
            child: ScrollConfiguration(
              behavior: const ScrollBehavior().copyWith(
                scrollbars: true,
                dragDevices: {PointerDeviceKind.touch, PointerDeviceKind.mouse},
              ),
              child: SingleChildScrollView(
                controller: horizontalController,
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  headingRowHeight: 40,
                  dataRowHeight: 40,
                  headingRowColor: MaterialStateProperty.all(
                    const Color(0xFFF8F9FA),
                  ),
                  border: TableBorder(
                    horizontalInside: BorderSide(
                      color: Colors.grey.shade200,
                      width: 1,
                    ),
                    bottom: BorderSide(color: Colors.grey.shade200, width: 1),
                  ),
                  columns: [
                    DataColumn(label: Text('الولاية'.tr)),
                    DataColumn(label: Text('مستخدمون'.tr)),
                    DataColumn(label: Text('ضيوف'.tr)),
                    DataColumn(label: Text('إجمالي المستخدمون'.tr)),
                    DataColumn(label: Text('إجمالي الضيوف'.tr)),
                    DataColumn(label: Text("نسبة دخول".tr)),
                  ],
                  rows: controller.pagedData.asMap().entries.expand((entry) {
                    StateStats stateItem = entry.value; // ← هنا عرفنا stateItem
                    return [
                      DataRow(
                        cells: [
                          DataCell(
                            Text(
                              stateItem.state,
                              style: TextStyle(fontSize: 12),
                            ),
                          ),
                          DataCell(
                            Text(
                              stateItem.dailyUser.toString(),
                              style: TextStyle(fontSize: 14),
                            ),
                          ),
                          DataCell(
                            Text(
                              stateItem.dailyG.toString(),
                              style: TextStyle(fontSize: 14),
                            ),
                          ),
                          DataCell(
                            Text(
                              stateItem.totalUser.toString(),
                              style: TextStyle(fontSize: 14),
                            ),
                          ),
                          DataCell(
                            Text(
                              stateItem.totalG.toString(),
                              style: TextStyle(fontSize: 14),
                            ),
                          ),
                          DataCell(
                            Row(
                              children: [
                                Expanded(
                                  child: SizedBox(
                                    width: 100,
                                    child: Container(
                                      height: 8,
                                      decoration: BoxDecoration(
                                        color: Colors.grey.shade200,
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: FractionallySizedBox(
                                        alignment: Alignment.centerLeft,
                                        widthFactor:
                                            stateItem.dailyPercent / 100,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Colors.blue,
                                            borderRadius: BorderRadius.circular(
                                              4,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  '${stateItem.dailyPercent.toStringAsFixed(0)}%',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ];
                  }).toList(),
                ),
              ),
            ),
          ),
          TablePaginationFooter(
            currentPage: controller.currentPage,
            rowsPerPage: controller.rowsPerPage,
            totalEntries: controller.filteredData.length,
            totalPages: controller.totalPages,
            currentFilteredLength: controller.filteredData.length,
            onNext: controller.nextPage,
            onPrevious: controller.previousPage,
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


  // Widget _buildPieChartSection({
  //   required double realPercent,
  //   required int realCount,
  //   required double jzafiPercent,
  //   required int jzafiCount,
  //   required double simplePercent,
  //   required int simpleCount,
  // }) {
  //   return Container(
  //     height: 400,
  //     padding: const EdgeInsets.all(24),
  //     decoration: BoxDecoration(
  //       color: Colors.white,
  //       borderRadius: BorderRadius.circular(20),
  //       boxShadow: [
  //         BoxShadow(
  //           color: Colors.black.withOpacity(0.05),
  //           blurRadius: 20,
  //           offset: const Offset(0, 10),
  //         ),
  //       ],
  //     ),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         Text(
  //           "logs_analysis_by_system".tr,
  //           style: const TextStyle(
  //             fontSize: 18,
  //             fontWeight: FontWeight.bold,
  //             color: Color(0xFF2D3748),
  //           ),
  //         ),

  //         const SizedBox(height: 20),

  //         Expanded(
  //           child: Row(
  //             children: [
  //               /// Chart
  //               Expanded(
  //                 child: Stack(
  //                   alignment: Alignment.center,
  //                   children: [
  //                     PieChart(
  //                       PieChartData(
  //                         sectionsSpace: 3,
  //                         centerSpaceRadius: 65,
  //                         sections: [
  //                           PieChartSectionData(
  //                             value: realPercent,
  //                             title: "${realPercent.toInt()}%",
  //                             radius: 80,
  //                             gradient: const LinearGradient(
  //                               colors: [Color(0xFF6269F2), Color(0xFF8B91FF)],
  //                             ),
  //                             titleStyle: const TextStyle(
  //                               color: Colors.white,
  //                               fontWeight: FontWeight.bold,
  //                             ),
  //                           ),
  //                           PieChartSectionData(
  //                             value: jzafiPercent,
  //                             title: "${jzafiPercent.toInt()}%",
  //                             radius: 80,
  //                             gradient: const LinearGradient(
  //                               colors: [Color(0xFFFFAD5F), Color(0xFFFF7D05)],
  //                             ),
  //                             titleStyle: const TextStyle(
  //                               color: Colors.white,
  //                               fontWeight: FontWeight.bold,
  //                             ),
  //                           ),
  //                           PieChartSectionData(
  //                             value: simplePercent,
  //                             title: "${simplePercent.toInt()}%",
  //                             radius: 80,
  //                             gradient: const LinearGradient(
  //                               colors: [Color(0xFFAC54F1), Color(0xFFD483FF)],
  //                             ),
  //                             titleStyle: const TextStyle(
  //                               color: Colors.white,
  //                               fontWeight: FontWeight.bold,
  //                             ),
  //                           ),
  //                         ],
  //                       ),
  //                     ),

  //                     /// center title
  //                     Column(
  //                       mainAxisSize: MainAxisSize.min,
  //                       children: [
  //                         Text(
  //                           "total".tr,
  //                           style: TextStyle(
  //                             color: Colors.grey.shade600,
  //                             fontSize: 14,
  //                           ),
  //                         ),
  //                         Text(
  //                           "${realCount + jzafiCount + simpleCount}",
  //                           style: const TextStyle(
  //                             fontWeight: FontWeight.bold,
  //                             fontSize: 22,
  //                           ),
  //                         ),
  //                       ],
  //                     ),
  //                   ],
  //                 ),
  //               ),

  //               const SizedBox(width: 20),

  //               /// Legend
  //               Column(
  //                 mainAxisAlignment: MainAxisAlignment.center,
  //                 crossAxisAlignment: CrossAxisAlignment.start,
  //                 children: [
  //                   _legendItem(
  //                     color1: const Color(0xFF6269F2),
  //                     color2: const Color(0xFF8B91FF),
  //                     title: "system_real".tr,
  //                     percent: realPercent,
  //                     count: realCount,
  //                   ),

  //                   const SizedBox(height: 12),

  //                   _legendItem(
  //                     color1: const Color(0xFFFFAD5F),
  //                     color2: const Color(0xFFFF7D05),
  //                     title: "system_partial".tr,
  //                     percent: jzafiPercent,
  //                     count: jzafiCount,
  //                   ),

  //                   const SizedBox(height: 12),

  //                   _legendItem(
  //                     color1: const Color(0xFFAC54F1),
  //                     color2: const Color(0xFFD483FF),
  //                     title: "system_simplified".tr,
  //                     percent: simplePercent,
  //                     count: simpleCount,
  //                   ),
  //                 ],
  //               ),
  //             ],
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }
