import 'package:chafi_dashboard/view/screen/Regulated.dart';
import 'package:chafi_dashboard/view/screen/TaxCollection/RealSystem.dart';
import 'package:chafi_dashboard/view/screen/application/JoiningCategoriesApp.dart';
import 'package:chafi_dashboard/view/screen/application/PartialSystemapp.dart';
import 'package:chafi_dashboard/view/screen/application/SimplifiedSystemapp.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
import '../view/screen/application/RealSystemapp.dart';
import '../view/screen/different.dart';

abstract class NavigationBarcontroller extends GetxController {
  // ignore: non_constant_identifier_names
  changePage(int currentpage);
}

class NavigationBarcontrollerImp extends GetxController {
  RxInt currentPage = 0.obs;
  RxnInt expandedIndex = RxnInt();
  RxnInt currentSubIndex = RxnInt();
  Rx<Widget Function()?> currentSubPage = Rx<Widget Function()?>(null);

final List<Map<String, dynamic>> screens = [
  {
    'name': 'nav_home'.tr,
    'icon': Icons.dashboard,
    'page': () => DashboardHome(),
    'subPages': [],
  },

  {
    'name': 'طبيعة النشاط'.tr,
    'icon': Icons.nature_people,
    'page': () => Natureoftheactivity(),
    'subPages': [],
  },

  {
    'name': 'النشاطات'.tr,
    'icon': Icons.work_outline,
    'page': () => Activities(),
    'subPages': [],
  },

  {
    'name': 'nav_institutions'.tr,
    'icon': Icons.apartment,
    'page': "",
    'subPages': [
      {
        'name': 'nav_institutions'.tr,
        'icon': Icons.business,
        'page': () => Institutions(),
      },
      {
        'name': "nav_regulated".tr,
        'icon': Icons.verified_outlined,
        'page': () => Regulated(),
      },
    ],
  },

  {
    'name': 'الأنظمة الجبائية'.tr,
    'icon': Icons.account_balance,
    'page': "",
    'subPages': [
      {
        'name': 'فئات'.tr,
        'icon': Icons.category,
        'page': () => Joiningcategories(),
      },
      {
        'name': 'النضام الجزافي'.tr,
        'icon': Icons.payments_outlined,
        'page': () => Partialsystem(),
      },
      {
        'name': 'النضام المبسط'.tr,
        'icon': Icons.rule_folder_outlined,
        'page': () => Simplifiedsystem(),
      },
      {
        'name': 'النضام الحقيقي'.tr,
        'icon': Icons.analytics_outlined,
        'page': () => Realsystem(),
      },
    ],
  },

  {
    'name': 'التطبيقات'.tr,
    'icon': Icons.apps,
    'page': "",
    'subPages': [
      {
        'name': 'فئات'.tr,
        'icon': Icons.category_outlined,
        'page': () => Joiningcategoriesapp(),
      },
      {
        'name': 'النضام الجزافي'.tr,
        'icon': Icons.request_quote_outlined,
        'page': () => Partialsystemapp(),
      },
      {
        'name': 'النضام المبسط'.tr,
        'icon': Icons.tune_outlined,
        'page': () => Simplifiedsystemapp(),
      },
      {
        'name': 'النضام الحقيقي'.tr,
        'icon': Icons.insights_outlined,
        'page': () => Realsystemapp(),
      },
    ],
  },

  {
    'name': "nav_different".tr,
    'icon': Icons.extension_outlined,
    'page': () => Different(),
    'subPages': [],
  },

  {
    'name': "nav_appointments".tr,
    'icon': Icons.event_note,
    'page': () => Appointmentscommitments(),
    'subPages': [],
  },

  {
    'name': "nav_faq".tr,
    'icon': Icons.help_outline,
    'page': () => Commonquestions(),
    'subPages': [],
  },

  {
    'name': "external_links".tr,
    'icon': Icons.link_outlined,
    'page': () => Externallinks(),
    'subPages': [],
  },

  {
    'name': "قوانين".tr,
    'icon': Icons.gavel_outlined,
    'page': () => Law(),
    'subPages': [],
  },

  {
    'name': "الإشعارات".tr,
    'icon': Icons.notifications_active_outlined,
    'page': () => NotificationBar(),
    'subPages': [],
  },

  {
    'name': "التقارير".tr,
    'icon': Icons.description_outlined,
    'page': () => Reports(),
    'subPages': [],
  },

  {
    'name': "الحصري".tr,
    'icon': Icons.star_outline,
    'page': () => Exclusive(),
    'subPages': [],
  },
];
  void changePage(int index) {
    currentPage.value = index;
    currentSubIndex.value = null;
    currentSubPage.value = null;
  }

  void toggleExpand(int index) {
    expandedIndex.value = expandedIndex.value == index ? null : index;
  }

  void changeSubPage(int subIndex, Widget Function() page) {
    currentSubIndex.value = subIndex;
    currentSubPage.value = page;
  }
}
