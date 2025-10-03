import 'dart:convert';
import 'dart:io';
import 'package:fridayonline/member/models/affiliate/bank.model.dart';
import 'package:fridayonline/member/models/affiliate/commission.balance.model.dart';
import 'package:fridayonline/member/models/affiliate/commission.condition.model.dart';
import 'package:fridayonline/member/models/affiliate/commission.dtlearning.model.dart';
import 'package:fridayonline/member/models/affiliate/commission.dtlorder.model.dart';
import 'package:fridayonline/member/models/affiliate/commission.sumearning.model.dart';
import 'package:fridayonline/member/models/affiliate/commission.sumorder.model.dart';
import 'package:fridayonline/member/models/affiliate/dashboard.overview.dart';
import 'package:fridayonline/member/models/affiliate/dashboard.products.dart';
import 'package:fridayonline/member/models/affiliate/dashboard.summary.dart';
import 'package:fridayonline/member/models/affiliate/option.model.dart';
import 'package:fridayonline/member/models/affiliate/payment.model.dart';
import 'package:fridayonline/member/models/affiliate/productcontent.model.dart';
import 'package:fridayonline/member/models/affiliate/profile.model.dart';
import 'package:fridayonline/member/models/affiliate/recommendproduct.model.dart';
import 'package:fridayonline/member/models/affiliate/share.model.dart';
import 'package:fridayonline/member/models/affiliate/shopcontent.model.dart';
import 'package:fridayonline/member/models/affiliate/tips.model.dart';
import 'package:http/http.dart' as http;

import 'package:fridayonline/member/models/affiliate/contentType.model.dart'
    as type;
import 'package:fridayonline/member/models/affiliate/response.model.dart';
import 'package:fridayonline/member/models/affiliate/status.model.dart';
import 'package:fridayonline/member/models/affiliate/username.model.dart';
import 'package:fridayonline/preferrence.dart';

import 'package:fridayonline/service/pathapi.dart';
import 'package:fridayonline/member/utils/auth_fetch.dart';
import 'package:http_parser/http_parser.dart';

class AffiliateService {
  final _data = SetData();

  Future<AccountStatus?> checkStatus() async {
    var url = Uri.parse("${b2c_api_url}api/v1/affiliate/account/status");

    try {
      var jsonCall = await AuthFetch.get(
        url,
        headers: <String, String>{
          'Authorization': 'Bearer ${await _data.accessToken}',
          'Content-type': 'application/json; charset=utf-8'
        },
      );
      if (jsonCall.statusCode == 200) {
        var jsonString = jsonCall.bodyBytes;
        final response = accountStatusFromJson(utf8.decode(jsonString));

        return response;
      }
      return Future.error(
          'Error AffiliateService : api/v1/affiliate/account/status');
    } catch (e) {
      print('error api/v1/affiliate/account/status : $e');
      return Future.error("$e  from api/v1/affiliate/account/status");
    }
  }

  Future<UsernameAvailable?> checkUsername(String username) async {
    var url = Uri.parse(
        "${b2c_api_url}api/v1/affiliate/account/check_username?user_name=$username");

    try {
      var jsonCall = await AuthFetch.get(
        url,
        headers: <String, String>{
          'Authorization': 'Bearer ${await _data.accessToken}',
          'Content-type': 'application/json; charset=utf-8'
        },
      );
      if (jsonCall.statusCode == 200) {
        var jsonString = jsonCall.bodyBytes;
        final response = usernameAvailableFromJson(utf8.decode(jsonString));
        return response;
      }
      return Future.error(
          'Error AffiliateService : api/v1/affiliate/account/check_username');
    } catch (e) {
      print('error api/v1/affiliate/account/check_username : $e');
      return Future.error("$e  from api/v1/affiliate/account/check_username");
    }
  }

  Future<Response?> register({
    required String username,
    required String shopName,
    required String email,
    required String mobile,
  }) async {
    var url = Uri.parse("${b2c_api_url}api/v1/affiliate/account/register");

    final payload = {
      "user_name": username,
      "store_name": shopName,
      "email": email,
      "moblie": mobile
    };

    try {
      var jsonCall = await AuthFetch.post(
        url,
        headers: <String, String>{
          'Authorization': 'Bearer ${await _data.accessToken}',
          'Content-type': 'application/json; charset=utf-8'
        },
        body: jsonEncode(payload),
      );
      if (jsonCall.statusCode == 200) {
        var jsonString = jsonCall.bodyBytes;
        final response = responseFromJson(utf8.decode(jsonString));
        return response;
      }
      return Future.error(
          'Error AffiliateService : api/v1/affiliate/account/check_username');
    } catch (e) {
      print('error api/v1/affiliate/account/check_username : $e');
      return Future.error("$e  from api/v1/affiliate/account/check_username");
    }
  }

  Future<Option?> getPrefix() async {
    var url = Uri.parse("${b2c_api_url}api/v1/prename");

    try {
      var jsonCall = await AuthFetch.get(
        url,
        headers: <String, String>{
          'Authorization': 'Bearer ${await _data.accessToken}',
          'Content-type': 'application/json; charset=utf-8'
        },
      );
      if (jsonCall.statusCode == 200) {
        var jsonString = jsonCall.bodyBytes;
        final response = optionFromJson(utf8.decode(jsonString));
        return response;
      }
      return Future.error('Error AffiliateService : api/v1/prename');
    } catch (e) {
      print('error api/v1/prename : $e');
      return Future.error("$e  from api/v1/prename");
    }
  }

  Future<BankOption?> getBank() async {
    var url = Uri.parse("${b2c_api_url}api/v1/bank");

    try {
      var jsonCall = await AuthFetch.get(
        url,
        headers: <String, String>{
          'Authorization': 'Bearer ${await _data.accessToken}',
          'Content-type': 'application/json; charset=utf-8'
        },
      );
      if (jsonCall.statusCode == 200) {
        var jsonString = jsonCall.bodyBytes;
        final response = bankOptionFromJson(utf8.decode(jsonString));
        return response;
      }
      return Future.error('Error AffiliateService :api/v1/bank');
    } catch (e) {
      print('errorapi/v1/bank : $e');
      return Future.error("$e  fromapi/v1/bank");
    }
  }

  Future<Option?> getOption(String option) async {
    var url =
        Uri.parse("${b2c_api_url}api/v1/affiliate/products/options/$option");

    try {
      var jsonCall = await AuthFetch.get(
        url,
        headers: <String, String>{
          'Authorization': 'Bearer ${await _data.accessToken}',
          'Content-type': 'application/json; charset=utf-8'
        },
      );
      if (jsonCall.statusCode == 200) {
        var jsonString = jsonCall.bodyBytes;
        final response = optionFromJson(utf8.decode(jsonString));
        return response;
      }
      return Future.error(
          'Error AffiliateService : api/v1/affiliate/products/options');
    } catch (e) {
      print('error api/v1/affiliate/products/options : $e');
      return Future.error("$e  from api/v1/affiliate/products/options");
    }
  }

  Future<type.ContentType?> getContentType() async {
    var url = Uri.parse("${b2c_api_url}api/v1/affiliate/contents/types");

    try {
      var jsonCall = await AuthFetch.get(
        url,
        headers: <String, String>{
          'Authorization': 'Bearer ${await _data.accessToken}',
          'Content-type': 'application/json; charset=utf-8'
        },
      );
      if (jsonCall.statusCode == 200) {
        var jsonString = jsonCall.bodyBytes;
        final response = type.contentTypeFromJson(utf8.decode(jsonString));
        return response;
      }
      return Future.error(
          'Error AffiliateService : api/v1/affiliate/contents/types');
    } catch (e) {
      print('error api/v1/affiliate/contents/types : $e');
      return Future.error("$e  from api/v1/affiliate/contents/types");
    }
  }

  Future<Response?> addProduct({
    required String tabType, // content , product , category
    required int contentId, // id ของ content หรือ category
    required int productId,
  }) async {
    var url = Uri.parse("${b2c_api_url}api/v1/affiliate/contents/products");

    final payload = {
      "target_type": tabType,
      "id": contentId,
      "product_id": productId
    };

    try {
      var jsonCall = await AuthFetch.post(
        url,
        headers: <String, String>{
          'Authorization': 'Bearer ${await _data.accessToken}',
          'Content-type': 'application/json; charset=utf-8'
        },
        body: jsonEncode(payload),
      );
      if (jsonCall.statusCode == 200) {
        var jsonString = jsonCall.bodyBytes;
        final response = responseFromJson(utf8.decode(jsonString));
        return response;
      }
      return Future.error(
          'Error AffiliateService : api/v1/affiliate/account/check_username');
    } catch (e) {
      print('error api/v1/affiliate/account/check_username : $e');
      return Future.error("$e  from api/v1/affiliate/account/check_username");
    }
  }

  Future<Response?> createContent({
    required String type, // product, image, video, text
    required String name,
    String? text,
    List<Map<String, dynamic>>? products,
    List<File>? files,
  }) async {
    var url = Uri.parse("${b2c_api_url}api/v1/affiliate/contents");

    try {
      // final token = await _data.accessToken;
      final info = <String, dynamic>{
        "content_type": type,
        "content_name": name,
        if (type == "text") "display_text": (text ?? "").trim(),
        if (type == "product" && (products?.isNotEmpty ?? false))
          "products": products,
      };
      final fields = <String, String>{
        "info": jsonEncode(info),
      };

      // --- form-data: files ---
      final List<http.MultipartFile> parts = <http.MultipartFile>[];
      if (files != null && files.isNotEmpty) {
        final fieldKey = (type == "video") ? "video" : "image";
        for (final f in files) {
          parts.add(await http.MultipartFile.fromPath(
            fieldKey,
            f.path,
            contentType:
                (fieldKey == 'video') ? MediaType('video', 'mp4') : null,
          ));
        }
      }

      var streamed = await AuthFetch.multipartRequestWithAuth(
        url,
        method: 'POST',
        headers: {
          'Content-Type': 'multipart/form-data',
        },
        fields: fields,
        files: parts,
      );

      final body = await streamed.stream.bytesToString();

      if (streamed.statusCode >= 200 && streamed.statusCode < 300) {
        return responseFromJson(body);
      }
      return Future.error(
        'Error AffiliateService : api/v1/affiliate/contents '
        '-> ${streamed.statusCode} : $body',
      );
    } catch (e) {
      print('error api/v1/affiliate/contents : $e');
      return Future.error("$e  from api/v1/affiliate/contents");
    }
  }

  Future<Response?> updateContent({
    required int contentId,
    required String type, // product, image, video, text
    required String name,
    String? text,
    List<dynamic>? products,
    List<File>? files,
  }) async {
    var url = Uri.parse("${b2c_api_url}api/v1/affiliate/contents");

    try {
      // final token = await _data.accessToken;
      final info = <String, dynamic>{
        "content_type": type,
        "content_id": contentId,
        "content_name": name,
        if (type == "text") "display_text": (text ?? "").trim(),
        if (type == "product" && (products?.isNotEmpty ?? false))
          "products": products,
      };
      final fields = <String, String>{
        "info": jsonEncode(info),
      };

      // --- form-data: files ---
      final List<http.MultipartFile> parts = <http.MultipartFile>[];
      if (files != null && files.isNotEmpty) {
        final fieldKey = (type == "video") ? "video" : "image";
        for (final f in files) {
          parts.add(await http.MultipartFile.fromPath(
            fieldKey,
            f.path,
            contentType:
                (fieldKey == 'video') ? MediaType('video', 'mp4') : null,
          ));
        }
      }

      var streamed = await AuthFetch.multipartRequestWithAuth(
        url,
        method: 'PUT',
        headers: {
          'Content-Type': 'multipart/form-data',
        },
        fields: fields,
        files: parts,
      );

      final body = await streamed.stream.bytesToString();

      if (streamed.statusCode >= 200 && streamed.statusCode < 300) {
        return responseFromJson(body);
      }
      return Future.error(
        'Error AffiliateService : api/v1/affiliate/contents '
        '-> ${streamed.statusCode} : $body',
      );
    } catch (e) {
      print('error api/v1/affiliate/contents : $e');
      return Future.error("$e  from api/v1/affiliate/contents");
    }
  }

  Future<Response?> updateCategory({
    required int contentId,
    required String type, // product, image, video, text
    required String name,
    List<dynamic>? products,
  }) async {
    var url = Uri.parse("${b2c_api_url}api/v1/affiliate/contents/categories");

    final payload = {
      "content_type": type,
      "category_id": contentId,
      "category_name": name,
      "products": products
    };

    try {
      var jsonCall = await AuthFetch.put(
        url,
        headers: <String, String>{
          'Authorization': 'Bearer ${await _data.accessToken}',
          'Content-type': 'application/json; charset=utf-8'
        },
        body: jsonEncode(payload),
      );
      if (jsonCall.statusCode == 200) {
        var jsonString = jsonCall.bodyBytes;
        final response = responseFromJson(utf8.decode(jsonString));
        return response;
      }
      return Future.error(
          'Error AffiliateService : api/v1/affiliate/contents/categories');
    } catch (e) {
      print('error api/v1/affiliate/contents/categories : $e');
      return Future.error("$e  from api/v1/affiliate/contents/categories");
    }
  }

  Future<Response?> deleteContent({
    required String tabType, // content , category
    required int contentId, // id ของ content หรือ category
  }) async {
    var url = Uri.parse("${b2c_api_url}api/v1/affiliate/contents");

    final payload = {
      "target_type": tabType,
      "id": contentId,
    };

    try {
      var jsonCall = await AuthFetch.delete(
        url,
        headers: <String, String>{
          'Authorization': 'Bearer ${await _data.accessToken}',
          'Content-type': 'application/json; charset=utf-8'
        },
        body: jsonEncode(payload),
      );
      if (jsonCall.statusCode == 200) {
        var jsonString = jsonCall.bodyBytes;
        final response = responseFromJson(utf8.decode(jsonString));
        return response;
      }
      return Future.error('Error AffiliateService : api/v1/affiliate/contents');
    } catch (e) {
      print('error api/v1/affiliate/contents : $e');
      return Future.error("$e  from api/v1/affiliate/contents");
    }
  }

  Future<Response?> deleteProduct({
    required int productId,
  }) async {
    var url = Uri.parse("${b2c_api_url}api/v1/affiliate/contents/products");

    final payload = {
      "target_type": "product",
      "id": 0,
      "product_id": productId
    };

    try {
      var jsonCall = await AuthFetch.delete(
        url,
        headers: <String, String>{
          'Authorization': 'Bearer ${await _data.accessToken}',
          'Content-type': 'application/json; charset=utf-8'
        },
        body: jsonEncode(payload),
      );
      if (jsonCall.statusCode == 200) {
        var jsonString = jsonCall.bodyBytes;
        final response = responseFromJson(utf8.decode(jsonString));
        return response;
      }
      return Future.error(
          'Error AffiliateService : api/v1/affiliate/contents/products');
    } catch (e) {
      print('error api/v1/affiliate/contents/products : $e');
      return Future.error("$e  from api/v1/affiliate/contents/products");
    }
  }

  Future<Response?> createCategory({
    required String categoryName,
    required List<int> products,
  }) async {
    var url = Uri.parse("${b2c_api_url}api/v1/affiliate/contents/categories");

    final payload = {"category_name": categoryName, "products": products};

    try {
      var jsonCall = await AuthFetch.post(
        url,
        headers: <String, String>{
          'Authorization': 'Bearer ${await _data.accessToken}',
          'Content-type': 'application/json; charset=utf-8'
        },
        body: jsonEncode(payload),
      );
      if (jsonCall.statusCode == 200) {
        var jsonString = jsonCall.bodyBytes;
        final response = responseFromJson(utf8.decode(jsonString));
        return response;
      }
      return Future.error(
          'Error AffiliateService : api/v1/affiliate/contents/categories');
    } catch (e) {
      print('error api/v1/affiliate/contents/categories : $e');
      return Future.error("$e  from api/v1/affiliate/contents/categories");
    }
  }

  Future<AffiliateProfile?> getProfile() async {
    var url = Uri.parse("${b2c_api_url}api/v1/affiliate/profile");

    try {
      var jsonCall = await AuthFetch.get(
        url,
        headers: <String, String>{
          'Authorization': 'Bearer ${await _data.accessToken}',
          'Content-type': 'application/json; charset=utf-8'
        },
      );
      if (jsonCall.statusCode == 200) {
        var jsonString = jsonCall.bodyBytes;
        final response = affiliateProfileFromJson(utf8.decode(jsonString));
        return response;
      }
      return Future.error('Error AffiliateService : api/v1/affiliate/profile');
    } catch (e) {
      print('error api/v1/affiliate/profile : $e');
      return Future.error("$e  from api/v1/affiliate/profile");
    }
  }

  Future<Response?> updateProfile({
    String? username, // product, image, video, text
    String? shopName,
    String? email,
    String? mobile,
    File? cover,
    File? avatar,
  }) async {
    var url = Uri.parse("${b2c_api_url}api/v1/affiliate/profile/update");

    try {
      // final token = await _data.accessToken;
      final info = <String, dynamic>{
        "store_name": shopName,
        "email": email,
        "phone": mobile,
        "user_name": username,
      };
      final fields = <String, String>{
        "info": jsonEncode(info),
      };

      // --- form-data: files ---
      final List<http.MultipartFile> parts = <http.MultipartFile>[];

      if (cover != null && cover.path.isNotEmpty) {
        parts.add(await http.MultipartFile.fromPath('cover_image', cover.path));
      }

      if (avatar != null && avatar.path.isNotEmpty) {
        parts.add(await http.MultipartFile.fromPath('logo_image', avatar.path));
      }

      var streamed = await AuthFetch.multipartRequestWithAuth(
        url,
        method: 'PATCH',
        headers: {
          'Content-Type': 'multipart/form-data',
        },
        fields: fields,
        files: parts,
      );

      final body = await streamed.stream.bytesToString();

      if (streamed.statusCode >= 200 && streamed.statusCode < 300) {
        return responseFromJson(body);
      }
      return Future.error(
        'Error AffiliateService : api/v1/affiliate/contents '
        '-> ${streamed.statusCode} : $body',
      );
    } catch (e) {
      print('error api/v1/affiliate/contents : $e');
      return Future.error("$e  from api/v1/affiliate/contents");
    }
  }

  Future<PaymentInfo?> getPaymentInfo() async {
    var url = Uri.parse("${b2c_api_url}api/v1/affiliate/account/payment/info");

    try {
      var jsonCall = await AuthFetch.get(
        url,
        headers: <String, String>{
          'Authorization': 'Bearer ${await _data.accessToken}',
          'Content-type': 'application/json; charset=utf-8'
        },
      );
      if (jsonCall.statusCode == 200) {
        var jsonString = jsonCall.bodyBytes;
        final response = paymentInfoFromJson(utf8.decode(jsonString));
        return response;
      }
      return Future.error(
          'Error AffiliateService : api/v1/affiliate/account/payment/info');
    } catch (e) {
      print('error api/v1/affiliate/account/payment/info : $e');
      return Future.error("$e  from api/v1/affiliate/account/payment/info");
    }
  }

  // for update
  Future<Response?> setPaymentInfo({
    Map<String, Object?>? accountInfo,
    Map<String, Object?>? bankInfo,
    Map<String, Object?>? taxInfo,
    File? bookBank,
    File? idCard,
  }) async {
    var url =
        Uri.parse("${b2c_api_url}api/v1/affiliate/account/payment/settings");

    try {
      final fields = <String, String>{
        if (accountInfo != null) "account_info": jsonEncode(accountInfo),
        if (bankInfo != null) "bank_info": jsonEncode(bankInfo),
        if (taxInfo != null) "tax_info": jsonEncode(taxInfo),
      };

      final List<http.MultipartFile> parts = <http.MultipartFile>[];

      if (bookBank != null && bookBank.path.isNotEmpty) {
        parts
            .add(await http.MultipartFile.fromPath('book_bank', bookBank.path));
      }

      if (idCard != null && idCard.path.isNotEmpty) {
        parts.add(await http.MultipartFile.fromPath('id_card', idCard.path));
      }

      var streamed = await AuthFetch.multipartRequestWithAuth(
        url,
        method: 'POST',
        headers: {
          'Content-Type': 'multipart/form-data',
        },
        fields: fields,
        files: parts,
      );

      final body = await streamed.stream.bytesToString();

      if (streamed.statusCode >= 200 && streamed.statusCode < 300) {
        return responseFromJson(body);
      }
      return Future.error(
        'Error AffiliateService : api/v1/affiliate/account/payment/settings '
        '-> ${streamed.statusCode} : $body',
      );
    } catch (e) {
      print('error api/v1/affiliate/account/payment/settings : $e');
      return Future.error("$e  from api/v1/affiliate/account/payment/settings");
    }
  }

  Future<AffiliateContent?> getAffiliateContent({
    required String page, //page: view, modify
    required String target, //target_type: content, category
    required int contentId, //id กรณีที่อยากดูเป็นรายตัว 0 = ทั้งหมด
  }) async {
    var url = Uri.parse("${b2c_api_url}api/v1/affiliate/contents");

    final payload = {"page": page, "target_type": target, "id": contentId};

    try {
      var jsonCall = await AuthFetch.get(
        url,
        headers: <String, String>{
          'Authorization': 'Bearer ${await _data.accessToken}',
          'Content-type': 'application/json; charset=utf-8'
        },
        body: jsonEncode(payload),
      );
      if (jsonCall.statusCode == 200) {
        var jsonString = jsonCall.bodyBytes;
        final response = affiliateContentFromJson(utf8.decode(jsonString));
        return response;
      }
      return Future.error('Error AffiliateService : api/v1/affiliate/profile');
    } catch (e) {
      print('error api/v1/affiliate/profile : $e');
      return Future.error("$e  from api/v1/affiliate/profile");
    }
  }

  Future<AffiliateProductList?> getAffiliateProduct({
    required String page, //page: view, modify
    required String sortBy, //sales, price, ctime
    required String orderBy, //desc, asc
    required int limit,
    required int offset,
  }) async {
    var url = Uri.parse("${b2c_api_url}api/v1/affiliate/products/store");

    final payload = {
      "page": page,
      "sort_by": sortBy,
      "order": orderBy,
      "limit": limit,
      "offset": offset
    };

    try {
      var jsonCall = await AuthFetch.post(
        url,
        headers: <String, String>{
          'Authorization': 'Bearer ${await _data.accessToken}',
          'Content-type': 'application/json; charset=utf-8'
        },
        body: jsonEncode(payload),
      );
      if (jsonCall.statusCode == 200) {
        var jsonString = jsonCall.bodyBytes;
        final response = affiliateProductListFromJson(utf8.decode(jsonString));
        return response;
      }
      return Future.error('Error AffiliateService : api/v1/affiliate/profile');
    } catch (e) {
      print('error api/v1/affiliate/profile : $e');
      return Future.error("$e  from api/v1/affiliate/profile");
    }
  }

  Future<AffiliateProductList?> getFilterProduct({
    required String target, // target_type: content, category, product
    required int categoryId,
    required int brandId,
    required int storeId,
    required String commission, // name of option
    required String seachKey,
    required int limit,
    required int offset,
  }) async {
    var url = Uri.parse("${b2c_api_url}api/v1/affiliate/products/filter");

    final payload = {
      "target_type": target,
      "category_id": categoryId,
      "brand_id": brandId,
      "store_id": storeId,
      "commission": commission,
      "keyword": seachKey,
      "limit": limit,
      "offset": offset
    };

    try {
      var jsonCall = await AuthFetch.post(
        url,
        headers: <String, String>{
          'Authorization': 'Bearer ${await _data.accessToken}',
          'Content-type': 'application/json; charset=utf-8'
        },
        body: jsonEncode(payload),
      );
      if (jsonCall.statusCode == 200) {
        var jsonString = jsonCall.bodyBytes;
        final response = affiliateProductListFromJson(utf8.decode(jsonString));
        return response;
      }
      return Future.error('Error AffiliateService : api/v1/affiliate/profile');
    } catch (e) {
      print('error api/v1/affiliate/profile : $e');
      return Future.error("$e  from api/v1/affiliate/profile");
    }
  }

  Future<Response?> sortContent({
    required String target, // target_type: contents, categories,
    required int contentId,
  }) async {
    final contentUrl = '${b2c_api_url}api/v1/affiliate/contents/sort/';
    final categoryUrl =
        '${b2c_api_url}api/v1/affiliate/contents/categories/sort/';

    var url = Uri.parse(target == 'categories'
        ? '$categoryUrl$contentId'
        : '$contentUrl$contentId');

    try {
      var jsonCall = await AuthFetch.patch(
        url,
        headers: <String, String>{
          'Authorization': 'Bearer ${await _data.accessToken}',
          'Content-type': 'application/json; charset=utf-8'
        },
      );
      if (jsonCall.statusCode == 200) {
        var jsonString = jsonCall.bodyBytes;
        final response = responseFromJson(utf8.decode(jsonString));
        return response;
      }
      return Future.error('Error AffiliateService : sortContent');
    } catch (e) {
      print('error sortContent : $e');
      return Future.error("$e  from sortContent");
    }
  }

  Future<Response?> hideContent({
    required String target, // target_type: contents, categories,
    required String status,
    required int contentId,
  }) async {
    var url = Uri.parse("${b2c_api_url}api/v1/affiliate/contents/status");

    final payload = {"target_type": target, "status": status, "id": contentId};

    try {
      var jsonCall = await AuthFetch.patch(
        url,
        headers: <String, String>{
          'Authorization': 'Bearer ${await _data.accessToken}',
          'Content-type': 'application/json; charset=utf-8'
        },
        body: jsonEncode(payload),
      );
      if (jsonCall.statusCode == 200) {
        var jsonString = jsonCall.bodyBytes;
        final response = responseFromJson(utf8.decode(jsonString));
        return response;
      }
      return Future.error('Error AffiliateService : sortContent');
    } catch (e) {
      print('error sortContent : $e');
      return Future.error("$e  from sortContent");
    }
  }

  Future<Response?> hideProduct(
      {required String status,
      required int productId,
      required int contentId}) async {
    var url =
        Uri.parse("${b2c_api_url}api/v1/affiliate/contents/products/status");

    final payload = {
      "target_type": 'product',
      "status": status,
      "id": contentId,
      "product_id": productId
    };

    try {
      var jsonCall = await AuthFetch.patch(
        url,
        headers: <String, String>{
          'Authorization': 'Bearer ${await _data.accessToken}',
          'Content-type': 'application/json; charset=utf-8'
        },
        body: jsonEncode(payload),
      );
      if (jsonCall.statusCode == 200) {
        var jsonString = jsonCall.bodyBytes;
        final response = responseFromJson(utf8.decode(jsonString));
        return response;
      }
      return Future.error('Error AffiliateService : sortContent');
    } catch (e) {
      print('error sortContent : $e');
      return Future.error("$e  from sortContent");
    }
  }

  Future<AffiliateRecommendProductList?> getRecommendProduct({
    required int limit,
    required int offset,
  }) async {
    var url = Uri.parse("${b2c_api_url}api/v1/affiliate/products/recommend");

    final payload = {"limit": limit, "offset": offset};

    try {
      var jsonCall = await AuthFetch.post(
        url,
        headers: <String, String>{
          'Authorization': 'Bearer ${await _data.accessToken}',
          'Content-type': 'application/json; charset=utf-8'
        },
        body: jsonEncode(payload),
      );
      if (jsonCall.statusCode == 200) {
        var jsonString = jsonCall.bodyBytes;
        final response =
            affiliateRecommendProductListFromJson(utf8.decode(jsonString));
        return response;
      }
      return Future.error('Error AffiliateService : api/v1/affiliate/profile');
    } catch (e) {
      print('error api/v1/affiliate/profile : $e');
      return Future.error("$e  from api/v1/affiliate/profile");
    }
  }

  Future<CommissionBalance?> getCommissionBalance() async {
    var url = Uri.parse("${b2c_api_url}api/v1/affiliate/commissions/balance");

    try {
      var jsonCall = await AuthFetch.get(
        url,
        headers: <String, String>{
          'Authorization': 'Bearer ${await _data.accessToken}',
          'Content-type': 'application/json; charset=utf-8'
        },
      );
      if (jsonCall.statusCode == 200) {
        var jsonString = jsonCall.bodyBytes;
        final response = commissionBalanceFromJson(utf8.decode(jsonString));
        return response;
      }
      return Future.error(
          'Error AffiliateService : api/v1/affiliate/commissions/balance');
    } catch (e) {
      print('error api/v1/affiliate/commissions/balance : $e');
      return Future.error("$e  from api/v1/affiliate/commissions/balance");
    }
  }

  Future<AffiliateSummaryOrder?> getSummaryOrder({
    required String page, // page: orders, earnings
    String? period,
    String? str,
    String? end,
  }) async {
    var url = Uri.parse("${b2c_api_url}api/v1/affiliate/commissions/summary");

    final payload = {
      "page": page,
      if (period != null) "period": period,
      if (str != null) "start_time": str,
      if (end != null) "end_time": end
    };

    try {
      var jsonCall = await AuthFetch.post(
        url,
        headers: <String, String>{
          'Authorization': 'Bearer ${await _data.accessToken}',
          'Content-type': 'application/json; charset=utf-8'
        },
        body: jsonEncode(payload),
      );
      if (jsonCall.statusCode == 200) {
        var jsonString = jsonCall.bodyBytes;
        final response = affiliateSummaryOrderFromJson(utf8.decode(jsonString));
        return response;
      }
      return Future.error(
          'Error AffiliateService : api/v1/affiliate/commissions/summary');
    } catch (e) {
      print('error api/v1/affiliate/commissions/summary : $e');
      return Future.error("$e  from api/v1/affiliate/commissions/summary");
    }
  }

  Future<AffiliateSummaryEarning?> getSummaryEarning({
    required String page, // page: orders, earnings
    String? period,
    String? str,
    String? end,
  }) async {
    var url = Uri.parse("${b2c_api_url}api/v1/affiliate/commissions/summary");

    final payload = {
      "page": page,
      if (period != null) "period": period,
      if (str != null) "start_time": str,
      if (end != null) "end_time": end
    };

    try {
      var jsonCall = await AuthFetch.post(
        url,
        headers: <String, String>{
          'Authorization': 'Bearer ${await _data.accessToken}',
          'Content-type': 'application/json; charset=utf-8'
        },
        body: jsonEncode(payload),
      );
      if (jsonCall.statusCode == 200) {
        var jsonString = jsonCall.bodyBytes;
        final response =
            affiliateSummaryEarningFromJson(utf8.decode(jsonString));
        return response;
      }
      return Future.error(
          'Error AffiliateService : api/v1/affiliate/commissions/summary');
    } catch (e) {
      print('error api/v1/affiliate/commissions/summary : $e');
      return Future.error("$e  from api/v1/affiliate/commissions/summary");
    }
  }

  Future<AffiliateCondition?> getCommissionCondition() async {
    var url = Uri.parse("${b2c_api_url}api/v1/affiliate/commissions/rules");

    try {
      var jsonCall = await AuthFetch.get(
        url,
        headers: <String, String>{
          'Authorization': 'Bearer ${await _data.accessToken}',
          'Content-type': 'application/json; charset=utf-8'
        },
      );
      if (jsonCall.statusCode == 200) {
        var jsonString = jsonCall.bodyBytes;
        final response = affiliateConditionFromJson(utf8.decode(jsonString));
        return response;
      }
      return Future.error(
          'Error AffiliateService : api/v1/affiliate/commissions/rules');
    } catch (e) {
      print('error api/v1/affiliate/commissions/rules : $e');
      return Future.error("$e  from api/v1/affiliate/commissions/rules");
    }
  }

  Future<AffiliateOrderDetail?> getCommissionOrderDetail(
      {required String date}) async {
    var url = Uri.parse("${b2c_api_url}api/v1/affiliate/commissions/orders");

    final payload = {"start_time": date};

    try {
      var jsonCall = await AuthFetch.post(
        url,
        headers: <String, String>{
          'Authorization': 'Bearer ${await _data.accessToken}',
          'Content-type': 'application/json; charset=utf-8'
        },
        body: jsonEncode(payload),
      );
      if (jsonCall.statusCode == 200) {
        var jsonString = jsonCall.bodyBytes;
        final response = affiliateOrderDetailFromJson(utf8.decode(jsonString));
        return response;
      }
      return Future.error(
          'Error AffiliateService : api/v1/affiliate/commissions/orders');
    } catch (e) {
      print('error api/v1/affiliate/commissions/orders : $e');
      return Future.error("$e  from api/v1/affiliate/commissions/orders");
    }
  }

  Future<AffiliateEarningDetail?> getCommissionEarningDetail(
      {required String date}) async {
    var url = Uri.parse("${b2c_api_url}api/v1/affiliate/commissions/earnings");

    final payload = {"start_time": date};

    try {
      var jsonCall = await AuthFetch.post(
        url,
        headers: <String, String>{
          'Authorization': 'Bearer ${await _data.accessToken}',
          'Content-type': 'application/json; charset=utf-8'
        },
        body: jsonEncode(payload),
      );
      if (jsonCall.statusCode == 200) {
        var jsonString = jsonCall.bodyBytes;
        final response =
            affiliateEarningDetailFromJson(utf8.decode(jsonString));
        return response;
      }
      return Future.error(
          'Error AffiliateService : api/v1/affiliate/commissions/earnings');
    } catch (e) {
      print('error api/v1/affiliate/commissions/earnings : $e');
      return Future.error("$e  from api/v1/affiliate/commissions/earnings");
    }
  }

  Future<DashBoardOverview?> getDbOverview(
      {String? period, String? str, String? end}) async {
    var url = Uri.parse("${b2c_api_url}api/v1/affiliate/dashboards/overview");

    final payload = {"period": period, "start_time": str, "end_time": end};

    try {
      var jsonCall = await AuthFetch.post(
        url,
        headers: <String, String>{
          'Authorization': 'Bearer ${await _data.accessToken}',
          'Content-type': 'application/json; charset=utf-8'
        },
        body: jsonEncode(payload),
      );
      if (jsonCall.statusCode == 200) {
        var jsonString = jsonCall.bodyBytes;
        final response = dashBoardOverviewFromJson(utf8.decode(jsonString));
        return response;
      }
      return Future.error(
          'Error AffiliateService : api/v1/affiliate/commissions/earnings');
    } catch (e) {
      print('error api/v1/affiliate/commissions/earnings : $e');
      return Future.error("$e  from api/v1/affiliate/commissions/earnings");
    }
  }

  Future<AccountSummary?> getAccountSummary() async {
    var url = Uri.parse("${b2c_api_url}api/v1/affiliate/profile/summary");

    try {
      var jsonCall = await AuthFetch.get(
        url,
        headers: <String, String>{
          'Authorization': 'Bearer ${await _data.accessToken}',
          'Content-type': 'application/json; charset=utf-8'
        },
      );
      if (jsonCall.statusCode == 200) {
        var jsonString = jsonCall.bodyBytes;
        final response = accountSummaryFromJson(utf8.decode(jsonString));
        return response;
      }
      return Future.error(
          'Error AffiliateService : api/v1/affiliate/profile/summary');
    } catch (e) {
      print('error api/v1/affiliate/profile/summary : $e');
      return Future.error("$e  from api/v1/affiliate/profile/summary");
    }
  }

  Future<AffiliateTips?> getAffiliateTips() async {
    var url = Uri.parse("${b2c_api_url}api/v1/affiliate/tips");

    try {
      var jsonCall = await AuthFetch.get(
        url,
        headers: <String, String>{
          'Authorization': 'Bearer ${await _data.accessToken}',
          'Content-type': 'application/json; charset=utf-8'
        },
      );
      if (jsonCall.statusCode == 200) {
        var jsonString = jsonCall.bodyBytes;
        final response = affiliateTipsFromJson(utf8.decode(jsonString));
        return response;
      }
      return Future.error('Error AffiliateService : api/v1/affiliate/tips');
    } catch (e) {
      print('error api/v1/affiliate/tips : $e');
      return Future.error("$e  from api/v1/affiliate/tips");
    }
  }

  Future<DashBoardProducts?> getDbProductPerformance(
      {String? period,
      String? str,
      String? end,
      int? categoryId,
      String? orderBy, // DESC, ASC
      String? keyword, // search
      int? limit,
      int? offset}) async {
    var url = Uri.parse(
        "${b2c_api_url}api/v1/affiliate/dashboards/products/performance");

    final payload = {
      "period": period,
      "start_time": str,
      "end_time": end,
      "category_id": categoryId,
      "order_by": orderBy,
      "keyword": keyword,
      "limit": limit,
      "offset": offset
    };

    try {
      var jsonCall = await AuthFetch.post(
        url,
        headers: <String, String>{
          'Authorization': 'Bearer ${await _data.accessToken}',
          'Content-type': 'application/json; charset=utf-8'
        },
        body: jsonEncode(payload),
      );
      if (jsonCall.statusCode == 200) {
        var jsonString = jsonCall.bodyBytes;
        final response = dashBoardProductsFromJson(utf8.decode(jsonString));
        return response;
      }
      return Future.error(
          'Error AffiliateService : api/v1/affiliate/commissions/earnings');
    } catch (e) {
      print('error api/v1/affiliate/commissions/earnings : $e');
      return Future.error("$e  from api/v1/affiliate/commissions/earnings");
    }
  }

  Future<ShareResponse?> getShare({
    required String shareType,
    required int? productId,
    required String channel,
    required int? categoryId,
  }) async {
    var url = Uri.parse("${b2c_api_url}api/v1/share");

    final payload = {
      "share_type": shareType, // category , // store // product
      if (productId != null && shareType == 'product') "product_id": productId,
      "channel": channel,
      if (categoryId != null) "category_id": categoryId
    };

    try {
      var jsonCall = await AuthFetch.post(
        url,
        headers: <String, String>{
          'Authorization': 'Bearer ${await _data.accessToken}',
          'Content-type': 'application/json; charset=utf-8'
        },
        body: jsonEncode(payload),
      );
      if (jsonCall.statusCode == 200) {
        var jsonString = jsonCall.bodyBytes;
        final response = shareResponseFromJson(utf8.decode(jsonString));
        return response;
      }
      return Future.error('Error AffiliateService : api/v1/share');
    } catch (e) {
      print('error api/v1/share : $e');
      return Future.error("$e  from api/v1/share");
    }
  }
}
