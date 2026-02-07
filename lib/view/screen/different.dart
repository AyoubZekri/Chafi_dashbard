import 'package:chafi_dashboard/controller/Different/AddDifferentController.dart';
import 'package:chafi_dashboard/controller/Different/EditDifferentController.dart';
import 'package:chafi_dashboard/controller/NavigationBarcontroller.dart';
import 'package:chafi_dashboard/core/constant/Colorapp.dart';
import 'package:chafi_dashboard/view/screen/Different/AddDifferent.dart';
import 'package:chafi_dashboard/view/screen/Different/EditDifferent.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/DifferentController.dart';
import '../../core/class/handlingview.dart';
import '../../core/functions/Dealog.dart';
import '../Widget/Button/ActionButton.dart';
import '../Widget/Card/InstitutionsCard.dart';
import '../Widget/Differente/CustemDifferentedealog.dart';
import '../Widget/TextFild/SearchFild.dart';

class Different extends StatefulWidget {
  const Different({super.key});

  @override
  State<Different> createState() => _DifferentState();
}

class _DifferentState extends State<Different> {
  @override
  Widget build(BuildContext context) {
    Get.create(() => DifferentcontrollerImp());
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 243, 243, 243),
      body: GetBuilder<DifferentcontrollerImp>(
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
                        // Get.create(() => AddinstitutionscontrollerImp());
                        Get.put(AdddifferentcontrollerImp());

                        Get.find<NavigationBarcontrollerImp>().changeSubPage(
                          99,
                          () => const Adddifferent(),
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
                            childAspectRatio: 0.6,
                          ),
                      itemCount: controller.filteredData.length,
                      itemBuilder: (context, index) {
                        final item = controller.filteredData[index];
                        return InstitutionsCard(
                          onEdit: () {
                            final controller = Get.put(
                              EditdifferentcontrollerImp(),
                              permanent: true,
                            );
                            controller.fillDataFromModel(item);
                            Get.find<NavigationBarcontrollerImp>()
                                .changeSubPage(99, () => Editdifferent());
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
                              builder: (_) => Custemdifferentedealog(
                                controller: controller,
                                law: item,
                              ),
                            );
                          },
                          title:item.localizedName,
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
