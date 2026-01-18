import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import '../../../core/constant/Colorapp.dart';

class CustomFilePickerField extends StatelessWidget {
  final String label;
  final String hintText;
  final TextEditingController controller;

  const CustomFilePickerField({
    super.key,
    required this.label,
    required this.hintText,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 8),

        TextFormField(
          controller: controller,
          readOnly: true,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColor.black,
          ),
          onTap: () async {
            final result = await FilePicker.platform.pickFiles(
              type: FileType.custom,
              allowedExtensions: ['pdf', 'doc', 'docx'],
            );

            if (result != null) {
              controller.text = result.files.single.name;
            }
          },
          decoration: InputDecoration(
            hintText: hintText,
            filled: true,
            fillColor: const Color.fromARGB(255, 255, 255, 255),
            suffixIcon: const Icon(Icons.upload_file),
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
