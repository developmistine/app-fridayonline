// import 'package:fridayonline/homepage/myhomepage.dart';
import 'package:fridayonline/homepage/theme/theme_color.dart';
// import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:url_launcher/url_launcher.dart';

class ErrorPage extends StatelessWidget {
  final FlutterErrorDetails errorDetails;
  const ErrorPage({super.key, required this.errorDetails});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * .12,
              ),
              Lottie.asset('assets/images/error_code.json'),
              SizedBox(
                height: MediaQuery.of(context).size.height * .07,
              ),
              Text(
                "ขออภัยในความไม่สะดวก",
                style: TextStyle(
                    color: theme_color_df,
                    fontWeight: FontWeight.bold,
                    fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ErrorPageFullPage extends StatefulWidget {
  const ErrorPageFullPage({super.key});

  @override
  State<ErrorPageFullPage> createState() => _ErrorPageFullPageState();
}

class _ErrorPageFullPageState extends State<ErrorPageFullPage>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      print('resumed');
      // user returned to our app
    } else if (state == AppLifecycleState.inactive) {
      print('inactive');
      // user is about quit our app temporally
    } else if (state == AppLifecycleState.paused) {
      print('paused');
    } else if (state == AppLifecycleState.detached) {
      print('detached');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(backgroundColor: Colors.white, title: const Text('')),
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * .12,
              ),
              Lottie.asset('assets/images/error_code.json'),
              SizedBox(
                height: MediaQuery.of(context).size.height * .07,
              ),
              Text(
                textAlign: TextAlign.center,
                "กรุณาตรวจสอบการเชื่อมต่ออินเทอร์เน็ตของท่าน \n ขออภัยในความไม่สะดวก",
                style: TextStyle(
                    color: theme_color_df,
                    fontWeight: FontWeight.bold,
                    fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AppUpdateVersion extends StatelessWidget {
  final String url;
  final String title;
  final String detail;
  const AppUpdateVersion(
      {super.key,
      required this.url,
      required this.title,
      required this.detail});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          backgroundColor: theme_color_df,
          title: Text(
            title,
            style: const TextStyle(
                color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
          )),
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * .12,
              ),
              Lottie.asset('assets/images/app-update.json', height: 300),
              const SizedBox(
                height: 20,
              ),
              Text(
                detail,
                textAlign: TextAlign.center,
                style: TextStyle(color: theme_color_df, fontSize: 18),
              ),
              const SizedBox(
                height: 30,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width / 1.3,
                height: 50,
                child: ElevatedButton(
                  style:
                      ElevatedButton.styleFrom(backgroundColor: theme_color_df),
                  onPressed: () {
                    var url1 = Uri.parse(url);
                    launchUrl(
                      url1,
                      mode: LaunchMode.externalApplication,
                    );
                    // Navigator.pop(context);
                    // Navigator.pop(context, true);
                  },
                  child: const Text(
                    textAlign: TextAlign.center,
                    'อัปเดต',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
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
