import 'package:chafi_dashboard/controller/NavigationBarcontroller.dart';
import 'package:chafi_dashboard/controller/TaxCollection/AddTaxCollectionController.dart';
import 'package:chafi_dashboard/controller/TaxCollection/EditTaxCollectionController.dart';
import 'package:chafi_dashboard/core/constant/Colorapp.dart';
import 'package:chafi_dashboard/view/screen/TaxCollection/AddTaxCollection.dart';
import 'package:chafi_dashboard/view/screen/TaxCollection/EditTaxCollection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controller/TaxCollection/PartialSystemController.dart';
import '../../../core/class/handlingview.dart';
import '../../../core/functions/Dealog.dart';
import '../../Widget/Button/ActionButton.dart';
import '../../Widget/Card/InstitutionsCard.dart';
import '../../Widget/Tax/TaxDealoge.dart';
import '../../Widget/TextFild/CustemDropDownField.dart';
import '../../Widget/TextFild/SearchFild.dart';

class Partialsystem extends StatefulWidget {
  const Partialsystem({super.key});

  @override
  State<Partialsystem> createState() => _PartialsystemState();
}

class _PartialsystemState extends State<Partialsystem> {
  @override
  Widget build(BuildContext context) {
    Get.create(() => PartialsystemcontrollerImp());
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 243, 243, 243),
      body: GetBuilder<PartialsystemcontrollerImp>(
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ActionButton(
                      label: "add_new".tr,
                      icon: CupertinoIcons.add,
                      backgroundColor: AppColor.typography,
                      onPressed: () {
                        // Get.create(() => AddinstitutionscontrollerImp());
                        final controller = Get.put(
                          AddtaxcollectioncontrollerImp(),
                        );
                        controller.type = 0;
                        Get.find<NavigationBarcontrollerImp>().changeSubPage(
                          99,
                          () => const Addtaxcollection(),
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
                        Mycontroller: controller.searchController,
                        onChanged: (value) {
                          controller.search(value);
                        },
                        hint: "search".tr,
                      ),
                    ),

                    const SizedBox(width: 12),

                    SizedBox(
                      width: 280,
                      child: CustemDropDownField(
                        items: controller.dataCategory
                            .map(
                              (f) => DropdownMenuItem<int>(
                                value: f.id,
                                child: Text(
                                  f.localizedName.toString(),
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
                            childAspectRatio: 0.6,
                          ),
                      itemCount: controller.filteredData.length,
                      itemBuilder: (context, index) {
                        final item = controller.filteredData[index];
                        return InstitutionsCard(
                          onEdit: () {
                            final controller = Get.put(
                              EditTaxCollectionControllerImp(),
                              permanent: true,
                            );
                            controller.fillDataFromModel(item);
                            controller.type = 0;

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
                              builder: (_) => CustemPartialTaxdealog(
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
