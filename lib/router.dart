import 'package:fridayonline/enduser/enduser.main.dart';
import 'package:fridayonline/enduser/views/(brand)/brand.store.dart';
import 'package:fridayonline/enduser/views/(cart)/cart.main.dart';
import 'package:fridayonline/enduser/views/(initials)/home/home.view.dart';
import 'package:fridayonline/enduser/views/(search)/search.result.dart';
import 'package:fridayonline/enduser/views/(search)/search.view.dart';
import 'package:fridayonline/enduser/views/(showproduct)/show.sku.view.dart';
import 'package:fridayonline/homepage/category/category_page/category_list_product.dart';
import 'package:fridayonline/homepage/catelog/catelog_detail.dart';
import 'package:fridayonline/homepage/catelog/catelog_list_product.dart';
import 'package:fridayonline/homepage/check_information/delivery_status/delivery_status.dart';
import 'package:fridayonline/homepage/check_information/delivery_status/delivery_status_detail.dart';
import 'package:fridayonline/homepage/check_information/delivery_status/delivery_status_express_sales_detail.dart';
import 'package:fridayonline/homepage/check_information/enduser/enduser_check_information.dart';
import 'package:fridayonline/homepage/check_information/lead/lead_check_all.dart';
import 'package:fridayonline/homepage/check_information/order/order_order.dart';
import 'package:fridayonline/homepage/check_information/order_history/express_sales_detail.dart';
import 'package:fridayonline/homepage/check_information/order_history/order_history.dart';
import 'package:fridayonline/homepage/check_information/order_history/order_history_detail.dart';
import 'package:fridayonline/homepage/home/home_special_promotion_bwpoint.dart';
import 'package:fridayonline/homepage/login/anonymous_login.dart';
import 'package:fridayonline/homepage/login/lead_login.dart';
import 'package:fridayonline/homepage/myhomepage.dart';
import 'package:fridayonline/homepage/page_showproduct/Detail_product.dart';
import 'package:fridayonline/homepage/pageactivity/cart_activity.dart';
import 'package:fridayonline/homepage/pageactivity/search_activity.dart';
import 'package:fridayonline/homepage/setting/languages/change_languages.dart';
import 'package:fridayonline/homepage/show_case/cart/show_case_cart_home.dart';
import 'package:fridayonline/homepage/show_case/search/show_case_search.dart';
import 'package:fridayonline/homepage/splashscreen.dart';
import 'package:fridayonline/mslinfo/aboutfriday.dart';
import 'package:fridayonline/mslinfo/address/address.dart';
import 'package:fridayonline/mslinfo/fridaymarket.dart';
import 'package:fridayonline/mslinfo/helpermsl.dart';
import 'package:fridayonline/mslinfo/saledirect.dart';
import 'package:fridayonline/mslinfo/sharecatalog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

List<GetPage<dynamic>> router = [
  GetPage(
      name: '/EndUserHomePage',
      page: () => const EndUserHomePage(),
      transition: Transition.fadeIn),
  GetPage(
      name: '/', page: () => const SplashScreen(), transition: Transition.fade),
  GetPage(name: '/cart_activity', page: () => const Cart()),
  GetPage(name: '/index', page: () => MyHomePage()),
  GetPage(
      name: '/show_case_cart_activity', page: () => const ShowCaseCartHome()),
  GetPage(name: '/search_activity', page: () => const SearchProduct()),
  GetPage(
      name: '/show_case_search_activity',
      page: () => const ShowCaseSearchHome()),
  GetPage(
      name: '/my_list_category',
      page: () => MylistCategory(),
      transition: Transition.rightToLeft),
  GetPage(
      name: '/my_detail',
      page: () => const DetailProduct(),
      transition: Transition.rightToLeft),

  GetPage(
      name: '/special_promotion_bwpoint',
      page: () => const SpecialPromotionBwpoint(),
      transition: Transition.rightToLeft),
  GetPage(
      name: '/catelog_detail',
      page: () => const CatelogDetail(),
      transition: Transition.rightToLeft),
  GetPage(
      name: '/catelog_list_product_page',
      page: () => CatelogListProduct(),
      transition: Transition.rightToLeft),
  GetPage(
      name: '/check_information_order_delivery_status',
      page: () => const CheckInformationDelivery(),
      transition: Transition.rightToLeft),
  GetPage(
      name: '/check_information_delivery_status_detail',
      page: () => const CheckInformationDeliveryStatusDetail(),
      transition: Transition.rightToLeft),
  GetPage(
      name: '/delivery_status_express_sales_detail',
      page: () => const DeliveryStatusExpressSalesDetail(),
      transition: Transition.rightToLeft),
  GetPage(
      name: '/check_information_order',
      page: () => const CheckInformationOrderOrder(),
      transition: Transition.rightToLeft),
  GetPage(
      name: '/check_information_order_history',
      page: () => const CheckInformationHistory(),
      transition: Transition.rightToLeft),
  GetPage(
      name: '/check_information_order_history_detail',
      page: () => const CheckInformationOrderHistoryDetail(),
      transition: Transition.rightToLeft),
  GetPage(
      name: '/check_information_order_history_express_detail',
      page: () => const OrderHistoryExpressSalesDetail(),
      transition: Transition.rightToLeft),
  GetPage(
      name: '/enduser_check_information',
      page: () => const EndUserCheck(),
      transition: Transition.rightToLeft),
  GetPage(
      name: '/lead_check_information',
      page: () => const LeadCheckAll(),
      transition: Transition.rightToLeft),

  //Setting
  GetPage(
      name: '/change_languages',
      page: () => const ChangeLanguage(),
      transition: Transition.rightToLeft), //เปลี่ยนภาษา

  GetPage(name: '/sharecatalog', page: () => const ShareCatalog()),
  GetPage(name: '/editaddress', page: () => const AddressNew()),
  GetPage(name: '/fridaymarket', page: () => const FridayMarket()),
  GetPage(
      name: '/saledirect',
      page: () => const SaleDirect(),
      transition: Transition.rightToLeft),
  GetPage(name: '/backAppbarnotify', page: () => MyHomePage()),
  GetPage(name: '/login', page: () => const Anonumouslogin()),
  GetPage(name: '/aboutfriday', page: () => const AboutFriday()),
  GetPage(name: '/helpermsl', page: () => const HelperMsl()),
  GetPage(name: '/loginLead', page: () => Leadlogin()),
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
];
