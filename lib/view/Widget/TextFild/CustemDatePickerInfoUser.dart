import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // ستحتاج لإضافة حزمة intl في pubspec.yaml لتنسيق التاريخ
import '../../../core/constant/Colorapp.dart';

class CustemDatePickerInfoUser extends StatelessWidget {
  final String hintText;
  final String label;
  final TextEditingController? myController;
  final BuildContext context; // نحتاج السياق لفتح التقويم

  const CustemDatePickerInfoUser({
    super.key,
    required this.hintText,
    required this.label,
     this.myController,
    required this.context,
  });

  // دالة اختيار التاريخ
  Future<void> _selectDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF6269F2), // لون التقويم المتناسق مع تصميمك
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      myController?.text = DateFormat('yyyy-MM-dd').format(picked);
    }
  }

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
          controller: myController,
          readOnly: true, // يمنع الكتابة اليدوية ويجبر المستخدم على اختيار التاريخ
          onTap: _selectDate, // يفتح التقويم عند الضغط على الحقل
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColor.black,
          ),
          decoration: InputDecoration(
            hintText: hintText,
            filled: true,
            fillColor: Colors.white,
            suffixIcon: const Icon(Icons.calendar_today, color: Colors.grey, size: 20),
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