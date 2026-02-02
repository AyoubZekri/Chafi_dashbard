import 'package:flutter/material.dart';
import '../constant/Colorapp.dart';

Future<bool> showCustomConfirmationDialog(
  BuildContext context, {
  required String title,
  required String message,
  String confirmText = "موافق",
  String cancelText = "إلغاء",
  VoidCallback? onConfirmAction,
  VoidCallback? onCancelAction,
}) async {
  bool? result = await showDialog<bool>(
    context: context,
    builder: (BuildContext context) {
      return Center(
        child: Material(
          color: Colors.transparent,
          child: Container(
            width: MediaQuery.of(context).size.width * 0.4, // 40% من عرض الشاشة
            constraints: const BoxConstraints(
              minHeight: 150,
              maxHeight: 400, // يمنع overflow في الشاشات الصغيرة
            ),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColor.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: SingleChildScrollView(
              // يمنع overflow
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: AppColor.typography,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    message,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 16, color: Colors.black87),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        onPressed: () {
                          onCancelAction?.call();
                          Navigator.of(context).pop(false);
                        },
                        child: Text(
                          cancelText,
                          style: const TextStyle(
                            color: AppColor.typography,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColor.typography,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 30,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () {
                          onConfirmAction?.call();
                          Navigator.of(context).pop(true);
                        },
                        child: Text(
                          confirmText,
                          style: const TextStyle(
                            color: AppColor.white,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    },
  );

  return result ?? false;
}
