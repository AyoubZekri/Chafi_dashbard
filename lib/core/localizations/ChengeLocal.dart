import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../constant/Themdata.dart';
import '../services/Services.dart';

class LocalController extends GetxController {
  Locale? language;
  Myservices myservices = Get.put(Myservices());
  ThemeData themeData = themeAr;
  changeLang(String langcode) {
    Locale locale = Locale(langcode);
    myservices.sharedPreferences!.setString("lang", langcode);
    themeData = langcode == "ar" ? themeAr : themeEn;
    Get.updateLocale(locale);
  }

  @override
  void onInit() {
    String? sharedPreflang = myservices.sharedPreferences!.getString("lang");
    if (sharedPreflang == "ar") {
      language = const Locale("ar");
    } else if (sharedPreflang == "fr") {
      language = const Locale("fr");
    } else {
      language = const Locale("ar");
    }
    super.onInit();
  }
}
