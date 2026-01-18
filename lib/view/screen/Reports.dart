import 'package:chafi_dashboard/controller/Different/AddDifferentController.dart';
import 'package:chafi_dashboard/controller/NavigationBarcontroller.dart';
import 'package:chafi_dashboard/core/constant/Colorapp.dart';
import 'package:chafi_dashboard/core/constant/imageassets.dart';
import 'package:chafi_dashboard/view/screen/Different/AddDifferent.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/ReportsController.dart';
import '../Widget/Button/ActionButton.dart';
import '../Widget/Card/CustemPost.dart';
import '../Widget/Card/CustemShwoDealog.dart';
import '../Widget/TextFild/LabeledTextField.dart';
import '../Widget/TextFild/SearchFild.dart';

class Reports extends StatefulWidget {
  const Reports({super.key});

  @override
  State<Reports> createState() => _ReportsState();
}

class _ReportsState extends State<Reports> {
  @override
  Widget build(BuildContext context) {
    Get.create(() => ReportscontrollerImp());
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 243, 243, 243),
      body: GetBuilder<ReportscontrollerImp>(
        builder: (controller) {
          return Container(
            padding: const EdgeInsets.all(24.0),
            margin: const EdgeInsets.all(24.0),

            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 6,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Section: Title and Add Button
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Institutions',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    ActionButton(
                      label: 'add_new'.tr,
                      icon: CupertinoIcons.add,
                      backgroundColor: AppColor.typography,
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => Dialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Container(
                              width: 800,
                              padding: const EdgeInsets.all(24),
                              child: GetBuilder<ReportscontrollerImp>(
                                builder: (controller) {
                                  return SingleChildScrollView(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          'إضافة تقرير جديد'.tr,
                                          style: const TextStyle(
                                            fontSize: 22,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 20),
                                        Container(
                                          margin: const EdgeInsets.symmetric(
                                            horizontal: 30,
                                          ),
                                          height: 250,
                                          width: 300,
                                          decoration: BoxDecoration(
                                            color: AppColor.white,
                                            borderRadius: BorderRadius.circular(
                                              10,
                                            ),
                                            border: Border.all(width: 2),
                                          ),
                                          child: controller.file == null
                                              ? MaterialButton(
                                                  onPressed: () {
                                                    controller
                                                        .uploadimagefile();
                                                  },
                                                  child: Text("اضافة صورة".tr),
                                                )
                                              : Stack(
                                                  children: [
                                                    Center(
                                                      child: SizedBox(
                                                        height: 120,
                                                        child: ClipRRect(
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                10,
                                                              ),
                                                          child: Image.file(
                                                            controller.file!,
                                                            fit: BoxFit.cover,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Positioned(
                                                      bottom: 5,
                                                      right: 5,
                                                      child: IconButton(
                                                        icon: const Icon(
                                                          Icons.edit,
                                                          color: Colors.white,
                                                        ),
                                                        onPressed: () {
                                                          controller
                                                              .uploadimagefile();
                                                        },
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                        ),

                                        const SizedBox(height: 20),

                                        Row(
                                          children: [
                                            Expanded(
                                              child: CustemtextfromfildInfoUser(
                                                // myController: controller.,
                                                label: 'title_ar'.tr,
                                                hintText: 'title_hint'.tr,
                                              ),
                                            ),
                                            const SizedBox(width: 15),
                                            Expanded(
                                              child: CustemtextfromfildInfoUser(
                                                // myController: controller.namefr,
                                                label: 'title_fr'.tr,
                                                hintText: 'title_hint'.tr,
                                              ),
                                            ),
                                          ],
                                        ),

                                        const SizedBox(height: 15),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: CustemtextfromfildInfoUser(
                                                maxLines: 3,
                                                // myController: controller.namear,
                                                label:
                                                    'الحتوى بالغة العربية'.tr,
                                                hintText: 'أدخل المحتوى هنا'.tr,
                                              ),
                                            ),
                                            const SizedBox(width: 15),
                                            Expanded(
                                              child: CustemtextfromfildInfoUser(
                                                maxLines: 3,
                                                // myController: controller.namefr,
                                                label:
                                                    'الحتوى بالغة الفرنسية'.tr,
                                                hintText: 'أدخل المحتوى هنا'.tr,
                                              ),
                                            ),
                                          ],
                                        ),

                                        // الصف الثالث: التبعيات
                                        const SizedBox(height: 30),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            TextButton(
                                              onPressed: () => Get.back(),
                                              child: Text(
                                                'cancel'.tr,
                                                style: const TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 16,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 15),
                                            ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: const Color(
                                                  0xFF6269F2,
                                                ),
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 30,
                                                      vertical: 12,
                                                    ),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                              ),
                                              onPressed: () {},
                                              child: Text(
                                                'save'.tr,
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 16,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,

                  children: [
                    SizedBox(
                      width: 260,
                      child: SearchField(
                        hint: 'search'.tr,
                        onChanged: (value) {},
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Grid of Agent Cards
                Expanded(
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 20,
                          mainAxisSpacing: 20,
                          childAspectRatio: 0.75,
                        ),
                    itemCount: 6,
                    itemBuilder: (context, index) {
                      return ReportPostCard(
                        title: controller.reportsData[index]['title']!,
                        description:
                            controller.reportsData[index]['description']!,
                        imageUrl: Appimageassets.one,
                        createdAt: controller.reportsData[index]['created_at']!,
                        onEdit: () {},
                        onDelete: () {},
                        onShwo: () {
                          showReportDialog(
                            context: context,
                            title: controller.reportsData[index]['title']!,
                            description:
                                controller.reportsData[index]['description']!,
                            imageUrl: Appimageassets.one,
                            createdAt: '2026-01-05',
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void showReportDialog({
    required BuildContext context,
    required String title,
    required String description,
    required String imageUrl,
    required String createdAt,
  }) {
    showDialog(
      context: context,
      builder: (_) {
        return Dialog(
          insetPadding: const EdgeInsets.all(20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 600),
              child: ReportPostDialogContent(
                title: title,
                description: description,
                imageUrl: imageUrl,
                createdAt: createdAt,
              ),
            ),
          ),
        );
      },
    );
  }
}
