import 'package:chafi_dashboard/controller/application/AddAppController.dart';
import 'package:chafi_dashboard/core/constant/Colorapp.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/functions/valiedinput.dart';
import '../../Widget/TextFild/DropdownFild.dart';
import '../../Widget/TextFild/LabeledTextField.dart';
import '../../Widget/institutions/ToggleRow.dart';

class Addapp extends StatefulWidget {
  const Addapp({super.key});

  @override
  State<Addapp> createState() => _AddappState();
}

class _AddappState extends State<Addapp> {
  @override
  Widget build(BuildContext context) {
    Get.find<AddappcontrollerImp>();
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 243, 243, 243),
      body: GetBuilder<AddappcontrollerImp>(
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
              child: Form(
                key: controller.formState,
                child: Column(
                  children: [
                    Center(
                      child: Text(
                        "إضافة مقال جديد".tr,
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
                            myController: controller.titlear,
                            label: "title_ar".tr,
                            hintText: "أدخل العنوان هنا...".tr,
                            valid: (val) => validateInput(val!, 1, 100, "text"),
                          ),
                        ),
                        SizedBox(width: 24),
                        Expanded(
                          child: CustemtextfromfildInfoUser(
                            myController: controller.titlefr,
                            label: "title_fr".tr,
                            hintText: "أدخل العنوان هنا...".tr,
                            valid: (val) => validateInput(val!, 1, 100, "text"),
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
                            myController: controller.infoar,
                            label: "content_ar".tr,
                            hintText: "اكتب المحتوى هنا...".tr,
                            maxLines: 5,
                            valid: (val) => validateInput(val!, 1, 1000, "text"),
                          ),
                        ),
                        SizedBox(width: 20),
                        Expanded(
                          child: CustemtextfromfildInfoUser(
                            myController: controller.infofr,
                            label: "content_fr".tr,
                            hintText: "اكتب المحتوى هنا...".tr,
                            maxLines: 5,
                            valid: (val) => validateInput(val!, 1, 1000, "text"),
                          ),
                        ),
                      ],
                    ),
                    if (controller.type != null) const SizedBox(height: 20),
                    if (controller.type != null)
                      Dropdownfild(
                        label: "الفئة".tr,
                        hintText: "إختر الفئة".tr,
                        items: controller.category
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
                        value: controller.selectedCategory,
                        onChanged: (val) {
                          setState(() {
                            controller.selectedCategory = val;
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
                              items: controller.datalaw
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
                              hintText: "أدخل رقم الصفحة...".tr,
                              valid: (val) =>
                                  validateInput(val!, 1, 10, "number"),
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
                          controller.adddata();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2D62ED),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          "save".tr,
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
