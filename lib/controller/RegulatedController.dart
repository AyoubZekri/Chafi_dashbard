import 'package:get/get.dart';

abstract class Regulatedcontroller extends GetxController {}

class RegulatedcontrollerImp extends Regulatedcontroller {
  int selectedFilter = 0;

  final List<Map<String, Object>> filters = [
    {'key': 0, 'label': "all".tr},
    {'key': 1, 'label': "filter_innovative".tr},
    {'key': 2, 'label': "filter_startup".tr},
    {'key': 3, 'label': "filter_incubator".tr},
  ];

  @override
  void onInit() {
    print("Regulated");
    super.onInit();
  }
}
