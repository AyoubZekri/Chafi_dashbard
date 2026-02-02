import 'package:chafi_dashboard/controller/Different/EditDifferentController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/class/Statusrequest.dart';
import '../../../core/constant/Colorapp.dart';
import '../../Widget/TextFild/DropdownFild.dart';
import '../../Widget/TextFild/LabeledTextField.dart';
import '../../Widget/institutions/ToggleRow.dart';

class Editdifferent extends StatefulWidget {
  const Editdifferent({super.key});

  @override
  State<Editdifferent> createState() => _EditdifferentState();
}

class _EditdifferentState extends State<Editdifferent> {
  @override
  Widget build(BuildContext context) {
    Get.create(() => EditdifferentcontrollerImp());
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 243, 243, 243),
      body: GetBuilder<EditdifferentcontrollerImp>(
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
                      "edit_different_article".tr,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppColor.black,
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  Row(
                    children: [
                      Expanded(
                        child: CustemtextfromfildInfoUser(
                          myController: controller.titlear,
                          label: "title_ar".tr,
                          hintText: "title_hint".tr,
                        ),
                      ),
                      SizedBox(width: 24),
                      Expanded(
                        child: CustemtextfromfildInfoUser(
                          myController: controller.titlefr,
                          label: "title_fr".tr,
                          hintText: "title_hint".tr,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: CustemtextfromfildInfoUser(
                          myController: controller.infoar,
                          label: "content_ar".tr,
                          hintText: "content_hint".tr,
                          maxLines: 5,
                        ),
                      ),
                      SizedBox(width: 20),
                      Expanded(
                        child: CustemtextfromfildInfoUser(
                          myController: controller.infofr,
                          label: "content_fr".tr,
                          hintText: "content_hint".tr,
                          maxLines: 5,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 64),
                  ToggleRow(
                    label: "calculator_toggle".tr,
                    value: controller.isCalculatorActive,
                    onChanged: (val) {
                      setState(() {
                        controller.isCalculatorActive = val;
                      });
                    },
                  ),
                  if (controller.isCalculatorActive)
                    Dropdownfild(
                      label: "calculator_label".tr,
                      hintText: "calculator_hint".tr,
                      items: controller.calcelators
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
                    label: "law_toggle".tr,
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
                            items: controller.data
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
                            myController: controller.numperindex,
                            label: "page_number".tr,
                            hintText: "page_number_hint".tr,
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
                        controller.editdata();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2D62ED),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child:controller.statusrequest ==
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
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
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
