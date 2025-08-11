import 'package:fridayonline/analytics/analytics_engine.dart';
import 'package:fridayonline/controller/point_rewards/point_rewards_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../controller/cart/cart_controller.dart';
import '../../controller/cart/dropship_controller.dart';
import '../../model/set_data/set_data.dart';
import '../pageactivity/cart_activity.dart';
import '../theme/theme_color.dart';
import '../theme/themeimage_menu.dart';
import 'package:badges/badges.dart' as badges;

class CartIconButton extends StatelessWidget {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  final data = SetData();
  final loading = Get.find<FetchCartItemsController>();
  CartIconButton({
    super.key,
    this.icon,
  });
  final Image? icon;
  // FetchCartItemsController cartListItems = Get.put(FetchCartItemsController());
  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context)
          .copyWith(textScaler: const TextScaler.linear(1.0)),
      child: GetBuilder<FetchCartItemsController>(builder: (direcsale) {
        return GetBuilder<FetchCartDropshipController>(builder: (dropship) {
          return InkWell(
            onTap: () async {
              if (!direcsale.isDataLoading.value &&
                  !dropship.isDataLoading.value) {
                final SharedPreferences prefs = await _prefs;
                if (prefs.getString("login") == '1') {
                  if (prefs.getString("ShowcaseCart") == '1') {
                    AnalyticsEngine.sendAnalyticsEvent(
                        'click_cart',
                        await data.repCode,
                        await data.repSeq,
                        await data.repType);
                    Get.to(() => const Cart());
                  } else {
                    Get.put(FetchAddressDropshipController())
                        .fetchDropshipAddress();
                    Get.toNamed('/show_case_cart_activity');
                    prefs.setString("ShowcaseCart", '1');
                  }
                } else {
                  Get.to(() => const Cart());
                  // Get.toNamed('/cart_activity');
                }
              }
            },
            child: GetX<FetchCartItemsController>(builder: (cartListItems) {
              return badges.Badge(
                  position: badges.BadgePosition.topEnd(top: 0, end: 0),
                  badgeAnimation: badges.BadgeAnimation.slide(
                      loopAnimation: loading.isDataLoading.value),
                  badgeContent: loading.isDataLoading.value
                      ? Text(
                          // textAlign: TextAlign.center,
                          cartListItems.itemsCartList == null
                              ? "0"
                              : "${cartListItems.itemsCartList!.cardHeader.totalitem + cartListItems.itemsCartList!.cardHeader.carddetailB2C.map((e) => e.carddetail).length}",
                          //? fade dropship
                          // "${cartListItems.itemsCartList!.cardHeader.totalitem + dropship.itemDropship!.cartHeader.totalItem}",
                          style: TextStyle(
                              inherit: false,
                              color:
                                  icon == null ? theme_color_df : Colors.white,
                              fontSize: 12),
                        )
                      : Text(
                          // textAlign: TextAlign.center,
                          "${cartListItems.itemsCartList!.cardHeader.totalitem + cartListItems.itemsCartList!.cardHeader.carddetailB2C.map((e) => e.carddetail).length}",
                          //? fade dropship
                          // "${cartListItems.itemsCartList!.cardHeader.totalitem + dropship.itemDropship!.cartHeader.totalItem}",
                          style: TextStyle(
                              inherit: false,
                              color:
                                  icon == null ? theme_color_df : Colors.white,
                              fontSize: 12),
                        ),
                  badgeStyle: badges.BadgeStyle(
                      badgeColor: icon != null ? theme_color_df : Colors.white,
                      padding: const EdgeInsets.all(6)),
                  child: IconButton(
                    onPressed: () async {
                      if (!direcsale.isDataLoading.value) {
                        final SharedPreferences prefs = await _prefs;
                        if (prefs.getString("login") == '1') {
                          if (prefs.getString("ShowcaseCart") == '1') {
                            Get.put(FetchAddressDropshipController())
                                .fetchDropshipAddress();
                            Get.put(SearchPointRewardsController())
                                .getAddressUser();
                            Get.to(() => const Cart());
                            // Get.toNamed('/cart_activity');
                          } else {
                            Get.put(SearchPointRewardsController())
                                .getAddressUser();
                            Get.put(FetchAddressDropshipController())
                                .fetchDropshipAddress();
                            Get.toNamed('/show_case_cart_activity');
                            prefs.setString("ShowcaseCart", '1');
                          }
                        } else {
                          Get.to(() => const Cart());
                          // Get.toNamed('/cart_activity');
                        }
                      }
                    },
                    icon: SizedBox(
                        width: 25, height: 25, child: icon ?? ImageCart),
                  ));
            }),
          );
        });
      }),
    );
    // });
  }
}
