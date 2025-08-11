import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:fridayonline/homepage/theme/theme_color.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class ThumbnailResult {
  final Image image;
  final int dataSize;
  final int height;
  final int width;
  const ThumbnailResult(
      {required this.image,
      required this.dataSize,
      required this.height,
      required this.width});
}

class ThumbnailRequest {
  final String video;
  final String thumbnailPath;
  final ImageFormat imageFormat;
  final int maxHeight;
  final int maxWidth;
  final int timeMs;
  final int quality;

  const ThumbnailRequest(
      {required this.video,
      required this.thumbnailPath,
      required this.imageFormat,
      required this.maxHeight,
      required this.maxWidth,
      required this.timeMs,
      required this.quality});
}

class VideoThumbnails extends StatefulWidget {
  const VideoThumbnails({super.key, required this.path});
  final String path;

  @override
  State<VideoThumbnails> createState() => _VideoThumbnailsWidgetState();
}

class _VideoThumbnailsWidgetState extends State<VideoThumbnails> {
  Uint8List? bytes;
  final Completer<ThumbnailResult> completer = Completer();
  Future<ThumbnailResult> genThumbnail(ThumbnailRequest r) async {
    Uint8List bytes;
    final Completer<ThumbnailResult> completer = Completer();
    final thumbnailPath = await VideoThumbnail.thumbnailFile(
        video: r.video,
        thumbnailPath: r.thumbnailPath,
        imageFormat: r.imageFormat,
        maxHeight: r.maxHeight,
        maxWidth: r.maxWidth,
        timeMs: r.timeMs,
        quality: r.quality);

    final file = File(thumbnailPath!);
    bytes = file.readAsBytesSync();

    int imageDataSize = bytes.length;

    final image = Image.memory(bytes);
    image.image
        .resolve(const ImageConfiguration())
        .addListener(ImageStreamListener((ImageInfo info, bool _) {
      completer.complete(ThumbnailResult(
        image: image,
        dataSize: imageDataSize,
        height: info.image.height,
        width: info.image.width,
      ));
    }));
    return completer.future;
  }

  Future<ThumbnailResult> initVideo() async {
    // check mounted
    if (!mounted) {
      return Future.error('Unmounted');
    }
    final thumbnail = await genThumbnail(ThumbnailRequest(
      video: widget.path,
      thumbnailPath: (await getTemporaryDirectory()).path,
      imageFormat: ImageFormat.WEBP,
      maxHeight: 64,
      maxWidth: 64,
      timeMs: 0,
      quality: 50,
    ));
    return thumbnail;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    // controller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ThumbnailResult>(
      future: initVideo(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
              height: 65,
              width: 65,
              clipBehavior: Clip.antiAlias,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(8)),
                border: Border.fromBorderSide(
                    BorderSide(color: Colors.grey, width: 1.0)),
              ),
              child: Center(
                  child: Lottie.asset(
                'assets/images/loading.json',
              )));
        }
        if (snapshot.hasData) {
          final image = snapshot.data.image as Image;

          return Stack(
            alignment: Alignment.center,
            children: [
              Container(
                  constraints: const BoxConstraints(
                    minWidth: 65,
                    minHeight: 65,
                  ),
                  // margin: const EdgeInsets.only(right: 4),
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(8)),
                    border: Border.fromBorderSide(
                        BorderSide(color: theme_color_df, width: 1.0)),
                  ),
                  child: image),
              const Icon(
                Icons.play_arrow_rounded,
                color: Colors.white,
              )
            ],
          );
        } else if (snapshot.hasError) {
          return Container(
            padding: const EdgeInsets.all(8.0),
            color: Colors.red,
            child: const Icon(Icons.error),
          );
        } else {
          return const SizedBox();
        }
      },
    );
  }
}
