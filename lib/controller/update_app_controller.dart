import 'package:get/get.dart';

class UpdateAppController extends GetxController {
  var statusUpdate = false;
  var title = '';
  var detail = '';
  var url = '';

  setStatusupdate(titl, detai, link) {
    statusUpdate = true;
    title = titl;
    detail = detai;
    url = link;
  }
}
