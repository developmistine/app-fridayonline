import 'package:fridayonline/controller/cart/cart_controller.dart';
import 'package:fridayonline/homepage/pageactivity/cart/cart_page/cart_order%20summary.dart';
import 'package:fridayonline/homepage/theme/theme_color.dart';
import 'package:fridayonline/homepage/theme/theme_loading.dart';
import 'package:fridayonline/homepage/widget/appbarmaster.dart';
import 'package:fridayonline/model/set_data/set_data.dart';
import 'package:fridayonline/safearea.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';

import '../../controller/cart/dropship_controller.dart';
import '../../controller/cart/function_add_to_cart.dart';
import '../../service/languages/multi_languages.dart';
import 'cart/cart_widget/cart_bottom_confirm.dart';
import 'cart/cart_theme/cart_all_theme.dart';
import 'cart/cart_widget/cart_friday_order.dart';
import 'cart/cart_widget/cart_head_firday.dart';

class Cart extends StatefulWidget {
  const Cart({super.key});

  @override
  State<Cart> createState() => _CartState();
}

class _CartState extends State<Cart> {
  //
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  var inputors = <TextEditingController>[];
  Map<String, TextEditingController> controllers = {};

  List<TextEditingController> inputorsDropship = <TextEditingController>[];
  FetchCartItemsController controller = Get.find<FetchCartItemsController>();
  String? typeUser;

  // bool _enableEdit = true;
  var i = 0;
  @override
  void initState() {
    super.initState();
    if (controller.isChangeLanguage.value) {
      controller.fetch_cart_items();
    }
    //? call ข้อมูล users
    callGetType();
  }

  callGetType() async {
    SetData data = SetData();
    var typeuser = await data.repType;
    setState(() {
      typeUser = typeuser;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context)
          .copyWith(textScaler: const TextScaler.linear(1.0)),
      child: SafeAreaProvider(
        child: Scaffold(
            key: _scaffoldKey,
            backgroundColor: Colors.grey.shade100,
            appBar: appBarTitleMaster(
              MultiLanguages.of(context)!.translate('order_title'),
            ),
            body: GestureDetector(
                onTap: () {
                  FocusScope.of(context).unfocus();
                },
                child: MediaQuery(
                  data: MediaQuery.of(context)
                      .copyWith(textScaler: const TextScaler.linear(1.0)),
                  child: GetBuilder<FetchCartItemsController>(
                      builder: (cartController) {
                    if (!cartController.isDataLoading.value) {
                      var direcSale =
                          cartController.itemsCartList!.cardHeader.carddetail;
                      var suppliers = cartController
                          .itemsCartList!.cardHeader.carddetailB2C;

                      for (int i = 0; i < direcSale.length; i++) {
                        inputors.add(TextEditingController());
                        inputors[i].text = direcSale[i].qty.toString();
                      }
                      for (int i = 0; i < direcSale.length; i++) {
                        inputorsDropship.add(TextEditingController());
                        inputorsDropship[i].text = direcSale[i].qty.toString();
                      }
                      // Initialize controllers for each product
                      for (var supplier in suppliers) {
                        for (var product in supplier.carddetail) {
                          controllers[product.billCode] = TextEditingController(
                            text: product.qtyConfirm.toString(),
                          );
                        }
                      }

                      return RefreshIndicator(
                        color: Colors.amber,
                        onRefresh: () async {
                          await controller.fetch_cart_items();
                          await Get.find<FetchCartDropshipController>()
                              .fetchCartDropship();
                          for (int i = 0;
                              i <
                                  controller.itemsCartList!.cardHeader
                                      .carddetail.length;
                              i++) {
                            inputors.add(TextEditingController());
                            var qtyDirecsale = controller
                                .itemsCartList!.cardHeader.carddetail[i].qty
                                .toString();
                            inputors[i].text = qtyDirecsale;
                          }
                        },
                        child: SingleChildScrollView(
                          physics: const AlwaysScrollableScrollPhysics(
                              parent: BouncingScrollPhysics()),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              if (direcSale.isEmpty && suppliers.isEmpty)
                                Center(
                                  heightFactor: 5,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Image.asset(
                                            'assets/images/logo/logofriday.png',
                                            width: 70),
                                      ),
                                      const Text('ไม่พบสินค้า'),
                                    ],
                                  ),
                                ),
                              //? direcsale
                              direcSale.isNotEmpty
                                  ? Container(
                                      margin: const EdgeInsets.all(8),
                                      clipBehavior: Clip.antiAlias,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        color: Colors.white,
                                      ),
                                      child: Column(
                                        children: [
                                          // head friday
                                          headFriday(
                                              context,
                                              typeUser,
                                              cartController.itemsCartList!
                                                  .cardHeader.deliveryDate),
                                          Divider(
                                            color: theme_color_df,
                                            height: 1,
                                            thickness: 1,
                                          ),
                                          ListView.separated(
                                              padding: EdgeInsets.zero,
                                              physics:
                                                  const NeverScrollableScrollPhysics(),
                                              primary: false,
                                              shrinkWrap: true,
                                              itemCount: cartController
                                                  .itemsCartList!
                                                  .cardHeader
                                                  .carddetail
                                                  .length,
                                              itemBuilder:
                                                  (BuildContext context,
                                                      int index) {
                                                return Slidable(
                                                    endActionPane: ActionPane(
                                                      extentRatio: 0.20,
                                                      motion:
                                                          const ScrollMotion(),
                                                      children: [
                                                        SlidableAction(
                                                          flex: 1,
                                                          onPressed: (s) async {
                                                            Get.find<
                                                                    FetchCartItemsController>()
                                                                .fetch_cart_items();

                                                            await fnEditCart(
                                                                context,
                                                                cartController
                                                                    .itemsCartList!
                                                                    .cardHeader
                                                                    .carddetail[index],
                                                                'cart_page_delete',
                                                                '',
                                                                '',
                                                                ref: 'cart',
                                                                contentId: '');
                                                            inputors.removeAt(
                                                                index);
                                                          },
                                                          backgroundColor:
                                                              theme_red,
                                                          foregroundColor:
                                                              Colors.white,
                                                          icon: Icons.delete,
                                                          label: 'ลบ',
                                                        ),
                                                      ],
                                                    ),
                                                    child: listCart(
                                                        _scaffoldKey,
                                                        context,
                                                        inputors,
                                                        index,
                                                        true));
                                              },
                                              separatorBuilder:
                                                  (BuildContext context,
                                                      int index) {
                                                return Divider(
                                                  color: theme_color_df,
                                                  height: 0,
                                                );
                                              }),
                                          summaryShop(
                                              controller.itemsCartList!
                                                  .cardHeader.carddetail,
                                              context,
                                              typeUser),
                                        ],
                                      ),
                                    )
                                  : Container(),
                              suppliers.isNotEmpty
                                  ? ListView.builder(
                                      padding: EdgeInsets.zero,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      primary: false,
                                      shrinkWrap: true,
                                      itemCount: suppliers.length,
                                      itemBuilder: (BuildContext context,
                                          int supplierIndex) {
                                        final supplier =
                                            suppliers[supplierIndex];
                                        return Container(
                                          margin: const EdgeInsets.only(
                                              bottom: 8, left: 8, right: 8),
                                          clipBehavior: Clip.antiAlias,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            color: Colors.white,
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              headSupplier(
                                                  context,
                                                  typeUser,
                                                  cartController.itemsCartList!
                                                      .cardHeader.deliveryDate,
                                                  supplier),
                                              Divider(
                                                color: theme_color_df,
                                                height: 1,
                                                thickness: 1,
                                              ),
                                              ListView.separated(
                                                  padding: EdgeInsets.zero,
                                                  physics:
                                                      const NeverScrollableScrollPhysics(),
                                                  primary: false,
                                                  shrinkWrap: true,
                                                  itemCount: supplier
                                                      .carddetail.length,
                                                  itemBuilder:
                                                      (BuildContext context,
                                                          int productIndex) {
                                                    final product =
                                                        supplier.carddetail[
                                                            productIndex];
                                                    final controller =
                                                        controllers[
                                                            product.billCode];

                                                    return Slidable(
                                                        endActionPane:
                                                            ActionPane(
                                                          extentRatio: 0.20,
                                                          motion:
                                                              const ScrollMotion(),
                                                          children: [
                                                            SlidableAction(
                                                              flex: 1,
                                                              onPressed:
                                                                  (s) async {
                                                                Get.find<
                                                                        FetchCartItemsController>()
                                                                    .fetch_cart_items();

                                                                await fnEditCart(
                                                                    context,
                                                                    product,
                                                                    'cart_page_delete',
                                                                    '',
                                                                    '',
                                                                    ref: 'cart',
                                                                    contentId:
                                                                        '');
                                                                controllers.remove(
                                                                    product
                                                                        .billCode);
                                                              },
                                                              backgroundColor:
                                                                  theme_red,
                                                              foregroundColor:
                                                                  Colors.white,
                                                              icon:
                                                                  Icons.delete,
                                                              label: 'ลบ',
                                                            ),
                                                          ],
                                                        ),
                                                        child: listCartB2C(
                                                            _scaffoldKey,
                                                            context,
                                                            controller!,
                                                            product,
                                                            true));
                                                  },
                                                  separatorBuilder:
                                                      (BuildContext context,
                                                          int index) {
                                                    return Divider(
                                                      color: theme_color_df,
                                                      height: 0,
                                                    );
                                                  }),
                                              summaryShopSupplier(
                                                  supplier, context, typeUser)
                                              // summaryShop(supplier.carddetail,
                                              //     context, typeUser),
                                            ],
                                          ),
                                        );
                                      },
                                    )
                                  : const SizedBox()
                            ],
                          ),
                        ),
                      );
                    } else {
                      return Center(
                        child: theme_loading_df,
                      );
                    }
                  }),
                )),
            bottomNavigationBar: typeUser == null
                ? const SizedBox()
                : Container(
                    color: Colors.white,
                    child: bottomConfirm(
                      context,
                      true,
                      'order',
                      inputorsDropship,
                      inputors,
                      typeUser,
                    ),
                  )),
      ),
    );
  }
}
