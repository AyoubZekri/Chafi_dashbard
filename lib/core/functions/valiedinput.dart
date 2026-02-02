import 'package:get/get.dart';

/// Validation function
/// [val] : القيمة  
/// [min] : الحد الأدنى للطول  
/// [max] : الحد الأقصى للطول  
/// [type] : نوع الحقل: 'username', 'email', 'phone', 'text', 'number'
String? validateInput(String val, int min, int max, String type) {
  if (val.isEmpty) {
    return "الحقل لا يمكن أن يكون فارغًا".tr;
  }

  if (val.length < min) {
    return "الحقل يجب أن يكون على الأقل $min حرفًا".tr;
  }

  if (val.length > max) {
    return "الحقل يجب ألا يزيد عن $max حرفًا".tr;
  }

  switch (type.toLowerCase()) {
    case 'username':
      if (!GetUtils.isUsername(val)) {
        return "اسم المستخدم غير صالح".tr;
      }
      break;

    case 'email':
      if (!GetUtils.isEmail(val)) {
        return "البريد الإلكتروني غير صالح".tr;
      }
      break;

    case 'phone':
      if (!GetUtils.isPhoneNumber(val)) {
        return "رقم الهاتف غير صالح".tr;
      }
      break;

    case 'number':
      if (int.tryParse(val) == null) {
        return "يجب أن يكون رقماً صحيحاً".tr;
      }
      break;

    case 'text':
    default:
      // أي نص عادي
      break;
  }

  // null = لا يوجد خطأ
  return null;
}
