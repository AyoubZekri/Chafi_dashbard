import 'package:flutter/material.dart';
import 'package:get/get.dart';

abstract class Editdifferentcontroller extends GetxController {}

class EditdifferentcontrollerImp extends Editdifferentcontroller {
  final titlear = TextEditingController();
  final infoar = TextEditingController();
  final titlefr = TextEditingController();
  final infofr = TextEditingController();
  final numperindex = TextEditingController();

  bool isCalculatorActive = false;
  bool isLawActive = false;
  int? selectedCalculator;
  int? selectedLaw;

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
