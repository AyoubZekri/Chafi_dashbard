import 'package:get/get.dart';

abstract class Differentcontroller extends GetxController {}

class DifferentcontrollerImp extends Differentcontroller {
  @override
  void onInit() {
    print("Different");
    super.onInit();
  }
}
