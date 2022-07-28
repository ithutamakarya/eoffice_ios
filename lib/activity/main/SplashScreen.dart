import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:eoffice/util/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:eoffice/model/UserModel.dart';
import 'package:eoffice/activity/main/home.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http_client_helper/http_client_helper.dart';

class SplashScreen extends StatefulWidget {
  @override
  SplashScreenState createState() => new SplashScreenState();
}

class SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  var _visible = true;

  AnimationController animationController;
  Animation<double> animation;

  SharedPreferences sharedPreferences;
  String loginToken;
  bool loginSuccess;
  String userLogin, userPassword;
  int idUser;

  CancellationToken cancellationToken;
  String msg = "";

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  startTime() async {
    var _duration = new Duration(seconds: 3);
    return new Timer(_duration, navigationPage);
  }

  void navigationPage() async {
    sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      if (sharedPreferences.getString("userLogin") != null) {
        userLogin = sharedPreferences.getString("userLogin");
        userPassword = sharedPreferences.getString("userPassword");

        login();
      } else {
        Navigator.of(context).pushReplacementNamed(LOGIN_SCREEN);
      }
    });
  }

  Future<List> login() async {
    sharedPreferences = await SharedPreferences.getInstance();
    userLogin = sharedPreferences.getString("userLogin");
    userPassword = sharedPreferences.getString("userPassword");

    Map datas = {'username': userLogin, 'password': userPassword};

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

      Map<String, dynamic> value = json.decode(response.body);
      bool success = value['success'];

      if (success) {
        final data = json.decode(response.body);
        String tokenUser = data['token'];
        loginToken = tokenUser;

        sharedPreferences.setString("loginToken", loginToken);
        sharedPreferences.setString("userLogin", userLogin);
        sharedPreferences.setString("userPassword", userPassword);
        sharedPreferences.commit();

        var urlDetailToken = URL_DETAIL_USER + loginToken;

        try {
          final responseDetailToken = await http.get(urlDetailToken);

          if (responseDetailToken.statusCode == 200) {
            Map<String, dynamic> valueDetailToken =
                json.decode(responseDetailToken.body);
            UserModel shape = new UserModel.fromJson(valueDetailToken);
            sharedPreferences.setInt("idUser", shape.user.id);
            sharedPreferences.setString("nameUser", shape.user.name);
            sharedPreferences.setString("userNameUser", shape.user.username);
            sharedPreferences.setString("emailUser", shape.user.email);
            sharedPreferences.setString("satker", shape.satker);
            sharedPreferences.setString("gravatar", shape.user.gravatar);
            sharedPreferences.commit();

            Navigator.pushReplacement(
                context,
                new MaterialPageRoute(
                    builder: (BuildContext context) =>
                        new HomeScreen(shape.user.name, shape.satker)));
          } else {
            _scaffoldKey.currentState.showSnackBar(SnackBar(
              content: Text('Gagal mengambil data'),
              duration: Duration(seconds: 3),
            ));
          }
        } catch (e) {
          _scaffoldKey.currentState.showSnackBar(SnackBar(
            content: Text("1 " + e.toString()),
            duration: Duration(seconds: 3),
          ));
        }
      } else {
        _scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text('User tidak ditemukan'),
          duration: Duration(seconds: 3),
        ));
      }
    } catch (e) {
      print(e.toString());
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text("2 " + e.toString()),
        duration: Duration(seconds: 3),
      ));
    }
  }

  @override
  void initState() {
    super.initState();

    animationController = new AnimationController(
        vsync: this, duration: new Duration(seconds: 2));
    animation =
        new CurvedAnimation(parent: animationController, curve: Curves.easeOut);

    animation.addListener(() => this.setState(() {}));
    animationController.forward();

    setState(() {
      _visible = !_visible;
    });
    startTime();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          new Container(decoration: new BoxDecoration(color: Colors.white)),
          new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new Image.asset(
                'assets/images/HKLogo.png',
                width: animation.value * 250,
                height: animation.value * 250,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
