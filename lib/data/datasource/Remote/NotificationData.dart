
import '../../../LinkApi.dart';
import '../../../core/class/Crud.dart';

class Notificationdata {
  Crud crud;
  Notificationdata(this.crud);

  viewdata() async {
    var response = await crud.postWithheaders(Applink.notificationShwo, {});
    return response.fold((l) => l, (r) => r);
  }

  adddata(Map data) async {
    var response = await crud.postWithheaders(
      Applink.notificationadd,
      data,
    );
    return response.fold((l) => l, (r) => r);
  }

  deletdata(Map data) async {
    var response = await crud.postWithheaders(
      Applink.notificationdelet,
      data,
    );
    return response.fold((l) => l, (r) => r);
  }

  editdata(Map data) async {
    var response;
    response = await crud.postWithheaders(Applink.notificationedit, data);
    return response.fold((l) => l, (r) => r);
  }
}
