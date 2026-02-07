import 'package:chafi_dashboard/core/constant/Colorapp.dart';
import 'package:chafi_dashboard/core/constant/imageassets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controller/Auth/Forgenpasswordcontroller.dart';
import '../../../core/functions/valiedinput.dart';
import '../../Widget/TextFild/CustemTextFildAuth.dart';

class Forgenpassword extends StatefulWidget {
  const Forgenpassword({super.key});

  @override
  State<Forgenpassword> createState() => _ForgenpasswordState();
}

class _ForgenpasswordState extends State<Forgenpassword> {
  @override
  Widget build(BuildContext context) {
    Get.put(Forgenpasswordcontroller());
    return Scaffold(
      backgroundColor: const Color(0xFFF8F7FA),
      body: GetBuilder<Forgenpasswordcontroller>(
        builder: (controller) {
          return Stack(
            children: [
              SingleChildScrollView(
                child: Form(
                  key: controller.formstate,
                  child: Center(
                    child: Container(
                      width: 450,
                      padding: const EdgeInsets.all(40),
                      margin: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // الشعار (Logo)
                          Center(
                            child: Container(
                              height: 100,
                              width: 100,
                              decoration: const BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage(Appimageassets.logo),
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 30),

                          Text(
                            "لإعادة كلمة السر".tr,
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF5D596C),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            "يجب إدخال البريد الإلكتروني صحيح".tr,
                            style: TextStyle(
                              fontSize: 15,
                              color: Color(0xFF6F6B7D),
                            ),
                          ),
                          const SizedBox(height: 30),
                          Text(
                            "email_label".tr,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF5D596C),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Custemtextfildauth(
                            myController: controller.email,
                            hintText: "enter_email_here".tr,
                            iconData: Icons.email_outlined,
                            keyboardType: TextInputType.emailAddress,
                            valid: (val) =>
                                validateInput(val!, 0, 300, "email"),
                          ),
                          const SizedBox(height: 20),

                          Text(
                            "password_label".tr,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF5D596C),
                            ),
                          ),
                          SizedBox(height: 8),
                          Custemtextfildauth(
                            myController: controller.password,
                            hintText: "enter_password".tr,
                            obscureText: controller.issobscureText,
                            iconData: controller.issobscureText == true
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            onTap: () {
                              controller.showPassword();
                            },
                            valid: (val) => validateInput(val!, 6, 100, "text"),
                          ),
                          SizedBox(height: 20),
                          Text(
                            "تأكيد كلمة السر".tr,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF5D596C),
                            ),
                          ),
                          SizedBox(height: 8),
                          Custemtextfildauth(
                            myController: controller.confirmPassword,
                            hintText: "enter_password".tr,
                            obscureText: controller.issobscureText2,
                            iconData: controller.issobscureText2 == true
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            onTap: () {
                              controller.showPassword2();
                            },
                            valid: (val) => validateInput(val!, 6, 100, "text"),
                          ),

                          const SizedBox(height: 25),

                          SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColor.typography,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                elevation: 2,
                              ),
                              onPressed: () {
                                controller.reset();
                              },
                              child: Text(
                                "تاكيد".tr,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 20),

                          SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColor.typography,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                elevation: 2,
                              ),
                              onPressed: () {
                                controller.GoToBack();
                              },
                              child: Text(
                                "عودة".tr,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
               
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
