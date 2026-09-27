import 'dart:io';
import '../../../LinkApi.dart';
import '../../../core/class/Crud.dart';

class TaxSearchData {
  Crud crud;
  TaxSearchData(this.crud);

  viewdata(Map data) async {
    var response = await crud.postWithheaders(Applink.taxSearchShow, data);
    return response.fold((l) => l, (r) => r);
  }

  // multipart حتى يمكن إرفاق ملف (الحقل "file")
  adddata(Map data, File? file) async {
    var response = await crud.addRequestWithImageOne(
      Applink.taxSearchAdd,
      data,
      1,
      file,
      "file",
    );
    return response.fold((l) => l, (r) => r);
  }

  editdata(Map data, File? file) async {
    var response = await crud.addRequestWithImageOne(
      Applink.taxSearchEdit,
      data,
      1,
      file,
      "file",
    );
    return response.fold((l) => l, (r) => r);
  }

  deletdata(Map data) async {
    var response = await crud.postWithheaders(
      Applink.taxSearchDelete,
      data,
    );
    return response.fold((l) => l, (r) => r);
  }
}
