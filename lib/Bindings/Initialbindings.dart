
import 'package:get/get.dart';

import '../core/class/Crud.dart';
import '../core/services/Services.dart';

class Initialbindings extends Bindings {
  @override
  void dependencies() {
    Get.put(Crud());
    Get.put(Myservices());
  }
}
