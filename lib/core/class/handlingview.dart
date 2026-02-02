import 'package:flutter/material.dart';
import '../constant/Colorapp.dart';

import 'Statusrequest.dart';

class Handlingview extends StatelessWidget {
  final Statusrequest statusrequest;
  final IconData? iconData; // <- خليها nullable
  final String? title; // <- خليها nullable
  final Widget widget;

  const Handlingview({
    super.key,
    required this.statusrequest,
    required this.widget,
    this.iconData,
    this.title,
  });

  @override
  Widget build(BuildContext context) {
    switch (statusrequest) {
      case Statusrequest.loadeng:
      case Statusrequest.none:
        return Center(
          child: SizedBox(
            width: 50,
            height: 50,
            child: CircularProgressIndicator(
              strokeWidth: 4,
              color: AppColor.typography,
            ),
          ),
        );

      case Statusrequest.serverfailure:
        return _errorView(icon: Icons.cloud_off, message: "Server Error");

      case Statusrequest.offlinefailure:
        return _errorView(
          icon: Icons.wifi_off,
          message: "No Internet Connection",
        );

      case Statusrequest.failure:
        return _errorView(icon: Icons.inbox, message: "لا توجد بيانات لعرضها");

      default:
        return widget;
    }
  }

  Widget _errorView({required IconData icon, required String message}) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: AppColor.typography, size: 50),
          const SizedBox(height: 12),
          Text(
            message,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColor.grey,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
