import '../../../LinkApi.dart';
import '../../../core/class/Crud.dart';

class Usersdata {
  Crud crud;
  Usersdata(this.crud);

  viewdata() async {
    var response = await crud.getWithheaders(Applink.usersShow);
    return response.fold((l) => l, (r) => r);
  }

  deletdata(int id) async {
    var response = await crud.postWithheaders(Applink.usersDelete, {
      "id": id.toString(),
    });
    return response.fold((l) => l, (r) => r);
  }
}
