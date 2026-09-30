import '../../../LinkApi.dart';
import '../../../core/class/Crud.dart';

class FeedbackCompareData {
  Crud crud;
  FeedbackCompareData(this.crud);

  viewdata(Map data) async {
    var response = await crud.postWithheaders(Applink.feedbackCompare, data);
    return response.fold((l) => l, (r) => r);
  }
}
