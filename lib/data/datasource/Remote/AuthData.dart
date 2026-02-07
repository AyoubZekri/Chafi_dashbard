import '../../../LinkApi.dart';
import '../../../core/class/Crud.dart';

class Authdata {
  Crud crud;
  Authdata(this.crud);

  logen(Map data) async {
    var response = await crud.postWithout(Applink.login, data);
    return response.fold((l) => l, (r) => r);
  }

  signin(Map data) async {
    var response = await crud.postWithout(Applink.signIn, data);
    return response.fold((l) => l, (r) => r);
  }

  resetPassword(Map data) async {
    var response = await crud.postWithout(Applink.resetPassword, data);
    return response.fold((l) => l, (r) => r);
  }

  logout() async {
    var response = await crud.getWithheaders(Applink.logout);
    return response.fold((l) => l, (r) => r);
  }
}
