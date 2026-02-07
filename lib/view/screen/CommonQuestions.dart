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
            padding: const EdgeInsets.all(24.0),
            margin: const EdgeInsets.all(24.0),
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

                // Search Field
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    SizedBox(
                      width: 260,
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
                const SizedBox(height: 24),

                // Grid of Question Cards
                Expanded(
                  child: Handlingview(
                    statusrequest: controller.statusrequest,
                    widget: GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 20,
                            mainAxisSpacing: 20,
                            childAspectRatio: 0.6,
                          ),
                      itemCount: controller.filteredData.length,
                      itemBuilder: (context, index) {
                        final item = controller.filteredData[index];
                        return InstitutionsCard(
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
                    ),
                    iconData: Icons.error,
                    title: "حدث خطأ أثناء تحميل البيانات",
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
