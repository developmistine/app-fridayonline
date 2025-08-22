import 'package:fridayonline/member/components/webview/webview.dart';
import 'package:fridayonline/member/enduser.main.dart';
import 'package:fridayonline/member/views/(brand)/brand.store.dart';
import 'package:fridayonline/member/views/(cart)/cart.main.dart';
import 'package:fridayonline/member/views/(initials)/home/home.view.dart';
import 'package:fridayonline/member/views/(search)/search.result.dart';
import 'package:fridayonline/member/views/(search)/search.view.dart';
import 'package:fridayonline/member/views/(showproduct)/show.sku.view.dart';
import 'package:fridayonline/splashscreen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

List<GetPage<dynamic>> router = [
  GetPage(
      name: '/EndUserHomePage',
      page: () => const EndUserHomePage(),
      transition: Transition.fadeIn),
  GetPage(
      name: '/', page: () => const SplashScreen(), transition: Transition.fade),
  // b2c
  GetPage(name: "/EndUserCart", page: () => const EndUserCart()),
  GetPage(name: "/EndUserSearch", page: () => const EndUserSearch()),
  GetPage(
      name: "/EndUserSearchResult", page: () => const EndUserSearchResult()),
  GetPage(name: "/EndUserHome", page: () => EndUserHome()),
  GetPage(
      name: '/ShowProductSku/:id',
      page: () => const ShowProductSku(),
      curve: Curves.linear,
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 250)),
  GetPage(
      name: '/BrandStore/:id',
      page: () => Store(
            storeId: Get.parameters['id']!,
          )),
  GetPage(name: '/WebViewApp', page: () => const WebViewApp()),
];
