import 'package:get/get.dart';

abstract class Institutionscontroller extends GetxController {}

class InstitutionscontrollerImp extends Institutionscontroller {
  int selectedFilter = 0;

  final List<Map<String, Object>> filters = [
    {'key': 0, 'label': ' all'.tr},
    {'key': 1, 'label': 'micro'.tr},
    {'key': 2, 'label': 'small'.tr},
    {'key': 3, 'label': 'medium'.tr},
    {'key': 4, 'label': 'large'.tr},
    {'key': 5, 'label': 'very_large'.tr},
  ];

  @override
  void onInit() {
    print("Institutions");
    super.onInit();
  }
}
