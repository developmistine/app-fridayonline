import 'dart:async';
import 'package:appfridayecommerce/enduser/views/(chat)/chat.gallery.dart';
import 'package:appfridayecommerce/enduser/views/(chat)/chat.stay.picture.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:path/path.dart';

class CameraPage extends StatefulWidget {
  final int roomId;
  final int senderId;
  const CameraPage({super.key, required this.roomId, required this.senderId});

  @override
  State<CameraPage> createState() => _CustomCameraPageState();
}

class _CustomCameraPageState extends State<CameraPage> {
  late CameraController _controller;
  late List<CameraDescription> _cameras;
  int _selectedCameraIdx = 0;
  bool _isRecording = false;
  bool _isVideoMode = false;
  bool _isReady = false;
  FlashMode _flashMode = FlashMode.off;

  Timer? _timer;
  double _recordDuration = 0.0;
  final double _maxDuration = 15.0;

  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  Future<void> _initCamera() async {
    _cameras = await availableCameras();

    if (_selectedCameraIdx >= _cameras.length) {
      _selectedCameraIdx = 0;
    }

    _controller = CameraController(
      _cameras[_selectedCameraIdx],
      ResolutionPreset.high,
      enableAudio: true,
    );

    await _controller.initialize();
    await _controller.setFlashMode(_flashMode); // ตั้งค่าแฟลชตอนเริ่ม

    if (mounted) {
      setState(() {
        _isReady = true;
      });
    }
  }

  Future<void> _switchCamera() async {
    if (_cameras.length < 2) return; // ถ้ามีกล้องเดียวให้ return

    _selectedCameraIdx = _selectedCameraIdx % 2 == 0 ? 1 : 0;

    await _controller.dispose();

    _controller = CameraController(
      _cameras[_selectedCameraIdx],
      ResolutionPreset.high,
      enableAudio: true,
    );

    await _controller.initialize();
    await _controller.setFlashMode(_flashMode);

    if (mounted) setState(() {});
  }

  Future<void> _toggleFlash() async {
    if (_flashMode == FlashMode.off) {
      _flashMode = FlashMode.torch; // เปิดไฟฉาย (แฟลชติดค้าง)
    } else {
      _flashMode = FlashMode.off;
    }

    await _controller.setFlashMode(_flashMode);
    if (mounted) setState(() {});
  }

  // Future<String> _getFilePath({required bool isVideo}) async {
  //   final dir = await getTemporaryDirectory();
  //   final String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
  //   final String ext = isVideo ? '.mp4' : '.jpg';
  //   return join(dir.path, '$timestamp$ext');
  // }

  Future<void> _takePhoto(context) async {
    // final path = await _getFilePath(isVideo: false);
    await _controller.takePicture().then((file) {
      // Navigator.pop(context, File(file.path));
      Get.to(() => StayPicture(
          file: file, roomId: widget.roomId, senderId: widget.senderId));
    });
  }

  Future<void> _startOrStopVideo(BuildContext context) async {
    if (_isRecording) {
      await _controller.stopVideoRecording().then((res) {
        // Navigator.pop(context, File(res.path));
        Get.to(() => StayPicture(
            file: res, roomId: widget.roomId, senderId: widget.senderId));
      });
      _timer?.cancel();
      setState(() {
        _isRecording = false;
        _recordDuration = 0;
      });
    } else {
      await _controller.startVideoRecording();
      setState(() {
        _isRecording = true;
        _recordDuration = 0;
      });

      _timer = Timer.periodic(const Duration(milliseconds: 100), (timer) async {
        if (_recordDuration >= _maxDuration) {
          await _startOrStopVideo(context);
        } else {
          setState(() {
            _recordDuration = double.parse(
              (_recordDuration + 0.1).toStringAsFixed(1),
            );
          });
        }
      });
    }
  }

  @override
  void dispose() {
    if (!mounted) return;
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isReady) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            Stack(
              children: [
                ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: CameraPreview(_controller)),
                Positioned(
                  top: 20,
                  left: 10,
                  child: InkWell(
                      onTap: () {
                        Get.back();
                      },
                      child: const Icon(Icons.close_rounded,
                          color: Colors.white, size: 28)),
                ),
                Positioned(
                  top: 10,
                  left: 0,
                  right: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.flip_camera_ios_rounded,
                            color: Colors.white, size: 28),
                        onPressed: _switchCamera,
                      ),
                      IconButton(
                        icon: Icon(
                          _flashMode == FlashMode.off
                              ? Icons.flash_off
                              : Icons.flash_on,
                          color: Colors.white,
                          size: 28,
                        ),
                        onPressed: _toggleFlash,
                      ),
                      // IconButton(
                      //   icon: Icon(
                      //     _isVideoMode ? Icons.photo_camera : Icons.videocam,
                      //     color: Colors.white,
                      //     size: 32,
                      //   ),
                      //   onPressed: () {
                      //     setState(() {
                      //       _isVideoMode = !_isVideoMode;
                      //     });
                      //   },
                      // ),
                    ],
                  ),
                ),
                if (_isVideoMode)
                  Positioned(
                    bottom: 120,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: _isRecording
                          ? Text(
                              _recordDuration.toStringAsFixed(1),
                              style: GoogleFonts.notoSansThaiLooped(
                                  color: Colors.white,
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold),
                            )
                          : null,
                    ),
                  ),
                Positioned(
                  bottom: 30,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Stack(
                      clipBehavior: Clip.none,
                      alignment: Alignment.bottomRight,
                      children: [
                        if (_isVideoMode && _isRecording)
                          SizedBox(
                            width: 72,
                            height: 72,
                            child: CircularProgressIndicator(
                              value: _isRecording
                                  ? _recordDuration / _maxDuration
                                  : 0,
                              strokeWidth: 4,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                _isRecording ? Colors.red : Colors.white,
                              ),
                              backgroundColor: Colors.grey.shade300,
                            ),
                          ),
                        GestureDetector(
                          onTap: () {
                            _isVideoMode
                                ? _startOrStopVideo(context)
                                : _takePhoto(context);
                          },
                          child: Container(
                            width: 72,
                            height: 72,
                            clipBehavior: Clip.antiAlias,
                            padding: EdgeInsets.all(_isRecording ? 18 : 2),
                            decoration: BoxDecoration(
                                color: Colors.transparent,
                                shape: BoxShape.circle,
                                border: Border.all(
                                    color: Colors.white,
                                    width: 3,
                                    strokeAlign:
                                        BorderSide.strokeAlignOutside)),
                            child: Container(
                              decoration: BoxDecoration(
                                  shape: _isRecording
                                      ? BoxShape.rectangle
                                      : BoxShape.circle,
                                  color:
                                      _isVideoMode ? Colors.red : Colors.white),
                            ),
                            // ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  right: 12,
                  bottom: 30,
                  child: InkWell(
                    onTap: () {
                      Get.to(() => const ChatGallary(), arguments: 2);
                    },
                    child: const Icon(
                      Icons.image,
                      size: 38,
                      color: Colors.white38,
                    ),
                  ),
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onTap: () {
                    setState(() {
                      _isVideoMode = !_isVideoMode;
                    });
                  },
                  child: Column(
                    children: [
                      Text(
                        "รูปภาพ",
                        style: GoogleFonts.notoSansThaiLooped(
                          decorationThickness: 4,
                          fontWeight: _isVideoMode
                              ? FontWeight.normal
                              : FontWeight.bold,
                          color: _isVideoMode ? Colors.grey : Colors.white,
                        ),
                      ),
                      SizedBox(
                        width: 40,
                        height: 18,
                        child: Divider(
                          thickness: 4,
                          color: _isVideoMode ? Colors.black : Colors.amber,
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  width: 12,
                ),
                InkWell(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onTap: () {
                    setState(() {
                      _isVideoMode = !_isVideoMode;
                    });
                  },
                  child: Column(
                    children: [
                      Text(
                        "วิดีโอ",
                        style: GoogleFonts.notoSansThaiLooped(
                          fontWeight: _isVideoMode
                              ? FontWeight.bold
                              : FontWeight.normal,
                          color: _isVideoMode ? Colors.white : Colors.grey,
                        ),
                      ),
                      SizedBox(
                        width: 40,
                        height: 18,
                        child: Divider(
                          thickness: 4,
                          color: _isVideoMode ? Colors.amber : Colors.black,
                        ),
                      )
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
}
