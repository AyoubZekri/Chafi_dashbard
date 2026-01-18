import 'package:get/get.dart';

abstract class Partialsystemcontroller extends GetxController {}

class PartialsystemcontrollerImp extends Partialsystemcontroller {
  int selectedFilter = 0;

  final List<Map<String, Object>> filters = [
    {'key': 0, 'label': ' العقوبات'},
    {'key': 1, 'label': 'الادماجات '},
    {'key': 2, 'label': 'مخالفات'},
  ];

  @override
  void onInit() {
    print("Institutions");
    super.onInit();
  }
}
