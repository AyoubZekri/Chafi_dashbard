import 'dart:ui';

import 'package:chafi_dashboard/LinkApi.dart';
import 'package:chafi_dashboard/core/constant/Colorapp.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/Exclusivecontroller.dart';
import '../../core/class/handlingview.dart';
import '../../core/functions/Dealog.dart';
import '../Widget/Button/ActionButton.dart';
import '../Widget/Card/CustemPostExclusive.dart';
import '../Widget/Post/PostDealog.dart';
import '../Widget/TextFild/SearchFild.dart';

class Exclusive extends StatefulWidget {
  const Exclusive({super.key});

  @override
  State<Exclusive> createState() => _ExclusiveState();
}

class _ExclusiveState extends State<Exclusive> {
  @override
  Widget build(BuildContext context) {
    Get.create(() => Exclusivecontroller());
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 243, 243, 243),
      body: GetBuilder<Exclusivecontroller>(
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
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  alignment: Alignment.centerLeft,
                  child: ActionButton(
                    label: 'add_new'.tr,
                    icon: CupertinoIcons.add,
                    backgroundColor: AppColor.typography,
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => PostImgDialog(
                          mode: PostDialogMode.add,
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
                              hint: 'search'.tr,
                              onChanged: (value) {},
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                const SizedBox(height: 24),

                // Grid of Agent Cards
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
                                  childAspectRatio: 1.7,
                                ),
                            itemCount: controller.data.length,
                            itemBuilder: (context, index) {
                          return Custempostexclusive(
                            imageUrl:
                                "${Applink.image}${controller.data[index].image}",
                            onEdit: () {
                              controller.setEditData(controller.data[index]);

                              showDialog(
                                context: context,
                                builder: (context) => PostImgDialog(
                                  mode: PostDialogMode.edit,
                                  controller: controller,
                                  id: controller.data[index].id,
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
                                    controller.data[index].id,
                                  );
                                },
                              );
                            },
                          );
                        },
                      );
                    },
                  ),
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
