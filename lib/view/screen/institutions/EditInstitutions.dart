import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controller/Institutions/EditinstitutionsController.dart';
import '../../../core/class/Statusrequest.dart';
import '../../../core/constant/Colorapp.dart';
import '../../Widget/TextFild/DropdownFild.dart';
import '../../Widget/TextFild/LabeledTextField.dart';
import '../../Widget/institutions/ToggleRow.dart';

class Editinstitutions extends StatefulWidget {
  const Editinstitutions({super.key});

  @override
  State<Editinstitutions> createState() => _EditinstitutionsState();
}

class _EditinstitutionsState extends State<Editinstitutions> {
  @override
  Widget build(BuildContext context) {
    Get.create(() => EditinstitutionscontrollerImp());
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 243, 243, 243),
      body: GetBuilder<EditinstitutionscontrollerImp>(
        builder: (controller) {
          return SingleChildScrollView(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 1000),
              margin: const EdgeInsets.all(24),
              padding: const EdgeInsets.all(24),
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
                children: [
                  Center(
                    child: Text(
                      "edit_article".tr,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppColor.black,
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),

                  // العنوان
                  Row(
                    children: [
                      Expanded(
                        child: CustemtextfromfildInfoUser(
                          myController: controller.titleAr,
                          label: "title_ar".tr,
                          hintText: "enter_title_here".tr,
                        ),
                      ),
                      SizedBox(width: 24),
                      Expanded(
                        child: CustemtextfromfildInfoUser(
                          myController: controller.titleFr,
                          label: "title_fr".tr,
                          hintText: "enter_title_here".tr,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // الموضوع
                  Row(
                    children: [
                      Expanded(
                        child: CustemtextfromfildInfoUser(
                          myController: controller.infoAr,
                          label: "content_ar".tr,
                          hintText: "enter_content_here".tr,
                          maxLines: 5,
                        ),
                      ),
                      SizedBox(width: 20),
                      Expanded(
                        child: CustemtextfromfildInfoUser(
                          myController: controller.infoFr,
                          label: "content_fr".tr,
                          hintText: "enter_content_here".tr,
                          maxLines: 5,
                        ),
                      ),
                    ],
                  ),
                  if (controller.type != null) const SizedBox(height: 20),
                  if (controller.type != null)
                    Dropdownfild(
                      label: controller.type == 1
                          ? "institution_type".tr
                          : "regulated_type".tr,
                      hintText: controller.type == 1
                          ? "institution_type".tr
                          : "regulated_type".tr,
                      items:
                          (controller.type == 1
                                  ? controller.institutions
                                  : controller.regulated)
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
                      value: controller.selectedInstitutions,
                      onChanged: (val) {
                        setState(() {
                          controller.selectedInstitutions = val;
                        });
                      },
                    ),

                  const SizedBox(height: 64),

                  // Toggle الحاسبة
                  ToggleRow(
                    label: "activate_calculator".tr,
                    value: controller.isCalculatorActive,
                    onChanged: (val) {
                      setState(() {
                        controller.isCalculatorActive = val;
                      });
                    },
                  ),

                  if (controller.isCalculatorActive)
                    Dropdownfild(
                      label: "choose_calculator".tr,
                      hintText: "choose_calculator".tr,
                      items: controller.calculators
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
                      value: controller.selectedCalculator,
                      onChanged: (val) {
                        setState(() {
                          controller.selectedCalculator = val;
                        });
                      },
                    ),

                  const SizedBox(height: 32),

                  ToggleRow(
                    label: "activate_law".tr,
                    value: controller.isLawActive,
                    onChanged: (val) {
                      setState(() {
                        controller.isLawActive = val;
                      });
                    },
                  ),

                  if (controller.isLawActive)
                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Dropdownfild(
                            label: "law_label".tr,
                            hintText: "law_hint".tr,
                            items: controller.laws
                                .map(
                                  (f) => DropdownMenuItem<int>(
                                    value: f.id,
                                    child: Text(
                                      f.name.toString(),
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                  ),
                                )
                                .toList(),
                            value: controller.selectedLaw,
                            onChanged: (val) {
                              setState(() {
                                controller.selectedLaw = val;
                              });
                            },
                          ),
                        ),
                        const SizedBox(width: 24),
                        Expanded(
                          flex: 1,
                          child: CustemtextfromfildInfoUser(
                            myController: controller.numPerIndex,
                            label: "page_number".tr,
                            hintText: "مثال: 145",
                          ),
                        ),
                      ],
                    ),

                  const SizedBox(height: 48),

                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: () {
                        controller.editData();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2D62ED),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child:controller.statusRequest ==
                              Statusrequest.loadeng
                          ? const SizedBox(
                              width: 15,
                              height: 15,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : Text(
                        "save".tr,
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
