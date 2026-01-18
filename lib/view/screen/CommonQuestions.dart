import 'package:chafi_dashboard/controller/NavigationBarcontroller.dart';
import 'package:chafi_dashboard/core/constant/Colorapp.dart';
import 'package:chafi_dashboard/view/screen/institutions/EditInstitutions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/CommonquestionsController.dart';
import '../Widget/Button/ActionButton.dart';
import '../Widget/Card/InstitutionsCard.dart';
import '../Widget/TextFild/LabeledTextField.dart';
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
                        builder: (context) => Dialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Container(
                            width: 800,
                            padding: const EdgeInsets.all(24),
                            child: SingleChildScrollView(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'new_question'.tr,
                                    style: const TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 20),

                                  // الصف الأول: الأسئلة
                                  Row(
                                    children: [
                                      Expanded(
                                        child: CustemtextfromfildInfoUser(
                                          label: 'question_ar'.tr,
                                          hintText: 'question_hint_ar'.tr,
                                        ),
                                      ),
                                      const SizedBox(width: 15),
                                      Expanded(
                                        child: CustemtextfromfildInfoUser(
                                          label: 'question_fr'.tr,
                                          hintText: 'question_hint_fr'.tr,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 15),

                                  // الصف الثاني: الأجوبة
                                  Row(
                                    children: [
                                      Expanded(
                                        child: CustemtextfromfildInfoUser(
                                          label: 'answer_ar'.tr,
                                          hintText: 'answer_hint_ar'.tr,
                                          maxLines: 4,
                                        ),
                                      ),
                                      const SizedBox(width: 15),
                                      Expanded(
                                        child: CustemtextfromfildInfoUser(
                                          label: 'answer_fr'.tr,
                                          hintText: 'answer_hint_fr'.tr,
                                          maxLines: 4,
                                        ),
                                      ),
                                    ],
                                  ),

                                  const SizedBox(height: 30),

                                  // أزرار التحكم
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      TextButton(
                                        onPressed: () => Get.back(),
                                        child: Text(
                                          'cancel'.tr,
                                          style: const TextStyle(
                                            color: Colors.grey,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 15),
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              const Color(0xFF6269F2),
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 30,
                                            vertical: 12,
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                        ),
                                        onPressed: () {},
                                        child: Text(
                                          'add'.tr,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
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
                      child: SearchField(onChanged: (value) {},hint: "search".tr,),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Grid of Question Cards
                Expanded(
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 20,
                      childAspectRatio: 0.8,
                    ),
                    itemCount: 6,
                    itemBuilder: (context, index) => InstitutionsCard(
                      buttomcare: false,
                      onEdit: () {
                        Get.find<NavigationBarcontrollerImp>().changeSubPage(
                          99,
                          () => const Editinstitutions(),
                        );
                      },
                      title:
                          "1_كيف تُحتسب الجباية السنوية للمؤسسات:",
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
