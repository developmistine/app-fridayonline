import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../model/check_information/order_history/get_history_invoice.dart';
import '../model/return_product/history_all.dart';
import '../model/return_product/history_by_seq.dart';
import '../model/return_product/return_json.dart';
import '../service/return_product/return_product_sv.dart';

class ReturnProductController extends GetxController {
  List<String> reasonText = [];
  final reasonCode = RxString('');
  List<RxBool>? checked;
  RxInt indexSteps = 0.obs;
  GetProductByInvioce? productByinvoice;
  RxBool isDataLoading = false.obs;
  List<TextEditingController> controllers = [];
  TextEditingController reasonController = TextEditingController();
  // List<FocusNode> focusNodes = [];
  RxInt items = 0.obs;
  RxInt price = 0.obs;
  List<HistoryReturnAll>? historyReturnAll;
  HistoryReturnBySeq? historyReturnBySeq;
  RxInt badger = 0.obs;
  List<int>? checkedReason = [];
  List<XFile>? imageFile = [];
  List<XFile> ifile = [];
  List<ImgageProduct> fileJson = [];
  @override
  void onClose() {
    // printWhite('close controller');
    for (var element in controllers) {
      element.dispose();
    }
    // for (var element in focusNodes) {
    //   element.dispose();
    // }
    checkedReason = [];
    items.value = 0;
    price.value = 0;
    reasonText = [];
    reasonController.clear();
    for (var element in checked!) {
      element.value = false;
    }
    fileJson = [];
    ifile = [];
    imageFile = [];
    super.onClose();
  }

  void setImgage(img, index) {
    imageFile![index] = img;
    ifile.add(img);
    fileJson.add(
        ImgageProduct(ifile: ifile, reason: ifile.indexOf(img).toString()));

    // for (var element in fileJson) {
    //   // printWhite('element is ${element.ifile}');
    // }
  }

  void addCounter(index) {
    items.value++;
    price.value += int.parse(controllers[index].text);
  }

  void removeCounter(index) {
    items.value--;
    price.value -= int.parse(controllers[index].text);
  }

  typeCounter() {
    price.value = 0;
    List<int>? number = [];
    for (int i = 0; i < controllers.length; i++) {
      if (checked![i].value) {
        number.add(int.parse(controllers[i].text));
      }
    }

    price.value = number.reduce((value, element) => value + element);
  }

  fetchReturnProduct(invoice) async {
    try {
      isDataLoading(true);
      productByinvoice = await getProductByInvoice(invoice);
      checked = List<RxBool>.generate(
          productByinvoice!.productDetail!.length, (index) => false.obs);
      controllers = List.generate(productByinvoice!.productDetail!.length,
          (index) => TextEditingController());
      checkedReason =
          List.generate(productByinvoice!.productDetail!.length, (index) => 0);
      reasonText = List.generate(productByinvoice!.productDetail!.length,
          (index) => productByinvoice!.reasonAll[0].reason);
      imageFile = List.generate(
          productByinvoice!.productDetail!.length, (index) => XFile(''));
      // controllers = List.generate(
      //     productByinvoice!.productDetail!.length,
      //     (index) => TextEditingController(
      //         text: productByinvoice!.productDetail![index].qty.toString()));
      // focusNodes = List.generate(
      //     productByinvoice!.productDetail!.length, (index) => FocusNode());
    } catch (e) {
      debugPrint('error is $e');
    } finally {
      isDataLoading(false);
    }
  }

  // getHistoryAll
  fetchHistoryReturnAll() async {
    try {
      isDataLoading(true);
      historyReturnAll = await getHistoryAll();
    } catch (e) {
      debugPrint('error is $e');
    } finally {
      isDataLoading(false);
    }
  }

  // getHistory by seq
  fetchHistoryReturnBySeq(invoice, seq) async {
    try {
      isDataLoading(true);
      historyReturnBySeq = await getHistoryBySeq(invoice, seq);
    } catch (e) {
      debugPrint('error is $e');
    } finally {
      isDataLoading(false);
    }
  }

  // get badger return product
  fetchBadgerReturnProduct() async {
    try {
      isDataLoading(true);
      badger.value = await getBadger();
    } catch (e) {
      debugPrint('error is $e');
    } finally {
      isDataLoading(false);
    }
  }
}
