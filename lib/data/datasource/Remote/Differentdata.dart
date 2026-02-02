
import '../../../LinkApi.dart';
import '../../../core/class/Crud.dart';

class Differentdata {
  Crud crud;
  Differentdata(this.crud);

  viewdata(Map data) async {
    var response = await crud.postWithheaders(Applink.differentShow, data);
    return response.fold((l) => l, (r) => r);
  }

  adddata(Map data) async {
    var response = await crud.postWithheaders(Applink.differentadd, data);
    return response.fold((l) => l, (r) => r);
  }

  deletdata(Map data) async {
    var response = await crud.postWithheaders(Applink.differentdelet, data);
    return response.fold((l) => l, (r) => r);
  }

  editdata(Map data) async {
    var response;
    response = await crud.postWithheaders(Applink.differentedit, data);
    return response.fold((l) => l, (r) => r);
  }
}
