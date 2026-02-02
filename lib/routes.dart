import 'package:chafi_dashboard/core/constant/routes.dart';
import 'package:chafi_dashboard/view/screen/NavigationBar.dart';
import 'package:get/get.dart';

import 'view/screen/Auth/ForgenPassword.dart';
import 'view/screen/Auth/Login.dart';
import 'view/screen/Auth/Signup.dart';

import 'view/screen/Home.dart';
import 'view/screen/Institutions.dart';
import 'view/screen/Regulated.dart';
import 'view/screen/Activities.dart';
import 'view/screen/NatureOfTheActivity.dart';
import 'view/screen/AppointmentsCommitments.dart';
import 'view/screen/CommonQuestions.dart';
import 'view/screen/ExternalLinks.dart';
import 'view/screen/Law.dart';
import 'view/screen/Notification.dart';
import 'view/screen/Reports.dart';
import 'view/screen/Exclusive.dart';
import 'view/screen/TaxCollection/JoiningCategories.dart';
import 'view/screen/TaxCollection/PartialSystem.dart';
import 'view/screen/TaxCollection/SimplifiedSystem.dart';
import 'view/screen/TaxCollection/RealSystem.dart';
import 'view/screen/application/JoiningCategoriesApp.dart';
import 'view/screen/application/PartialSystemapp.dart';
import 'view/screen/application/SimplifiedSystemapp.dart';
import 'view/screen/application/RealSystemapp.dart';
import 'view/screen/different.dart';

List<GetPage<dynamic>> routes = [
  // Auth routes
  GetPage(name: "/", page: () => Login(), participatesInRootNavigator: true),
  GetPage(name: Approutes.login, page: () => Login()),
  GetPage(name: Approutes.signup, page: () => Signup()),
  GetPage(name: Approutes.forgenPassword, page: () => Forgenpassword()),

  // Main layout (Sidebar ثابت)
  GetPage(name: Approutes.sidbar, page: () => MainLayout()),

  // Dashboard pages
  GetPage(name: Approutes.nav_home, page: () => DashboardHome()),
  GetPage(name: Approutes.natureoftheactivity, page: () => Natureoftheactivity()),
  GetPage(name: Approutes.activities, page: () => Activities()),

  // Institutions
  GetPage(name: Approutes.institutions, page: () => Institutions()),
  GetPage(name: Approutes.regulated, page: () => Regulated()),

  // Tax collection
  GetPage(name: Approutes.joiningCategories, page: () => Joiningcategories()),
  GetPage(name: Approutes.partialSystem, page: () => Partialsystem()),
  GetPage(name: Approutes.simplifiedSystem, page: () => Simplifiedsystem()),
  GetPage(name: Approutes.realSystem, page: () => Realsystem()),

  // Applications
  GetPage(name: Approutes.joiningCategoriesApp, page: () => Joiningcategoriesapp()),
  GetPage(name: Approutes.partialSystemApp, page: () => Partialsystemapp()),
  GetPage(name: Approutes.simplifiedSystemApp, page: () => Simplifiedsystemapp()),
  GetPage(name: Approutes.realSystemApp, page: () => Realsystemapp()),

  // Other pages
  GetPage(name: Approutes.different, page: () => Different()),
  GetPage(name: Approutes.appointments, page: () => Appointmentscommitments()),
  GetPage(name: Approutes.faq, page: () => Commonquestions()),
  GetPage(name: Approutes.externalLinks, page: () => Externallinks()),
  GetPage(name: Approutes.law, page: () => Law()),
  GetPage(name: Approutes.notification, page: () => NotificationBar()),
  GetPage(name: Approutes.reports, page: () => Reports()),
  GetPage(name: Approutes.exclusive, page: () => Exclusive()),
];
