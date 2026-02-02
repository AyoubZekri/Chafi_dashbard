import 'dart:io';

import '../../../LinkApi.dart';
import '../../../core/class/Crud.dart';

class Postdata {
  Crud crud;
  Postdata(this.crud);

  viewdata(Map data) async {
    var response = await crud.postWithheaders(Applink.postShow,data);
    return response.fold((l) => l, (r) => r);
  }

  adddata(Map data, File file) async {
    var response = await crud.addRequestWithImageOne(
      Applink.postadd,
      data,
      2,

      file,
    );
    return response.fold((l) => l, (r) => r);
  }

  deletdata(Map data) async {
    var response = await crud.postWithheaders(Applink.postdelet, data);
    return response.fold((l) => l, (r) => r);
  }

  editdata(Map data, [File? file]) async {
    var response;
    if (file == null) {
      response = await crud.postWithheaders(Applink.postedit, data);
    } else {
      response = await crud.addRequestWithImageOne(
        Applink.postedit,
        data,
        2,
        file,
      );
    }
    ;
    return response.fold((l) => l, (r) => r);
  }
}
