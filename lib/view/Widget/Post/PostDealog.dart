import 'package:chafi_dashboard/LinkApi.dart';
import 'package:chafi_dashboard/controller/ReportsController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controller/Exclusivecontroller.dart';
import '../../../core/class/Statusrequest.dart';
import '../../../core/constant/Colorapp.dart';
import '../../../core/functions/valiedinput.dart';
import '../TextFild/LabeledTextField.dart';

class PostDialog extends StatefulWidget {
  final PostDialogMode mode;
  final ReportscontrollerImp controller;
  final int? id;

  const PostDialog({
    super.key,
    required this.mode,
    required this.controller,
    this.id,
  });

  @override
  State<PostDialog> createState() => _PostDialogState();
}

class _PostDialogState extends State<PostDialog> {
  bool get isEdit => widget.mode == PostDialogMode.edit;

  ReportscontrollerImp get controller => widget.controller;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Container(
        width: 800,
        padding: const EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: Form(
            key: controller.formState,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  isEdit ? 'تعديل التقرير'.tr : 'إضافة تقرير جديد'.tr,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),

                // ===== صورة التقرير =====
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 30),
                  height: 250,
                  width: 300,
                  decoration: BoxDecoration(
                    color: AppColor.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(width: 2),
                  ),
                  child: Stack(
                    children: [
                      Center(
                        child: SizedBox(
                          height: 120,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: controller.file != null
                                // صورة جديدة
                                ? Image.file(
                                    controller.file!,
                                    fit: BoxFit.cover,
                                  )
                                // صورة قديمة
                                : controller.editfile != null
                                ? Image.network(
                                    "${Applink.image}${controller.editfile!}",
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, __, ___) => const Icon(
                                      Icons.broken_image,
                                      size: 60,
                                    ),
                                  )
                                // لا صورة
                                : TextButton(
                                    onPressed: _pickImage,
                                    child: Text("اضافة صورة".tr),
                                  ),
                          ),
                        ),
                      ),

                      if (controller.file != null ||
                          controller.editfile != null)
                        Positioned(
                          bottom: 5,
                          right: 5,
                          child: IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: _pickImage,
                          ),
                        ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // ===== العناوين =====
                Row(
                  children: [
                    Expanded(
                      child: CustemtextfromfildInfoUser(
                        myController: isEdit
                            ? controller.edittitlear1
                            : controller.titlear1,
                        label: 'title_ar'.tr,
                        hintText: 'title_hint'.tr,
                        valid: (val) => validateInput(val!, 2, 100, "text"),
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: CustemtextfromfildInfoUser(
                        myController: isEdit
                            ? controller.edittitlefr1
                            : controller.titlefr1,
                        label: 'title_fr'.tr,
                        hintText: 'title_hint'.tr,
                        valid: (val) => validateInput(val!, 2, 100, "text"),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 15),

                Row(
                  children: [
                    Expanded(
                      child: CustemtextfromfildInfoUser(
                        myController: isEdit
                            ? controller.edittitlear2
                            : controller.titlear2,
                        label: 'title_ar2'.tr,
                        hintText: 'title_hint'.tr,
                        valid: (val) => validateInput(val!, 0, 100, "text"),
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: CustemtextfromfildInfoUser(
                        myController: isEdit
                            ? controller.edittitlefr2
                            : controller.titlefr2,
                        label: 'title_fr2'.tr,
                        hintText: 'title_hint'.tr,
                        valid: (val) => validateInput(val!, 0, 100, "text"),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 15),

                // ===== المحتوى =====
                Row(
                  children: [
                    Expanded(
                      child: CustemtextfromfildInfoUser(
                        maxLines: 3,
                        myController: isEdit
                            ? controller.editinfoar
                            : controller.infoar,
                        label: 'الحتوى بالغة العربية'.tr,
                        hintText: 'أدخل المحتوى هنا'.tr,
                        valid: (val) => validateInput(val!, 2, 1000, "text"),
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: CustemtextfromfildInfoUser(
                        maxLines: 3,
                        myController: isEdit
                            ? controller.editinfofr
                            : controller.infofr,
                        label: 'الحتوى بالغة الفرنسية'.tr,
                        hintText: 'أدخل المحتوى هنا'.tr,
                        valid: (val) => validateInput(val!, 2, 1000, "text"),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 30),

                // ===== الأزرار =====
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Get.back(),
                      child: Text(
                        'cancel'.tr,
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    const SizedBox(width: 15),
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
                        if (isEdit) {
                          controller.editData(widget.id!);
                        } else {
                          controller.adddata();
                        }
                      },
                      child: controller.statusrequest == Statusrequest.loadeng
                          ? const SizedBox(
                              width: 15,
                              height: 15,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : Text(
                              'save'.tr,
                              style: const TextStyle(
                                color: Colors.white,
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
  }

  Future<void> _pickImage() async {
    await controller.uploadimagefile();
    setState(() {}); // 🔥 تحديث الواجهة
  }
}

class PostImgDialog extends StatefulWidget {
  final PostDialogMode mode;
  final Exclusivecontroller controller;
  final int? id;

  const PostImgDialog({
    super.key,
    required this.mode,
    required this.controller,
    this.id,
  });

  @override
  State<PostImgDialog> createState() => _PostImgDialogState();
}

class _PostImgDialogState extends State<PostImgDialog> {
  bool get isEdit => widget.mode == PostDialogMode.edit;

  Exclusivecontroller get controller => widget.controller;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Container(
        width: 800,
        padding: const EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                isEdit ? 'edit'.tr : 'إضافة حصري جديد'.tr,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),

              // ===== صورة التقرير =====
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 30),
                height: 250,
                width: 300,
                decoration: BoxDecoration(
                  color: AppColor.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(width: 2),
                ),
                child: Stack(
                  children: [
                    Center(
                      child: SizedBox(
                        height: 120,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: controller.file != null
                              // صورة جديدة
                              ? Image.file(controller.file!, fit: BoxFit.fill)
                              // صورة قديمة
                              : controller.editfile != null && isEdit
                              ? Image.network(
                                  "${Applink.image}${controller.editfile!}",
                                  fit: BoxFit.fill,
                                  errorBuilder: (_, __, ___) =>
                                      const Icon(Icons.broken_image, size: 60),
                                )
                              // لا صورة
                              : TextButton(
                                  onPressed: _pickImage,
                                  child: Text("اضافة صورة".tr),
                                ),
                        ),
                      ),
                    ),

                    if (controller.file != null || controller.editfile != null)
                      Positioned(
                        bottom: 5,
                        right: 5,
                        child: IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: _pickImage,
                        ),
                      ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // ===== الأزرار =====
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Get.back(),
                    child: Text(
                      'cancel'.tr,
                      style: const TextStyle(color: Colors.grey, fontSize: 16),
                    ),
                  ),
                  const SizedBox(width: 15),
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
                      if (isEdit) {
                        controller.editData(widget.id!);
                      } else {
                        controller.adddata();
                      }
                    },
                    child: controller.statusrequest == Statusrequest.loadeng
                        ? const SizedBox(
                            width: 15,
                            height: 15,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : Text(
                            'save'.tr,
                            style: const TextStyle(
                              color: Colors.white,
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
    );
  }

  Future<void> _pickImage() async {
    await controller.uploadimagefile();
    if (!mounted) return;
    setState(() {}); // 🔥 تحديث الواجهة
  }
}

enum PostDialogMode { add, edit }
