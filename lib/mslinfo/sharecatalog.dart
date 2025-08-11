import 'package:fridayonline/homepage/login/widgetsetprofilerheader.dart';
import 'package:fridayonline/homepage/widget/appbarmaster.dart';
import 'package:fridayonline/model/shartcat/shorturl.dart';
import 'package:fridayonline/service/mslinfo/objectenduser.dart';
import 'package:fridayonline/service/mslinfo/servicegetenduserlist.dart';
import 'package:fridayonline/service/mslinfo/sharecat_shorturl_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:qr_flutter/qr_flutter.dart';
// import 'package:shared_preferences/shared_preferences.dart';

import '../homepage/theme/theme_color.dart';
import '../homepage/widget/widgetsetline.dart';
import '../model/check_information/enduser/enduser_del.dart';
import '../service/languages/multi_languages.dart';
import '../service/logapp/logapp_service.dart';
// import '../service/pathapi.dart';

class ShareCatalog extends StatefulWidget {
  const ShareCatalog({super.key});

  @override
  State<ShareCatalog> createState() => _ShareCatalogState();
}

class _ShareCatalogState extends State<ShareCatalog> {
  // ส่วนที่ระบบดำเนินการประกาศตัว
  String? lspath = '';
  String? lsRepSeq = '';
  String? lsRepCode = '';
  String? lsRepName = '';
  late Objectenduser objectenduser;
  late Objectenduser objectenduserlist;

  @override
  void initState() {
    super.initState();
    callShareCatUrl();
  }

  Future<void> share() async {
    // print("ton");
    // LogSH
    LogAppShareCatalogCall("share_cat");
    await FlutterShare.share(
        title: 'แชร์แค็ตตาล็อก',
        text:
            ' แชร์แค็ตตาล็อก แอปพลิเคชันฟรายเดย์ คลิกลิงค์เพื่อโหลดแอปพลิเคชัน',
        linkUrl: lspath,
        chooserTitle: 'แชร์แค็ตตาล็อก');
  }

  void loadenduserlist() async {
    objectenduser = await GetEndUserList();

    setState(() {
      objectenduserlist = objectenduser;
    });
  }

  void callShareCatUrl() async {
    SharecatshortUrl? res = await shareCatShorUrlService();
    setState(() {
      lspath = res!.shortUrl;
    });
  }

  void callDelEus(String musersdata, String mtel) async {
    DelEus? dataDel = await DelEndUserCall(musersdata, mtel);

    // print(data_del!.toJson());

    if (dataDel!.value.success == "1") {
      var mMsg = dataDel.value.description.msg.msgAlert1;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showDialog(
            barrierDismissible: false,
            builder: (BuildContext context) {
              return Dialog(
                elevation: 0,
                backgroundColor: const Color(0xffffffff),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 15),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [],
                    ),
                    const SizedBox(height: 15),
                    Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Column(
                        children: [
                          Text(
                            mMsg,
                            style: const TextStyle(
                                fontFamily: 'notoreg',
                                fontWeight: FontWeight.bold,
                                fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Divider(
                      height: 1,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: SizedBox(
                            width: 100,
                            height: 50,
                            child: InkWell(
                              highlightColor: Colors.grey[200],
                              onTap: () {
                                //do somethig
                                Navigator.pop(context, false);
                                loadenduserlist();
                              },
                              child: Center(
                                child: Text(
                                  "ตกลง",
                                  style: TextStyle(
                                      fontSize: 15.0,
                                      color: theme_color_df,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'notoreg'),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Divider(
                      height: 1,
                    ),
                  ],
                ),
              );
            },
            context: context);
      });
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showDialog(
            barrierDismissible: false,
            builder: (BuildContext context) {
              return Dialog(
                elevation: 0,
                backgroundColor: const Color(0xffffffff),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 15),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [],
                    ),
                    const SizedBox(height: 15),
                    const Padding(
                      padding: EdgeInsets.all(2.0),
                      child: Column(
                        children: [
                          Text(
                            "ไม่สมารถลบข้อมูลลูกค้าได้",
                            style: TextStyle(
                                fontFamily: 'notoreg',
                                fontWeight: FontWeight.bold,
                                fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Divider(
                      height: 1,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: SizedBox(
                            width: 100,
                            height: 50,
                            child: InkWell(
                              highlightColor: Colors.grey[200],
                              onTap: () {
                                //do somethig
                                Navigator.pop(context, false);
                              },
                              child: Center(
                                child: Text(
                                  "ตกลง",
                                  style: TextStyle(
                                      fontSize: 15.0,
                                      color: theme_color_df,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'notoreg'),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Divider(
                      height: 1,
                    ),
                  ],
                ),
              );
            },
            context: context);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarTitleMaster(
          MultiLanguages.of(context)!.translate('me_share_catalog')),
      body: MediaQuery(
        data: MediaQuery.of(context)
            .copyWith(textScaler: const TextScaler.linear(1.0)),
        child: Column(
          children: [
            // ส่วนที่แสดงความห่างของระบบในส่วนที่ 1
            const SizedBox(
              height: 5.0,
            ),
            // ส่วนที่แสดงข้อความต่างๆของระบบ
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 8.0),
                  child: Text(
                    MultiLanguages.of(context)!.translate('me_scan_qrcode'),
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: 'notoreg',
                      fontWeight: FontWeight.bold,
                      color: theme_color_back1,
                    ),
                  ),
                )
              ],
            ),
            // ส่วนที่ระบบแสดงเป็น QRCODE ออกมา
            QrImageView(
              data: lspath!,
              size: 200,
            ),

            Container(
                alignment: Alignment.center,
                child: SizedBox(
                  width: 200,
                  child: ElevatedButton.icon(
                      style: ButtonStyle(
                          foregroundColor:
                              WidgetStateProperty.all<Color>(Colors.white),
                          backgroundColor:
                              WidgetStateProperty.all<Color>(theme_color_df),
                          shape:
                              WidgetStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30.0),
                                      side:
                                          BorderSide(color: theme_color_df)))),
                      onPressed: share,
                      icon: const Icon(
                        Icons.share,
                        size: 18,
                        color: Colors.white,
                      ),
                      label: Text(
                        MultiLanguages.of(context)!
                            .translate('me_share_catalog_btn'),
                      )),
                )),

            settextheader(
                MultiLanguages.of(context)!.translate('me_customer_detail')),
            controlline(),
            FutureBuilder(
              future: GetEndUserList(),
              builder: (BuildContext context,
                  AsyncSnapshot<Objectenduser> snapshot) {
                //

                if (snapshot.hasError) {
                  return const Center(
                    child: Text("พบข้อผิดพลาดในการ Load ข้อมูล"),
                  );
                }
                // กรณีที่มีข้อมูล ระบบจะทำการ Return ออกมาแบบไหน
                if (snapshot.hasData) {
                  var usersdata = snapshot.data;

                  return Expanded(
                    flex: 1,
                    child: ListView.builder(
                      // ส่วนนี้ทำการ Update ข้อมูลเข้ามา
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: usersdata!.reference.byEnduser.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Card(
                            color: Colors.white,
                            child: ListTile(
                                tileColor: Colors.white,
                                onTap: () async {
                                  var musersdata = usersdata
                                      .reference.byEnduser[index].userId;
                                  var mtel =
                                      usersdata.reference.byEnduser[index].tel;

                                  showDialog(
                                      barrierDismissible: false,
                                      builder: (BuildContext context) {
                                        return Dialog(
                                          elevation: 0,
                                          backgroundColor:
                                              const Color(0xffffffff),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(15.0),
                                          ),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              const SizedBox(height: 15),
                                              const Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [],
                                              ),
                                              const SizedBox(height: 15),
                                              const Padding(
                                                padding: EdgeInsets.all(2.0),
                                                child: Text(
                                                  "คุณต้องการลบข้อมูลลูกค้าหรือไม่",
                                                  style: TextStyle(
                                                    fontFamily: 'notoreg',
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(height: 20),
                                              const Divider(
                                                height: 1,
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceAround,
                                                children: [
                                                  InkWell(
                                                    onTap: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                    child: SizedBox(
                                                      width: 100,
                                                      height: 50,
                                                      child: InkWell(
                                                        highlightColor:
                                                            Colors.grey[200],
                                                        onTap: () {
                                                          //do somethig

                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                        child: Center(
                                                          child: Text(
                                                            "ยกเลิก",
                                                            style: TextStyle(
                                                                fontSize: 15.0,
                                                                color:
                                                                    theme_color_df,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontFamily:
                                                                    'notoreg'),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  InkWell(
                                                    onTap: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                    child: SizedBox(
                                                      width: 100,
                                                      height: 50,
                                                      child: InkWell(
                                                        highlightColor:
                                                            Colors.grey[200],
                                                        onTap: () {
                                                          //do somethig
                                                          Navigator.pop(
                                                              context, false);

                                                          callDelEus(
                                                              musersdata, mtel);
                                                        },
                                                        child: Center(
                                                          child: Text(
                                                            "ลบ",
                                                            style: TextStyle(
                                                                fontSize: 15.0,
                                                                color:
                                                                    theme_color_df,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontFamily:
                                                                    'notoreg'),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              // const Divider(
                                              //   height: 1,
                                              // ),
                                            ],
                                          ),
                                        );
                                      },
                                      context: context);

                                  //
                                },
                                title: Text(
                                  '${usersdata.reference.byEnduser[index].name} ${usersdata.reference.byEnduser[index].surname}',
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontFamily: 'notoreg',
                                      fontWeight: FontWeight.bold),
                                ),
                                subtitle: Text(
                                    'เบอร์ติดต่อ ${usersdata.reference.byEnduser[index].tel}'
                                        .replaceAllMapped(
                                            RegExp(r'(\d{3})(\d{3})(\d+)'),
                                            (Match m) =>
                                                "${m[1]}-${m[2]}-${m[3]}"),
                                    style: TextStyle(
                                        fontFamily: 'notoreg',
                                        fontSize: 15,
                                        color: theme_color_back1)),
                                // leading: Icon(
                                //   Icons.person,
                                //   size: 25,
                                // ),
                                trailing: Image.asset(
                                    scale: 1.8,
                                    'assets/images/cart/delete.png'),
                                iconColor: theme_color_df));
                      },
                    ),
                  );
                }
                // กรณี Run อยู่ยังไม่มี Data
                return const Stack(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Center(
                          child: CircularProgressIndicator(),
                        ),
                      ],
                    )
                  ],
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
