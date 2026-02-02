import 'dart:io';

import '../../../LinkApi.dart';
import '../../../core/class/Crud.dart';

class Categorydata {
  Crud crud;
  Categorydata(this.crud);

  viewdata(Map data) async {
    var response = await crud.postWithheaders(Applink.categoryShow, data);
    return response.fold((l) => l, (r) => r);
  }

  adddata(Map data) async {
    var response = await crud.postWithheaders(Applink.categoryadd, data);
    return response.fold((l) => l, (r) => r);
  }

  deletdata(Map data) async {
    var response = await crud.postWithheaders(Applink.categorydelet, data);
    return response.fold((l) => l, (r) => r);
  }

  editdata(Map data, [File? file]) async {
    var response;
    response = await crud.postWithheaders(Applink.categoryedit, data);
    return response.fold((l) => l, (r) => r);
  }
}
