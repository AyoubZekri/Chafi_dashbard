import 'package:flutter/material.dart';
import 'package:get/get.dart';

abstract class Editinstitutionscontroller extends GetxController {}

class EditinstitutionscontrollerImp extends Editinstitutionscontroller {
  final titlear = TextEditingController();
  final infoar = TextEditingController();
  final titlefr = TextEditingController();
  final infofr = TextEditingController();
  final numperindex = TextEditingController();

  bool isCalculatorActive = false;
  bool isLawActive = false;
  int? selectedCalculator;
  int? selectedLaw;
  int? type;

  final List<Map<String, Object>> institutions = [
    {'key': 1, 'label': "micro".tr},
    {'key': 2, 'label': "small".tr},
    {'key': 3, 'label': "medium".tr},
    {'key': 4, 'label': "large".tr},
    {'key': 5, 'label': "very_large".tr},
  ];

  final List<Map<String, Object>> regulated = [
    {'key': 1, 'label': "filter_innovative".tr},
    {'key': 2, 'label': "filter_startup".tr},
    {'key': 3, 'label':  "filter_incubator".tr},
  ];

  final List<Map<String, Object>> calcelators = [
    {'key': 0, 'label': 'Hassba1'},
    {'key': 1, 'label': 'Hassba2'},
    {'key': 2, 'label': 'Hassba3'},
  ];

  final List<Map<String, Object>> law = [
    {'key': 0, 'label': 'law1'},
    {'key': 1, 'label': 'law2'},
    {'key': 2, 'label': 'law3'},
  ];
  @override
  void onInit() {
    super.onInit();
  }

}
