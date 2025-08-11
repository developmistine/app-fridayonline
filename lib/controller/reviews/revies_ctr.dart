import 'package:fridayonline/model/review/review_product_model.dart';
import 'package:fridayonline/service/review/review_service.dart';
import 'package:get/get.dart';

class ReviewsCtr extends GetxController {
  Success? success;
  ReviewsProduct? reviewsProduct;
  RxBool isLoading = false.obs;
  RxInt currentPage = 1.obs;
  saveReviewsFn(listImg, listVideo, json) async {
    try {
      isLoading.value = true;
      success = await saveReview(listImg, listVideo, json);
    } finally {
      isLoading.value = false;
    }
  }

  setPagination() {
    currentPage.value = currentPage.value + 1;
  }

  disposePagination() {
    currentPage.value = 1;
  }
}
