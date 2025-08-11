import 'package:fridayonline/controller/app_controller.dart';
import 'package:fridayonline/homepage/theme/theme_color.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';

import '../../service/languages/multi_languages.dart';

class CustomAlertDialogs extends StatefulWidget {
  const CustomAlertDialogs({
    super.key,
    required this.title,
    required this.description,
  });

  final String title, description;

  @override
  State<CustomAlertDialogs> createState() => _CustomAlertDialogsState();
}

class _CustomAlertDialogsState extends State<CustomAlertDialogs> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AppController>(builder: (controller) {
      return MediaQuery(
        data: MediaQuery.of(context)
            .copyWith(textScaler: const TextScaler.linear(1.0)),
        child: Dialog(
          elevation: 0,
          backgroundColor: const Color(0xffffffff),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        widget.title,
                        style: TextStyle(
                            fontSize: 15.0,
                            color: theme_color_df,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'notoreg'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    widget.description,
                    style: const TextStyle(
                        fontFamily: 'notoreg', color: Colors.black),
                  ),
                ),
                const SizedBox(height: 20),
                const Divider(
                  height: 1,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: 50,
                  child: InkWell(
                    highlightColor: Colors.grey[200],
                    onTap: () {
                      //do somethig
                      controller.Setcurrentsetstatuschick(1);
                      Navigator.of(context).pop();
                    },
                    child: Center(
                      child: Text(
                        MultiLanguages.of(context)!.translate('alert_close'),
                        style: TextStyle(
                            fontSize: 15.0,
                            color: theme_color_df,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'notoreg'),
                      ),
                    ),
                  ),
                ),
                const Divider(
                  height: 1,
                ),
                // Container(
                //   width: MediaQuery.of(context).size.width,
                //   height: 50,
                //   child: InkWell(
                //     borderRadius: BorderRadius.only(
                //       bottomLeft: Radius.circular(15.0),
                //       bottomRight: Radius.circular(15.0),
                //     ),
                //     highlightColor: Colors.grey[200],
                //     onTap: () {
                //       Navigator.of(context).pop();
                //     },
                //     child: Center(
                //       child: Text(
                //         "Cancel",
                //         style: TextStyle(
                //           fontSize: 16.0,
                //           fontWeight: FontWeight.normal,
                //         ),
                //       ),
                //     ),
                //   ),
                // ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
