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
                          builder: (context) => PostImgDialog(
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
                  child: Handlingview(
                    statusrequest: controller.statusrequest,
                    widget: GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
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
                                controller.deletdata(controller.data[index].id);
                              },
                            );
                          },
                        );
                      },
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
