import 'package:chafi_dashboard/controller/NavigationBarcontroller.dart';
import 'package:chafi_dashboard/controller/RegulatedController.dart';
import 'package:chafi_dashboard/core/constant/Colorapp.dart';
import 'package:chafi_dashboard/view/screen/institutions/EditInstitutions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/Institutions/AddinstitutionsController.dart';
import '../Widget/Button/ActionButton.dart';
import '../Widget/Card/InstitutionsCard.dart';
import '../Widget/TextFild/CustemDropDownField.dart';
import '../Widget/TextFild/SearchFild.dart';
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
                // Header Section: Title and Add Button
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
                      child: SearchField(onChanged: (value) {},hint: "search".tr,),
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
                          });
                        },
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
                          childAspectRatio: 0.6, // تناسب الطول مع العرض
                        ),
                    itemCount: 6,
                    itemBuilder: (context, index) => InstitutionsCard(
                      onEdit: () {
                        Get.find<NavigationBarcontrollerImp>().changeSubPage(
                          99,
                          () => const Editinstitutions(),
                        );
                      },
                      title: "1_كيف تُحتسب الجباية السنوية للمؤسسات:",
                      info:
                          "تُعدّ الجباية السنوية من أهم الالتزامات التي يجب على كل مؤسسة احترامها، سواء كانت صغيرة، متوسطة، أو كبيرة. فهم طريقة حساب الجباية يجنّب المؤسسات الأخطاء والغرامات ويُساعدها على التخطيط المالي بشكل أفضل. في هذا المقال، نقدّم شرحًا مبسّطًا وواضحًا لكيفية احتساب الجباية السنوية وفق أهم المبادئ العامة.",
                      isActiveCalculator: true,
                      isActiveLaw: false,
                      creationDate: '',
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
