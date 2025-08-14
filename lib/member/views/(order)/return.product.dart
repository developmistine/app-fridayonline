import 'package:fridayonline/member/components/appbar/appbar.master.dart';
import 'package:fridayonline/member/controller/order.ctr.dart';
import 'package:fridayonline/member/models/orders/reason.return.model.dart';
import 'package:fridayonline/member/services/orders/order.service.dart';
import 'package:fridayonline/member/utils/format.dart';
import 'package:fridayonline/member/views/(profile)/myorder.dart';
import 'package:fridayonline/member/widgets/dialog.dart';
import 'package:fridayonline/theme.dart';
import 'package:fridayonline/preferrence.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chewie/chewie.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';
import 'dart:io' as io;
import 'package:path_provider/path_provider.dart' as path_provider;

class ReturnProdut extends StatefulWidget {
  const ReturnProdut({super.key});

  @override
  State<ReturnProdut> createState() => _ReturnProdutState();
}

class _ReturnProdutState extends State<ReturnProdut> {
  final orderCtr = Get.find<OrderController>();
  @override
  Widget build(BuildContext context) {
    return MediaQuery(
        data: MediaQuery.of(context)
            .copyWith(textScaler: const TextScaler.linear(1.0)),
        child: Theme(
            data: Theme.of(context).copyWith(
              elevatedButtonTheme: ElevatedButtonThemeData(
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                      textStyle: GoogleFonts.notoSansThaiLooped())),
              outlinedButtonTheme: OutlinedButtonThemeData(
                  style: OutlinedButton.styleFrom(
                      textStyle: GoogleFonts.notoSansThaiLooped())),
              textTheme: GoogleFonts.notoSansThaiLoopedTextTheme(
                Theme.of(context).textTheme,
              ),
            ),
            child: Scaffold(
              appBar: appBarMasterEndUser('เลือกสินค้าที่ต้องการคืน'),
              body: Obx(() {
                if (orderCtr.isLoadingDetail.value) {
                  return const Center(
                      child: CircularProgressIndicator.adaptive());
                }
                if (orderCtr.orderDetail == null ||
                    orderCtr.orderDetail!.code == '-9') {
                  return const Center(
                    child: Text('ไม่พอข้อมูล'),
                  );
                }
                var orderDetail = orderCtr.orderDetail!.data;
                return SingleChildScrollView(
                    child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: shawdowCard(),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'หมายเลขคำสั่งซื้อ',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13),
                                ),
                                Text(orderDetail.orderNo,
                                    style: TextStyle(
                                        fontSize: 13,
                                        color: themeColorDefault,
                                        fontWeight: FontWeight.bold))
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'พัสดุเลขที่',
                                  style: TextStyle(fontSize: 12),
                                ),
                                Text(
                                    orderDetail.shippingInfo[0].trackingNo == ""
                                        ? "-"
                                        : orderDetail
                                            .shippingInfo[0].trackingNo,
                                    style: const TextStyle(fontSize: 12))
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'ชำระผ่าน',
                                  style: TextStyle(fontSize: 12),
                                ),
                                Text(
                                    orderDetail.paymentInfo.paymentMethod
                                        .paymentChannelName,
                                    style: const TextStyle(fontSize: 12))
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: shawdowCard(),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            InkWell(
                              onTap: () {
                                if (orderDetail.itemGroups.every((element) =>
                                    element.amount == element.qty)) {
                                  setState(() {
                                    orderDetail.itemGroups.map((item) {
                                      item.qty = 0;
                                      item.isSeleted = false;
                                      return item;
                                    }).toList();
                                  });
                                } else {
                                  setState(() {
                                    orderDetail.itemGroups.map((item) {
                                      item.qty = item.amount;
                                      item.isSeleted = true;
                                      return item;
                                    }).toList();
                                  });
                                }
                              },
                              child: Row(
                                children: [
                                  if (orderDetail.itemGroups.every((element) =>
                                      element.amount == element.qty))
                                    const Icon(
                                      Icons.check_box,
                                    )
                                  else
                                    const Icon(Icons.check_box_outline_blank),
                                  const SizedBox(
                                    width: 4,
                                  ),
                                  const Text(
                                    'เลือกทั้งหมด',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 12,
                            ),
                            ListView.builder(
                              shrinkWrap: true,
                              primary: false,
                              padding: EdgeInsets.zero,
                              itemCount: orderDetail.itemGroups.length,
                              itemBuilder: (context, index) {
                                var item = orderDetail.itemGroups[index];
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 8.0),
                                  child: Row(
                                    children: [
                                      Expanded(
                                          child: Container(
                                        padding: const EdgeInsets.all(2),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(4),
                                            border: Border.all(
                                                width: 0.5,
                                                color: Colors.grey.shade400)),
                                        child: CachedNetworkImage(
                                          height: 60,
                                          imageUrl: item.image,
                                        ),
                                      )),
                                      const SizedBox(
                                        width: 8,
                                      ),
                                      Expanded(
                                        flex: 4,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              item.productName,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Row(
                                              children: [
                                                const Spacer(),
                                                Text(
                                                  "x${myFormat.format(item.amount)}",
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: const TextStyle(
                                                    fontSize: 11,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  '฿${myFormat.format(item.refundAmountPerItem)}',
                                                  style: const TextStyle(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                Row(
                                                  children: [
                                                    InkWell(
                                                      onTap: () {
                                                        if (item.qty > 0) {
                                                          setState(() {
                                                            item.qty--;
                                                          });
                                                        }
                                                      },
                                                      child: Container(
                                                        width: 25,
                                                        height: 25,
                                                        decoration:
                                                            BoxDecoration(
                                                                borderRadius:
                                                                    const BorderRadius
                                                                        .only(
                                                                  topLeft: Radius
                                                                      .circular(
                                                                          4),
                                                                  bottomLeft: Radius
                                                                      .circular(
                                                                          4),
                                                                ),
                                                                border: Border.all(
                                                                    color: Colors
                                                                        .grey
                                                                        .shade400)),
                                                        child: const Center(
                                                            child: Text(
                                                          '-',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              inherit: false),
                                                        )),
                                                      ),
                                                    ),
                                                    Container(
                                                      width: 25,
                                                      height: 25,
                                                      decoration: BoxDecoration(
                                                          border: Border.symmetric(
                                                              horizontal: BorderSide(
                                                                  color: Colors
                                                                      .grey
                                                                      .shade400))),
                                                      child: Center(
                                                          child: Text(
                                                        item.qty.toString(),
                                                        style: TextStyle(
                                                            color: Colors
                                                                .deepOrange
                                                                .shade700,
                                                            inherit: false,
                                                            fontSize: 12,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      )),
                                                    ),
                                                    InkWell(
                                                      onTap: () {
                                                        if (item.qty <
                                                            item.amount) {
                                                          setState(() {
                                                            item.qty++;
                                                          });
                                                        }
                                                      },
                                                      child: Container(
                                                        width: 25,
                                                        height: 25,
                                                        decoration:
                                                            BoxDecoration(
                                                                borderRadius:
                                                                    const BorderRadius
                                                                        .only(
                                                                  topRight: Radius
                                                                      .circular(
                                                                          4),
                                                                  bottomRight: Radius
                                                                      .circular(
                                                                          4),
                                                                ),
                                                                border: Border.all(
                                                                    color: Colors
                                                                        .grey
                                                                        .shade400)),
                                                        child: const Center(
                                                            child: Text(
                                                          '+',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              inherit: false),
                                                        )),
                                                      ),
                                                    ),
                                                  ],
                                                )
                                              ],
                                            )
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      SizedBox(
                        width: Get.width,
                        height: 40,
                        child: ElevatedButton(
                            onPressed: orderDetail.itemGroups
                                    .every((element) => element.qty == 0)
                                ? null
                                : () async {
                                    loadingProductStock(context);
                                    var res =
                                        await fetchReturnReasonOrdersService();
                                    Get.back();
                                    returnDialog(reason: res.data);
                                  },
                            style: ElevatedButton.styleFrom(
                                backgroundColor: themeColorDefault),
                            child: const Text(
                              'ถัดไป',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 12),
                            )),
                      )
                    ],
                  ),
                ));
              }),
            )));
  }

  BoxDecoration shawdowCard() {
    return const BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.all(Radius.circular(4)),
      boxShadow: [
        BoxShadow(
          color: Color.fromARGB(14, 0, 0, 0),
          offset: Offset(0, 4.0),
          blurRadius: 0.2,
          spreadRadius: 0.2,
        ), //BoxShadow
      ],
    );
  }

  returnDialog({required List<Datum> reason}) {
    var countImg = 0;
    final List<io.File> imageFileList = [];
    VideoPlayerController? controller;
    VideoPlayerController? toBeDisposed;
    bool isPlay = true;

    final ImagePicker pickerImage = ImagePicker();
    final ImagePicker pickerVideo = ImagePicker();
    var commentTextCtr = TextEditingController();

    Future<void> disposeVideoController() async {
      if (toBeDisposed != null) {
        await toBeDisposed!.dispose();
      }
      toBeDisposed = controller;
      controller = null;
    }

    //
    return Get.bottomSheet(isScrollControlled: true, SafeArea(
        child: StatefulBuilder(builder: (context, StateSetter setState) {
      openImagePicker() async {
        List<XFile>? result = await pickerImage.pickMultiImage();
        if (result.isNotEmpty) {
          setState(() {
            countImg += result.length;
          });
          if (countImg > 5) {
            setState(() {
              countImg -= result.length;
            });
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Get.snackbar('Friday Online', 'อัปโหลดรูปภาพได้ไม่เกิน 5 รูป');
              result.clear();
            });
          } else {
            final f = result
                .asMap()
                .map((i, path) => MapEntry(i, io.File(path.path.toString())))
                .values
                .toList();

            List<int> sizeInBytes = f.map((e) => e.lengthSync()).toList();
            //? หาขนาดไฟล? MB
            var limitSize = sizeInBytes.map((e) => e / (1024 * 1024)).toList();
            for (var i = 0; i < limitSize.length; i++) {
              if (limitSize[i].toDouble() <= 5.00) {
                setState(() {
                  imageFileList.add(io.File(result[i].path.toString()));
                });
              } else {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  Get.snackbar(
                      'Friday Online', 'ไฟล์ภาพที่มีขนาดเกิน 5 MB จะถูกคัดออก');
                  result.clear();
                });
              }
            }
          }
        } else {
          final dir = await path_provider.getTemporaryDirectory();
          final file = io.File('${dir.absolute.path}/CacheImageReview');
          final directory = io.Directory(file.path);

          if (await directory.exists()) {
            final files = directory.listSync();
            for (final file in files) {
              if (file is io.File) {
                await file.delete();
              }
            }
          }
          setState(() {
            countImg = 0;
            imageFileList.clear();
          });
        }
      }

      openVidePicker() async {
        try {
          XFile? file = await pickerVideo.pickVideo(
              source: ImageSource.gallery,
              maxDuration: const Duration(seconds: 10));

          if (file != null && mounted) {
            await disposeVideoController();
            late VideoPlayerController testLengthController;
            testLengthController =
                VideoPlayerController.file(io.File(file.path));
            controller = testLengthController;
            await testLengthController.initialize();
            setState(() {});
            if (testLengthController.value.duration.inMinutes > 1) {
              WidgetsBinding.instance.addPostFrameCallback((_) async {
                Get.snackbar(
                    'Friday Online', 'วิดีโอที่อัปโหลดต้องไม่เกิน 1 นาที');
                await disposeVideoController();
                setState(() {});
              });
              return;
            }
          }
        } catch (e) {
          Get.snackbar(
            'Friday Online',
            '$e',
          );
          return;
        }
      }

      //? โชว์วิดีโอ
      previewVideo() {
        return Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Stack(
            alignment: Alignment.topRight,
            children: [
              Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(8)),
                      border: Border.all(
                          color: const Color.fromARGB(255, 191, 191, 191))),
                  child: Center(
                    child: Visibility(
                        visible: controller != null,
                        child: controller != null &&
                                controller!.value.isInitialized
                            ? Stack(
                                alignment: Alignment.center,
                                children: [
                                  AspectRatio(
                                      aspectRatio:
                                          controller!.value.aspectRatio,
                                      child: Chewie(
                                        controller: ChewieController(
                                          videoPlayerController: controller!,
                                          allowFullScreen: false,
                                          showControls: false,
                                        ),
                                      )),
                                  InkWell(
                                      onTap: () {
                                        setState(() {
                                          isPlay = !isPlay;
                                          if (isPlay) {
                                            setState(() {
                                              controller!.pause();
                                            });
                                          }
                                          if (!isPlay) {
                                            setState(() {
                                              controller!.play();
                                            });
                                          }
                                        });
                                      },
                                      child: isPlay
                                          ? CircleAvatar(
                                              backgroundColor:
                                                  Colors.white.withOpacity(0.4),
                                              radius: 10,
                                              child: const Icon(
                                                Icons.play_circle_fill,
                                                size: 20,
                                                color: Colors.white,
                                              ))
                                          : CircleAvatar(
                                              backgroundColor:
                                                  Colors.white.withOpacity(0.4),
                                              radius: 10,
                                              child: const Icon(
                                                Icons.pause_circle,
                                                size: 20,
                                                color: Colors.white,
                                              ))),
                                ],
                              )
                            : const SizedBox()),
                  )),
              InkWell(
                onTap: () {
                  setState(() {
                    controller!.dispose();
                    controller = null;
                  });
                },
                child: Container(
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(8),
                        topRight: Radius.circular(8)),
                    color: Colors.black45,
                  ),
                  child: const Icon(
                    size: 18,
                    Icons.close,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        );
      }

      showUpload() {
        return Wrap(children: [
          ...imageFileList.map((listImg) {
            return Padding(
              padding: const EdgeInsets.only(top: 4, bottom: 4, right: 4),
              child: Stack(
                alignment: AlignmentDirectional.topEnd,
                children: [
                  Container(
                      width: 70,
                      height: 70,
                      decoration: BoxDecoration(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(8)),
                          border: Border.all(
                              color: const Color.fromARGB(255, 191, 191, 191))),
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: Image.file(
                              fit: BoxFit.cover, io.File(listImg.path)))),
                  InkWell(
                    onTap: () async {
                      countImg -= 1;

                      var fileCache = io.File(listImg.path);
                      if (fileCache.existsSync()) {
                        await fileCache.delete(recursive: true);
                      }
                      imageFileList.removeWhere(
                          (element) => element.path == listImg.path);
                      imageFileList.removeWhere(
                          (element) => element.path == listImg.path);
                      setState(() {});
                    },
                    child: Container(
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(8),
                            topRight: Radius.circular(8)),
                        color: Colors.black45,
                      ),
                      child: const Icon(
                        size: 18,
                        Icons.close,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
          if (controller != null)
            //? โชว์วิดีโอที่อัพโหลด
            Padding(
                padding: const EdgeInsets.only(top: 4, bottom: 4, right: 4),
                child: previewVideo()),
        ]);
      }

      return GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: MediaQuery(
          data: MediaQuery.of(context)
              .copyWith(textScaler: const TextScaler.linear(1)),
          child: Container(
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(8),
                      topRight: Radius.circular(8)),
                  color: Colors.white),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'โปรดระบุเหตุผลในการคืนสินค้า',
                              style: GoogleFonts.notoSansThaiLooped(
                                  fontSize: 12, fontWeight: FontWeight.bold),
                            ),
                            InkWell(
                                onTap: () {
                                  Get.back();
                                },
                                child: const Icon(Icons.close))
                          ],
                        ),
                      ),
                      const Divider(
                        height: 0,
                      ),
                      ConstrainedBox(
                        constraints: const BoxConstraints(maxHeight: 240),
                        child: ListView.builder(
                          itemCount: reason.length,
                          padding: EdgeInsets.zero,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: InkWell(
                                onTap: () {
                                  setState(
                                    () {
                                      for (var e in reason) {
                                        e.isSelected = false;
                                      }
                                      reason[index].isSelected = true;
                                    },
                                  );
                                },
                                child: Row(
                                  children: [
                                    if (!reason[index].isSelected)
                                      Icon(
                                        Icons.radio_button_off,
                                        color: Colors.grey.shade400,
                                      )
                                    else
                                      Icon(
                                        Icons.radio_button_checked,
                                        color: themeColorDefault,
                                      ),
                                    const SizedBox(
                                      width: 4,
                                    ),
                                    Text(
                                      reason[index].returnReason,
                                      style: GoogleFonts.notoSansThaiLooped(
                                          fontSize: 12),
                                    )
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      Text(
                        "เหตุผลในการคืนสินค้า",
                        style: GoogleFonts.notoSansThaiLooped(
                            fontWeight: FontWeight.bold, fontSize: 12),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: TextField(
                          maxLines: 3,
                          minLines: 3,
                          controller: commentTextCtr,
                          style: GoogleFonts.notoSansThaiLooped(fontSize: 12),
                          decoration: const InputDecoration(
                            hintText: 'กรอกรายละเอียดปัญหาที่คุณพบ (ไม่บังคับ)',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                            'แนบรูปภาพ ',
                            style: GoogleFonts.notoSansThaiLooped(
                                fontWeight: FontWeight.bold, fontSize: 12),
                          ),
                          Text(
                            '(ขนาดไม่เกิน 5 MB, สูงสุด 5 รูป)',
                            style: GoogleFonts.notoSansThaiLooped(fontSize: 11),
                          ),
                        ],
                      ),
                      //? โชว์ภาพที่อัพโหลด
                      imageFileList.isNotEmpty || controller != null
                          ? showUpload()
                          : const SizedBox(),

                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: InkWell(
                              onTap: () async {
                                await openImagePicker();
                              },
                              child: DottedBorder(
                                borderType: BorderType.RRect,
                                radius: const Radius.circular(10),
                                dashPattern: const [6, 2],
                                strokeWidth: 0.5,
                                color: Colors.grey.shade700,
                                child: Container(
                                  width: 80,
                                  padding: const EdgeInsets.all(12.0),
                                  alignment: Alignment.center,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(Icons.camera_alt_outlined,
                                          size: 28,
                                          color: Colors.grey.shade700),
                                      Text(
                                        'รูปภาพ',
                                        style: GoogleFonts.notoSansThaiLooped(
                                            fontSize: 12,
                                            color: Colors.grey.shade700),
                                      ),
                                      Text(
                                        '($countImg / 5)',
                                        style: GoogleFonts.notoSansThaiLooped(
                                            fontSize: 12,
                                            color: Colors.grey.shade700),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: InkWell(
                              onTap: () async {
                                isPlay = true;
                                await openVidePicker();
                              },
                              child: DottedBorder(
                                borderType: BorderType.RRect,
                                radius: const Radius.circular(10),
                                dashPattern: const [6, 2],
                                strokeWidth: 0.5,
                                color: Colors.grey.shade700,
                                child: Container(
                                  width: 80,
                                  padding: const EdgeInsets.all(12.0),
                                  alignment: Alignment.center,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(Icons.videocam_outlined,
                                          size: 28,
                                          color: Colors.grey.shade700),
                                      Text(
                                        'วิดีโอ',
                                        style: GoogleFonts.notoSansThaiLooped(
                                            fontSize: 12,
                                            color: Colors.grey.shade700),
                                      ),
                                      Text(
                                        '(${controller != null ? 1 : 0} / 1)',
                                        style: GoogleFonts.notoSansThaiLooped(
                                            fontSize: 12,
                                            color: Colors.grey.shade700),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Builder(builder: (context) {
                        var selectedReason = reason
                            .firstWhereOrNull((e) => e.isSelected == true);
                        var products =
                            orderCtr.orderDetail!.data.itemGroups.where(
                          (element) {
                            return element.isSeleted == true && element.qty > 0;
                          },
                        ).toList();

                        var isNotSlectedChoice =
                            reason.every((r) => r.isSelected == false);
                        var isRequiredImg = false;
                        if (selectedReason == null) {
                          isRequiredImg = false;
                        } else {
                          isRequiredImg = selectedReason.imageFlag &&
                              (imageFileList.isEmpty && controller == null);
                        }

                        return Container(
                          padding: const EdgeInsets.only(bottom: 8),
                          width: Get.width,
                          height: 50,
                          child: ElevatedButton(
                              onPressed: isNotSlectedChoice || isRequiredImg
                                  ? null
                                  : () async {
                                      loadingCart(context);

                                      SetData data = SetData();
                                      var payload = {
                                        "cust_id": await data.b2cCustID,
                                        "device": await data.device,
                                        "ordshop_id": orderCtr.orderShopId,
                                        "reason_id": selectedReason!.returnId,
                                        "comment": commentTextCtr.text,
                                        "products": products
                                            .map((e) => {
                                                  "product_id": e.productId,
                                                  "orddtl_id": e.orddtlId,
                                                  "item_id": e.itemId,
                                                  "qty": e.qty,
                                                  "refund_amount":
                                                      e.refundAmountPerItem,
                                                })
                                            .toList()
                                      };
                                      await submitReturnSaveService(
                                              json: payload,
                                              images: imageFileList,
                                              video: controller == null
                                                  ? null
                                                  : io.File(
                                                      controller!.dataSource))
                                          .then((res) {
                                        Get.back();
                                        if (res!.code == "100") {
                                          dialogAlert([
                                            const Icon(
                                              Icons.check_rounded,
                                              color: Colors.white,
                                              size: 35,
                                            ),
                                            const Text(
                                              'บันทึกข้อมูลเรียบร้อย',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 14),
                                            )
                                          ]);
                                          Future.delayed(
                                              const Duration(
                                                  milliseconds: 1500), () {
                                            Get.back();
                                            Get.back();
                                            Get.back();
                                            Get.back(result: 4);
                                            Get.find<OrderController>()
                                                .fetchOrderList(4, 0);
                                            Get.find<OrderController>()
                                                .fetchNotifyOrderTracking(
                                                    10627, 0);
                                            Get.to(() => const MyOrderHistory(),
                                                arguments: 4);
                                          });
                                        } else {
                                          if (!Get.isSnackbarOpen) {
                                            Get.snackbar('แจ้งเตือน',
                                                'เกิดข้อผิดพลาดกรุณาลองใหม่อีกครั้งค่ะ',
                                                backgroundColor:
                                                    Colors.red.withOpacity(0.8),
                                                colorText: Colors.white);
                                          }
                                          return;
                                        }
                                      });
                                    },
                              style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12)),
                                  backgroundColor: themeColorDefault),
                              child: Text(
                                'ยืนยัน',
                                style: GoogleFonts.notoSansThaiLooped(
                                    fontWeight: FontWeight.bold),
                              )),
                        );
                      })
                    ],
                  ),
                ),
              )),
        ),
      );
    })));
  }
}
