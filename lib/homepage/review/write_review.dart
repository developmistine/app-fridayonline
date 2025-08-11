// import 'dart:developer';
import 'dart:async';
import 'dart:convert';
import 'dart:io';
// import 'dart:math';
import 'package:fridayonline/controller/reviews/revies_ctr.dart';
import 'package:fridayonline/homepage/review/review_dialog/review_success_bottolmsheet.dart';
import 'package:fridayonline/model/review/review_detials_model.dart';
import 'package:fridayonline/model/set_data/set_data.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
// import 'package:path/path.dart' as path;
import 'package:fridayonline/homepage/dialogalert/customalertdialogs.dart';
import 'package:fridayonline/homepage/theme/theme_color.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chewie/chewie.dart';
import 'package:dotted_border/dotted_border.dart';
// import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
// import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';
import 'dart:io' as io;
// import 'package:image/image.dart' as imgLibrary;
import '../../service/address/addresssearch.dart';
import '../widget/appbarmaster.dart';
// import 'history_review.dart';
// import 'review_dialog/review_success_bottolmsheet.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
// import 'dart:math' as math;
// import 'dart:typed_data' as typed_data;
// import 'package:http/http.dart' as http;

class WriteReview extends StatefulWidget {
  const WriteReview({super.key, required this.productReview});
  final ReviewWaiting productReview;

  @override
  State<WriteReview> createState() => _WriteReviewState();
}

class _WriteReviewState extends State<WriteReview> {
  // io.File? _image;
  final List<io.File> _imageFileList = [];
  VideoPlayerController? _controller;
  VideoPlayerController? _toBeDisposed;

  bool isPlay = true;
  ImageProvider? provider;
  bool isLoadImg = false;

  double? productRating = 0.0;
  double? deliveryRating = 0.0;
  TextEditingController textReview = TextEditingController();

  var textLength = 0;
  var countImg = 0;

  var maxLength = 360;
  final ImagePicker _pickerImage = ImagePicker();
  final ImagePicker _pickerVideo = ImagePicker();

  // Implementing the image picker
  _openImagePicker() async {
    List<XFile>? result = await _pickerImage.pickMultiImage();
    if (result.isNotEmpty) {
      setState(() {
        isLoadImg = true;
      });
      countImg += result.length;
      // print("image count is $countImg");
      if (countImg > 10) {
        countImg -= result.length;
        setState(() {
          isLoadImg = false;
        });
        WidgetsBinding.instance.addPostFrameCallback((_) {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return const CustomAlertDialogs(
                  title: 'ฟรายเดย์',
                  description: 'อัปโหลดรูปภาพได้ไม่เกิน 10 รูป',
                );
              }).then((value) => {result.clear()});
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
              // getFileImage(result[i].path.toString(), i);
              // CompressFile(io.File(result.files[i].path.toString()));
              _imageFileList.add(io.File(result[i].path.toString()));
              isLoadImg = false;
              //? ชื่อรูป
              // var listName = result[i].name;
              // log(listName.tr);
            });
          } else {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return const CustomAlertDialogs(
                      title: 'ฟรายเดย์',
                      description: 'ไฟล์ภาพที่มีขนาดเกิน 5 MB จะถูกคัดออก');
                },
              );
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
        _imageFileList.clear();
      });
    }
  }

  io.File createFile(String path) {
    final file = io.File(path);
    if (!file.existsSync()) {
      file.createSync(recursive: true);
    }
    return file;
  }

  Future<void> _disposeVideoController() async {
    if (_toBeDisposed != null) {
      await _toBeDisposed!.dispose();
    }
    _toBeDisposed = _controller;
    _controller = null;
  }

  // VideoPlayerController? testLengthController;
  _openVidePicker() async {
    try {
      XFile? file = await _pickerVideo.pickVideo(
          source: ImageSource.gallery,
          maxDuration: const Duration(seconds: 10));

      if (file != null && mounted) {
        await _disposeVideoController();
        late VideoPlayerController testLengthController;
        testLengthController = VideoPlayerController.file(io.File(file.path));
        _controller = testLengthController;
        await testLengthController.initialize();
        setState(() {});
        if (testLengthController.value.duration.inMinutes > 1) {
          WidgetsBinding.instance.addPostFrameCallback((_) async {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return const CustomAlertDialogs(
                    title: 'ฟรายเดย์',
                    description: 'วิดีโอที่อัปโหลดต้องไม่เกิน 1 นาที');
              },
            );
            await _disposeVideoController();
            setState(() {});
          });
          return;
        }
      }
    } catch (e) {
      Get.dialog(CustomAlertDialogs(
        title: 'ฟรายเดย์',
        description: '$e',
      ));

      return;
    }
  }

  getFileImage(String filePick, int i) async {
    final img = io.File(filePick);
    // Uint8List imagebytes = await img.readAsBytes();
    print('pre compress');
    // const config = ImageConfiguration();

    final dir = await path_provider.getTemporaryDirectory();
    // print('dir ${dir.absolute.path}');
    // final io.File file = createFile('${dir.absolute.path}/test-$i.webp');
    // print('file patch ${file.absolute.path}');
    // file.writeAsBytesSync(imagebytes.buffer.asUint8List());
    var dateName = DateTime.now();
    var formatDate = DateFormat('mdy_HHmmss').format(dateName);

    // io.Directory('${dir.absolute.path}/CacheImageReview').createSync();
    final file = io.File('${dir.absolute.path}/CacheImageReview');
    if (!file.existsSync()) {
      io.Directory('${dir.absolute.path}/CacheImageReview').createSync();
    }
    final targetPath =
        '${dir.absolute.path}/CacheImageReview/temp_${formatDate}_$i.webp';
    // print('target $targetPath');
    final imgFile = await testCompressAndGetFile(img, targetPath);
    // print('file compress ${imgFile!.absolute.path}');
    if (imgFile == null) {
      return;
    }
    safeSetState(() {
      provider = FileImage(imgFile);
      print('provider $provider');
    });
  }

  Future<io.File?> testCompressAndGetFile(
      io.File file, String targetPath) async {
    final result = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      targetPath,
      quality: 40,
      // minWidth: 1024,
      // minHeight: 1024,
      format: CompressFormat.webp,
    );
    // print('size default ${file.lengthSync()}');
    // print('size default is ${getFileSizeString(bytes: file.lengthSync())}');
    // print('size convert is ${getFileSizeString(bytes: result!.lengthSync())}');

    // print('size convert ${result.lengthSync()}');
    // print('type of convert is ${path.extension(result.path)}');
    setState(() {
      _imageFileList.add(io.File(result!.path.toString()));

      isLoadImg = false;
    });
    if (kDebugMode) {
      print('covert image patch ${_imageFileList.map((e) => e.path)}');
    }
    return null;
    // return null;
    // return result;
  }

  @override
  void dispose() {
    textReview.clear();
    textLength = 0;
    productRating = 0.0;
    deliveryRating = 0.0;
    _imageFileList.clear();
    countImg = 0;
    if (_controller != null) {
      _controller!.dispose();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      appBar: appBarTitleMaster('เขียนรีวิว'),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Container(
            height: MediaQuery.of(context).size.height,
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(12)),
                color: Colors.white),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child:
                  ListView(physics: const BouncingScrollPhysics(), children: [
                //? สินค้า
                widgetproduct(),
                const SizedBox(height: 15),
                //? ช่อง text review
                widgetTextReview(),
                //? ดาวรีวิวคุณภาพสินค้า
                widgetStarReview(),
                const Divider(),
                //? ดาวขนส่ง
                widgetDeliveryReview(),
                const Divider(),
                const SizedBox(
                  height: 12,
                ),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //? โชว์ภาพที่อัพโหลด
                    isLoadImg && _imageFileList.isNotEmpty
                        ? Column(
                            children: [
                              const Text('กำลังประมวลผลรูปภาพ...'),
                              showUpload()
                            ],
                          )
                        : isLoadImg && _imageFileList.isEmpty
                            ? const Text('กำลังประมวลผลรูปภาพ...')
                            : _imageFileList.isNotEmpty
                                ? showUpload()
                                : Container(),
                    if (_imageFileList.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: SizedBox(
                          // width: 100,
                          height: 28,
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                disabledBackgroundColor:
                                    const Color.fromRGBO(239, 239, 239, 1),
                              ),
                              onPressed: null,
                              child: Text(
                                '${_imageFileList.length}/10',
                                style: const TextStyle(
                                    color: Colors.black, fontFamily: 'notoreg'),
                              )),
                        ),
                      ),
                    if (_controller != null)
                      //? โชว์วิดีโอที่อัพโหลด
                      _previewVideo(),
                  ],
                ),
                //     ? imageCompressed!
                const SizedBox(
                  height: 8,
                ),

                //? upload ภาพและวิดีโอ
                widgetUpload(),
                const SizedBox(
                  height: 20,
                ),
                //? ปุ่มส่งความคิดเห็น
                widgetButton()
              ]),
            ),
          ),
        ),
      ),
    );
  }

//? โชว์วิดีโอ
  _previewVideo() {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Stack(
        alignment: Alignment.topRight,
        children: [
          Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                  border: Border.all(
                      color: const Color.fromRGBO(171, 171, 171, 1))),
              child: Center(
                child: Visibility(
                    visible: _controller != null,
                    child: _controller != null &&
                            _controller!.value.isInitialized
                        ? Stack(
                            alignment: Alignment.center,
                            children: [
                              AspectRatio(
                                  aspectRatio: _controller!.value.aspectRatio,
                                  child: Chewie(
                                    controller: ChewieController(
                                      videoPlayerController: _controller!,
                                      allowFullScreen: false,
                                      showControls: false,
                                    ),
                                  )),
                              InkWell(
                                  onTap: () {
                                    setState(() {
                                      isPlay = !isPlay;
                                      // log('play or pause $isPlay');
                                      if (isPlay) {
                                        setState(() {
                                          _controller!.pause();
                                        });
                                      }
                                      if (!isPlay) {
                                        setState(() {
                                          _controller!.play();
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
                                          ))
                                      : CircleAvatar(
                                          backgroundColor:
                                              Colors.white.withOpacity(0.4),
                                          radius: 10,
                                          child: const Icon(
                                            Icons.pause_circle,
                                            size: 20,
                                          ))),
                            ],
                          )
                        : const SizedBox()
                    // child: FutureBuilder(
                    //     future: _initializeVideoPlayerFuture,
                    //     builder: (context, snapshot) {
                    //       if (snapshot.connectionState == ConnectionState.done) {
                    //         final chewieController = ChewieController(
                    //           allowFullScreen: false,
                    //           showControls: false,
                    //           videoPlayerController: _controller!,
                    //           // autoPlay: true,
                    //           looping: true,
                    //         );
                    //         if (_controller == null) {
                    //           chewieController.dispose();
                    //         }
                    //         return Stack(
                    //           alignment: Alignment.center,
                    //           children: [
                    //             AspectRatio(
                    //                 aspectRatio: _controller!.value.aspectRatio,
                    //                 child: Chewie(
                    //                   controller: chewieController,
                    //                 )),
                    //             InkWell(
                    //                 onTap: () {
                    //                   setState(() {
                    //                     isPlay = !isPlay;
                    //                     // log('play or pause $isPlay');
                    //                     if (isPlay) {
                    //                       setState(() {
                    //                         chewieController.pause();
                    //                       });
                    //                     }
                    //                     if (!isPlay) {
                    //                       setState(() {
                    //                         chewieController.play();
                    //                       });
                    //                     }
                    //                   });
                    //                 },
                    //                 child: isPlay
                    //                     ? CircleAvatar(
                    //                         backgroundColor:
                    //                             Colors.white.withOpacity(0.4),
                    //                         radius: 10,
                    //                         child: const Icon(
                    //                           Icons.play_circle_fill,
                    //                           size: 20,
                    //                         ))
                    //                     : CircleAvatar(
                    //                         backgroundColor:
                    //                             Colors.white.withOpacity(0.4),
                    //                         radius: 10,
                    //                         child: const Icon(
                    //                           Icons.pause_circle,
                    //                           size: 20,
                    //                         ))),
                    //           ],
                    //         );
                    //       } else {
                    //         return Center(child: theme_loading_df);
                    //       }
                    //     }),
                    ),
              )),
          Transform.rotate(
            angle: 210 / 90,
            child: InkWell(
              onTap: () {
                setState(() {
                  // log('remove video');
                  _controller!.dispose();
                  _controller = null;
                  // chewieController.dispose();
                });
              },
              child: const Icon(size: 20, Icons.add_circle_outlined),
            ),
          ),
        ],
      ),
    );
  }

  //? โชว์ภาพหรือวิดีโอที่อัพโหลด
  showUpload() {
    return Wrap(
      children: _imageFileList
          .asMap()
          .map((i, listImg) => MapEntry(
              i,
              Padding(
                padding: const EdgeInsets.all(4.0),
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
                                color: const Color.fromRGBO(171, 171, 171, 1))),
                        // height: 100,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 20),
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: Image.file(
                                  fit: BoxFit.cover, io.File(listImg.path))),
                        )),
                    Transform.rotate(
                      angle: 210 / 90,
                      child: InkWell(
                        onTap: () async {
                          await removeImageAndCache(i);
                        },
                        child: const Icon(size: 20, Icons.add_circle_outlined),
                      ),
                    ),
                  ],
                ),
              )))
          .values
          .toList(),
    );
  }

  //? ปุ่มส่งความคิดเห็น
  widgetButton() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: SizedBox(
        width: double.infinity,
        height: 60,
        child: ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: theme_color_df),
            onPressed: productRating == 0.0 || deliveryRating == 0.0
                ? null
                : () async {
                    SetData data = SetData();
                    var json = jsonEncode({
                      "rep_type": await data.repType,
                      "invoice": widget.productReview.invoice,
                      "rep_seq": await data.repSeq,
                      "rep_code": await data.repCode,
                      "enduser_id": await data.enduserId,
                      "rep_name": widget.productReview.name,
                      "sales_campaign": widget.productReview.salesCampaign,
                      "order_campaign": widget.productReview.orderCampaign,
                      "brand": widget.productReview.brand,
                      "fs_code": widget.productReview.fsCode,
                      "bill_code": widget.productReview.billCode,
                      "bill_desc": widget.productReview.billDesc,
                      "unit": widget.productReview.unit,
                      "comment": textReview.text,
                      "product_rating": productRating,
                      "delivery_rating": deliveryRating,
                    });

                    List<File>? listImg = [];
                    List<File>? listVideo = [];
                    if (_imageFileList.isNotEmpty) {
                      for (var i = 0; i < _imageFileList.length; i++) {
                        listImg.add(_imageFileList[i]);
                      }
                    }
                    // video
                    if (_controller != null) {
                      listVideo.add(io.File(_controller!.dataSource));
                    }
                    Get.find<ReviewsCtr>()
                        .saveReviewsFn(listImg, listVideo, json);

                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      successSentReview(context);
                    });
                  },
            child: const Text(
              'ส่งความคิดเห็น',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            )),
      ),
    );
  }

  //? upload ภาพและวิดีโอ
  widgetUpload() {
    return Row(
      children: [
        //? upload ภาพ
        InkWell(
          onTap: () async {
            if (countImg >= 10) {
              return;
            } else {
              await _openImagePicker();
            }
          },
          child: DottedBorder(
            borderType: BorderType.RRect,
            radius: const Radius.circular(10),
            dashPattern: const [8, 8],
            strokeWidth: 2,
            color: theme_color_df,
            child: const Padding(
                padding: EdgeInsets.all(12.0),
                child: Column(
                  children: [
                    Icon(Icons.camera_alt_rounded,
                        size: 40, color: Color.fromRGBO(123, 123, 123, 1)),
                    Text('อัปโหลดรูป')
                  ],
                )),
          ),
        ),
        const SizedBox(
          width: 12,
        ),
        //? upload วิดีโอ
        InkWell(
          onTap: () {
            // CompressFile('s');
            isPlay = true;
            _openVidePicker();
          },
          child: DottedBorder(
            borderType: BorderType.RRect,
            radius: const Radius.circular(10),
            dashPattern: const [8, 8],
            strokeWidth: 2,
            color: theme_color_df,
            child: const Padding(
                padding: EdgeInsets.all(12.0),
                child: Column(
                  children: [
                    Icon(Icons.videocam,
                        size: 40, color: Color.fromRGBO(123, 123, 123, 1)),
                    Text('อัปโหลดวิดีโอ')
                  ],
                )),
          ),
        ),
      ],
    );
  }

  //? ดาวขนส่ง
  widgetDeliveryReview() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'ขนส่ง',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Center(
              child: RatingBar(
                itemSize: 45,
                initialRating: 0,
                minRating: 0,
                direction: Axis.horizontal,
                allowHalfRating: true,
                itemCount: 5,
                itemPadding: const EdgeInsets.symmetric(horizontal: 6.0),
                onRatingUpdate: (rating) {
                  setState(() {
                    deliveryRating = rating;
                  });
                },
                ratingWidget: RatingWidget(
                  full: Image.asset('assets/images/review/fullStar.png'),
                  half: Image.asset('assets/images/review/halfStar.png'),
                  empty: Image.asset('assets/images/review/emptyStar.png'),
                ),
              ),
            ),
          ),
          const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('แย่'),
                Text('พอใช้'),
                Text('ดีมาก'),
              ]),
        ],
      ),
    );
  }

  //? ดาวรีวิวคุณภาพสินค้า
  widgetStarReview() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'คุณภาพสินค้า',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Center(
              child: RatingBar(
                itemSize: 45,
                initialRating: 0,
                minRating: 0,
                direction: Axis.horizontal,
                allowHalfRating: true,
                itemCount: 5,
                itemPadding: const EdgeInsets.symmetric(horizontal: 6.0),
                onRatingUpdate: (rating) {
                  setState(() {
                    productRating = rating;
                  });
                },
                ratingWidget: RatingWidget(
                  full: Image.asset('assets/images/review/fullStar.png'),
                  half: Image.asset('assets/images/review/halfStar.png'),
                  empty: Image.asset('assets/images/review/emptyStar.png'),
                ),
              ),
            ),
          ),
          const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('แย่'),
                Text('พอใช้'),
                Text('ดีมาก'),
              ]),
        ],
      ),
    );
  }

  //? กล่่องข้อความรีวิว
  widgetTextReview() {
    return Container(
        width: double.infinity,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
        child: TextFormField(
          inputFormatters: [LengthLimitingTextInputFormatter(maxLength)],
          keyboardType: TextInputType.text,
          controller: textReview,
          decoration: InputDecoration(
            hintMaxLines: 10,
            hintStyle: const TextStyle(fontSize: 14),
            hintText:
                'เล่าความประทับใจ หลังจากใช้งานสินค้าของคุณเป็นอย่างไร กรุณาใช้คำอย่างสุภาพ',
            suffixIcon: Container(
                width: 80,
                alignment: Alignment.bottomCenter,
                height: 150,
                child: Text(
                  '${textLength.toString()} / $maxLength',
                  style: const TextStyle(fontSize: 12),
                )),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
          maxLines: 5,
          onChanged: (value) {
            setState(() {
              textLength = value.length;
            });
          },
        ));
  }

  //? สินค้า
  widgetproduct() {
    return Row(
      children: [
        Expanded(
          child: Stack(
            alignment: Alignment.bottomRight,
            children: [
              Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(12)),
                    border: Border.all(
                        color: const Color.fromRGBO(171, 171, 171, 1))),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child:
                      CachedNetworkImage(imageUrl: widget.productReview.image),
                ),
              ),
              Container(
                width: 30,
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: theme_color_df,
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(8),
                        bottomRight: Radius.circular(8))),
                child: Text(
                  '${widget.productReview.unit}x',
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              )
            ],
          ),
        ),
        const SizedBox(
          width: 12,
        ),
        Expanded(
          flex: 3,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.productReview.billDesc,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              Text('เลขที่ใบกำกับภาษี ${widget.productReview.invoice}'),
              Text('รอบการขาย ${widget.productReview.salesCampaign}')
            ],
          ),
        )
      ],
    );
  }

  //? function remove image and remove cache
  Future<void> removeImageAndCache(int i) async {
    countImg -= 1;
    print("image count is $countImg");

    var fileCache = io.File(_imageFileList[i].path);
    if (fileCache.existsSync()) {
      await fileCache.delete(recursive: true);
    }

    _imageFileList
        .removeWhere((element) => element.path == _imageFileList[i].path);
    setState(() {});
  }
}

extension _StateExtension on State {
  /// [setState] when it's not building, then wait until next frame built.
  FutureOr<void> safeSetState(FutureOr<dynamic> Function() fn) async {
    await fn();
    if (mounted &&
        !context.debugDoingBuild &&
        context.owner?.debugBuilding == false) {
      // ignore: invalid_use_of_protected_member
      setState(() {});
    }
    final Completer<void> completer = Completer<void>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      completer.complete();
    });
    return completer.future;
  }
}
