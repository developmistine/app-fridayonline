import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../model/market/market_retun_login.dart';
import '../../service/market/market_service.dart';
import '../market/market_main.dart';

class FacebookLoginPage extends StatefulWidget {
  const FacebookLoginPage({Key? key}) : super(key: key);

  @override
  State<FacebookLoginPage> createState() => _FacebookLoginPageState();
}

class _FacebookLoginPageState extends State<FacebookLoginPage> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  Map<String, dynamic>? _userData;
  // AccessToken? _accessToken;
  // bool _checking = true;

  @override
  void initState() {
    super.initState();

    _checkIfisLoggedIn();
  }

  Future<void> _checkIfisLoggedIn() async {
    final accessToken = await FacebookAuth.instance.accessToken;

    setState(() {
      // _checking = false;
    });

    if (accessToken != null) {
      print(accessToken.toJson());
      final userData = await FacebookAuth.instance.getUserData();
      // _accessToken = accessToken;
      setState(() {
        _userData = userData;
        print(_userData);
      });
    } else {
      _login();
    }
  }

  Future<void> _login() async {
    final SharedPreferences prefs = await _prefs;
    final LoginResult result = await FacebookAuth.instance.login();

    if (result.status == LoginStatus.success) {
      // _accessToken = result.accessToken;

      final userData = await FacebookAuth.instance.getUserData();
      _userData = userData;
      var displayname = _userData!['name'];
      var userid = _userData!['id'];
      var imgUrl = _userData!['picture']['data']['url'];

      // print("AccessToken> " + accesstoken);
      // print("DisplayName> " + displayname);
      // print("StatusMessage> " + statusmessage);
      // print("ProfileURL> " + imgUrl);
      // print("userId> " + userId);

      // กรณีที่ทำการ Set Data

      MarketRetunLogin dataLoginRetun = await MarketLoginSystemsCall();

      if (dataLoginRetun.code == "100") {
        prefs.setString("login_market", '1');
        prefs.setString("Chanelsignin", 'Facebook');
        prefs.setString("CustomerID", dataLoginRetun.userId);
        prefs.setString("AccessToken", userid);
        prefs.setString("AccessID", userid);
        prefs.setString("Name", displayname);
        prefs.setString("ProfileImg", imgUrl);
        prefs.setString("UserTypeMarket", dataLoginRetun.userType);

        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => MarketMainPage()));
      } else {}
    } else {
      print(result.status);
      print(result.message);
    }
    setState(() {
      // _checking = false;
    });
  }

  _logout() async {
    await FacebookAuth.instance.logOut();
    // _accessToken = null;
    _userData = null;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: (Container(
      child: Text(''),
    )));
    // return MaterialApp(
    //   home: Scaffold(
    //     appBar: AppBar(title: Text('Facebook Auth Project')),
    //     body: _checking
    //         ? Center(
    //             child: CircularProgressIndicator(),
    //           )
    //         : Center(
    //             child: Column(
    //             mainAxisAlignment: MainAxisAlignment.center,
    //             crossAxisAlignment: CrossAxisAlignment.center,
    //             children: [
    //               _userData != null
    //                   ? Text('name: ${_userData!['name']}')
    //                   : Container(),
    //               _userData != null
    //                   ? Text('email: ${_userData!['email']}')
    //                   : Container(),
    //               _userData != null
    //                   ? Text('id: ${_userData!['id']}')
    //                   : Container(),
    //               _userData != null
    //                   ? Container(
    //                       child: Image.network(
    //                           _userData!['picture']['data']['url']),
    //                     )
    //                   : Container(),
    //               SizedBox(
    //                 height: 20,
    //               ),
    //               CupertinoButton(
    //                   color: Colors.blue,
    //                   child: Text(
    //                     _userData != null ? 'LOGOUT' : 'LOGIN',
    //                     style: TextStyle(color: Colors.white),
    //                   ),
    //                   onPressed: _userData != null ? _logout : _login)
    //             ],
    //           )),
    //   ),
    // );
  }
}
