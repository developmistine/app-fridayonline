import 'dart:convert';
import 'package:fridayonline/print.dart';
import 'package:http/http.dart' as http;

class InteractionLogger {
  static const String _baseUrl =
      "https://apiback.fridayth.com/log/v1/interactions";

  // Base customer information
  static Map<String, dynamic> _baseCustomerInfo = {};

  // Initialize base customer information
  static initialize({
    required String sessionId,
    required int customerId,
    required String customerCode,
    required String customerType,
    required String customerName,
    required String channel,
    required String deviceType,
    required String deviceToken,
  }) {
    _baseCustomerInfo = {
      "session_id": sessionId,
      "customer_id": customerId,
      "customer_code": customerCode,
      "customer_type": customerType,
      "customer_name": customerName,
      "channel": channel,
      "device_type": deviceType,
      "device_token": deviceToken,
    };
  }

  // Generic log function
  static Future<String> _logInteraction(Map<String, dynamic> context) async {
    var url = Uri.parse(_baseUrl);

    var payload = {
      ..._baseCustomerInfo,
      "context": context,
    };

    var json = jsonEncode(payload);
    printJSON(payload);

    try {
      var apiResponse = await http.post(
        url,
        headers: <String, String>{
          'Content-type': 'application/json; charset=utf-8'
        },
        body: json,
      );
      return apiResponse.body;
    } catch (e) {
      throw Exception('Failed to log interaction: $e');
    }
  }

  // ---------- Content Actions ----------

  // Log popup/banner/notification interactions
  static Future<String> logContentInteraction({
    required String
        type, // popup, popupsmall, banner, favorite, privileges, promotion, push, notify
    required String contentId,
    required String contentName,
    String? contentImage,
  }) async {
    var context = {
      "action": "content",
      "type": type,
      "content_id": contentId,
      "content_name": contentName,
    };

    if (contentImage != null) {
      context["content_image"] = contentImage;
    }

    return await _logInteraction(context);
  }

  // Log catalog interactions
  static Future<String> logCatalogInteraction({
    required String catalogId,
    required String catalogType,
    required String catalogBrand,
    required String catalogMedia,
    required String catalogName,
    required String catalogCampaign,
    String? catalogImage,
  }) async {
    var context = {
      "action": "content",
      "type": "catalog",
      "catalog_id": catalogId,
      "catalog_type": catalogType,
      "catalog_brand": catalogBrand,
      "catalog_media": catalogMedia,
      "catalog_name": catalogName,
      "catalog_campaign": catalogCampaign,
    };

    if (catalogImage != null) {
      context["catalog_image"] = catalogImage;
    }

    return await _logInteraction(context);
  }

  // Log catalog page interactions
  static Future<String> logCatalogPageInteraction({
    required String catalogId,
    required String catalogType,
    required String catalogBrand,
    required String catalogMedia,
    required String catalogCampaign,
    required String catalogPageIndex,
    required String catalogPageImage,
    required int catalogPageTime,
  }) async {
    var context = {
      "action": "content",
      "type": "catalog_page",
      "catalog_id": catalogId,
      "catalog_type": catalogType,
      "catalog_brand": catalogBrand,
      "catalog_media": catalogMedia,
      "catalog_campaign": catalogCampaign,
      "catalog_page_index": catalogPageIndex,
      "catalog_page_image": catalogPageImage,
      "catalog_page_time": catalogPageTime,
    };

    return await _logInteraction(context);
  }

  // Log category interactions
  static Future<String> logCategoryInteraction({
    required String categoryId,
    required String categoryName,
    String? subCategoryId,
    String? subCategoryName,
  }) async {
    var context = {
      "action": "content",
      "type": "category",
      "category_id": categoryId,
      "category_name": categoryName,
    };

    if (subCategoryId != null) {
      context["sub_category_id"] = subCategoryId;
    }
    if (subCategoryName != null) {
      context["sub_category_name"] = subCategoryName;
    }

    return await _logInteraction(context);
  }

  // Log product interactions
  static Future<String> logProductInteraction({
    required String type,
    required String contentId,
    required String catalogId,
    required String catalogType,
    required String catalogName,
    required String catalogImage,
    required String catalogIndex,
    required String categoryId,
    required String subCategoryId,
    required String categoryName,
    required String subCategoryName,
    required String productCode,
    required String productBrand,
    required String productCampaign,
    required String productMedia,
    required String productName,
    required String productImage,
    required double productPrice,
    required int productTime,
  }) async {
    var context = {
      "action": "product",
      "type": type,
      "catalog_id": catalogId,
      "content_id": contentId,
      "catalog_type": catalogType,
      "catalog_name": catalogName,
      "catalog_image": catalogImage,
      "catalog_index": catalogIndex,
      "category_id": categoryId,
      "sub_category_id": subCategoryId,
      "category_name": categoryName,
      "sub_category_name": subCategoryName,
      "product_code": productCode,
      "product_brand": productBrand,
      "product_campaign": productCampaign,
      "product_media": productMedia,
      "product_name": productName,
      "product_image": productImage,
      "product_price": productPrice,
      "product_time": productTime,
    };

    return await _logInteraction(context);
  }

  // Log search interactions
  static Future<String> logSearchInteraction({
    required String searchKeyword,
    required bool searchStatus,
  }) async {
    var context = {
      "action": "search",
      "type": "search",
      "search_keyword": searchKeyword,
      "search_status": searchStatus.toString(),
    };

    return await _logInteraction(context);
  }

  // ---------- Convenience Methods ----------

  // Quick log popup
  static Future<String> logPopup({
    required String contentId,
    required String contentName,
    String? contentImage,
  }) async {
    return await logContentInteraction(
      type: "popup",
      contentId: contentId,
      contentName: contentName,
      contentImage: contentImage,
    );
  }

  // Quick log popup small
  static Future<String> logPopupSmall({
    required String contentId,
    required String contentName,
    String? contentImage,
  }) async {
    return await logContentInteraction(
      type: "popup_small",
      contentId: contentId,
      contentName: contentName,
      contentImage: contentImage,
    );
  }

  // Quick log banner
  static Future<String> logBanner({
    required String contentId,
    required String contentName,
    String? contentImage,
  }) async {
    return await logContentInteraction(
      type: "banner",
      contentId: contentId,
      contentName: contentName,
      contentImage: contentImage,
    );
  }

  // Quick log favorite
  static Future<String> logFavorite({
    required String contentId,
    required String contentName,
    String? contentImage,
  }) async {
    return await logContentInteraction(
      type: "favorite",
      contentId: contentId,
      contentName: contentName,
      contentImage: contentImage,
    );
  }

  // Quick log privileges
  static Future<String> logPrivileges({
    required String contentId,
    required String contentName,
    String? contentImage,
  }) async {
    return await logContentInteraction(
      type: "privileges",
      contentId: contentId,
      contentName: contentName,
      contentImage: contentImage,
    );
  }

  // Quick log promotion
  static Future<String> logPromotion({
    required String contentId,
    required String contentName,
    String? contentImage,
  }) async {
    return await logContentInteraction(
      type: "promotion",
      contentId: contentId,
      contentName: contentName,
      contentImage: contentImage,
    );
  }

  // Quick log push
  static Future<String> logPush({
    required String contentId,
    required String contentName,
    String? contentImage,
  }) async {
    return await logContentInteraction(
      type: "push",
      contentId: contentId,
      contentName: contentName,
      contentImage: contentImage,
    );
  }

  // Quick log notification
  static Future<String> logNotification({
    required String contentId,
    required String contentName,
    String? contentImage,
  }) async {
    return await logContentInteraction(
      type: "notify",
      contentId: contentId,
      contentName: contentName,
      contentImage: contentImage,
    );
  }
}

// ---------- Usage Examples ----------

/*
// 1. Initialize ตอนเริ่มต้นแอพ
void initializeLogger() {
  InteractionLogger.initialize(
    sessionId: "test-session-id",
    customerId: 5486041,
    customerCode: "0999005499",
    customerType: "2",
    customerName: "คุณสมศรี มีความสามารถ",
    channel: "app",
    deviceType: "android",
    deviceToken: "1212312121",
  );
}

// 2. Log popup interaction
Future<void> logPopupView() async {
  try {
    String response = await InteractionLogger.logPopup(
      contentId: "1077",
      contentName: "R2502",
      contentImage: "https://s3.catalog-yupin.com/Yupindata/IMGPopup2025/1750220312.gif",
    );
    print("Popup logged: $response");
  } catch (e) {
    print("Error logging popup: $e");
  }
}

// 3. Log catalog view
Future<void> logCatalogView() async {
  try {
    String response = await InteractionLogger.logCatalogInteraction(
      catalogId: "2988",
      catalogType: "1",
      catalogBrand: "10",
      catalogMedia: "01",
      catalogName: "แค็ตตาล็อกฟรายเดย์",
      catalogCampaign: "202514",
      catalogImage: "https://s3.catalog-yupin.com/MistineImages/IMGCat/img/2025/1751337727.jpg.webp",
    );
    print("Catalog logged: $response");
  } catch (e) {
    print("Error logging catalog: $e");
  }
}

// 4. Log product view
Future<void> logProductView() async {
  try {
    String response = await InteractionLogger.logProductInteraction(
      catalogId: "2988",
      catalogType: "1",
      catalogName: "แค็ตตาล็อกฟรายเดย์ เล่มที่ 14",
      catalogImage: "https://s3.catalog-yupin.com/MistineImages/IMGCat/img/2025/1751337727.jpg.webp",
      catalogIndex: "117",
      categoryId: "01",
      subCategoryId: "03",
      categoryName: "สกินแคร์",
      subCategoryName: "บำรุงผิวหน้าเพื่อผิวกระจ่างใส",
      productCode: "35267",
      productBrand: "10",
      productCampaign: "202514",
      productMedia: "01",
      productName: "สาเก ไบรท์เทนนิ่ง ซีรั่ม 45 มล.",
      productImage: "https://s3.catalog-yupin.com/MistineImages/products/41337.webp",
      productPrice: 600,
      productTime: 10,
    );
    print("Product logged: $response");
  } catch (e) {
    print("Error logging product: $e");
  }
}

// 5. Log search
Future<void> logSearch(String keyword, bool success) async {
  try {
    String response = await InteractionLogger.logSearchInteraction(
      searchKeyword: keyword,
      searchStatus: success,
    );
    print("Search logged: $response");
  } catch (e) {
    print("Error logging search: $e");
  }
}

// 6. Log category navigation
Future<void> logCategoryView() async {
  try {
    String response = await InteractionLogger.logCategoryInteraction(
      categoryId: "01",
      categoryName: "สกินแคร์",
      subCategoryId: "02",
      subCategoryName: "ทำความสะอาดผิวหน้า",
    );
    print("Category logged: $response");
  } catch (e) {
    print("Error logging category: $e");
  }
}
*/