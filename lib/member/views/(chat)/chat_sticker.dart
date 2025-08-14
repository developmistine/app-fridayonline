import 'package:fridayonline/member/components/appbar/appbar.master.dart';
import 'package:fridayonline/member/components/showproduct/nodata.dart';
import 'package:fridayonline/member/models/chat/sticker_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class ChatSticker extends StatelessWidget {
  final List<Sticker> sticker;
  const ChatSticker({super.key, required this.sticker});

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
              textTheme: GoogleFonts.notoSansThaiLoopedTextTheme(
                Theme.of(context).textTheme,
              ),
            ),
            child: Scaffold(
              appBar: appBarMasterEndUser('รายการสติกเกอร์'),
              body: sticker.isEmpty
                  ? Center(
                      child: nodata(context),
                    )
                  : GridView.builder(
                      padding: EdgeInsets.zero,
                      scrollDirection: Axis.vertical,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3, mainAxisExtent: 140),
                      itemCount: sticker.length,
                      itemBuilder: (context, index) {
                        var items = sticker[index];

                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: GestureDetector(
                            onTap: () {
                              Get.back(result: items);
                            },
                            child: CachedNetworkImage(
                              width: 300,
                              height: 300,
                              imageUrl: items.stickerImage,
                            ),
                          ),
                        );
                      },
                    ),
            )));
  }
}
