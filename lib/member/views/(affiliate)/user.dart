import 'package:flutter/material.dart';
import 'package:fridayonline/member/components/profile/affiliate/user.apply.dart';
import 'package:fridayonline/member/components/profile/affiliate/user.header.dart';
import 'package:fridayonline/member/components/profile/affiliate/user.slide.dart';
import 'package:fridayonline/safearea.dart';

class AffiliateUser extends StatefulWidget {
  const AffiliateUser({super.key});

  @override
  State<AffiliateUser> createState() => _AffiliateUserState();
}

class _AffiliateUserState extends State<AffiliateUser> {
  @override
  Widget build(BuildContext context) {
    return SafeAreaProvider(
        child: Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: SingleChildScrollView(
        child: SizedBox(
          child: Stack(children: [
            Container(
              clipBehavior: Clip.antiAlias,
              decoration: ShapeDecoration(
                gradient: LinearGradient(
                  begin: Alignment(0.46, 0.00),
                  end: Alignment(0.46, 1.00),
                  colors: [Color(0xFF2291F5), Color(0xFF2EA9E1)],
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(16),
                    bottomRight: Radius.circular(16),
                  ),
                ),
              ),
              child: Image.asset(
                'assets/images/profileimg/background.png',
                fit: BoxFit.cover,
                width: double.infinity,
                height: 268,
              ),
            ),
            SafeArea(child: Column(children: [Header(), Slides(), Apply()]))
          ]),
        ),
      ),
    ));
  }
}
