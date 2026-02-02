import 'dart:io';

import '../../../LinkApi.dart';
import '../../../core/class/Crud.dart';

class Lawdata {
  Crud crud;
  Lawdata(this.crud);

  viewdata() async {
    var response = await crud.getWithheaders(Applink.lawShow);
    return response.fold((l) => l, (r) => r);
  }

  adddata(Map data, File file) async {
    var response = await crud.addRequestWithImageOne(
      Applink.lawadd,
      data,
      1,
      file,
    );
    return response.fold((l) => l, (r) => r);
  }

  deletdata(Map data) async {
    var response = await crud.postWithheaders(Applink.lawdelet, data);
    return response.fold((l) => l, (r) => r);
  }

  editdata(Map data, [File? file]) async {
    var response;
    if (file == null) {
      response = await crud.postWithheaders(Applink.lawedit, data);
    } else {
      response = await crud.addRequestWithImageOne(
        Applink.lawedit,
        data,
        1,
        file,
      );
    }
    ;
    return response.fold((l) => l, (r) => r);
  }
}
