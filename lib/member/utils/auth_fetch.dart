import 'dart:convert';
import 'package:fridayonline/member/controller/chat.ctr.dart';
import 'package:fridayonline/print.dart';
import 'package:fridayonline/service/pathapi.dart';
import 'package:fridayonline/splashscreen.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthFetch {
  static bool _isRefreshing = false;
  static Future<String?>? _refreshPromise;

  static Future<http.Response> fetchWithAuth(
    Uri url, {
    String method = 'GET',
    Map<String, String>? headers,
    Object? body,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString('accessToken');

    Map<String, String> requestHeaders = {
      'Authorization': 'Bearer $accessToken',
      ...?headers,
    };

    final request = http.Request(method, url);
    request.headers.addAll(requestHeaders);
    if (body != null) {
      request.body = body.toString();
    }
    http.StreamedResponse streamedResponse = await request.send();
    http.Response response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 401) {
      if (!_isRefreshing) {
        _isRefreshing = true;
        _refreshPromise = _refreshAccessToken();
      }

      try {
        final newToken = await _refreshPromise;
        _isRefreshing = false;
        _refreshPromise = null;

        if (newToken != null && newToken.isNotEmpty) {
          requestHeaders['Authorization'] = 'Bearer $newToken';
          // Retry the request with new token
          final retryRequest = http.Request(method, url);
          retryRequest.headers.addAll(requestHeaders);
          if (body != null) {
            retryRequest.body = body.toString();
          }
          http.StreamedResponse retryStreamedResponse =
              await retryRequest.send();
          response = await http.Response.fromStream(retryStreamedResponse);
        }
      } catch (e) {
        _isRefreshing = false;
        _refreshPromise = null;
        print('Error refreshing token: $e');
      }
    }

    return response;
  }

  // Convenience methods for common HTTP operations
  static Future<http.Response> get(
    Uri url, {
    Map<String, String>? headers,
  }) =>
      fetchWithAuth(url, method: 'GET', headers: headers);

  static Future<http.Response> post(
    Uri url, {
    Map<String, String>? headers,
    Object? body,
    Encoding? encoding,
  }) =>
      fetchWithAuth(
        url,
        method: 'POST',
        headers: headers,
        body: body,
      );

  static Future<http.Response> put(
    Uri url, {
    Map<String, String>? headers,
    Object? body,
  }) =>
      fetchWithAuth(
        url,
        method: 'PUT',
        headers: headers,
        body: body,
      );

  static Future<http.Response> patch(
    Uri url, {
    Map<String, String>? headers,
    Object? body,
  }) =>
      fetchWithAuth(
        url,
        method: 'PATCH',
        headers: headers,
        body: body,
      );

  static Future<http.Response> delete(
    Uri url, {
    Map<String, String>? headers,
  }) =>
      fetchWithAuth(url, method: 'DELETE', headers: headers);

  // Method สำหรับ Multipart Request
  static Future<http.StreamedResponse> multipartRequestWithAuth(
    Uri url, {
    required String method,
    Map<String, String>? headers,
    Map<String, String>? fields,
    List<http.MultipartFile>? files,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString('accessToken');

    Map<String, String> requestHeaders = {
      'Authorization': 'Bearer $accessToken',
      ...?headers,
    };

    // สร้าง multipart request
    var request = http.MultipartRequest(method, url);
    request.headers.addAll(requestHeaders);

    // เพิ่ม fields
    if (fields != null) {
      request.fields.addAll(fields);
    }

    // เพิ่ม files
    if (files != null) {
      request.files.addAll(files);
    }

    var response = await request.send();

    // ถ้าได้ 401 ให้ refresh token และลองใหม่
    if (response.statusCode == 401) {
      if (!_isRefreshing) {
        _isRefreshing = true;
        _refreshPromise = _refreshAccessToken();
      }

      try {
        final newToken = await _refreshPromise;
        _isRefreshing = false;
        _refreshPromise = null;

        if (newToken != null && newToken.isNotEmpty) {
          requestHeaders['Authorization'] = 'Bearer $newToken';

          // สร้าง request ใหม่ด้วย token ใหม่
          var retryRequest = http.MultipartRequest(method, url);
          retryRequest.headers.addAll(requestHeaders);

          if (fields != null) {
            retryRequest.fields.addAll(fields);
          }

          if (files != null) {
            retryRequest.files.addAll(files);
          }

          response = await retryRequest.send();
        }
      } catch (e) {
        _isRefreshing = false;
        _refreshPromise = null;
        print('Error refreshing token: $e');
      }
    }

    return response;
  }

  static Future<String?> _refreshAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    String? refreshToken = prefs.getString('refreshToken');

    try {
      final response = await http.post(
        //! dev_api_b2c , b2c_api_url
        Uri.parse('${b2c_api_url}refresh'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'refresh_token': refreshToken,
        }),
      );
      printWhite('เริ่มใช้งาน refresh token');
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['access_token'] != null &&
            data['access_token'].toString().isNotEmpty &&
            data['refresh_token'] != null &&
            data['refresh_token'].toString().isNotEmpty) {
          await prefs.setString('accessToken', data['access_token']);
          await prefs.setString('refreshToken', data['refresh_token']);

          return data['access_token'];
        } else {
          await initGuestToken();
        }
      } else {
        await initGuestToken();
      }
    } catch (e) {
      await initGuestToken();
    }
    return null;
  }

  static initGuestToken() async {
    final Future<SharedPreferences> pref = SharedPreferences.getInstance();

    await pref.then((SharedPreferences prefs) async {
      // 1. เก็บ sessionId ไว้ก่อน
      String? sessionId = prefs.getString("sessionId");
      String? lastActive = prefs.getString('lastActiveTime');
      String? deviceId = prefs.getString('deviceId');

      // 2. ลบทุก key ทีละตัว (ไม่ใช้ clear())
      final keys = prefs.getKeys();
      for (String key in keys) {
        if (key != "sessionId" &&
            key != 'lastActiveTime' &&
            key != 'deviceId' &&
            key != 'branch_first_processed' &&
            key != 'last_processed_click_timestamp') {
          await prefs.remove(key);
        }
      }

      Get.find<WebSocketController>().onClose();

      // 3. ถ้าอยากให้ชัวร์ set sessionId กลับอีกทีก็ได้ (option)
      if (sessionId != null) {
        await prefs.setString("sessionId", sessionId);
      }
      if (lastActive != null) {
        await prefs.setString('lastActiveTime', lastActive);
      }
      if (deviceId != null) {
        await prefs.setString('deviceId', deviceId);
      }
    });

    Get.offAll(() => const SplashScreen());
    return;
  }
}
