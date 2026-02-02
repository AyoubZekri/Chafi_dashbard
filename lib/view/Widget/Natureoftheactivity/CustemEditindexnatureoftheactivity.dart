import 'package:chafi_dashboard/controller/NatureoftheactivityController.dart';
import 'package:chafi_dashboard/data/model/NatureoftheactivityModel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/functions/valiedinput.dart';
import '../TextFild/LabeledTextField.dart';

class Custemeditindexnatureoftheactivity extends StatelessWidget {
  final Natureoftheactivitycontroller controller;
  final Natureoftheactivitymodel law;

  const Custemeditindexnatureoftheactivity({
    super.key,
    required this.controller,
    required this.law,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Container(
        width: 400,
        padding: const EdgeInsets.all(24),
        child: Form(
          key: controller.formState,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'تعديل الترتيب',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 20),

              CustemtextfromfildInfoUser(
                myController: controller.index,
                label: 'classement'.tr,
                hintText: 'classement'.tr,
                valid: (val) => validateInput(val!, 1, 6, "number"),
              ),

              const SizedBox(height: 25),

              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Get.back(),
                    child: Text(
                      'cancel'.tr,
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ),
                  const SizedBox(width: 15),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6269F2),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 25,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () {
                      controller.editindex(law.id);
                    },
                    child: Text(
                      'save'.tr,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
