import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../constant/routes.dart';
import '../services/Services.dart';

class Mymiddleware extends GetMiddleware {
  @override
  int? get priority => 1;

  final Myservices myServices = Get.find();

  @override
  RouteSettings? redirect(String? route) {
    final token = myServices.sharedPreferences?.getString("token");

    if (token == null || token.isEmpty) {
      return const RouteSettings(name: Approutes.login);
    } else {
      return const RouteSettings(name: Approutes.sidbar);
    }
  }
}
