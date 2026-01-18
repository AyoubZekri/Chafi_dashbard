import 'package:chafi_dashboard/core/constant/Colorapp.dart';
import 'package:chafi_dashboard/core/constant/imageassets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controller/Auth/LoginController.dart';
import '../../Widget/TextFild/CustemTextFildAuth.dart';

class Login extends StatelessWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(Logincontroller());
    return Scaffold(
      backgroundColor: const Color(0xFFF8F7FA),
      body: GetBuilder<Logincontroller>(
        builder: (controller) {
          return Stack(
            children: [
              SingleChildScrollView(
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
                          "welcome".tr,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF5D596C),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          "welcome_sub".tr,
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
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "password_label".tr,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF5D596C),
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                controller.GoToForgenPassword();
                              },
                              child: Text(
                                "forgot_password".tr,
                                style: TextStyle(
                                  color: AppColor.primarycolor,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          ],
                        ),
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
                              controller.login();
                            },
                            child: Text(
                              "sign_in".tr,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 25),

                        // إنشاء حساب جديد
                        Center(
                          child: Wrap(
                            children: [
                              Text(
                                "new_on_platform".tr,
                                style: TextStyle(
                                  color: Color(0xFF6F6B7D),
                                  fontSize: 16,
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  controller.GoToSignUp();
                                },
                                child: Text(
                                  "sign_up".tr,
                                  style: TextStyle(
                                    color: AppColor.primarycolor,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
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
