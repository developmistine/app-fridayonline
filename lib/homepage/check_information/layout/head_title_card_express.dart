import 'package:flutter/material.dart';
import '../../theme/theme_color.dart';

class HeadTitleExpress extends StatelessWidget {
  const HeadTitleExpress({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(22),
          topLeft: Radius.circular(22),
        ),
        color: Color(0XFFFD7F6B),
      ),
      child: Padding(
        padding:
            const EdgeInsets.only(top: 10, left: 15, right: 15, bottom: 10),
        child: IntrinsicHeight(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          border: Border.all(width: 3, color: theme_color_df),
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5)),
                      child: Padding(
                        padding: const EdgeInsets.all(5),
                        child: Text(
                          'ส่งด่วน 3 วัน',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: theme_color_df,
                              fontSize: 13),
                        ),
                      ),
                    ),
                    const VerticalDivider(
                      color: Colors.black,
                      thickness: 1,
                    ),
                    const Expanded(
                      child: Text(
                        'เก็บเงินปลายทาง',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            fontSize: 13),
                      ),
                    )
                  ],
                ),
              ),
              const Text(
                'ดูรายละเอียด',
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
