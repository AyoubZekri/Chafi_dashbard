import 'package:get/get.dart';


abstract class Homecontroller extends GetxController {}

class HomecontrollerImp extends Homecontroller {
  @override
  void onInit() {
    print("Home");
    super.onInit();
  }
}
