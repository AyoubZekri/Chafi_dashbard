import 'package:flutter/material.dart';

import '../../../core/constant/Colorapp.dart';

class Custemtextfildauth extends StatelessWidget {
  final String hintText;
  final int? maxLines;
  final TextEditingController? myController;
  final TextInputType? keyboardType;
  final bool? obscureText;
  final IconData iconData;
  final void Function()? onTap;
  const Custemtextfildauth({
    super.key,
    required this.hintText,
    this.myController,
    this.keyboardType,
    this.obscureText,
    this.maxLines,
    required this.iconData,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
            hintStyle: TextStyle(color: Colors.grey),
            filled: true,
            fillColor: const Color.fromARGB(255, 255, 255, 255),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: AppColor.grey),
            ),
            suffixIcon: InkWell(
              onTap: onTap,
              child: Icon(iconData, color: AppColor.grey),
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
