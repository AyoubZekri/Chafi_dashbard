import 'package:chafi_dashboard/controller/NavigationBarcontroller.dart';
import 'package:chafi_dashboard/controller/RegulatedController.dart';
import 'package:chafi_dashboard/core/constant/Colorapp.dart';
import 'package:chafi_dashboard/view/screen/institutions/EditInstitutions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/Institutions/AddinstitutionsController.dart';
import '../../controller/Institutions/EditinstitutionsController.dart';
import '../../controller/Institutionscontroller.dart';
import '../../core/class/handlingview.dart';
import '../../core/functions/Dealog.dart';
import '../Widget/Button/ActionButton.dart';
import '../Widget/Card/InstitutionsCard.dart';
import '../Widget/TextFild/CustemDropDownField.dart';
import '../Widget/TextFild/SearchFild.dart';
import '../Widget/institutions/CustemInstitutionDealog.dart';
import 'institutions/Addinstitutions.dart';

class Regulated extends StatefulWidget {
  const Regulated({super.key});

  @override
  State<Regulated> createState() => _RegulatedState();
}

class _RegulatedState extends State<Regulated> {
  @override
  Widget build(BuildContext context) {
    Get.create(() => RegulatedcontrollerImp());
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 243, 243, 243),
      body: GetBuilder<RegulatedcontrollerImp>(
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Institutions/',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Institutions',
                          style: TextStyle(color: Colors.grey, fontSize: 20),
                        ),
                      ],
                    ),
                    ActionButton(
                      label: 'add_new'.tr,
                      icon: CupertinoIcons.add,
                      backgroundColor: AppColor.typography,
                      onPressed: () {
                        final controller = Get.put(
                          AddinstitutionscontrollerImp(),
                        );

                        controller.type = 2;
                        Get.find<NavigationBarcontrollerImp>().changeSubPage(
                          99,
                          () => const Addinstitutions(),
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
                        items: controller.filters
                            .map(
                              (f) => DropdownMenuItem<int>(
                                value: f['key'] as int,
                                child: Text(
                                  f['label'].toString(),
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
                              EditinstitutionscontrollerImp(),
                              permanent: true,
                            );
                            controller.fillDataFromModel(item);
                            Get.find<NavigationBarcontrollerImp>()
                                .changeSubPage(99, () => Editinstitutions());
                          },
                          onDelete: () async {
                            await showCustomConfirmationDialog(
                              context,
                              title: "تنبيه",
                              message: "هل أنت متأكد من الحذف؟",
                              onConfirmAction: () {
                                Get.find<InstitutionscontrollerImp>().deletLaw(
                                  item.id,
                                );
                              },
                            );
                          },
                          onEditindex: () {
                            controller.setIndexData(item);
                            showDialog(
                              context: context,
                              builder: (_) => CustemRegulateddealog(
                                controller: controller,
                                law: item,
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
