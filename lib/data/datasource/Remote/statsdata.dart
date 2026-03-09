import 'dart:io';

import '../../../LinkApi.dart';
import '../../../core/class/Crud.dart';

class Statsdata {
  Crud crud;
  Statsdata(this.crud);

  viewdata() async {
    var response = await crud.getWithheaders(Applink.satas);
    return response.fold((l) => l, (r) => r);
  }

}
