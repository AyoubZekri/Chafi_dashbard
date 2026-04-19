import 'package:flutter/material.dart';
import '../../../../core/constant/Colorapp.dart';

class CustomAddLawButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  const CustomAddLawButton({
    super.key,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColor.typography),
      ),
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: const Icon(
          Icons.add_circle_outline,
          color: AppColor.typography,
          size: 20,
        ),
        label: Text(
          label,
          style: const TextStyle(
            color: AppColor.typography,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 12,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }
}
