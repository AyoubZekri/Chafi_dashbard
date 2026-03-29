import 'dart:ui';

import 'package:chafi_dashboard/core/constant/Colorapp.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/CommonquestionsController.dart';
import '../../core/class/handlingview.dart';
import '../../core/functions/Dealog.dart';
import '../Widget/Button/ActionButton.dart';
import '../Widget/Card/InstitutionsCard.dart';
import '../Widget/Commonquestions/CommonquestionsDealog.dart';
import '../Widget/TextFild/SearchFild.dart';

class Commonquestions extends StatefulWidget {
  const Commonquestions({super.key});

  @override
  State<Commonquestions> createState() => _CommonquestionsState();
}

class _CommonquestionsState extends State<Commonquestions> {
  @override
  Widget build(BuildContext context) {
    Get.create(() => CommonquestionscontrollerImp());

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 243, 243, 243),
      body: GetBuilder<CommonquestionscontrollerImp>(
        builder: (controller) {
          return Container(
            padding: const EdgeInsets.all(16.0),
            margin: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Section: Title and Add Button
                Container(
                  alignment: Alignment.topLeft,
                  child: ActionButton(
                    label: 'add_new'.tr,
                    icon: CupertinoIcons.add,
                    backgroundColor: AppColor.typography,
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => Commonquestionsdealog(
                          mode: CommonquestionsdealogMode.add,
                          controller: controller,
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 20),

                LayoutBuilder(
                  builder: (context, constraints) {
                    bool isMobile = constraints.maxWidth < 600;
                    return SizedBox(
                      width: double.infinity,
                      child: Wrap(
                        alignment: WrapAlignment.center,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        runSpacing: 16,
                        spacing: 16,
                        children: [
                          SizedBox(
                            width: isMobile ? constraints.maxWidth : 260,
                            child: SearchField(
                              Mycontroller: controller.searchController,
                              onChanged: (value) {
                                controller.search(value);
                              },
                              hint: "search".tr,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                const SizedBox(height: 24),

                // Grid of Question Cards
                Expanded(
                  child: ScrollConfiguration(
                    behavior: const ScrollBehavior().copyWith(
                      scrollbars: true,
                      dragDevices: {
                        PointerDeviceKind.touch,
                        PointerDeviceKind.mouse, // هنا نضيف دعم الفأرة
                      },
                    ),
                    child: Handlingview(
                      statusrequest: controller.statusrequest,
                      widget: LayoutBuilder(
                        builder: (context, constraints) {
                          int crossAxisCount = 3;
                          if (constraints.maxWidth < 600) {
                            crossAxisCount = 1;
                          } else if (constraints.maxWidth < 900) {
                            crossAxisCount = 2;
                          }
                          return GridView.builder(
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: crossAxisCount,
                                  crossAxisSpacing: 20,
                                  mainAxisSpacing: 20,
                                  childAspectRatio: 1.25,
                                ),
                        itemCount: controller.filteredData.length,
                        itemBuilder: (context, index) {
                          final item = controller.filteredData[index];
                          return InstitutionsCard(
                            buttomcare: false,
                            onView: () {
                              showReportDialog(
                                context: context,
                                title: item.localizedName,
                                description: item.localizedBody,
                                imageUrl: "",
                                createdAt: item.updatedAt.toString().substring(
                                  0,
                                  10,
                                ),
                              );
                            },

                            onEdit: () {
                              controller.setEditData(item);
                              showDialog(
                                context: context,
                                builder: (context) => Commonquestionsdealog(
                                  mode: CommonquestionsdealogMode.edit,
                                  controller: controller,
                                  id: item.id,
                                ),
                              );
                            },
                            onDelete: () async {
                              await showCustomConfirmationDialog(
                                context,
                                title: "تنبيه".tr,
                                message: "هل أنت متأكد من الحذف؟".tr,
                                onConfirmAction: () {
                                  controller.deletLaw(item.id);
                                },
                              );
                            },
                            onEditindex: () {
                              controller.setIndexData(item);
                              showDialog(
                                context: context,
                                builder: (_) => AppointmentsIndexDialog(
                                  controller: controller,
                                  appointmentsmodel: item,
                                ),
                              );
                            },
                            title: item.localizedName,
                            info: item.localizedBody,
                            isActiveCalculator: item.calcul != null,
                            isActiveLaw: item.lawId != null,
                            creationDate: item.updatedAt.toString().substring(
                              0,
                              10,
                            ),
                          );
                        },
                      );
                    },
                  ),
                  iconData: Icons.error,
                      title: "حدث خطأ أثناء تحميل البيانات",
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
}
