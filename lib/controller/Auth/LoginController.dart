import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/class/Statusrequest.dart';
import '../../core/constant/routes.dart';
import '../../core/functions/Snacpar copy.dart';
import '../../core/functions/handlingdatacontroller.dart';
import '../../core/services/Services.dart';
import '../../data/datasource/Remote/AuthData.dart';

class Logincontroller extends GetxController {
  GlobalKey<FormState> formstate = GlobalKey<FormState>();
  late TextEditingController email;
  late TextEditingController password;
  bool issobscureText = true;
  void showPassword() {
    issobscureText = issobscureText == true ? false : true;
    update();
  }

  Authdata authdata = Authdata(Get.find());
  Myservices myServices = Get.find();

  Login() async {
    // var formData = formstate.currentState;
    if (!formstate.currentState!.validate()) return;
    Statusrequest statusrequest = Statusrequest.loadeng;
    update();
    var response = await authdata.logen({
      "email": email.text,
      "password": password.text,
    });
    if (response == Statusrequest.serverfailure) {
     return showSnackbar("خطأ".tr, "لا يوجد اتصال بالإنترنت".tr, Colors.red);
    }
    print("Response: $response");
    statusrequest = handlingData(response);
    print("=============================== Controller $response ");
    if (statusrequest == Statusrequest.success) {
      if (response["status"] == 1) {
        myServices.sharedPreferences!.setInt(
          "id",
          response['data']["user"]['id'],
        );
        myServices.sharedPreferences!.setString(
          "email",
          response['data']["user"]["email"],
        );
        myServices.sharedPreferences!.setString(
          "username",
          response["data"]["user"]["username"],
        );
        myServices.sharedPreferences!.setInt(
          "user_notify_status",
          response["data"]["user"]["notification_status"],
        );

        myServices.sharedPreferences!.setString(
          "token",
          response["data"]["token"],
        );
        Get.offNamed(Approutes.sidbar);
      }
    } else {
      showSnackbar(
        "خطأ".tr,
        "البريد الإلكتروني أو كلمة المرور خاطئة".tr,
        Colors.orange,
      );
    }
    update();
  }

  GoToSignUp() {
    Get.offNamed(Approutes.signup);
  }

  GoToForgenPassword() {
    Get.toNamed(Approutes.forgenPassword);
  }

  @override
  void onInit() {
    // FirebaseMessaging.instance.getToken().then((value) {
    //   String? token = value;
    //   print("token:$token");
    // });

    email = TextEditingController();
    password = TextEditingController();
    super.onInit();
  }

  @override
  void dispose() {
    email.dispose();
    password.dispose();
    super.dispose();
  }
}
