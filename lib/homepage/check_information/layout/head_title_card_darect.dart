import 'package:flutter/material.dart';
import '../../theme/theme_color.dart';

class HeadTitleCardDirect extends StatelessWidget {
  final String headTitles;
  const HeadTitleCardDirect({
    super.key,
    required this.headTitles,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 10, left: 15, right: 15),
          child: IntrinsicHeight(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    headTitles != '' ? headTitles : 'ร้านค้าไม่มีชื่อ',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: theme_color_df,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: VerticalDivider(
                    color: theme_color_df,
                    thickness: 1,
                  ),
                ),
                Text(
                  'ดูรายละเอียด',
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: theme_color_df),
                )
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 8, right: 8),
          child: Divider(
            color: theme_color_df,
            thickness: 1,
          ),
        ),
      ],
    );
  }
}
