import 'package:fridayonline/homepage/theme/theme_color.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class HomeExpressBanner extends StatelessWidget {
  const HomeExpressBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 350,
          child: Padding(
            padding:
                const EdgeInsets.only(left: 10, right: 10, bottom: 10, top: 10),
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  height: 168,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: const Color.fromARGB(255, 201, 230, 246),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 2,
                        offset:
                            const Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                                margin:
                                    const EdgeInsets.only(right: 8, bottom: 8),
                                width: 125,
                                child: Image.asset(
                                    'assets/images/home/friday_logo2.png')),
                            const Text(
                              'Banner',
                              style: TextStyle(fontSize: 24),
                            )
                          ],
                        ),
                        const Text(
                          'การรันตีสินค้าส่งด่วน 3 วัน',
                          style: TextStyle(fontSize: 24),
                        ),
                        const Text('ชำระเงินปลายทาง'),
                        const Text(
                          'เฉพาะแบนเนอร์นี้เท่านั้น',
                          style: TextStyle(
                              height: 2,
                              color: Colors.red,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                    height: 150,
                    width: double.infinity,
                    child: GridView.builder(
                      // shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemCount: 10,
                      itemBuilder: (BuildContext context, int index) {
                        return Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              boxShadow: const [
                                BoxShadow(
                                  color: Color.fromARGB(14, 0, 0, 0),
                                  offset: Offset(0.0, 4.0),
                                  blurRadius: 0.2,
                                  spreadRadius: 0.2,
                                ), //BoxShadow
                              ],
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Column(children: [
                                // if (show)
                                Center(
                                  child: CachedNetworkImage(
                                    imageUrl:
                                        'https://www.citypng.com/public/uploads/preview/-41601314003cc85anibww.png',
                                    height: 75,
                                    fit: BoxFit.contain,
                                  ),
                                ),

                                const SizedBox(height: 12),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      children: [
                                        Text(
                                          textAlign: TextAlign.left,
                                          "฿ 111",
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontFamily: 'notoreg',
                                              color: theme_color_df),
                                        ),
                                        const Text(
                                          textAlign: TextAlign.left,
                                          "฿9999",
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontFamily: 'notoreg',
                                            color: Colors.grey,
                                            decoration:
                                                TextDecoration.lineThrough,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ]),
                            ),
                          ),
                        );
                      },
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              mainAxisSpacing: 2,
                              mainAxisExtent: 100,
                              crossAxisCount: 1),
                    )),
              ],
            ),
          ),
        ),
        Container(
          height: 8,
          color: const Color.fromRGBO(218, 218, 218, 1),
        )
      ],
    );
  }
}
