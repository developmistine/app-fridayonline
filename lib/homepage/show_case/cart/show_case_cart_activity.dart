// ignore_for_file: no_leading_underscores_for_local_identifiers, prefer_final_fields, prefer_const_constructors, non_constant_identifier_names

import 'package:fridayonline/controller/cart/cart_controller.dart';
import 'package:fridayonline/homepage/pageactivity/cart/cart_page/cart_order%20summary.dart';
import 'package:fridayonline/homepage/theme/theme_color.dart';
import 'package:fridayonline/homepage/theme/theme_loading.dart';
import 'package:fridayonline/homepage/widget/appbarmaster.dart';
// import 'package:fridayonline/model/cart/cart_getItems.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:showcaseview/showcaseview.dart';

import '../../../controller/cart/dropship_controller.dart';
import '../../../controller/cart/function_add_to_cart.dart';
import '../../../model/cart/dropship/drop_ship_address.dart';
import '../../../model/set_data/set_data.dart';
import '../../../service/languages/multi_languages.dart';
import '../../pageactivity/cart/cart_page/cart_change_address.dart';
import '../../pageactivity/cart/cart_theme/cart_all_theme.dart';
import '../../pageactivity/cart/cart_widget/cart_bottom_confirm.dart';
// import '../../pageactivity/cart/cart_widget/cart_direcsale_product.dart';
// import '../../pageactivity/cart/cart_widget/cart_dropship_product.dart';
import '../../pageactivity/cart/cart_widget/cart_friday_order.dart';
// import '../../pageactivity/cart/cart_widget/cart_head_dropship.dart';
import '../../pageactivity/cart/cart_widget/cart_head_firday.dart';
// import '../../pageactivity/cart/cart_widget/notify_address.dart';

class ShowCaseCart extends StatefulWidget {
  const ShowCaseCart({super.key, required this.ChangeLanguage});
  final MultiLanguages ChangeLanguage;

  @override
  State<ShowCaseCart> createState() => _ShowCaseCartState();
}

class _ShowCaseCartState extends State<ShowCaseCart> {
  final GlobalKey _one = GlobalKey();
  final GlobalKey _two = GlobalKey();
  final GlobalKey _three = GlobalKey();
  final GlobalKey _four = GlobalKey();
  //
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool UsePoint = false;
  // var inputors = <InputQTY>[];
  var inputors = <TextEditingController>[];
  var inputorsDropship = <TextEditingController>[];
  Map<String, TextEditingController> controllers = {};

  SetData data = SetData();
  String? typeUser;
  // bool _enableEdit = true;
  @override
  void initState() {
    super.initState();
    // callApi();
    //? call ข้อมูล users
    callGetType();
    ambiguate(WidgetsBinding.instance)?.addPostFrameCallback(
      (_) => ShowCaseWidget.of(context).startShowCase([_one]),
    );
  }

  callGetType() async {
    var typeuser = await data.repType;
    setState(() {
      typeUser = typeuser;
    });
  }

  callApi() async {
    var cardDetails = Get.find<FetchCartItemsController>()
        .itemsCartList!
        .cardHeader
        .carddetail;
    for (int i = 0; i < cardDetails.length; i++) {
      inputors.add(TextEditingController());
      inputors[i].text = cardDetails[i].qty.toString();
    }
    for (int i = 0; i < cardDetails.length; i++) {
      inputorsDropship.add(TextEditingController());
      inputorsDropship[i].text = cardDetails[i].qty.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return MediaQuery(
      data: MediaQuery.of(context)
          .copyWith(textScaler: const TextScaler.linear(1.0)),
      child: Scaffold(
          backgroundColor: Colors.grey.shade100,
          key: _scaffoldKey,
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
                  return GetBuilder<FetchCartDropshipController>(
                      builder: (dropLoading) {
                    //? direc detail data

                    //? dropship detail data
                    // var dropship =
                    //     dropLoading.itemDropship!.cartHeader.cartDetail;

                    // if (!dropLoading.isDataLoading.value &&
                    //     !cartController.isDataLoading.value) {
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
                          await Get.find<FetchCartItemsController>()
                              .fetch_cart_items();
                          await Get.find<FetchCartDropshipController>()
                              .fetchCartDropship();
                          for (int i = 0;
                              i <
                                  Get.find<FetchCartItemsController>()
                                      .itemsCartList!
                                      .cardHeader
                                      .carddetail
                                      .length;
                              i++) {
                            inputors[i].text =
                                Get.find<FetchCartItemsController>()
                                    .itemsCartList!
                                    .cardHeader
                                    .carddetail[i]
                                    .qty
                                    .toString();
                          }
                        },
                        child: SingleChildScrollView(
                          physics: const AlwaysScrollableScrollPhysics(
                              parent: BouncingScrollPhysics()),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              //? Empty
                              //? fade dropship
                              // if (direcSale.isEmpty && dropship.isEmpty)
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
                                      Text('ไม่พบสินค้า'),
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
                                            thickness: 1.5,
                                          ),
                                          ListView.separated(
                                              padding: EdgeInsets.zero,
                                              physics:
                                                  NeverScrollableScrollPhysics(),
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
                                                if (index == 0) {
                                                  return Showcase.withWidget(
                                                    disableMovingAnimation:
                                                        true,
                                                    width: width,
                                                    height: height / 1.4,
                                                    container: InkWell(
                                                      onTap: () {
                                                        setState(() {
                                                          ShowCaseWidget.of(
                                                                  context)
                                                              .startShowCase(
                                                                  [_two]);
                                                        });
                                                      },
                                                      child: MediaQuery(
                                                        data: MediaQuery.of(
                                                                context)
                                                            .copyWith(
                                                                textScaler:
                                                                    TextScaler
                                                                        .linear(
                                                                            1.0)),
                                                        child: SizedBox(
                                                          width: width / 1,
                                                          height: height / 2,
                                                          child: Column(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .max,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Container(
                                                                margin:
                                                                    const EdgeInsets
                                                                        .only(
                                                                        left:
                                                                            10.0,
                                                                        top:
                                                                            50),
                                                                child:
                                                                    ClipRRect(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              8.0),
                                                                  child: Container(
                                                                      color: theme_color_df,
                                                                      width: 250,
                                                                      height: 80,
                                                                      child: Center(
                                                                        child:
                                                                            Text(
                                                                          textAlign:
                                                                              TextAlign.center,
                                                                          widget.ChangeLanguage.translate(
                                                                              'guide_in_cart'),
                                                                          style: const TextStyle(
                                                                              color: Colors.white,
                                                                              fontSize: 16),
                                                                        ),
                                                                      )),
                                                                ),
                                                              ),
                                                              Container(
                                                                margin:
                                                                    const EdgeInsets
                                                                        .only(
                                                                        left:
                                                                            180.0),
                                                                child:
                                                                    ElevatedButton(
                                                                        style: ButtonStyle(
                                                                            foregroundColor:
                                                                                WidgetStateProperty.all<Color>(theme_color_df),
                                                                            backgroundColor: WidgetStateProperty.all<Color>(Colors.white),
                                                                            shape: WidgetStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0), side: BorderSide(color: theme_color_df)))),
                                                                        onPressed: () {
                                                                          setState(
                                                                              () {
                                                                            ShowCaseWidget.of(context).startShowCase([
                                                                              _two
                                                                            ]);
                                                                          });
                                                                        },
                                                                        child: SizedBox(
                                                                          width:
                                                                              50,
                                                                          height:
                                                                              40,
                                                                          child:
                                                                              Center(
                                                                            child: Text(
                                                                                maxLines: 1,
                                                                                widget.ChangeLanguage.translate('btn_next_guide'),
                                                                                style: TextStyle(fontSize: 16)),
                                                                          ),
                                                                        )),
                                                              ),
                                                              Expanded(
                                                                child: Align(
                                                                    alignment:
                                                                        Alignment
                                                                            .bottomCenter,
                                                                    child: IconButton(
                                                                        icon: const Icon(
                                                                          Icons
                                                                              .close,
                                                                          color:
                                                                              Colors.white,
                                                                        ),
                                                                        onPressed: () {
                                                                          ShowCaseWidget.of(context)
                                                                              .next();
                                                                          ShowCaseWidget.of(context)
                                                                              .next();
                                                                          ShowCaseWidget.of(context)
                                                                              .next();
                                                                          ShowCaseWidget.of(context)
                                                                              .next();
                                                                        })),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    // overlayColor:
                                                    //     theme_color_df,
                                                    key: _one,
                                                    disposeOnTap: true,
                                                    onTargetClick: () {
                                                      setState(() {
                                                        ShowCaseWidget.of(
                                                                context)
                                                            .startShowCase(
                                                                [_two]);
                                                      });
                                                    },
                                                    child: Slidable(
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
                                                                    cartController
                                                                        .itemsCartList!
                                                                        .cardHeader
                                                                        .carddetail[index],
                                                                    'cart_page_delete',
                                                                    '',
                                                                    '',
                                                                    ref: 'cart',
                                                                    contentId: '');
                                                                for (var i = 0;
                                                                    i <
                                                                        cartController
                                                                            .itemsCartList!
                                                                            .cardHeader
                                                                            .carddetail
                                                                            .length;
                                                                    i++) {
                                                                  inputors[i].text = cartController
                                                                      .itemsCartList!
                                                                      .cardHeader
                                                                      .carddetail[
                                                                          i]
                                                                      .qty
                                                                      .toString();
                                                                }
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
                                                        child: show_case_list_Cart(
                                                            _scaffoldKey,
                                                            context,
                                                            cartController,
                                                            inputors,
                                                            index,
                                                            true,
                                                            _two,
                                                            _three,
                                                            _four,
                                                            widget
                                                                .ChangeLanguage)),
                                                  );
                                                } else {
                                                  return Slidable(
                                                      endActionPane: ActionPane(
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
                                                                  cartController
                                                                      .itemsCartList!
                                                                      .cardHeader
                                                                      .carddetail[index],
                                                                  'cart_page_delete',
                                                                  '',
                                                                  '',
                                                                  ref: 'cart',
                                                                  contentId: '');
                                                              for (var i = 0;
                                                                  i <
                                                                      cartController
                                                                          .itemsCartList!
                                                                          .cardHeader
                                                                          .carddetail
                                                                          .length;
                                                                  i++) {
                                                                inputors[i].text = cartController
                                                                    .itemsCartList!
                                                                    .cardHeader
                                                                    .carddetail[
                                                                        i]
                                                                    .qty
                                                                    .toString();
                                                              }
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
                                                  // child: FridayList(
                                                  //     cartController,
                                                  //     index,
                                                  //     true,
                                                  //     inputors,
                                                  //     _scaffoldKey));
                                                }
                                              },
                                              separatorBuilder:
                                                  (BuildContext context,
                                                          int index) =>
                                                      Divider(
                                                        color: theme_color_df,
                                                      )),
                                          summaryShop(
                                              cartController.itemsCartList!
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
                                            ],
                                          ),
                                        );
                                      },
                                    )
                                  : const SizedBox()

                              // //? fade dropship
                              // dropship.isNotEmpty
                              //     ? Container(
                              //         color: Colors.white,
                              //         child: Column(
                              //           // direction: Axis.vertical,
                              //           children: [
                              //             // วิดเจ็ดอระกาศแจ้งเตือน
                              //             notify_address(context),
                              //             // วิดเจ็ด แก้ไขที่อยู่
                              //             Edit_Address(context),
                              //             headDropship(context),
                              //             Divider(
                              //                 height: 1,
                              //                 thickness: 2,
                              //                 color: theme_color_df),
                              //             ListView.separated(
                              //                 padding: EdgeInsets.zero,
                              //                 shrinkWrap: true,
                              //                 primary: false,
                              //                 physics:
                              //                     NeverScrollableScrollPhysics(),
                              //                 itemCount: dropship.length,
                              //                 itemBuilder: ((context, index) {
                              //                   return Slidable(
                              //                     endActionPane: ActionPane(
                              //                       extentRatio: 0.20,
                              //                       motion:
                              //                           const ScrollMotion(),
                              //                       children: [
                              //                         SlidableAction(
                              //                           flex: 1,
                              //                           onPressed: (s) async {
                              //                             dropLoading
                              //                                 .fetchCartDropship();

                              //                             await fnEditCartDropship(
                              //                                 context,
                              //                                 dropLoading
                              //                                     .itemDropship!
                              //                                     .cartHeader
                              //                                     .cartDetail[index],
                              //                                 'cart_page_delete',
                              //                                 '',
                              //                                 '');
                              //                             inputorsDropship
                              //                                 .removeAt(index);
                              //                           },
                              //                           backgroundColor:
                              //                               theme_red,
                              //                           foregroundColor:
                              //                               Colors.white,
                              //                           icon: Icons.delete,
                              //                           label: 'ลบ',
                              //                         ),
                              //                       ],
                              //                     ),
                              //                     child: DropshipList(
                              //                         dropLoading,
                              //                         index,
                              //                         true,
                              //                         inputorsDropship,
                              //                         _scaffoldKey),
                              //                   );
                              //                 }),
                              //                 separatorBuilder:
                              //                     ((context, index) => Divider(
                              //                           color: theme_color_df,
                              //                         ))),
                              //             amountDropship(dropLoading)
                              //           ],
                              //         ),
                              //       )
                              //     : Container()
                            ],
                          ),
                        ),
                      );
                    } else {
                      return Center(
                        child: theme_loading_df,
                      );
                    }
                  });
                }),
              )),
          bottomNavigationBar: typeUser == null
              ? SizedBox()
              : Container(
                  color: Colors.white,
                  child: showCaseBottomConfirm(
                      context,
                      true,
                      'order',
                      inputorsDropship,
                      inputors,
                      _four,
                      widget.ChangeLanguage,
                      typeUser),
                )),
    );
  }

// ? ราคารวม dropship
  Container amountDropship(FetchCartDropshipController controller) {
    return Container(
      color: Colors.white,
      child: Flex(
        direction: Axis.vertical,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Divider(
            height: 1,
            color: theme_color_df,
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Wrap(
              runAlignment: WrapAlignment.end,
              alignment: WrapAlignment.end,
              crossAxisAlignment: WrapCrossAlignment.end,
              children: [
                Text(
                    '${MultiLanguages.of(context)!.translate('all_products_included')} ${controller.itemDropship!.cartHeader.totalItem} ${MultiLanguages.of(context)!.translate('order_list')}'),
                Text(
                    ', ${MultiLanguages.of(context)!.translate('order_total_price')} '),
                Text(
                  '${myFormat.format(controller.itemDropship!.cartHeader.totalAmount)} ${MultiLanguages.of(context)!.translate('order_baht')}',
                  style:
                      TextStyle(color: theme_red, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

// ? คำสั่งซื้อทั้งหมด
  Container orderAll(FetchCartItemsController controller) {
    return Container(
      color: Colors.white,
      height: 60,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'คำสั่งซื้อทั้งหมด : (${controller.itemsCartList!.cardHeader.totalitem})',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Wrap(
              children: [
                Obx(
                  () => controller.isDataLoading.value
                      ? Text(
                          MultiLanguages.of(context)!.translate('loading_cart'),
                        )
                      : Wrap(
                          children: [
                            Text(
                              '${myFormat.format(controller.itemsCartList!.cardHeader.totalAmount)} ',
                              style: TextStyle(
                                  color: Color.fromRGBO(46, 169, 225, 1)),
                            ),
                            Text(MultiLanguages.of(context)!
                                .translate('order_baht'))
                          ],
                        ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

// ?Widget เปลี่ยนที่อยู่ fade dropship
  MediaQuery Edit_Address(BuildContext context) {
    const border = OutlineInputBorder(
      borderSide: BorderSide(
        color: Colors.transparent,
        width: 0,
      ),
      borderRadius: BorderRadius.all(
        Radius.circular(8.0),
      ),
    );
    return MediaQuery(
      data: MediaQuery.of(context)
          .copyWith(textScaler: const TextScaler.linear(1.0)),
      child: SizedBox(
        child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(
                    flex: 4,
                    child: GetBuilder<FetchAddressDropshipController>(
                        builder: (address) {
                      if (!address.isDataLoading.value) {
                        if (address.itemDropship!.address.isNotEmpty) {
                          final Address hint =
                              address.itemDropship!.address.firstWhere(
                            (element) => (element.addressType == '1'),
                            orElse: () {
                              return Address(
                                  addressId: '',
                                  addressLine1: 'เพิ่มที่อยู่ส่งด่วน',
                                  addressLine2: '',
                                  addressType: '',
                                  amphurCode: '',
                                  mobileNo: '',
                                  nameAmphur: '',
                                  nameProvince: '',
                                  nameReceive: '',
                                  nameTumbon: '',
                                  postCode: '',
                                  provinceCode: '',
                                  tumbonCode: '',
                                  areaType: '');
                            },
                          );
                          return TextField(
                            textAlign: TextAlign.start,
                            textAlignVertical: TextAlignVertical.center,
                            readOnly: true,
                            decoration: InputDecoration(
                              focusedBorder: border,
                              enabledBorder: border,
                              filled: true,
                              fillColor: Color.fromRGBO(217, 217, 217, 1),
                              prefixIcon: Icon(
                                Icons.location_on,
                                color: theme_red,
                                size: 28,
                              ),
                              isDense: true,
                              isCollapsed: true,
                              hintText: address.isDataLoading.value
                                  ? ""
                                  : '${hint.addressLine1} ${hint.nameTumbon} ${hint.nameAmphur}' //? hint.addressLine1,
                              ,
                              hintStyle: const TextStyle(color: Colors.black),
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 2, horizontal: 1),
                              // border: OutlineInputBorder(),
                            ),
                          );
                        } else {
                          return TextField(
                            textAlign: TextAlign.start,
                            textAlignVertical: TextAlignVertical.center,
                            readOnly: true,
                            decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: theme_grey_bg,
                                  width: 0,
                                ),
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(4.0),
                                ),
                              ),
                              filled: true,
                              fillColor: Color.fromRGBO(217, 217, 217, 1),
                              prefixIcon: Icon(
                                Icons.location_on,
                                color: theme_red,
                                size: 28,
                              ),
                              isDense: true,
                              isCollapsed: true,
                              hintText: "เพิ่มที่อยู่ส่งด่วน",
                              hintStyle: const TextStyle(color: Colors.black),
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 2, horizontal: 2),
                              // border: OutlineInputBorder(),
                            ),
                          );
                        }
                      } else {
                        //? loading textfield
                        return TextField(
                          textAlign: TextAlign.start,
                          textAlignVertical: TextAlignVertical.center,
                          readOnly: true,
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: theme_grey_bg,
                                width: 0,
                              ),
                              borderRadius: const BorderRadius.all(
                                Radius.circular(4.0),
                              ),
                            ),
                            filled: true,
                            fillColor: Color.fromRGBO(217, 217, 217, 1),
                            prefixIcon: Icon(
                              Icons.location_on,
                              color: theme_red,
                              size: 28,
                            ),
                            isDense: true,
                            isCollapsed: true,
                            hintText: "...",
                            hintStyle: const TextStyle(color: Colors.black),
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 2, horizontal: 2),
                            // border: OutlineInputBorder(),
                          ),
                        );
                      }
                    })),
                SizedBox(
                  width: 8,
                ),
                Expanded(
                  flex: 2,
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.zero,
                      // backgroundColor: theme_color_df,
                      side: BorderSide(width: 1.0, color: theme_color_df),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                    ),
                    onPressed: () {
                      Get.put(FetchAddressDropshipController())
                          .fetchDropshipAddress();
                      Get.to(
                          transition: Transition.cupertinoDialog,
                          () => EditAddress(page: 'page1'));
                    },
                    child: const Text('เปลี่ยนที่อยู่'),
                  ),
                )
              ],
            )),
      ),
    );
  }
}

// ?Widget promotion
class promotion_widget extends StatelessWidget {
  const promotion_widget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color.fromRGBO(164, 214, 241, 1),
      height: 45,
      child: ListTile(
          title: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 13),
                child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: theme_color_df),
                      minimumSize: const Size(20, 25),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(1.0),
                      ),
                    ),
                    onPressed: () {},
                    child: Text('โปรโมชั่น')),
              ),
              Expanded(child: Text('แนะนำ')),
            ],
          ),
          trailing: Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Text('เลือกเพิ่ม'),
              Icon(
                Icons.arrow_forward_ios,
                color: theme_color_df,
              )
            ],
          )),
    );
  }
}
