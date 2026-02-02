import 'dart:io';

import '../../../LinkApi.dart';
import '../../../core/class/Crud.dart';

class InstitutionData {
  Crud crud;
  InstitutionData(this.crud);

  viewdata(Map data) async {
    var response = await crud.postWithheaders(Applink.institutionShow,data);
    return response.fold((l) => l, (r) => r);
  }

  adddata(Map data) async {
    var response = await crud.postWithheaders(Applink.institutionadd, data);
    return response.fold((l) => l, (r) => r);
  }

  deletdata(Map data) async {
    var response = await crud.postWithheaders(Applink.institutiondelet, data);
    return response.fold((l) => l, (r) => r);
  }

  editdata(Map data) async {
    var response;
      response = await crud.postWithheaders(Applink.institutionedit, data);

    return response.fold((l) => l, (r) => r);
  }
}
