import 'package:chafi_dashboard/controller/Different/AddDifferentController.dart';
import 'package:chafi_dashboard/controller/NavigationBarcontroller.dart';
import 'package:chafi_dashboard/core/constant/Colorapp.dart';
import 'package:chafi_dashboard/view/screen/Different/AddDifferent.dart';
import 'package:chafi_dashboard/view/screen/Different/EditDifferent.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/DifferentController.dart';
import '../Widget/Button/ActionButton.dart';
import '../Widget/Card/InstitutionsCard.dart';
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
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 20,
                          mainAxisSpacing: 20,
                          childAspectRatio: 0.55, // تناسب الطول مع العرض
                        ),
                    itemCount: 6,
                    itemBuilder: (context, index) => InstitutionsCard(
                      onEdit: () {
                        Get.find<NavigationBarcontrollerImp>().changeSubPage(
                          99,
                          () => Editdifferent(),
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
