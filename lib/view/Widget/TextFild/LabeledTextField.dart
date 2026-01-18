import 'package:flutter/material.dart';

import '../../../core/constant/Colorapp.dart';

class CustemtextfromfildInfoUser extends StatelessWidget {
  final String hintText;
  final String label;
  final int? maxLines;
  final TextEditingController? myController;
  final TextInputType? keyboardType;
  final bool? obscureText;
  const CustemtextfromfildInfoUser({
    super.key,
    required this.hintText,
    this.myController,
    this.keyboardType,
    this.obscureText,
    required this.label,
    this.maxLines,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
        ),
        const SizedBox(height: 8),

        TextFormField(
          obscureText: obscureText == null || obscureText == false
              ? false
              : true,
          controller: myController,
          keyboardType: keyboardType,
          maxLines: maxLines ?? 1,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColor.black,
          ),
          decoration: InputDecoration(
            hintText: hintText,
            filled: true,
            fillColor: const Color.fromARGB(255, 255, 255, 255),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: AppColor.grey),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: AppColor.grey),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ],
    );
  }
}
