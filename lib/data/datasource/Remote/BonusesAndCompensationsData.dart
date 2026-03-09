import 'dart:io';

import '../../../LinkApi.dart';
import '../../../core/class/Crud.dart';

class Bonusesandcompensationsdata {
  Crud crud;
  Bonusesandcompensationsdata(this.crud);

  viewdata() async {
    var response = await crud.getWithheaders(Applink.bonusesAndCompensationsShwo);
    return response.fold((l) => l, (r) => r);
  }

  adddata(Map data) async {
    var response = await crud.postWithheaders(
      Applink.bonusesAndCompensationsadd,
      data,
    );
    return response.fold((l) => l, (r) => r);
  }

  deletdata(Map data) async {
    var response = await crud.postWithheaders(
      Applink.bonusesAndCompensationsdelet,
      data,
    );
    return response.fold((l) => l, (r) => r);
  }

  editdata(Map data) async {
    var response;
    response = await crud.postWithheaders(Applink.bonusesAndCompensationsedit, data);
    return response.fold((l) => l, (r) => r);
  }
}
