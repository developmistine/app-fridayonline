import 'package:fridayonline/controller/app_controller.dart';
import 'package:fridayonline/homepage/review/history_review.dart';
import 'package:fridayonline/homepage/review/wait_review.dart';

import 'package:fridayonline/service/review/review_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../service/languages/multi_languages.dart';
import '../theme/theme_color.dart';

class Review extends StatelessWidget {
  const Review({super.key, required this.tabs});
  final int tabs;
  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context)
          .copyWith(textScaler: const TextScaler.linear(1.0)),
      child: Scaffold(
        appBar: PreferredSize(
            preferredSize: const Size.fromHeight(50),
            child: AppBar(
              leading: BackButton(
                  color: Colors.white,
                  onPressed: () {
                    Get.find<AppController>().setCurrentNavInget(4);
                    Get.toNamed('/backAppbarnotify',
                        parameters: {'changeView': '4'});
                  }),
              iconTheme: const IconThemeData(
                color: Colors.white, //change your color here
              ),
              centerTitle: true,
              backgroundColor: theme_color_df,
              title: const Text(
                "รีวิว",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontFamily: 'notoreg',
                    fontWeight: FontWeight.bold),
              ),
            )),
        body: DefaultTabController(
          initialIndex: tabs,
          length: 2,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Align(
                  alignment: Alignment.topCenter,
                  child: tabController(context)),
              Expanded(
                child: FutureBuilder(
                    future: reviewsDetails(),
                    builder: (context, snapshot) {
                      return TabBarView(
                        children: [
                          snapshot.connectionState == ConnectionState.waiting
                              ? const Center(
                                  child: CircularProgressIndicator(),
                                )
                              : WaitReview(snapshot.data!),
                          snapshot.connectionState == ConnectionState.waiting
                              ? const Center(
                                  child: CircularProgressIndicator(),
                                )
                              : HistoryReview(snapshot.data!),
                        ],
                      );
                    }),
              ),
              // search_field(),
            ],
          ),
        ),
      ),
    );
  }
}

Widget tabController(BuildContext context) {
  return Container(
    color: Colors.white,
    constraints: const BoxConstraints(maxHeight: 150.0),
    width: MediaQuery.of(context).size.width,
    child: TabBar(
      indicatorWeight: 3.5,
      labelColor: theme_color_df,
      indicatorColor: theme_color_df,
      unselectedLabelColor: Colors.black,
      tabs: const [
        Tab(
            child: Text(
          "รอรีวิว",
          style: TextStyle(fontSize: 16),
        )),
        Tab(
            child: Text(
          "ประวัติการรีวิว",
          style: TextStyle(fontSize: 16),
        )),
      ],
    ),
  );
}

MediaQuery headerFridayReview(context) {
  return MediaQuery(
    data: MediaQuery.of(context)
        .copyWith(textScaler: const TextScaler.linear(1.0)),
    child: Column(
      children: [
        Container(
          height: 50,
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // Checkbox(value: false, onChanged: (value) {}),
                const SizedBox(
                  width: 15,
                ),
                const Image(
                    width: 80,
                    image: AssetImage(
                      'assets/images/home/friday_logo.png',
                    )),
                const SizedBox(
                  width: 10,
                ),
                VerticalDivider(
                  width: 1,
                  thickness: 0.8,
                  indent: 10,
                  endIndent: 10,
                  color: theme_color_df,
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Text(
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    MultiLanguages.of(context)!
                        .translate('deliver_according_sales'),
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: theme_color_df),
                  ),
                ),
                Icon(
                  size: 22,
                  Icons.arrow_forward_ios_rounded,
                  color: theme_color_df,
                )
              ],
            ),
          ),
        ),
        Divider(
          color: theme_color_df,
          height: 1,
          thickness: 1.5,
        ),
      ],
    ),
  );
}
