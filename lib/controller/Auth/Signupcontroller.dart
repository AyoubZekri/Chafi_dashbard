import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/class/Statusrequest.dart';
import '../../core/constant/routes.dart';
import '../../core/functions/Snacpar copy.dart';
import '../../core/functions/handlingdatacontroller.dart';
import '../../core/services/Services.dart';
import '../../data/datasource/Remote/AuthData.dart';

class Signupcontroller extends GetxController {
  GlobalKey<FormState> formstate = GlobalKey<FormState>();
  late TextEditingController name;
  late TextEditingController email;
  late TextEditingController password;
  late TextEditingController confirmPassword;

  bool issobscureText = true;
  bool issobscureText2 = true;

  void showPassword() {
    issobscureText = issobscureText == true ? false : true;
    update();
  }

  void showPassword2() {
    issobscureText2 = issobscureText2 == true ? false : true;
    update();
  }

  Authdata authdata = Authdata(Get.find());
  Myservices myServices = Get.find();
  List data = [];

  GoToSignin() {
    Get.offNamed(Approutes.login);
  }

  void signUp() async {
    if (!formstate.currentState!.validate()) return;
    Statusrequest statusrequest = Statusrequest.loadeng;
    update();
    var response = await authdata.signin({
      "username": name.text,
      "password": password.text,
      "email": email.text,
      "password_confirmation": password.text,
    });
    if (response == Statusrequest.serverfailure) {
      return showSnackbar("خطأ".tr, "لا يوجد اتصال بالإنترنت".tr, Colors.red);
    }
    print("Response: $response");
    statusrequest = handlingData(response);
    if (Statusrequest.success == statusrequest) {
      if (response["status"] == 1) {
        myServices.sharedPreferences!.setInt(
          "id",
          response['data']["user"]['id'],
        );
        myServices.sharedPreferences!.setString(
          "email",
          response['data']["user"]['email'],
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
          response["data"]["user"]["token"],
        );

        Get.offNamed(Approutes.sidbar);
      } else {
        showSnackbar("خطأ".tr, "حدث خطأ ما".tr, Colors.orange);
        statusrequest = Statusrequest.failure;
      }
    } else {
      showSnackbar("خطأ".tr, "حدث خطأ ما".tr, Colors.orange);
    }
    update();
  }

  // GoToForgenPassword() {
  //   Get.offNamed(Approutes.forgenPassword);
  // }

  @override
  void onInit() {
    // FirebaseMessaging.instance.getToken().then((value) {
    //   String? token = value;
    //   print("token:$token");
    // });
    name = TextEditingController();
    email = TextEditingController();
    password = TextEditingController();
    confirmPassword = TextEditingController();

    super.onInit();
  }

  @override
  void dispose() {
    name.dispose();
    email.dispose();
    password.dispose();
    confirmPassword.dispose();
    super.dispose();
  }
}
