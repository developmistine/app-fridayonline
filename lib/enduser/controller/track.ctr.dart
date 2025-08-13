import 'package:appfridayecommerce/preferrence.dart';
import 'package:get/get.dart';

class TrackCtr extends GetxController {
  @override
  void onInit() {
    super.onInit();
    fetchB2cCustId();
  }

  // content view
  int? trackContentId;
  String? trackContentTitle;
  String? trackContentType;

  int contentId = 0;
  String contentType = "";

  // product view
  int? shopId;
  int? productId;
  String? productName;
  int? catId;
  String? catName;
  double? price;
  String? referrer;

  var custId = 0;
  var reptype = "";
  fetchB2cCustId() async {
    SetData data = SetData();
    custId = await data.b2cCustID;
    reptype = await data.repType;
  }

  setLogContentAddToCart(int id, String type) {
    contentId = id;
    contentType = type;
  }

  clearLogContent() {
    contentId = 0;
    contentType = "";
  }

  setDataTrack(int contentId, String contentTitle, String contentType) {
    trackContentId = contentId;
    trackContentTitle = contentTitle;
    trackContentType = contentType;
  }

  clearTrackData() {
    trackContentId = null;
    trackContentTitle = null;
    trackContentType = null;
  }
}
