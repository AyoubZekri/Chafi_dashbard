import 'package:chafi_dashboard/core/constant/routes.dart';
import 'package:chafi_dashboard/view/screen/NavigationBar.dart';
import 'package:get/get.dart';

import 'view/screen/Auth/ForgenPassword.dart';
import 'view/screen/Auth/Login.dart';
import 'view/screen/Auth/Signup.dart';

List<GetPage<dynamic>> routes = [
  GetPage(name: "/", page: () => Login(), participatesInRootNavigator: true),
  GetPage(name: Approutes.login, page: () => Login()),
  GetPage(name: Approutes.signup, page: () => Signup()),
  GetPage(name: Approutes.forgenPassword, page: () => Forgenpassword()),
  GetPage(name: Approutes.sidbar, page: () => MainLayout()),

];
