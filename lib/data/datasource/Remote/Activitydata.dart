import 'dart:io';

import '../../../LinkApi.dart';
import '../../../core/class/Crud.dart';

class Activitydata {
  Crud crud;
  Activitydata(this.crud);

  viewdata(Map data) async {
    var response = await crud.postWithheaders(Applink.activitysShwo, data);
    return response.fold((l) => l, (r) => r);
  }

  adddata(Map data) async {
    var response = await crud.postWithheaders(Applink.activitysadd, data);
    return response.fold((l) => l, (r) => r);
  }

  deletdata(Map data) async {
    var response = await crud.postWithheaders(Applink.activitysdelet, data);
    return response.fold((l) => l, (r) => r);
  }

  editdata(Map data, [File? file]) async {
    var response;
    response = await crud.postWithheaders(Applink.activitysedit, data);
    return response.fold((l) => l, (r) => r);
  }
}
