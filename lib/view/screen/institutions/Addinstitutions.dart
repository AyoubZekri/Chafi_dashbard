import 'package:chafi_dashboard/core/constant/Colorapp.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controller/Institutions/AddinstitutionsController.dart';
import '../../../core/class/Statusrequest.dart';
import '../../../core/functions/valiedinput.dart';
import '../../Widget/TextFild/DropdownFild.dart';
import '../../Widget/TextFild/LabeledTextField.dart';
import '../../Widget/institutions/ToggleRow.dart';

class Addinstitutions extends StatefulWidget {
  const Addinstitutions({super.key});

  @override
  State<Addinstitutions> createState() => _AddinstitutionsState();
}

class _AddinstitutionsState extends State<Addinstitutions> {
  @override
  Widget build(BuildContext context) {
    Get.find<AddinstitutionscontrollerImp>();
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 243, 243, 243),
      body: GetBuilder<AddinstitutionscontrollerImp>(
        builder: (controller) {
          return SingleChildScrollView(
            child: Form(
              key: controller.formState,
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
                        controller.type == 1
                            ? "add_new_institution_article".tr
                            : "add_new_regulated_article".tr,
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
                            hintText: "enter_title_here".tr,
                            valid: (val) {
                              return validateInput(val!, 2, 100, "text");
                            },
                          ),
                        ),
                        SizedBox(width: 24),
                        Expanded(
                          child: CustemtextfromfildInfoUser(
                            myController: controller.titlefr,
                            label: "title_fr".tr,
                            hintText: "enter_title_here".tr,
                            valid: (val) {
                              return validateInput(val!, 2, 100, "text");
                            },
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
                            hintText: "enter_content_here".tr,
                            maxLines: 5,
                            valid: (val) => validateInput(val!, 2, 1000, "text"),
                          ),
                        ),
                        SizedBox(width: 20),
                        Expanded(
                          child: CustemtextfromfildInfoUser(
                            myController: controller.infofr,
                            label: "content_fr".tr,
                            hintText: "enter_content_here".tr,
                            maxLines: 5,
                            valid: (val) => validateInput(val!, 2, 1000, "text"),
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
                                      f['label'].toString().tr,
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                  ),
                                )
                                .toList(),
                        value: controller.selectedinstitutions,
                        onChanged: (val) {
                          setState(() {
                            controller.selectedinstitutions = val;
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
                                  f['label'].toString().tr,
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
              
                    if (controller.isLawActive) ...[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "law_list".tr,
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          ElevatedButton.icon(
                            onPressed: () {
                              controller.addLaw();
                            },
                            icon: const Icon(Icons.add, color: Colors.white),
                            label: Text("add_law_button".tr,
                                style: const TextStyle(color: Colors.white)),
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      ...List.generate(controller.lawsList.length, (index) {
                        var lawItem = controller.lawsList[index];
                        return Container(
                          margin: const EdgeInsets.only(bottom: 16),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.grey.shade50,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "${"law_item_title".tr} ${index + 1}",
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                  IconButton(
                                    onPressed: () =>
                                        controller.removeLaw(index),
                                    icon: const Icon(Icons.delete,
                                        color: Colors.red),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    flex: 2,
                                    child: Dropdownfild(
                                      label: "select_law_label".tr,
                                      hintText: "law_hint".tr,
                                      items: controller.data
                                          .map(
                                            (f) => DropdownMenuItem<int>(
                                              value: f.id,
                                              child: Text(
                                                f.localizedName.toString(),
                                                style: const TextStyle(
                                                    fontSize: 14),
                                              ),
                                            ),
                                          )
                                          .toList(),
                                      value: lawItem['law_id'],
                                      onChanged: (val) {
                                        controller.updateLawId(index, val as int?);
                                      },
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    flex: 2,
                                    child: CustemtextfromfildInfoUser(
                                      label: "name_ar_input_label".tr,
                                      hintText: "enter_name_ar_hint".tr,
                                      myController: TextEditingController(
                                          text: lawItem['name_ar'])
                                        ..selection =
                                            TextSelection.fromPosition(
                                          TextPosition(
                                              offset:
                                                  lawItem['name_ar']?.length ??
                                                      0),
                                        ),
                                      onChanged: (val) =>
                                          controller.updateLawNameAr(index, val),
                                      valid: (val) =>
                                          validateInput(val!, 0, 200, "text"),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    flex: 2,
                                    child: CustemtextfromfildInfoUser(
                                      label: "name_fr_input_label".tr,
                                      hintText: "enter_name_fr_hint".tr,
                                      myController: TextEditingController(
                                          text: lawItem['name_fr'])
                                        ..selection =
                                            TextSelection.fromPosition(
                                          TextPosition(
                                              offset:
                                                  lawItem['name_fr']?.length ??
                                                      0),
                                        ),
                                      onChanged: (val) =>
                                          controller.updateLawNameFr(index, val),
                                      valid: (val) =>
                                          validateInput(val!, 0, 200, "text"),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    flex: 1,
                                    child: CustemtextfromfildInfoUser(
                                      label: "page_number".tr,
                                      hintText: "page_number_hint".tr,
                                      myController: TextEditingController(
                                          text: lawItem['index_link']
                                              ?.toString())
                                        ..selection =
                                            TextSelection.fromPosition(
                                          TextPosition(
                                              offset: lawItem['index_link']
                                                      ?.toString()
                                                      .length ??
                                                  0),
                                        ),
                                      onChanged: (val) =>
                                          controller.updateLawIndex(index, val),
                                      valid: (val) =>
                                          validateInput(val!, 0, 10, "number"),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      }),
                    ],
                
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
