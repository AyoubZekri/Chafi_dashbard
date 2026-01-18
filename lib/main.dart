import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'Bindings/Initialbindings.dart';
import 'core/localizations/ChengeLocal.dart';
import 'core/localizations/Translation.dart';
import 'core/services/Services.dart';
import 'routes.dart';

final RouteObserver<ModalRoute<void>> routeObserver =
    RouteObserver<ModalRoute<void>>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initialServices();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    LocalController controller = Get.put(LocalController());
    return GetMaterialApp(
      navigatorObservers: [routeObserver],
      translations: MyTranslation(),
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: controller.themeData,
      locale: controller.language,
      initialBinding: Initialbindings(),
      getPages: routes,
    );
  }
}
