import '../../../LinkApi.dart';
import '../../../core/class/Crud.dart';

class TaxArticlesData {
  Crud crud;
  TaxArticlesData(this.crud);

  viewdata(Map data) async {
    var response = await crud.postWithheaders(Applink.taxArticleShow, data);
    return response.fold((l) => l, (r) => r);
  }

  adddata(Map data) async {
    var response = await crud.postWithheaders(Applink.taxArticleAdd, data);
    return response.fold((l) => l, (r) => r);
  }

  editdata(Map data) async {
    var response = await crud.postWithheaders(Applink.taxArticleEdit, data);
    return response.fold((l) => l, (r) => r);
  }

  deletdata(Map data) async {
    var response = await crud.postWithheaders(Applink.taxArticleDelete, data);
    return response.fold((l) => l, (r) => r);
  }
}
