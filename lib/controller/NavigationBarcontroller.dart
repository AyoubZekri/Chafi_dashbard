import 'package:chafi_dashboard/core/constant/routes.dart';
import 'package:chafi_dashboard/view/screen/Regulated.dart';
import 'package:chafi_dashboard/view/screen/TaxCollection/RealSystem.dart';
import 'package:chafi_dashboard/view/screen/application/JoiningCategoriesApp.dart';
import 'package:chafi_dashboard/view/screen/application/PartialSystemapp.dart';
import 'package:chafi_dashboard/view/screen/application/SimplifiedSystemapp.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../core/class/Statusrequest.dart';
import '../core/functions/Snacpar copy.dart';
import '../core/functions/handlingdatacontroller.dart';
import '../core/services/Services.dart';
import '../data/datasource/Remote/AuthData.dart';
import '../view/screen/Activities.dart';
import '../view/screen/AppointmentsCommitments.dart';
import '../view/screen/CommonQuestions.dart';
import '../view/screen/Exclusive.dart';
import '../view/screen/ExternalLinks.dart';
import '../view/screen/Home.dart';
import '../view/screen/Institutions.dart';
import '../view/screen/Law.dart';
import '../view/screen/NatureOfTheActivity.dart';
import '../view/screen/Notification.dart';
import '../view/screen/Reports.dart';
import '../view/screen/TaxCollection/JoiningCategories.dart';
import '../view/screen/TaxCollection/PartialSystem.dart';
import '../view/screen/TaxCollection/SimplifiedSystem.dart';
import '../view/screen/Users.dart';
import '../view/screen/application/RealSystemapp.dart';
import '../view/screen/bonuses_and_compensations.dart';
import '../view/screen/different.dart';

abstract class NavigationBarcontroller extends GetxController {
  // ignore: non_constant_identifier_names
  changePage(int currentpage);
}

class NavigationBarcontrollerImp extends GetxController {
  late TextEditingController email;
  late TextEditingController password;
  late TextEditingController confirmPassword;

  bool issobscureText = true;
  bool issobscureText2 = true;
  RxInt currentPage = 0.obs;
  RxnInt expandedIndex = RxnInt();
  RxnInt currentSubIndex = RxnInt();
  Rx<Widget Function()?> currentSubPage = Rx<Widget Function()?>(null);
  Authdata authdata = Authdata(Get.find());
  Myservices myServices = Get.find();

  String? get name => myServices.sharedPreferences!.getString("username");
  String? get emailofuser => myServices.sharedPreferences!.getString("email");

  final List<Map<String, dynamic>> screens = [
    {
      'name': 'nav_home',
      'icon': Icons.dashboard,
      'route': Approutes.nav_home,
      'page': () => DashboardHome(),
      'subPages': [],
    },
    {
      'name': 'Users',
      'icon': Icons.people,
      'page': () => Users(),
      'subPages': [],
    },

    {
      'name': 'طبيعة النشاط',
      'icon': Icons.nature_people,
      'route': Approutes.natureoftheactivity,
      'page': () => Natureoftheactivity(),
      'subPages': [],
    },

    {
      'name': 'النشاطات',
      'icon': Icons.work_outline,
      'route': Approutes.activities,

      'page': () => Activities(),
      'subPages': [],
    },

    {
      'name': 'العلوات والتعويضات',
      'icon': Icons.account_balance_wallet,
      'route': Approutes.activities,
      'page': () => BonusesAndCompensations(),
      'subPages': [],
    },
    {
      'name': 'nav_institutions',
      'icon': Icons.apartment,
      'route': Approutes.institutions,

      'page': "",
      'subPages': [
        {
          'name': 'nav_institutions',
          'route': Approutes.institutions,
          'icon': Icons.business,
          'page': () => Institutions(),
        },
        {
          'name': "nav_regulated",
          'route': Approutes.regulated,
          'icon': Icons.verified_outlined,
          'page': () => Regulated(),
        },
      ],
    },

    {
      'name': 'الأنظمة الجبائية',
      'icon': Icons.account_balance,
      'route': Approutes.joiningCategories,
      'page': "",
      'subPages': [
        {
          'name': 'فئات',
          'icon': Icons.category,
          'route': Approutes.joiningCategories,

          'page': () => Joiningcategories(),
        },
        {
          'name': 'النضام الجزافي',
          'route': Approutes.partialSystem,
          'icon': Icons.payments_outlined,
          'page': () => Partialsystem(),
        },
        {
          'name': 'النضام المبسط',
          'route': Approutes.simplifiedSystem,
          'icon': Icons.rule_folder_outlined,
          'page': () => Simplifiedsystem(),
        },
        {
          'name': 'النضام الحقيقي',
          'icon': Icons.analytics_outlined,
          'route': Approutes.realSystem,

          'page': () => Realsystem(),
        },
      ],
    },

    {
      'name': 'التطبيقات',
      'icon': Icons.apps,
      'route': Approutes.joiningCategoriesApp,

      'page': "",
      'subPages': [
        {
          'name': 'فئات',
          'icon': Icons.category_outlined,
          'route': Approutes.joiningCategoriesApp,
          'page': () => Joiningcategoriesapp(),
        },
        {
          'name': 'النضام الجزافي',
          'route': Approutes.partialSystemApp,

          'icon': Icons.request_quote_outlined,
          'page': () => Partialsystemapp(),
        },
        {
          'name': 'النضام المبسط',
          'route': Approutes.simplifiedSystemApp,

          'icon': Icons.tune_outlined,
          'page': () => Simplifiedsystemapp(),
        },
        {
          'name': 'النضام الحقيقي',
          'route': Approutes.realSystemApp,

          'icon': Icons.insights_outlined,
          'page': () => Realsystemapp(),
        },
      ],
    },

    {
      'name': "nav_different",
      'icon': Icons.extension_outlined,
      'route': Approutes.different,
      'page': () => Different(),
      'subPages': [],
    },

    {
      'name': "nav_appointments",
      'icon': Icons.event_note,
      'route': Approutes.appointments,

      'page': () => Appointmentscommitments(),
      'subPages': [],
    },

    {
      'name': "nav_faq",
      'icon': Icons.help_outline,
      'route': Approutes.faq,
      'page': () => Commonquestions(),
      'subPages': [],
    },

    {
      'name': "external_links",
      'icon': Icons.link_outlined,
      'route': Approutes.externalLinks,
      'page': () => Externallinks(),
      'subPages': [],
    },

    {
      'name': "قوانين",
      'icon': Icons.gavel_outlined,
      'route': Approutes.law,

      'page': () => Law(),
      'subPages': [],
    },

    {
      'name': "الإشعارات",
      'route': Approutes.notification,
      'icon': Icons.notifications_active_outlined,
      'page': () => NotificationBar(),
      'subPages': [],
    },

    {
      'name': "التقارير",
      'icon': Icons.description_outlined,
      'page': () => Reports(),
      'subPages': [],
    },

    {
      'name': "الحصري",
      'icon': Icons.star_outline,
      'page': () => Exclusive(),
      'subPages': [],
    },
  ];
  void changePage(int index) {
    currentPage.value = index;
    currentSubIndex.value = null;
    currentSubPage.value = null;
    update();
  }

  void toggleExpand(int index) {
    expandedIndex.value = expandedIndex.value == index ? null : index;
  }

  void changeSubPage(int subIndex, Widget Function() page) {
    currentSubIndex.value = subIndex;
    currentSubPage.value = page;
  }

  void showPassword() {
    issobscureText = issobscureText == true ? false : true;
    update();
  }

  void showPassword2() {
    issobscureText2 = issobscureText2 == true ? false : true;
    update();
  }

  void reset() async {
    Statusrequest statusrequest = Statusrequest.loadeng;
    update();
    var response = await authdata.resetPassword({
      "password": password.text,
      "email": email.text,
      "password_confirmation": confirmPassword.text,
    });
    if (response == Statusrequest.serverfailure) {
      return showSnackbar("خطأ", "لا يوجد اتصال بالإنترنت", Colors.red);
    }
    print("Response: $response");
    statusrequest = handlingData(response);
    if (Statusrequest.success == statusrequest) {
      if (response["status"] == 1) {
        Get.back();
      } else {
        showSnackbar("خطأ", "حدث خطأ ما", Colors.orange);
        statusrequest = Statusrequest.failure;
      }
    } else {
      showSnackbar("خطأ", "حدث خطأ ما", Colors.orange);
    }
    update();
  }

  logout() async {

    Statusrequest statusrequest = Statusrequest.loadeng;
    update();
    var response = await authdata.logout();

    statusrequest = handlingData(response);
    print("=============================== Controller $response ");
    if (statusrequest == Statusrequest.success) {
      if (response["status"] == 1) {
        myServices.sharedPreferences!.clear();
        Get.offNamed(Approutes.login);
      }
    } else {}
    update();
  }

  @override
  void onInit() {
    email = TextEditingController();
    password = TextEditingController();
    confirmPassword = TextEditingController();
    super.onInit();
  }
}
