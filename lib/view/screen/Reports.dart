import 'package:chafi_dashboard/LinkApi.dart';
import 'package:chafi_dashboard/core/constant/Colorapp.dart';
import 'package:chafi_dashboard/view/Widget/Post/PostDealog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/ReportsController.dart';
import '../../core/functions/Dealog.dart';
import '../Widget/Button/ActionButton.dart';
import '../Widget/Card/CustemPost.dart';
import '../Widget/Card/CustemShwoDealog.dart';
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
                          builder: (context) => PostDialog(
                            mode: PostDialogMode.add,
                            controller: controller,
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
                          childAspectRatio: 0.65,
                        ),
                    itemCount: controller.filteredData.length,
                    itemBuilder: (context, index) {
                      return ReportPostCard(
                        title: controller.filteredData[index].localizedTitle,
                        description:
                            controller.filteredData[index].localizedBody,
                        imageUrl:
                            "${Applink.image}${controller.filteredData[index].image}",
                        createdAt: controller.filteredData[index].createdAt
                            .toString()
                            .substring(0, 10),
                        onEdit: () {
                          controller.setEditData(
                            controller.filteredData[index],
                          );

                          showDialog(
                            context: context,
                            builder: (context) => PostDialog(
                              mode: PostDialogMode.edit,
                              controller: controller,
                              id: controller.filteredData[index].id,
                            ),
                          );
                        },
                        onDelete: () async {
                          await showCustomConfirmationDialog(
                            context,
                            title: "تنبيه".tr,
                            message: "هل أنت متأكد من الحذف؟".tr,
                            onConfirmAction: () {
                              controller.deletdata(
                                controller.filteredData[index].id,
                              );
                            },
                          );
                        },
                        onShwo: () {
                          showReportDialog(
                            context: context,
                            title:
                                controller.filteredData[index].localizedTitle,
                            description:
                                controller.filteredData[index].localizedBody,
                            imageUrl:
                                "${Applink.image}${controller.filteredData[index].image}",
                            createdAt: controller.filteredData[index].createdAt
                                .toString()
                                .substring(0, 10),
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
