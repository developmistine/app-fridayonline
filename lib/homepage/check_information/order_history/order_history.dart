import 'package:flutter/material.dart';
import '../../../service/languages/multi_languages.dart';
import '../../theme/theme_color.dart';
import 'order_history_direct_sales_radio.dart';
// import 'order_history_express_sales.dart';

class CheckInformationHistory extends StatelessWidget {
  const CheckInformationHistory({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context)
          .copyWith(textScaler: const TextScaler.linear(1.0)),
      child: Scaffold(
        backgroundColor: const Color(0XFFF5F5F5),
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.white),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          backgroundColor: theme_color_df,
          centerTitle: true,
          title: Text(
            MultiLanguages.of(context)!.translate('segment_history_buy'),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: const CheckInformationOrderHistory(),
      ),
    );
  }
}
