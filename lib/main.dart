import 'dart:async';

import 'package:flutter/material.dart';
import 'package:eoffice/util/constants.dart';
import 'package:eoffice/activity/main/SplashScreen.dart';
import 'package:eoffice/activity/main/login.dart';
import 'package:eoffice/activity/main/home.dart';
import 'package:eoffice/activity/suratmasuk/memomasuk/MemoMasuk.dart';
import 'package:eoffice/activity/suratmasuk/masuk/SuratMasuk.dart';
import 'package:eoffice/activity/suratmasuk/disposisi/DisposisiSuratMasuk.dart';
import 'package:eoffice/activity/suratmasuk/trackingmasuk/TrackingHistoriSuratMasuk.dart';
import 'package:eoffice/activity/suratkeluar/keluar/SuratKeluar.dart';
import 'package:eoffice/activity/suratkeluar/trackingkeluar/TrackingHistoriSuratKeluar.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(new MyApp());

class MyApp extends StatefulWidget {

  @override
  MyAppState createState() => MyAppState();

}

class MyAppState extends State<MyApp> {

  SharedPreferences sharedPreferences;
  String nameUser, satkerUser;

  @override
  void initState() {
    getToken();
    super.initState();
  }

  void getToken() async {
    sharedPreferences = await SharedPreferences.getInstance();

    setState(() {
      nameUser = sharedPreferences.getString("nameUser");
      satkerUser = sharedPreferences.getString("satker");
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primaryColor: new Color(0xFFFFFFFF),
          accentColor: Colors.blueAccent,
          fontFamily: 'Source Code Pro'),
      home: SplashScreen(),
      routes: getRoutes(),
    );
  }

  Map<String, WidgetBuilder> getRoutes() {
    return <String, WidgetBuilder>{
      ANIMATED_SPLASH: (BuildContext context) => new SplashScreen(),
      LOGIN_SCREEN: (BuildContext context) => new LoginPage(),
      HOME_SCREEN: (BuildContext context) => new HomeScreen(nameUser, satkerUser),
      SuratMasuk.routeName: (_) => SuratMasuk(),
      MemoMasuk.routeName: (_) => MemoMasuk(),
      DisposisiSuratMasuk.routeName: (_) => DisposisiSuratMasuk(),
      TrackingHistoriSuratMasuk.routeName: (_) => TrackingHistoriSuratMasuk(),
      SuratKeluar.routeName: (_) => SuratKeluar(),
      TrackingHistoriSuratKeluar.routeName: (_) => TrackingHistoriSuratKeluar()
    };
  }
}