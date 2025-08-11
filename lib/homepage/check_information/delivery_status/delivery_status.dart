import 'package:flutter/material.dart';
import '../../../service/languages/multi_languages.dart';
import '../../theme/theme_color.dart';
import 'deilvery_status_direct_sales.dart';
// import 'delivery_status_express_sales.dart';

class CheckInformationDelivery extends StatelessWidget {
  const CheckInformationDelivery({Key? key}) : super(key: key);

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
            MultiLanguages.of(context)!.translate('me_delivery'),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: const DeliveryStatusDirectSales(),
        //? fade dropship
        // body: DefaultTabController(
        //   length: 2,
        //   child: Column(
        //     children: <Widget>[
        //       Container(
        //         constraints: const BoxConstraints(maxHeight: 150.0),
        //         child: Material(
        //           color: Colors.white,
        //           child: TabBar(
        //             labelColor: theme_color_df,
        //             indicatorColor: theme_color_df,
        //             unselectedLabelColor: Colors.black,
        //             // ignore: prefer_const_literals_to_create_immutables
        //             tabs: [
        //               Tab(
        //                 child: Text(
        //                   MultiLanguages.of(context)!
        //                       .translate('tab_text_friday_direct_sales'),
        //                   style: const TextStyle(
        //                       fontSize: 15, fontWeight: FontWeight.bold),
        //                 ),
        //               ),
        //               Tab(
        //                 child: Text(
        //                   MultiLanguages.of(context)!
        //                       .translate('tab_text_express_delivery'),
        //                   style: const TextStyle(
        //                       fontSize: 15, fontWeight: FontWeight.bold),
        //                 ),
        //               ),
        //             ],
        //           ),
        //         ),
        //       ),
        //       Expanded(
        //         child: Container(
        //           color: Colors.white,
        //           child: const TabBarView(
        //             // controller: _tabController,
        //             children: [
        //               DeliveryStatusDirectSales(),
        //               DeliveryStatusExpressSales(),
        //             ],
        //           ),
        //         ),
        //       ),
        //     ],
        //   ),
        // ),
        // body: const DeliveryStatusDirectSales(),
      ),
    );
  }
}
