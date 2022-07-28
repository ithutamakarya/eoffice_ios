import 'package:flutter/material.dart';
import 'package:eoffice/util/constants.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:eoffice/model/UserModel.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:eoffice/activity/main/home.dart';
import 'package:eoffice/activity/suratmasuk/disposisi/EditDisposisiSuratMasuk.dart';
import 'package:eoffice/activity/suratkeluar/distribusi/EditDistribusiSuratKeluar.dart';
import 'package:eoffice/activity/suratmasuk/memomasuk/EditMemoMasuk.dart';
import 'package:eoffice/activity/suratmasuk/trackingmasuk/DetailTrackingHistory.dart';
import 'package:eoffice/activity/suratkeluar/trackingkeluar/DetailTrackingSuratKeluarHistory.dart';
import 'package:eoffice/activity/suratmasuk/memomasuk/DetailMemoMasuk.dart';
import 'package:progress_dialog/progress_dialog.dart';

class LoginPage extends StatefulWidget {
  static String tag = 'login-page';
  @override
  _LoginPageState createState() => new _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  SharedPreferences sharedPreferences;
  String loginToken;
  bool loginSuccess;

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final logo = Hero(
      tag: 'hero',
      child: CircleAvatar(
        backgroundColor: Colors.transparent,
        radius: 120.0,
        child: Image.asset('assets/images/HKLogo.png'),
      ),
    );

    final txt = Center(
      child: new Column(
        children: <Widget>[
          Text("Login eOffice",
              style: TextStyle(color: Colors.black, fontSize: 14.0)),
          new Container(
            height: 5.0,
          ),
          Text("PT. HUTAMA KARYA",
              style: TextStyle(color: Colors.black, fontSize: 14.0)),
        ],
      ),
    );

    final email = TextFormField(
      controller: _usernameController,
      keyboardType: TextInputType.emailAddress,
      autofocus: false,
      decoration: InputDecoration(
        hintText: 'Username',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );

    final password = TextFormField(
      autofocus: false,
      controller: _passwordController,
      obscureText: true,
      decoration: InputDecoration(
        hintText: 'Password',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );

    final loginButton = Padding(
        padding: EdgeInsets.symmetric(vertical: 16.0),
        child: new InkWell(
          onTap: () {
            login();
          },
          child: new Container(
              height: 42.0,
              decoration: new BoxDecoration(
                color: Colors.blueAccent,
                border: new Border.all(color: Colors.white, width: 1.0),
                borderRadius: new BorderRadius.circular(10.0),
              ),
              child: new Center(
                  child:
                      Text('Log In', style: TextStyle(color: Colors.white)))),
        ));

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      body: Center(
        child: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.only(left: 24.0, right: 24.0),
          children: <Widget>[
            logo,
            txt,
            SizedBox(height: 18.0),
            email,
            SizedBox(height: 8.0),
            password,
            SizedBox(height: 24.0),
            loginButton
          ],
        ),
      ),
    );
  }

  Future<List> login() async {
    ProgressDialog pr = new ProgressDialog(context, ProgressDialogType.Normal);
    pr.setMessage('Please wait...');
    pr.show();

    sharedPreferences = await SharedPreferences.getInstance();

    Map datas = {
      'username': _usernameController.text,
      'password': _passwordController.text
    };

    // Map headers = {
    //   'Accept-Language': 'id',
    //   'Connection': 'keep-alive',
    //   'Content-Type': 'application/x-www-form-urlencoded',
    //   'Accept': 'application/json',
    // };

    var url = URL_LOGIN;

    try {
      final response = await http.post(
        url,
        body: datas,
        headers: {
          'Accept-Language': 'id',
          'Connection': 'keep-alive',
          'Content-Type': 'application/x-www-form-urlencoded',
          'Accept': 'application/json',
          'Charset': 'utf-8',
        },
      );

      // debugPrint("Response : ${response.body}");

      Map<String, dynamic> value = json.decode(response.body);
      bool success = value['success'];

      if (success) {
        String tokenUser = value['token'];
        loginToken = tokenUser;
        sharedPreferences.setString("loginToken", loginToken);
        sharedPreferences.setString("userLogin", _usernameController.text);
        sharedPreferences.setString("userPassword", _passwordController.text);
        sharedPreferences.commit();

        _firebaseMessaging.configure(
          onMessage: (Map<String, dynamic> msg) async {
            showAlertDialog(msg);
          },
          onResume: (Map<String, dynamic> msg) async {
            if (msg['data']['masukke'].toString() == "0") {
            } else if (msg['data']['masukke'].toString() == "1") {
              Navigator.push(
                  context,
                  new MaterialPageRoute(
                      builder: (BuildContext context) =>
                          new EditDisposisiSuratMasuk(
                              msg['data']['disposisiid'].toString())));
            } else if (msg['data']['masukke'].toString() == "2") {
              Navigator.push(
                  context,
                  new MaterialPageRoute(
                      builder: (BuildContext context) =>
                          new EditDistribusiSuratKeluar(
                              msg['data']['disposisiid'].toString())));
            } else if (msg['data']['masukke'].toString() == "3") {
              Navigator.push(
                  context,
                  new MaterialPageRoute(
                      builder: (BuildContext context) =>
                          new DetailTrackingHistory(
                              msg['data']['disposisiid'].toString())));
            } else if (msg['data']['masukke'].toString() == "4") {
              Navigator.push(
                  context,
                  new MaterialPageRoute(
                      builder: (BuildContext context) =>
                          new DetailTrackingSuratKeluarHistory(
                              msg['data']['disposisiid'].toString())));
            } else if (msg['data']['masukke'].toString() == "5") {
              Navigator.push(
                  context,
                  new MaterialPageRoute(
                      builder: (BuildContext context) => new EditMemoMasuk(
                          msg['data']['disposisiid'].toString())));
            } else if (msg['data']['masukke'].toString() == "6") {
              Navigator.push(
                  context,
                  new MaterialPageRoute(
                      builder: (BuildContext context) => new DetailMemoMasuk(
                          msg['data']['disposisiid'].toString())));
            }
          },
          onLaunch: (Map<String, dynamic> msg) async {
            if (msg['data']['masukke'].toString() == "0") {
            } else if (msg['data']['masukke'].toString() == "1") {
              Navigator.push(
                  context,
                  new MaterialPageRoute(
                      builder: (BuildContext context) =>
                          new EditDisposisiSuratMasuk(
                              msg['data']['disposisiid'].toString())));
            } else if (msg['data']['masukke'].toString() == "2") {
              Navigator.push(
                  context,
                  new MaterialPageRoute(
                      builder: (BuildContext context) =>
                          new EditDistribusiSuratKeluar(
                              msg['data']['disposisiid'].toString())));
            } else if (msg['data']['masukke'].toString() == "3") {
              Navigator.push(
                  context,
                  new MaterialPageRoute(
                      builder: (BuildContext context) =>
                          new DetailTrackingHistory(
                              msg['data']['disposisiid'].toString())));
            } else if (msg['data']['masukke'].toString() == "4") {
              Navigator.push(
                  context,
                  new MaterialPageRoute(
                      builder: (BuildContext context) =>
                          new DetailTrackingSuratKeluarHistory(
                              msg['data']['disposisiid'].toString())));
            } else if (msg['data']['masukke'].toString() == "5") {
              Navigator.push(
                  context,
                  new MaterialPageRoute(
                      builder: (BuildContext context) => new EditMemoMasuk(
                          msg['data']['disposisiid'].toString())));
            } else if (msg['data']['masukke'].toString() == "6") {
              Navigator.push(
                  context,
                  new MaterialPageRoute(
                      builder: (BuildContext context) => new DetailMemoMasuk(
                          msg['data']['disposisiid'].toString())));
            }
          },
        );

        _firebaseMessaging.requestNotificationPermissions(
            const IosNotificationSettings(
                sound: true, alert: true, badge: true));

        _firebaseMessaging.onIosSettingsRegistered
            .listen((IosNotificationSettings setting) {});

        _firebaseMessaging.getToken().then((token) async {
          Map dataSaveToken = {'token': loginToken, 'token_push': token};
          var urlSaveToken = URL_SAVE_TOKEN_FIREBASE;

          try {
            final responseSaveToken = await http.post(
              urlSaveToken,
              body: dataSaveToken,
              headers: {
                'Accept-Language': 'id',
                'Connection': 'keep-alive',
                'Content-Type': 'application/x-www-form-urlencoded',
                'Accept': 'application/json',
                'Charset': 'utf-8',
              },
            );

            Map<String, dynamic> valueSaveToken =
                json.decode(responseSaveToken.body);
            bool successSaveToken = valueSaveToken['success'];

            if (successSaveToken) {
              var urlDetailToken = URL_DETAIL_USER + loginToken;
              try {
                final responseDetailToken = await http.get(
                  urlDetailToken,
                  headers: {
                    'Accept-Language': 'id',
                    'Connection': 'keep-alive',
                    'Content-Type': 'application/x-www-form-urlencoded',
                    'Accept': 'application/json',
                    'Charset': 'utf-8',
                  },
                );

                Map<String, dynamic> valueDetailToken =
                    json.decode(responseDetailToken.body);
                UserModel shape = new UserModel.fromJson(valueDetailToken);

                sharedPreferences.setInt("idUser", shape.user.id);
                sharedPreferences.setString("satker", shape.satker);
                sharedPreferences.setString("gravatar", shape.user.gravatar);
                sharedPreferences.setString("nameUser", shape.user.name);
                sharedPreferences.setString(
                    "userNameUser", shape.user.username);
                sharedPreferences.setString("emailUser", shape.user.email);
                sharedPreferences.setString("tokenFirebase", token);
                sharedPreferences.commit();

                pr.hide();
                Navigator.pushReplacement(
                    context,
                    new MaterialPageRoute(
                        builder: (BuildContext context) =>
                            new HomeScreen(shape.user.name, shape.satker)));
              } catch (e) {
                pr.hide();
                _scaffoldKey.currentState.showSnackBar(SnackBar(
                  content: Text(e.toString()),
                  duration: Duration(seconds: 3),
                ));
              }
            } else {
              pr.hide();
              _scaffoldKey.currentState.showSnackBar(SnackBar(
                content: Text('Gagal menyimpan token'),
                duration: Duration(seconds: 3),
              ));
            }
          } catch (e) {
            pr.hide();
            _scaffoldKey.currentState.showSnackBar(SnackBar(
              content: Text(e.toString()),
              duration: Duration(seconds: 3),
            ));
          }
        });
      } else {
        pr.hide();
        _scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text('User tidak ditemukan'),
          duration: Duration(seconds: 3),
        ));
      }
    } catch (e) {
      pr.hide();
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text(e.toString()),
        duration: Duration(seconds: 3),
      ));
    }
  }

  void showAlertDialog(Map<String, dynamic> msg) {
    showDialog(
        context: context,
        barrierDismissible: false, // user must tap on buttons
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(msg['notification']['title'].toString()),
            content: Text(msg['notification']['body'].toString()),
            actions: <Widget>[
              FlatButton(
                child: Text(
                  "Cancel",
                  style: TextStyle(color: Colors.black),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              FlatButton(
                child: Text("Open"),
                onPressed: () {
                  if (msg['data']['masukke'].toString() == "0") {
                  } else if (msg['data']['masukke'].toString() == "1") {
                    print("onMessage Login 1");
                    Navigator.pop(context);
                    Navigator.push(
                        context,
                        new MaterialPageRoute(
                            builder: (BuildContext context) =>
                                new EditDisposisiSuratMasuk(
                                    msg['data']['disposisiid'].toString())));
                  } else if (msg['data']['masukke'].toString() == "2") {
                    Navigator.pop(context);
                    Navigator.push(
                        context,
                        new MaterialPageRoute(
                            builder: (BuildContext context) =>
                                new EditDistribusiSuratKeluar(
                                    msg['data']['disposisiid'].toString())));
                  } else if (msg['data']['masukke'].toString() == "3") {
                    Navigator.pop(context);
                    Navigator.push(
                        context,
                        new MaterialPageRoute(
                            builder: (BuildContext context) =>
                                new DetailTrackingHistory(
                                    msg['data']['disposisiid'].toString())));
                  } else if (msg['data']['masukke'].toString() == "4") {
                    Navigator.pop(context);
                    Navigator.push(
                        context,
                        new MaterialPageRoute(
                            builder: (BuildContext context) =>
                                new DetailTrackingSuratKeluarHistory(
                                    msg['data']['disposisiid'].toString())));
                  } else if (msg['data']['masukke'].toString() == "5") {
                    Navigator.pop(context);
                    Navigator.push(
                        context,
                        new MaterialPageRoute(
                            builder: (BuildContext context) =>
                                new EditMemoMasuk(
                                    msg['data']['disposisiid'].toString())));
                  } else if (msg['data']['masukke'].toString() == "6") {
                    Navigator.pop(context);
                    Navigator.push(
                        context,
                        new MaterialPageRoute(
                            builder: (BuildContext context) =>
                                new DetailMemoMasuk(
                                    msg['data']['disposisiid'].toString())));
                  }
                },
              ),
            ],
          );
        });
  }
}
