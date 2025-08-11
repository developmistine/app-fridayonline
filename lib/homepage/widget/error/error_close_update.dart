import 'package:flutter/material.dart';

import '../../theme/theme_color.dart';

class ErrorCloseUpdate extends StatelessWidget {
  const ErrorCloseUpdate({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        child: Center(
          child: Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * .12,
              ),
              Image.asset('assets/images/error/error_page.png'),
              const SizedBox(
                height: 26,
              ),
              const Text(
                "ขออภัยค่ะ",
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 24),
              ),
              const SizedBox(
                height: 26,
              ),
              const Text(
                textAlign: TextAlign.center,
                "เนื่องจากมีการปรับปรุงระบบ ส่งผลให้ \n เข้างานแอปฯ ไม่ได้ในบางช่วงเวลา \n เราจะทำการแก้ไขอย่างเร่งด่วน \n กรุณาทำรายการใหม่อีกครั้งในภายหลัง ",
                style: TextStyle(color: Colors.black, fontSize: 18),
              ),
              const SizedBox(
                height: 35,
              ),
              ButtonTheme(
                minWidth: 150.0,
                height: 40.0,
                child: SizedBox(
                  width: 334,
                  height: 60,
                  child: ElevatedButton(
                    style: ButtonStyle(
                        foregroundColor:
                            MaterialStateProperty.all<Color>(Colors.white),
                        backgroundColor:
                            MaterialStateProperty.all<Color>(theme_color_df),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30.0),
                                    side: BorderSide(color: theme_color_df)))),
                    onPressed: () async {
                      Navigator.pop(context, true);
                    },
                    child: const Text('ตกลง',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Colors.white)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
