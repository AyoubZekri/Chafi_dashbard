import 'dart:ui';

import 'package:chafi_dashboard/controller/NavigationBarcontroller.dart';
import 'package:chafi_dashboard/controller/TaxCollection/AddTaxCollectionController.dart';
import 'package:chafi_dashboard/controller/TaxCollection/EditTaxCollectionController.dart';
import 'package:chafi_dashboard/core/constant/Colorapp.dart';
import 'package:chafi_dashboard/view/screen/TaxCollection/AddTaxCollection.dart';
import 'package:chafi_dashboard/view/screen/TaxCollection/EditTaxCollection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controller/TaxCollection/RealSytemController.dart';
import '../../../core/class/handlingview.dart';
import '../../../core/functions/Dealog.dart';
import '../../Widget/Button/ActionButton.dart';
import '../../Widget/Card/InstitutionsCard.dart';
import '../../Widget/Tax/TaxDealoge.dart';
import '../../Widget/TextFild/CustemDropDownField.dart';
import '../../Widget/TextFild/SearchFild.dart';

class Realsystem extends StatefulWidget {
  const Realsystem({super.key});

  @override
  State<Realsystem> createState() => _RealsystemState();
}

class _RealsystemState extends State<Realsystem> {
  @override
  Widget build(BuildContext context) {
    Get.create(() => RealsystemcontrollerImp());
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 243, 243, 243),
      body: GetBuilder<RealsystemcontrollerImp>(
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
                // Header Section: Title and Add Button
                Container(
                  alignment: Alignment.centerLeft,
                  child: ActionButton(
                    label: "add_new".tr,
                    icon: CupertinoIcons.add,
                    backgroundColor: AppColor.typography,
                    onPressed: () {
                      // Get.create(() => AddinstitutionscontrollerImp());
                      final controller = Get.put(
                        AddtaxcollectioncontrollerImp(),
                      );
                      controller.type = 2;
                      controller.viewdataCategory();

                      Get.find<NavigationBarcontrollerImp>().changeSubPage(
                        99,
                        () => const Addtaxcollection(),
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
                        alignment: isMobile
                            ? WrapAlignment.center
                            : WrapAlignment.spaceBetween,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        runSpacing: 16,
                        spacing: 16,
                        children: [
                          SizedBox(
                            width: isMobile ? constraints.maxWidth - 20 : 260,
                            child: SearchField(
                              Mycontroller: controller.searchController,
                              onChanged: (value) {
                                controller.search(value);
                              },
                              hint: "search".tr,
                            ),
                          ),

                          SizedBox(
                            width: isMobile ? constraints.maxWidth : 280,
                            child: CustemDropDownField(
                              items: controller.dataCategory
                                  .map(
                                    (f) => DropdownMenuItem<int>(
                                      value: f.id,
                                      child: Text(
                                        f.localizedName.toString().tr,
                                        style: const TextStyle(fontSize: 14),
                                      ),
                                    ),
                                  )
                                  .toList(),
                              value: controller.selectedFilter,
                              onChanged: (value) {
                                setState(() {
                                  controller.selectedFilter = value!;
                                  controller.viewdata();
                                });
                              },
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
                              childAspectRatio: 1.2,
                            ),
                        itemCount: controller.filteredData.length,
                        itemBuilder: (context, index) {
                          final item = controller.filteredData[index];
                          return InstitutionsCard(
                            onView: () {
                              showReportDialog(
                                context: context,
                                title: controller.currentLang == "ar"
                                    ? item.title
                                    : item.titleFr,
                                description: controller.currentLang == "ar"
                                    ? item.body
                                    : item.bodyFr,
                                imageUrl: "",
                                createdAt: item.updatedAt.toString().substring(
                                  0,
                                  10,
                                ),
                              );
                            },

                            onEdit: () {
                              Get.delete<EditTaxCollectionControllerImp>();
                              final controller = Get.put(
                                EditTaxCollectionControllerImp(),
                              );

                              controller.type = 0;
                              controller.viewdataCategory();
                              controller.fillDataFromModel(item);

                              Get.find<NavigationBarcontrollerImp>()
                                  .changeSubPage(99, () => Edittaxcollection());
                            },
                            onDelete: () async {
                              await showCustomConfirmationDialog(
                                context,
                                title: "تنبيه".tr,
                                message: "هل أنت متأكد من الحذف؟".tr,
                                onConfirmAction: () {
                                  controller.deletdata(item.id);
                                },
                              );
                            },
                            onEditindex: () {
                              controller.setIndexData(item);
                              showDialog(
                                context: context,
                                builder: (_) => CustemiRealTaxdealog(
                                  controller: controller,
                                  taxandappmodel: item,
                                ),
                              );
                            },
                            title: controller.currentLang == "ar"
                                ? item.title
                                : item.titleFr,
                            info: controller.currentLang == "ar"
                                ? item.body
                                : item.bodyFr,
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
