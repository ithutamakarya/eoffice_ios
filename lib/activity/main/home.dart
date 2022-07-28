import 'package:flutter/material.dart';
import 'package:eoffice/activity/main/ShowPDF.dart';
import 'package:eoffice/util/constants.dart';
import 'package:eoffice/activity/suratkeluar/keluar/SuratKeluar.dart';
import 'package:eoffice/activity/suratkeluar/distribusi/DistribusiSurat.dart';
import 'package:eoffice/activity/suratmasuk/masuk/SuratMasuk.dart';
import 'package:eoffice/activity/suratmasuk/memomasuk/MemoMasuk.dart';
import 'package:eoffice/activity/suratkeluar/memokeluar/MemoKeluar.dart';
import 'package:eoffice/activity/suratmasuk/disposisi/DisposisiSuratMasuk.dart';
import 'package:eoffice/activity/suratmasuk/trackingmasuk/TrackingHistoriSuratMasuk.dart';
import 'package:eoffice/activity/suratkeluar/trackingkeluar/TrackingHistoriSuratKeluar.dart';
import 'package:eoffice/activity/suratmasuk/masuk/DetailSuratMasuk.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:eoffice/util/separator.dart';
import 'package:eoffice/model/DashboardChartModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:eoffice/activity/suratmasuk/disposisi/EditDisposisiSuratMasuk.dart';
import 'package:eoffice/activity/suratmasuk/disposisi/EditDisposisiSuratMasukNotif.dart';
import 'package:eoffice/activity/suratkeluar/distribusi/EditDistribusiSuratKeluar.dart';
import 'package:eoffice/activity/suratkeluar/distribusi/EditDistribusiSuratKeluarNotif.dart';
import 'package:eoffice/activity/suratmasuk/memomasuk/EditMemoMasuk.dart';
import 'package:eoffice/activity/suratmasuk/memomasuk/EditMemoMasukNotif.dart';
import 'package:eoffice/activity/suratmasuk/trackingmasuk/DetailTrackingHistory.dart';
import 'package:eoffice/activity/suratmasuk/trackingmasuk/DetailTrackingHistoryNotif.dart';
import 'package:eoffice/activity/suratkeluar/trackingkeluar/DetailTrackingSuratKeluarHistory.dart';
import 'package:eoffice/activity/suratkeluar/trackingkeluar/DetailTrackingSuratKeluarHistoryNotif.dart';
import 'package:eoffice/activity/suratmasuk/memomasuk/DetailMemoMasuk.dart';
import 'package:eoffice/activity/suratmasuk/memomasuk/DetailMemoMasukNotif.dart';
// import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:simple_permissions/simple_permissions.dart';
import 'package:flutter/foundation.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:intl/intl.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

const directoryName = 'Download';

class HomeScreen extends StatefulWidget {
  static String tag = 'home-page';

  final data, data2;

  final bool horizontal;

  HomeScreen(this.data, this.data2, {this.horizontal = true});

  HomeScreen.vertical(this.data, this.data2) : horizontal = false;
  HomeScreenState createState() => new HomeScreenState(data, data2);

  void refreshNotif() {
    HomeScreenState.refreshNotif();
  }
}

class HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  final data, data2;
  final bool horizontal;

  HomeScreenState(this.data, this.data2, {this.horizontal = true});

  HomeScreenState.vertical(this.data, this.data2) : horizontal = false;

  FirebaseMessaging _firebaseMessaging = new FirebaseMessaging();
  static String _token;
  String test;
  static SharedPreferences sharedPreferences;
  static String nameUser, userNameUser, emailUser;
  static String satkerLogin, gravatar;
  static int idUser = 0;
  static String loginToken;

  String barcode = "";

  String _platformVersion = 'Unknown';

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  DropDownMenu selectedDropDownMenu;
  List<DropDownMenu> dropDownMenu = <DropDownMenu>[
    const DropDownMenu('Surat Masuk'),
    const DropDownMenu('Memo Masuk'),
    const DropDownMenu('Surat Keluar')
  ];

  Permission _permission = Permission.WriteExternalStorage;

  String pathPDF = "";

  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();

  static Future<DashboardChartModel> _future;
  static Future<DashboardChartModel> _futureNotif;
  static Future<DashboardChartModel> _futures;

  static DashboardChartModel dash;
  static DashboardChartModel dashNotif;

  static String dialogNotif = "";

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      new FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();

    _future = makeRequest();
    _futures = makeRequest();
    _futureNotif = makeRequestNotif();
    new Timer.periodic(
        Duration(minutes: 5),
        (Timer t) => setState(() {
              _futureNotif = makeRequestNotif();
            }));

    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("on message home");
        setState(() {
          _futureNotif = makeRequestNotif();
        });
        if (dialogNotif == "Edit Disposisi Surat Masuk") {
        } else if (dialogNotif == "Edit Disposisi Surat Keluar") {
        } else if (dialogNotif == "TTD") {
        } else if (dialogNotif == "Edit Memo Masuk") {
        } else if (dialogNotif == "") {
          showAlertDialog(message);
        } else {
          showAlertDialog(message);
        }
      },
      onResume: (Map<String, dynamic> message) async {
        print("on resume home");
        _futureNotif = makeRequestNotif();
        if (message['data']['masukke'].toString() == "0") {
        } else if (message['data']['masukke'].toString() == "1") {
          Navigator.push(
              context,
              new MaterialPageRoute(
                  builder: (BuildContext context) =>
                      new EditDisposisiSuratMasuk(
                          message['data']['disposisiid'].toString())));
        } else if (message['data']['masukke'].toString() == "2") {
          Navigator.push(
              context,
              new MaterialPageRoute(
                  builder: (BuildContext context) =>
                      new EditDistribusiSuratKeluar(
                          message['data']['disposisiid'].toString())));
        } else if (message['data']['masukke'].toString() == "3") {
          Navigator.push(
              context,
              new MaterialPageRoute(
                  builder: (BuildContext context) => new DetailTrackingHistory(
                      message['data']['disposisiid'].toString())));
        } else if (message['data']['masukke'].toString() == "4") {
          Navigator.push(
              context,
              new MaterialPageRoute(
                  builder: (BuildContext context) =>
                      new DetailTrackingSuratKeluarHistory(
                          message['data']['disposisiid'].toString())));
        } else if (message['data']['masukke'].toString() == "5") {
          Navigator.push(
              context,
              new MaterialPageRoute(
                  builder: (BuildContext context) => new EditMemoMasuk(
                      message['data']['disposisiid'].toString())));
        } else if (message['data']['masukke'].toString() == "6") {
          Navigator.push(
              context,
              new MaterialPageRoute(
                  builder: (BuildContext context) => new DetailMemoMasuk(
                      message['data']['disposisiid'].toString())));
        }
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("on launch home");
        _futureNotif = makeRequestNotif();
        if (message['data']['masukke'].toString() == "0") {
        } else if (message['data']['masukke'].toString() == "1") {
          Navigator.push(
              context,
              new MaterialPageRoute(
                  builder: (BuildContext context) =>
                      new EditDisposisiSuratMasuk(
                          message['data']['disposisiid'].toString())));
        } else if (message['data']['masukke'].toString() == "2") {
          Navigator.push(
              context,
              new MaterialPageRoute(
                  builder: (BuildContext context) =>
                      new EditDistribusiSuratKeluar(
                          message['data']['disposisiid'].toString())));
        } else if (message['data']['masukke'].toString() == "3") {
          Navigator.push(
              context,
              new MaterialPageRoute(
                  builder: (BuildContext context) => new DetailTrackingHistory(
                      message['data']['disposisiid'].toString())));
        } else if (message['data']['masukke'].toString() == "4") {
          Navigator.push(
              context,
              new MaterialPageRoute(
                  builder: (BuildContext context) =>
                      new DetailTrackingSuratKeluarHistory(
                          message['data']['disposisiid'].toString())));
        } else if (message['data']['masukke'].toString() == "5") {
          Navigator.push(
              context,
              new MaterialPageRoute(
                  builder: (BuildContext context) => new EditMemoMasuk(
                      message['data']['disposisiid'].toString())));
        } else if (message['data']['masukke'].toString() == "6") {
          Navigator.push(
              context,
              new MaterialPageRoute(
                  builder: (BuildContext context) => new DetailMemoMasuk(
                      message['data']['disposisiid'].toString())));
        }
      },
    );

    _firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(sound: true, alert: true, badge: true));

    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings setting) {});

    _firebaseMessaging.getToken().then((token) {});
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  didPopRoute() {
    super.didPopRoute();
  }

  Future<File> createFileOfPdfUrl(String url) async {
    ProgressDialog pr = new ProgressDialog(context, ProgressDialogType.Normal);
    pr.setMessage('Menunggu..');
    pr.show();

    var request = await HttpClient().getUrl(Uri.parse(url));
    var response = await request.close();
    var bytes = await consolidateHttpClientResponseBytes(response);
    String dir = (await getApplicationDocumentsDirectory()).path;
    File file = new File(dir + '/test.pdf');
    await file.writeAsBytes(bytes);

    String f = file.path;

    pr.hide();

    Navigator.push(
        context,
        new MaterialPageRoute(
            builder: (BuildContext context) => new ShowPDF(f)));
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

  static Future<DashboardChartModel> makeRequest() async {
    sharedPreferences = await SharedPreferences.getInstance();
    loginToken = sharedPreferences.getString("loginToken");
    nameUser = sharedPreferences.getString("nameUser");
    userNameUser = sharedPreferences.getString("userNameUser");
    emailUser = sharedPreferences.getString("emailUser");
    idUser = sharedPreferences.getInt("idUser");
    satkerLogin = sharedPreferences.getString("satker");
    gravatar = sharedPreferences.getString("gravatar");
    _token = sharedPreferences.getString("tokenFirebase");

    print(_token);

    final response = await http.get(URL_GET_DASHBOARD + loginToken);

    if (response.statusCode == 200) {
      Map<String, dynamic> value = json.decode(response.body);
      dash = new DashboardChartModel.fromJson(value);
      print(0);
      return DashboardChartModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load post.');
    }
  }

  static Future<DashboardChartModel> makeRequestNotif() async {
    sharedPreferences = await SharedPreferences.getInstance();
    loginToken = sharedPreferences.getString("loginToken");
    nameUser = sharedPreferences.getString("nameUser");
    userNameUser = sharedPreferences.getString("userNameUser");
    emailUser = sharedPreferences.getString("emailUser");
    idUser = sharedPreferences.getInt("idUser");
    satkerLogin = sharedPreferences.getString("satker");
    gravatar = sharedPreferences.getString("gravatar");
    _token = sharedPreferences.getString("tokenFirebase");

    print(gravatar);

    final response = await http.get(URL_GET_DASHBOARD + loginToken);

    if (response.statusCode == 200) {
      Map<String, dynamic> value = json.decode(response.body);
      dashNotif = new DashboardChartModel.fromJson(value);
      return DashboardChartModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load post.');
    }
  }

  static void refreshNotif() {
    _futureNotif = makeRequestNotif();
  }

  static void refreshing() {
    _future = makeRequest();
    _futures = makeRequest();
    _futureNotif = makeRequestNotif();
  }

  Future<bool> _onBackPressed() {
    AwesomeDialog(
        context: context,
        dialogType: DialogType.INFO,
        animType: AnimType.BOTTOMSLIDE,
        tittle: 'Keluar Aplikasi',
        desc: 'Apakah anda yakin?',
        btnOkText: 'Keluar',
        btnCancelText: 'Tidak',
        btnCancelOnPress: () {},
        btnOkOnPress: () {
          print(1);
          exit(0);
        }).show();
  }

  @override
  Widget build(BuildContext context) {
    Widget expansionTileSuratMasuk;
    Widget expansionTileSuratKeluar;
    Widget expansionTileMemoDinas;

    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
          key: _scaffoldKey,
          appBar: AppBar(
            elevation: 0.0,
            iconTheme: new IconThemeData(color: Colors.red),
            title: Row(
              children: [
                Image.asset(
                  'assets/logohk.png',
                  fit: BoxFit.contain,
                  height: 40,
                ),
                Container(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('Hutama Karya',
                        style: TextStyle(
                            fontFamily: 'Source Code Pro',
                            fontSize: 16.0,
                            color: Colors.red)))
              ],
            ),
            actions: <Widget>[
              new FutureBuilder<DashboardChartModel>(
                future: _futureNotif,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return new IconButton(
                        icon: new Stack(
                          children: <Widget>[
                            new Icon(Icons.notifications),
                            new Positioned(
                              right: 0,
                              child: new Container(
                                padding: EdgeInsets.all(1),
                                decoration: new BoxDecoration(
                                  color: Colors.blue,
                                  borderRadius: BorderRadius.circular(7),
                                ),
                                constraints: BoxConstraints(
                                  minWidth: 14,
                                  minHeight: 14,
                                ),
                                child: new Text(
                                  '${dashNotif.jmlnotif}',
                                  style: new TextStyle(
                                    color: Colors.white,
                                    fontSize: 8,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            )
                          ],
                        ),
                        onPressed: () async {
                          flutterLocalNotificationsPlugin.cancelAll();
                          showDialog(
                              context: context,
                              barrierDismissible:
                                  false, // user must tap on buttons
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text("Notifikasi"),
                                  content: ListView.builder(
                                    scrollDirection: Axis.vertical,
                                    shrinkWrap: true,
                                    itemCount: int.parse(
                                        '${dashNotif.listnotif.length}'),
                                    itemBuilder: (BuildContext context, int i) {
                                      return new Card(
                                        elevation: 8.0,
                                        margin: new EdgeInsets.symmetric(
                                            horizontal: 5.0, vertical: 6.0),
                                        child: Container(
                                            child: new ListTile(
                                                contentPadding:
                                                    EdgeInsets.symmetric(
                                                        horizontal: 5.0,
                                                        vertical: 5.0),
                                                title: Column(
                                                  children: <Widget>[
                                                    new Row(
                                                      children: <Widget>[
                                                        new Icon(
                                                            Icons
                                                                .markunread_mailbox,
                                                            color:
                                                                Colors.purple,
                                                            size: 16.0),
                                                        new Container(
                                                          width: 10.0,
                                                        ),
                                                        new Expanded(
                                                            child: Text(
                                                                '${dashNotif.listnotif[i].judul}',
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontSize:
                                                                        10.0)))
                                                      ],
                                                    ),
                                                    new Separators(),
                                                  ],
                                                ),
                                                subtitle:
                                                    Column(children: <Widget>[
                                                  new Row(
                                                    children: <Widget>[
                                                      Expanded(
                                                          child: Text(
                                                              '${dashNotif.listnotif[i].perihal}',
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .green,
                                                                  fontSize:
                                                                      10.0)))
                                                    ],
                                                  ),
                                                ]),
                                                onTap: () async {
                                                  setState(() {
                                                    _futureNotif =
                                                        makeRequestNotif();
                                                  });
                                                  if ('${dashNotif.listnotif[i].masukke}' ==
                                                      "0") {
                                                    _scaffoldKey.currentState
                                                        .showSnackBar(SnackBar(
                                                            content: Text(
                                                                'Hanya bisa dibuka di web'),
                                                            duration: Duration(
                                                                seconds: 3)));
                                                  } else if ('${dashNotif.listnotif[i].masukke}' ==
                                                      "1") {
                                                    Navigator.pop(context);
                                                    Navigator.push(
                                                        context,
                                                        new MaterialPageRoute(
                                                            builder: (BuildContext
                                                                    context) =>
                                                                new EditDisposisiSuratMasukNotif(
                                                                    '${dashNotif.listnotif[i].id}',
                                                                    '${dashNotif.listnotif[i].disposisiid}')));
                                                  } else if ('${dashNotif.listnotif[i].masukke}' ==
                                                      "2") {
                                                    Navigator.pop(context);
                                                    Navigator.push(
                                                        context,
                                                        new MaterialPageRoute(
                                                            builder: (BuildContext
                                                                    context) =>
                                                                new EditDistribusiSuratKeluarNotif(
                                                                    '${dashNotif.listnotif[i].id}',
                                                                    '${dashNotif.listnotif[i].disposisiid}')));
                                                  } else if ('${dashNotif.listnotif[i].masukke}' ==
                                                      "3") {
                                                    Navigator.pop(context);
                                                    Navigator.push(
                                                        context,
                                                        new MaterialPageRoute(
                                                            builder: (BuildContext
                                                                    context) =>
                                                                new DetailTrackingHistoryNotif(
                                                                    '${dashNotif.listnotif[i].id}',
                                                                    '${dashNotif.listnotif[i].disposisiid}')));
                                                  } else if ('${dashNotif.listnotif[i].masukke}' ==
                                                      "4") {
                                                    Navigator.pop(context);
                                                    Navigator.push(
                                                        context,
                                                        new MaterialPageRoute(
                                                            builder: (BuildContext
                                                                    context) =>
                                                                new DetailTrackingSuratKeluarHistoryNotif(
                                                                    '${dashNotif.listnotif[i].id}',
                                                                    '${dashNotif.listnotif[i].disposisiid}')));
                                                  } else if ('${dashNotif.listnotif[i].masukke}' ==
                                                      "5") {
                                                    Navigator.pop(context);
                                                    Navigator.push(
                                                        context,
                                                        new MaterialPageRoute(
                                                            builder: (BuildContext
                                                                    context) =>
                                                                new EditMemoMasukNotif(
                                                                    '${dashNotif.listnotif[i].id}',
                                                                    '${dashNotif.listnotif[i].disposisiid}')));
                                                  } else if ('${dashNotif.listnotif[i].masukke}' ==
                                                      "6") {
                                                    Navigator.pop(context);
                                                    Navigator.push(
                                                        context,
                                                        new MaterialPageRoute(
                                                            builder: (BuildContext
                                                                    context) =>
                                                                new DetailMemoMasukNotif(
                                                                    '${dashNotif.listnotif[i].id}',
                                                                    '${dashNotif.listnotif[i].disposisiid}')));
                                                  }
                                                })),
                                      );
                                    },
                                  ),
                                  actions: <Widget>[
                                    FlatButton(
                                      child: Text(
                                        "Kembali",
                                        style: TextStyle(color: Colors.black),
                                      ),
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                    )
                                  ],
                                );
                              });
                        });
                  } else if (snapshot.hasError) {
                    return new Text("${snapshot.error}");
                  }
                  return new Center(
                    child: new Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: new SizedBox(
                          child: CircularProgressIndicator(),
                          height: 20.0,
                          width: 20.0,
                        )),
                  );
                  // By default, show a loading spinner
                },
              ),
              new IconButton(
                  icon: const Icon(Icons.refresh),
                  tooltip: 'Refresh',
                  onPressed: () {
                    setState(() {
                      _future = makeRequest();
                      _futures = makeRequest();
                    });
                  }),
            ],
          ),
          body: new Container(
            child: new FutureBuilder<DashboardChartModel>(
              future: _future,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final List suratMasukList = <ClicksPerYear>[];
                  var seriesMasuk;
                  var chartMasuk;
                  var chartWidgetMasuk;

                  for (int i = 0;
                      i < int.parse('${dash.last3monthMasuk.dataMasuk.length}');
                      i++) {
                    suratMasukList.add(new ClicksPerYear(
                        '${dash.last3monthMasuk.dataMasuk[i].label}',
                        int.parse('${dash.last3monthMasuk.dataMasuk[i].value}'),
                        Colors.deepOrangeAccent));
                  }

                  seriesMasuk = [
                    new charts.Series<ClicksPerYear, String>(
                      domainFn: (ClicksPerYear clickData, _) => clickData.year,
                      measureFn: (ClicksPerYear clickData, _) =>
                          clickData.clicks,
                      colorFn: (ClicksPerYear clickData, _) => clickData.color,
                      id: 'Clicks',
                      data: suratMasukList,
                    )
                  ];
                  chartMasuk = new charts.BarChart(seriesMasuk,
                      animate: true,
                      barGroupingType: charts.BarGroupingType.grouped);
                  chartWidgetMasuk = new Column(
                    children: <Widget>[
                      new Padding(
                        padding: new EdgeInsets.all(12.0),
                        child: new SizedBox(
                          height: 200.0,
                          child: chartMasuk,
                        ),
                      )
                    ],
                  );

                  final List suratKeluarList = <ClicksPerYear>[];
                  var seriesKeluar;
                  var chartKeluar;
                  var chartWidgetKeluar;

                  for (int i = 0;
                      i <
                          int.parse(
                              '${dash.last3monthKeluar.dataKeluar.length}');
                      i++) {
                    suratKeluarList.add(new ClicksPerYear(
                        '${dash.last3monthKeluar.dataKeluar[i].label}',
                        int.parse(
                            '${dash.last3monthKeluar.dataKeluar[i].value}'),
                        Colors.pinkAccent));
                  }

                  seriesKeluar = [
                    new charts.Series<ClicksPerYear, String>(
                      domainFn: (ClicksPerYear clickData, _) => clickData.year,
                      measureFn: (ClicksPerYear clickData, _) =>
                          clickData.clicks,
                      colorFn: (ClicksPerYear clickData, _) => clickData.color,
                      id: 'Clicks',
                      data: suratKeluarList,
                    )
                  ];
                  chartKeluar = new charts.BarChart(seriesKeluar,
                      animate: true,
                      barGroupingType: charts.BarGroupingType.grouped);
                  chartWidgetKeluar = new Column(
                    children: <Widget>[
                      new Padding(
                        padding: new EdgeInsets.all(12.0),
                        child: new SizedBox(
                          height: 200.0,
                          child: chartKeluar,
                        ),
                      )
                    ],
                  );

                  final List memoList = <ClicksPerYear>[];
                  var seriesMemo;
                  var chartMemo;
                  var chartWidgetMemo;

                  for (int i = 0;
                      i < int.parse('${dash.last3monthMemo.dataMemo.length}');
                      i++) {
                    memoList.add(new ClicksPerYear(
                        '${dash.last3monthMemo.dataMemo[i].label}',
                        int.parse('${dash.last3monthMemo.dataMemo[i].value}'),
                        Colors.greenAccent));
                  }

                  seriesMemo = [
                    new charts.Series<ClicksPerYear, String>(
                      domainFn: (ClicksPerYear clickData, _) => clickData.year,
                      measureFn: (ClicksPerYear clickData, _) =>
                          clickData.clicks,
                      colorFn: (ClicksPerYear clickData, _) => clickData.color,
                      id: 'Clicks',
                      data: memoList,
                    )
                  ];
                  chartMemo = new charts.BarChart(seriesMemo,
                      animate: true,
                      barGroupingType: charts.BarGroupingType.grouped);
                  chartWidgetMemo = new Column(
                    children: <Widget>[
                      new Padding(
                        padding: new EdgeInsets.all(12.0),
                        child: new SizedBox(
                          height: 200.0,
                          child: chartMemo,
                        ),
                      )
                    ],
                  );

                  if ('${dash.last3monthMasuk.minMaxmonth}' == "404" &&
                      '${dash.last3monthKeluar.minMaxmonth}' == "404" &&
                      '${dash.last3monthMemo.minMaxmonth}' == "404") {
                    if (dash.menu[0].label != null) {
                      if ('${dash.menu[0].child.menu.menu1}' == "404" &&
                          '${dash.menu[0].child.menu.menu2}' == "200" &&
                          '${dash.menu[0].child.menu.menu3}' == "200") {
                        expansionTileSuratMasuk = new ExpansionTile(
                            trailing:
                                Icon(Icons.expand_more, color: Colors.red),
                            backgroundColor: Colors.red,
                            leading: new InkWell(
                              child: CircleAvatar(
                                  backgroundColor: Colors.orange,
                                  radius: 16.0,
                                  child: new Icon(Icons.message,
                                      color: Colors.white, size: 16.0)),
                            ),
                            title: new Text('Surat Masuk',
                                style: TextStyle(
                                    fontFamily: 'Source Code Pro',
                                    fontSize: 16.0,
                                    color: Colors.white)),
                            children: [
                              new Column(
                                children: <Widget>[
                                  new ListTile(
                                    leading: Container(
                                        padding: EdgeInsets.only(left: 28.0),
                                        child: Icon(Icons.chevron_right,
                                            color: Colors.white)),
                                    title: new Text("Disposisi Surat",
                                        style: TextStyle(
                                            fontFamily: 'Source Code Pro',
                                            fontSize: 14.0,
                                            color: Colors.white)),
                                    onTap: () {
                                      Navigator.of(context)
                                          .push(new DisposisiSuratMasukRoute());
                                    },
                                  ),
                                  new ListTile(
                                    leading: Container(
                                        padding: EdgeInsets.only(left: 28.0),
                                        child: Icon(Icons.chevron_right,
                                            color: Colors.white)),
                                    title: new Text("Tracking/History",
                                        style: TextStyle(
                                            fontFamily: 'Source Code Pro',
                                            fontSize: 14.0,
                                            color: Colors.white)),
                                    onTap: () {
                                      Navigator.of(context).push(
                                          new TrackingHistoriSuratMasukRoute());
                                    },
                                  )
                                ],
                              ),
                            ]);
                      } else if ('${dash.menu[0].child.menu.menu1}' == "200" &&
                          '${dash.menu[0].child.menu.menu2}' == "404" &&
                          '${dash.menu[0].child.menu.menu3}' == "200") {
                        expansionTileSuratMasuk = new ExpansionTile(
                            trailing:
                                Icon(Icons.expand_more, color: Colors.red),
                            backgroundColor: Colors.red,
                            leading: new InkWell(
                              child: CircleAvatar(
                                  backgroundColor: Colors.orange,
                                  radius: 16.0,
                                  child: new Icon(Icons.message,
                                      color: Colors.white, size: 16.0)),
                            ),
                            title: new Text('Surat Masuk',
                                style: TextStyle(
                                    fontFamily: 'Source Code Pro',
                                    fontSize: 16.0,
                                    color: Colors.white)),
                            children: [
                              new Column(
                                children: <Widget>[
                                  new ListTile(
                                    leading: Container(
                                        padding: EdgeInsets.only(left: 28.0),
                                        child: Icon(Icons.chevron_right,
                                            color: Colors.white)),
                                    title: new Text("Surat Masuk",
                                        style: TextStyle(
                                            fontFamily: 'Source Code Pro',
                                            fontSize: 14.0,
                                            color: Colors.white)),
                                    onTap: () {
                                      Navigator.of(context)
                                          .push(new SuratMasukRoute());
                                    },
                                  ),
                                  new ListTile(
                                    leading: Container(
                                        padding: EdgeInsets.only(left: 28.0),
                                        child: Icon(Icons.chevron_right,
                                            color: Colors.white)),
                                    title: new Text("Tracking/History",
                                        style: TextStyle(
                                            fontFamily: 'Source Code Pro',
                                            fontSize: 14.0,
                                            color: Colors.white)),
                                    onTap: () {
                                      Navigator.of(context).push(
                                          new TrackingHistoriSuratMasukRoute());
                                    },
                                  )
                                ],
                              ),
                            ]);
                      } else if ('${dash.menu[0].child.menu.menu1}' == "200" &&
                          '${dash.menu[0].child.menu.menu2}' == "200" &&
                          '${dash.menu[0].child.menu.menu3}' == "404") {
                        expansionTileSuratMasuk = new ExpansionTile(
                            trailing:
                                Icon(Icons.expand_more, color: Colors.red),
                            backgroundColor: Colors.red,
                            leading: new InkWell(
                              child: CircleAvatar(
                                  backgroundColor: Colors.orange,
                                  radius: 16.0,
                                  child: new Icon(Icons.message,
                                      color: Colors.white, size: 16.0)),
                            ),
                            title: new Text('Surat Masuk',
                                style: TextStyle(
                                    fontFamily: 'Source Code Pro',
                                    fontSize: 16.0,
                                    color: Colors.white)),
                            children: [
                              new Column(
                                children: <Widget>[
                                  new ListTile(
                                    leading: Container(
                                        padding: EdgeInsets.only(left: 28.0),
                                        child: Icon(Icons.chevron_right,
                                            color: Colors.white)),
                                    title: new Text("Surat Masuk",
                                        style: TextStyle(
                                            fontFamily: 'Source Code Pro',
                                            fontSize: 14.0,
                                            color: Colors.white)),
                                    onTap: () {
                                      Navigator.of(context)
                                          .push(new SuratMasukRoute());
                                    },
                                  ),
                                  new ListTile(
                                    leading: Container(
                                        padding: EdgeInsets.only(left: 28.0),
                                        child: Icon(Icons.chevron_right,
                                            color: Colors.white)),
                                    title: new Text("Disposisi Surat",
                                        style: TextStyle(
                                            fontFamily: 'Source Code Pro',
                                            fontSize: 14.0,
                                            color: Colors.white)),
                                    onTap: () {
                                      Navigator.of(context)
                                          .push(new DisposisiSuratMasukRoute());
                                    },
                                  )
                                ],
                              ),
                            ]);
                      } else if ('${dash.menu[0].child.menu.menu1}' == "200" &&
                          '${dash.menu[0].child.menu.menu2}' == "404" &&
                          '${dash.menu[0].child.menu.menu3}' == "404") {
                        expansionTileSuratMasuk = new ExpansionTile(
                            trailing:
                                Icon(Icons.expand_more, color: Colors.red),
                            backgroundColor: Colors.red,
                            leading: new InkWell(
                              child: CircleAvatar(
                                  backgroundColor: Colors.orange,
                                  radius: 16.0,
                                  child: new Icon(Icons.message,
                                      color: Colors.white, size: 16.0)),
                            ),
                            title: new Text('Surat Masuk',
                                style: TextStyle(
                                    fontFamily: 'Source Code Pro',
                                    fontSize: 16.0,
                                    color: Colors.white)),
                            children: [
                              new Column(
                                children: <Widget>[
                                  new ListTile(
                                    leading: Container(
                                        padding: EdgeInsets.only(left: 28.0),
                                        child: Icon(Icons.chevron_right,
                                            color: Colors.white)),
                                    title: new Text("Surat Masuk",
                                        style: TextStyle(
                                            fontFamily: 'Source Code Pro',
                                            fontSize: 14.0,
                                            color: Colors.white)),
                                    onTap: () {
                                      Navigator.of(context)
                                          .push(new SuratMasukRoute());
                                    },
                                  )
                                ],
                              ),
                            ]);
                      } else if ('${dash.menu[0].child.menu.menu1}' == "404" &&
                          '${dash.menu[0].child.menu.menu2}' == "200" &&
                          '${dash.menu[0].child.menu.menu3}' == "404") {
                        expansionTileSuratMasuk = new ExpansionTile(
                            trailing:
                                Icon(Icons.expand_more, color: Colors.red),
                            backgroundColor: Colors.red,
                            leading: new InkWell(
                              child: CircleAvatar(
                                  backgroundColor: Colors.orange,
                                  radius: 16.0,
                                  child: new Icon(Icons.message,
                                      color: Colors.white, size: 16.0)),
                            ),
                            title: new Text('Surat Masuk',
                                style: TextStyle(
                                    fontFamily: 'Source Code Pro',
                                    fontSize: 16.0,
                                    color: Colors.white)),
                            children: [
                              new Column(
                                children: <Widget>[
                                  new ListTile(
                                    leading: Container(
                                        padding: EdgeInsets.only(left: 28.0),
                                        child: Icon(Icons.chevron_right,
                                            color: Colors.white)),
                                    title: new Text("Disposisi Surat",
                                        style: TextStyle(
                                            fontFamily: 'Source Code Pro',
                                            fontSize: 14.0,
                                            color: Colors.white)),
                                    onTap: () {
                                      Navigator.of(context)
                                          .push(new DisposisiSuratMasukRoute());
                                    },
                                  )
                                ],
                              ),
                            ]);
                      } else if ('${dash.menu[0].child.menu.menu1}' == "404" &&
                          '${dash.menu[0].child.menu.menu2}' == "404" &&
                          '${dash.menu[0].child.menu.menu3}' == "200") {
                        expansionTileSuratMasuk = new ExpansionTile(
                            trailing:
                                Icon(Icons.expand_more, color: Colors.red),
                            backgroundColor: Colors.red,
                            leading: new InkWell(
                              child: CircleAvatar(
                                  backgroundColor: Colors.orange,
                                  radius: 16.0,
                                  child: new Icon(Icons.message,
                                      color: Colors.white, size: 16.0)),
                            ),
                            title: new Text('Surat Masuk',
                                style: TextStyle(
                                    fontFamily: 'Source Code Pro',
                                    fontSize: 16.0,
                                    color: Colors.white)),
                            children: [
                              new Column(
                                children: <Widget>[
                                  new ListTile(
                                    leading: Container(
                                        padding: EdgeInsets.only(left: 28.0),
                                        child: Icon(Icons.chevron_right,
                                            color: Colors.white)),
                                    title: new Text("Tracking/History",
                                        style: TextStyle(
                                            fontFamily: 'Source Code Pro',
                                            fontSize: 14.0,
                                            color: Colors.white)),
                                    onTap: () {
                                      Navigator.of(context).push(
                                          new TrackingHistoriSuratMasukRoute());
                                    },
                                  )
                                ],
                              ),
                            ]);
                      } else if ('${dash.menu[0].child.menu.menu1}' == "200" &&
                          '${dash.menu[0].child.menu.menu2}' == "200" &&
                          '${dash.menu[0].child.menu.menu3}' == "200") {
                        expansionTileSuratMasuk = new ExpansionTile(
                            trailing:
                                Icon(Icons.expand_more, color: Colors.red),
                            backgroundColor: Colors.red,
                            leading: new InkWell(
                              child: CircleAvatar(
                                  backgroundColor: Colors.orange,
                                  radius: 16.0,
                                  child: new Icon(Icons.message,
                                      color: Colors.white, size: 16.0)),
                            ),
                            title: new Text('Surat Masuk',
                                style: TextStyle(
                                    fontFamily: 'Source Code Pro',
                                    fontSize: 16.0,
                                    color: Colors.white)),
                            children: [
                              new Column(
                                children: <Widget>[
                                  new ListTile(
                                    leading: Container(
                                        padding: EdgeInsets.only(left: 28.0),
                                        child: Icon(Icons.chevron_right,
                                            color: Colors.white)),
                                    title: new Text("Surat Masuk",
                                        style: TextStyle(
                                            fontFamily: 'Source Code Pro',
                                            fontSize: 14.0,
                                            color: Colors.white)),
                                    onTap: () {
                                      Navigator.of(context)
                                          .push(new SuratMasukRoute());
                                    },
                                  ),
                                  new ListTile(
                                    leading: Container(
                                        padding: EdgeInsets.only(left: 28.0),
                                        child: Icon(Icons.chevron_right,
                                            color: Colors.white)),
                                    title: new Text("Disposisi Surat",
                                        style: TextStyle(
                                            fontFamily: 'Source Code Pro',
                                            fontSize: 14.0,
                                            color: Colors.white)),
                                    onTap: () {
                                      Navigator.of(context)
                                          .push(new DisposisiSuratMasukRoute());
                                    },
                                  ),
                                  new ListTile(
                                    leading: Container(
                                        padding: EdgeInsets.only(left: 28.0),
                                        child: Icon(Icons.chevron_right,
                                            color: Colors.white)),
                                    title: new Text("Tracking/History",
                                        style: TextStyle(
                                            fontFamily: 'Source Code Pro',
                                            fontSize: 14.0,
                                            color: Colors.white)),
                                    onTap: () {
                                      Navigator.of(context).push(
                                          new TrackingHistoriSuratMasukRoute());
                                    },
                                  )
                                ],
                              ),
                            ]);
                      } else if ('${dash.menu[0].child.menu.menu1}' == "404" &&
                          '${dash.menu[0].child.menu.menu2}' == "404" &&
                          '${dash.menu[0].child.menu.menu3}' == "404") {
                        expansionTileSuratMasuk = new ExpansionTile(
                            trailing:
                                Icon(Icons.expand_more, color: Colors.red),
                            backgroundColor: Colors.red,
                            leading: new InkWell(
                              child: CircleAvatar(
                                  backgroundColor: Colors.orange,
                                  radius: 16.0,
                                  child: new Icon(Icons.message,
                                      color: Colors.white, size: 16.0)),
                            ),
                            title: new Text('Surat Masuk',
                                style: TextStyle(
                                    fontFamily: 'Source Code Pro',
                                    fontSize: 16.0,
                                    color: Colors.white)),
                            children: [
                              new Column(
                                children: <Widget>[],
                              ),
                            ]);
                      }
                    } else {
                      expansionTileSuratMasuk = new Container(
                        height: 0,
                      );
                    }

                    if (dash.menu[1].label != null) {
                      if ('${dash.menu[1].child.menu.menu1}' == "404" &&
                          '${dash.menu[1].child.menu.menu2}' == "200" &&
                          '${dash.menu[1].child.menu.menu3}' == "200") {
                        expansionTileSuratKeluar = new ExpansionTile(
                            trailing:
                                Icon(Icons.expand_more, color: Colors.purple),
                            backgroundColor: Colors.purple,
                            leading: new InkWell(
                              child: CircleAvatar(
                                  backgroundColor: Colors.pinkAccent,
                                  radius: 16.0,
                                  child: new Icon(Icons.send,
                                      color: Colors.white, size: 16.0)),
                            ),
                            title: new Text('Surat Keluar',
                                style: TextStyle(
                                    fontFamily: 'Source Code Pro',
                                    fontSize: 16.0,
                                    color: Colors.white)),
                            children: [
                              new Column(
                                children: <Widget>[
                                  new ListTile(
                                    leading: Container(
                                        padding: EdgeInsets.only(left: 28.0),
                                        child: Icon(Icons.chevron_right,
                                            color: Colors.white)),
                                    title: new Text("Distribusi Surat",
                                        style: TextStyle(
                                            fontFamily: 'Source Code Pro',
                                            fontSize: 14.0,
                                            color: Colors.white)),
                                    onTap: () {
                                      Navigator.of(context)
                                          .push(new DistribusiSuratRoute());
                                    },
                                  ),
                                  new ListTile(
                                    leading: Container(
                                        padding: EdgeInsets.only(left: 28.0),
                                        child: Icon(Icons.chevron_right,
                                            color: Colors.white)),
                                    title: new Text("Tracking/History",
                                        style: TextStyle(
                                            fontFamily: 'Source Code Pro',
                                            fontSize: 14.0,
                                            color: Colors.white)),
                                    onTap: () {
                                      Navigator.of(context).push(
                                          new TrackingHistoriSuratKeluarRoute());
                                    },
                                  )
                                ],
                              ),
                            ]);
                      } else if ('${dash.menu[1].child.menu.menu1}' == "200" &&
                          '${dash.menu[1].child.menu.menu2}' == "404" &&
                          '${dash.menu[1].child.menu.menu3}' == "200") {
                        expansionTileSuratKeluar = new ExpansionTile(
                            trailing:
                                Icon(Icons.expand_more, color: Colors.purple),
                            backgroundColor: Colors.purple,
                            leading: new InkWell(
                              child: CircleAvatar(
                                  backgroundColor: Colors.pinkAccent,
                                  radius: 16.0,
                                  child: new Icon(Icons.send,
                                      color: Colors.white, size: 16.0)),
                            ),
                            title: new Text('Surat Keluar',
                                style: TextStyle(
                                    fontFamily: 'Source Code Pro',
                                    fontSize: 16.0,
                                    color: Colors.white)),
                            children: [
                              new Column(
                                children: <Widget>[
                                  new ListTile(
                                    leading: Container(
                                        padding: EdgeInsets.only(left: 28.0),
                                        child: Icon(Icons.chevron_right,
                                            color: Colors.white)),
                                    title: new Text("Surat Keluar",
                                        style: TextStyle(
                                            fontFamily: 'Source Code Pro',
                                            fontSize: 14.0,
                                            color: Colors.white)),
                                    onTap: () {
                                      Navigator.of(context)
                                          .push(new SuratKeluarRoute());
                                    },
                                  ),
                                  new ListTile(
                                    leading: Container(
                                        padding: EdgeInsets.only(left: 28.0),
                                        child: Icon(Icons.chevron_right,
                                            color: Colors.white)),
                                    title: new Text("Tracking/History",
                                        style: TextStyle(
                                            fontFamily: 'Source Code Pro',
                                            fontSize: 14.0,
                                            color: Colors.white)),
                                    onTap: () {
                                      Navigator.of(context).push(
                                          new TrackingHistoriSuratKeluarRoute());
                                    },
                                  )
                                ],
                              ),
                            ]);
                      } else if ('${dash.menu[1].child.menu.menu1}' == "200" &&
                          '${dash.menu[1].child.menu.menu2}' == "200" &&
                          '${dash.menu[1].child.menu.menu3}' == "404") {
                        expansionTileSuratKeluar = new ExpansionTile(
                            trailing:
                                Icon(Icons.expand_more, color: Colors.purple),
                            backgroundColor: Colors.purple,
                            leading: new InkWell(
                              child: CircleAvatar(
                                  backgroundColor: Colors.pinkAccent,
                                  radius: 16.0,
                                  child: new Icon(Icons.send,
                                      color: Colors.white, size: 16.0)),
                            ),
                            title: new Text('Surat Keluar',
                                style: TextStyle(
                                    fontFamily: 'Source Code Pro',
                                    fontSize: 16.0,
                                    color: Colors.white)),
                            children: [
                              new Column(
                                children: <Widget>[
                                  new ListTile(
                                    leading: Container(
                                        padding: EdgeInsets.only(left: 28.0),
                                        child: Icon(Icons.chevron_right,
                                            color: Colors.white)),
                                    title: new Text("Surat Keluar",
                                        style: TextStyle(
                                            fontFamily: 'Source Code Pro',
                                            fontSize: 14.0,
                                            color: Colors.white)),
                                    onTap: () {
                                      Navigator.of(context)
                                          .push(new SuratKeluarRoute());
                                    },
                                  ),
                                  new ListTile(
                                    leading: Container(
                                        padding: EdgeInsets.only(left: 28.0),
                                        child: Icon(Icons.chevron_right,
                                            color: Colors.white)),
                                    title: new Text("Distribusi Surat",
                                        style: TextStyle(
                                            fontFamily: 'Source Code Pro',
                                            fontSize: 14.0,
                                            color: Colors.white)),
                                    onTap: () {
                                      Navigator.of(context)
                                          .push(new DistribusiSuratRoute());
                                    },
                                  )
                                ],
                              ),
                            ]);
                      } else if ('${dash.menu[1].child.menu.menu1}' == "200" &&
                          '${dash.menu[1].child.menu.menu2}' == "404" &&
                          '${dash.menu[1].child.menu.menu3}' == "404") {
                        expansionTileSuratKeluar = new ExpansionTile(
                            trailing:
                                Icon(Icons.expand_more, color: Colors.purple),
                            backgroundColor: Colors.purple,
                            leading: new InkWell(
                              child: CircleAvatar(
                                  backgroundColor: Colors.pinkAccent,
                                  radius: 16.0,
                                  child: new Icon(Icons.send,
                                      color: Colors.white, size: 16.0)),
                            ),
                            title: new Text('Surat Keluar',
                                style: TextStyle(
                                    fontFamily: 'Source Code Pro',
                                    fontSize: 16.0,
                                    color: Colors.white)),
                            children: [
                              new Column(
                                children: <Widget>[
                                  new ListTile(
                                    leading: Container(
                                        padding: EdgeInsets.only(left: 28.0),
                                        child: Icon(Icons.chevron_right,
                                            color: Colors.white)),
                                    title: new Text("Surat Keluar",
                                        style: TextStyle(
                                            fontFamily: 'Source Code Pro',
                                            fontSize: 14.0,
                                            color: Colors.white)),
                                    onTap: () {
                                      Navigator.of(context)
                                          .push(new SuratKeluarRoute());
                                    },
                                  )
                                ],
                              ),
                            ]);
                      } else if ('${dash.menu[1].child.menu.menu1}' == "404" &&
                          '${dash.menu[1].child.menu.menu2}' == "200" &&
                          '${dash.menu[1].child.menu.menu3}' == "404") {
                        expansionTileSuratKeluar = new ExpansionTile(
                            trailing:
                                Icon(Icons.expand_more, color: Colors.purple),
                            backgroundColor: Colors.purple,
                            leading: new InkWell(
                              child: CircleAvatar(
                                  backgroundColor: Colors.pinkAccent,
                                  radius: 16.0,
                                  child: new Icon(Icons.send,
                                      color: Colors.white, size: 16.0)),
                            ),
                            title: new Text('Surat Keluar',
                                style: TextStyle(
                                    fontFamily: 'Source Code Pro',
                                    fontSize: 16.0,
                                    color: Colors.white)),
                            children: [
                              new Column(
                                children: <Widget>[
                                  new ListTile(
                                    leading: Container(
                                        padding: EdgeInsets.only(left: 28.0),
                                        child: Icon(Icons.chevron_right,
                                            color: Colors.white)),
                                    title: new Text("Distribusi Surat",
                                        style: TextStyle(
                                            fontFamily: 'Source Code Pro',
                                            fontSize: 14.0,
                                            color: Colors.white)),
                                    onTap: () {
                                      Navigator.of(context)
                                          .push(new DistribusiSuratRoute());
                                    },
                                  )
                                ],
                              ),
                            ]);
                      } else if ('${dash.menu[1].child.menu.menu1}' == "404" &&
                          '${dash.menu[1].child.menu.menu2}' == "404" &&
                          '${dash.menu[1].child.menu.menu3}' == "200") {
                        expansionTileSuratKeluar = new ExpansionTile(
                            trailing:
                                Icon(Icons.expand_more, color: Colors.purple),
                            backgroundColor: Colors.purple,
                            leading: new InkWell(
                              child: CircleAvatar(
                                  backgroundColor: Colors.pinkAccent,
                                  radius: 16.0,
                                  child: new Icon(Icons.send,
                                      color: Colors.white, size: 16.0)),
                            ),
                            title: new Text('Surat Keluar',
                                style: TextStyle(
                                    fontFamily: 'Source Code Pro',
                                    fontSize: 16.0,
                                    color: Colors.white)),
                            children: [
                              new Column(
                                children: <Widget>[
                                  new ListTile(
                                    leading: Container(
                                        padding: EdgeInsets.only(left: 28.0),
                                        child: Icon(Icons.chevron_right,
                                            color: Colors.white)),
                                    title: new Text("Tracking/History",
                                        style: TextStyle(
                                            fontFamily: 'Source Code Pro',
                                            fontSize: 14.0,
                                            color: Colors.white)),
                                    onTap: () {
                                      Navigator.of(context).push(
                                          new TrackingHistoriSuratKeluarRoute());
                                    },
                                  )
                                ],
                              ),
                            ]);
                      } else if ('${dash.menu[1].child.menu.menu1}' == "200" &&
                          '${dash.menu[1].child.menu.menu2}' == "200" &&
                          '${dash.menu[1].child.menu.menu3}' == "200") {
                        expansionTileSuratKeluar = new ExpansionTile(
                            trailing:
                                Icon(Icons.expand_more, color: Colors.purple),
                            backgroundColor: Colors.purple,
                            leading: new InkWell(
                              child: CircleAvatar(
                                  backgroundColor: Colors.pinkAccent,
                                  radius: 16.0,
                                  child: new Icon(Icons.send,
                                      color: Colors.white, size: 16.0)),
                            ),
                            title: new Text('Surat Keluar',
                                style: TextStyle(
                                    fontFamily: 'Source Code Pro',
                                    fontSize: 16.0,
                                    color: Colors.white)),
                            children: [
                              new Column(
                                children: <Widget>[
                                  new ListTile(
                                    leading: Container(
                                        padding: EdgeInsets.only(left: 28.0),
                                        child: Icon(Icons.chevron_right,
                                            color: Colors.white)),
                                    title: new Text("Surat Keluar",
                                        style: TextStyle(
                                            fontFamily: 'Source Code Pro',
                                            fontSize: 14.0,
                                            color: Colors.white)),
                                    onTap: () {
                                      Navigator.of(context)
                                          .push(new SuratKeluarRoute());
                                    },
                                  ),
                                  new ListTile(
                                    leading: Container(
                                        padding: EdgeInsets.only(left: 28.0),
                                        child: Icon(Icons.chevron_right,
                                            color: Colors.white)),
                                    title: new Text("Distribusi Surat",
                                        style: TextStyle(
                                            fontFamily: 'Source Code Pro',
                                            fontSize: 14.0,
                                            color: Colors.white)),
                                    onTap: () {
                                      Navigator.of(context)
                                          .push(new DistribusiSuratRoute());
                                    },
                                  ),
                                  new ListTile(
                                    leading: Container(
                                        padding: EdgeInsets.only(left: 28.0),
                                        child: Icon(Icons.chevron_right,
                                            color: Colors.white)),
                                    title: new Text("Tracking/History",
                                        style: TextStyle(
                                            fontFamily: 'Source Code Pro',
                                            fontSize: 14.0,
                                            color: Colors.white)),
                                    onTap: () {
                                      Navigator.of(context).push(
                                          new TrackingHistoriSuratKeluarRoute());
                                    },
                                  )
                                ],
                              ),
                            ]);
                      } else if ('${dash.menu[1].child.menu.menu1}' == "404" &&
                          '${dash.menu[1].child.menu.menu2}' == "404" &&
                          '${dash.menu[1].child.menu.menu3}' == "404") {
                        expansionTileSuratKeluar = new ExpansionTile(
                            trailing:
                                Icon(Icons.expand_more, color: Colors.purple),
                            backgroundColor: Colors.purple,
                            leading: new InkWell(
                              child: CircleAvatar(
                                  backgroundColor: Colors.pinkAccent,
                                  radius: 16.0,
                                  child: new Icon(Icons.send,
                                      color: Colors.white, size: 16.0)),
                            ),
                            title: new Text('Surat Keluar',
                                style: TextStyle(
                                    fontFamily: 'Source Code Pro',
                                    fontSize: 16.0,
                                    color: Colors.white)),
                            children: [
                              new Column(
                                children: <Widget>[],
                              ),
                            ]);
                      }
                    } else {
                      expansionTileSuratKeluar = new Container(
                        height: 0,
                      );
                    }

                    if (dash.menu[2].label != null) {
                      if ('${dash.menu[2].child.menu.menu1}' == "404" &&
                          '${dash.menu[2].child.menu.menu2}' == "200") {
                        expansionTileMemoDinas = new ExpansionTile(
                            trailing: Icon(Icons.expand_more,
                                color: Colors.blueAccent),
                            backgroundColor: Colors.blueAccent,
                            leading: new InkWell(
                              child: CircleAvatar(
                                  backgroundColor: Colors.greenAccent,
                                  radius: 16.0,
                                  child: new Icon(Icons.mail,
                                      color: Colors.white, size: 16.0)),
                            ),
                            title: new Text('Memo Dinas',
                                style: TextStyle(
                                    fontFamily: 'Source Code Pro',
                                    fontSize: 16.0,
                                    color: Colors.white)),
                            children: [
                              new Column(
                                children: <Widget>[
                                  new ListTile(
                                    leading: Container(
                                        padding: EdgeInsets.only(left: 28.0),
                                        child: Icon(Icons.chevron_right,
                                            color: Colors.white)),
                                    title: new Text("Memo Masuk",
                                        style: TextStyle(
                                            fontFamily: 'Source Code Pro',
                                            fontSize: 14.0,
                                            color: Colors.white)),
                                    onTap: () {
                                      Navigator.of(context)
                                          .push(new MemoMasukRoute());
                                    },
                                  )
                                ],
                              ),
                            ]);
                      } else if ('${dash.menu[2].child.menu.menu1}' == "200" &&
                          '${dash.menu[2].child.menu.menu2}' == "404") {
                        expansionTileMemoDinas = new ExpansionTile(
                            trailing: Icon(Icons.expand_more,
                                color: Colors.blueAccent),
                            backgroundColor: Colors.blueAccent,
                            leading: new InkWell(
                              child: CircleAvatar(
                                  backgroundColor: Colors.greenAccent,
                                  radius: 16.0,
                                  child: new Icon(Icons.mail,
                                      color: Colors.white, size: 16.0)),
                            ),
                            title: new Text('Memo Dinas',
                                style: TextStyle(
                                    fontFamily: 'Source Code Pro',
                                    fontSize: 16.0,
                                    color: Colors.white)),
                            children: [
                              new Column(
                                children: <Widget>[
                                  new ListTile(
                                    leading: Container(
                                        padding: EdgeInsets.only(left: 28.0),
                                        child: Icon(Icons.chevron_right,
                                            color: Colors.white)),
                                    title: new Text("Memo Keluar",
                                        style: TextStyle(
                                            fontFamily: 'Source Code Pro',
                                            fontSize: 14.0,
                                            color: Colors.white)),
                                    onTap: () {
                                      Navigator.of(context)
                                          .push(new MemoKeluarRoute());
                                    },
                                  )
                                ],
                              ),
                            ]);
                      } else if ('${dash.menu[2].child.menu.menu1}' == "200" &&
                          '${dash.menu[2].child.menu.menu2}' == "200") {
                        expansionTileMemoDinas = new ExpansionTile(
                            trailing: Icon(Icons.expand_more,
                                color: Colors.blueAccent),
                            backgroundColor: Colors.blueAccent,
                            leading: new InkWell(
                              child: CircleAvatar(
                                  backgroundColor: Colors.greenAccent,
                                  radius: 16.0,
                                  child: new Icon(Icons.mail,
                                      color: Colors.white, size: 16.0)),
                            ),
                            title: new Text('Memo Dinas',
                                style: TextStyle(
                                    fontFamily: 'Source Code Pro',
                                    fontSize: 16.0,
                                    color: Colors.white)),
                            children: [
                              new Column(
                                children: <Widget>[
                                  new ListTile(
                                    leading: Container(
                                        padding: EdgeInsets.only(left: 28.0),
                                        child: Icon(Icons.chevron_right,
                                            color: Colors.white)),
                                    title: new Text("Memo Keluar",
                                        style: TextStyle(
                                            fontFamily: 'Source Code Pro',
                                            fontSize: 14.0,
                                            color: Colors.white)),
                                    onTap: () {
                                      Navigator.of(context)
                                          .push(new MemoKeluarRoute());
                                    },
                                  ),
                                  new ListTile(
                                    leading: Container(
                                        padding: EdgeInsets.only(left: 28.0),
                                        child: Icon(Icons.chevron_right,
                                            color: Colors.white)),
                                    title: new Text("Memo Masuk",
                                        style: TextStyle(
                                            fontFamily: 'Source Code Pro',
                                            fontSize: 14.0,
                                            color: Colors.white)),
                                    onTap: () {
                                      Navigator.of(context)
                                          .push(new MemoMasukRoute());
                                    },
                                  )
                                ],
                              ),
                            ]);
                      } else if ('${dash.menu[2].child.menu.menu1}' == "404" &&
                          '${dash.menu[2].child.menu.menu2}' == "404") {
                        expansionTileMemoDinas = new ExpansionTile(
                            trailing: Icon(Icons.expand_more,
                                color: Colors.blueAccent),
                            backgroundColor: Colors.blueAccent,
                            leading: new InkWell(
                              child: CircleAvatar(
                                  backgroundColor: Colors.greenAccent,
                                  radius: 16.0,
                                  child: new Icon(Icons.mail,
                                      color: Colors.white, size: 16.0)),
                            ),
                            title: new Text('Memo Dinas',
                                style: TextStyle(
                                    fontFamily: 'Source Code Pro',
                                    fontSize: 16.0,
                                    color: Colors.white)),
                            children: [
                              new Column(
                                children: <Widget>[],
                              ),
                            ]);
                      }
                    } else {
                      expansionTileMemoDinas = new Container(
                        height: 0,
                      );
                    }

                    return new Container(
                        decoration: new BoxDecoration(
                          image: new DecorationImage(
                            image: new AssetImage("assets/bghk.jpg"),
                            fit: BoxFit.cover,
                            colorFilter: new ColorFilter.mode(
                                Colors.black.withOpacity(0.5),
                                BlendMode.dstATop),
                          ),
                        ),
                        child: new Center(
                          child: new SingleChildScrollView(
                            padding: EdgeInsets.only(left: 48.0, right: 48.0),
                            child: new Column(
                              children: <Widget>[
                                new Container(
                                    decoration: new BoxDecoration(
                                        color: Colors.red,
                                        shape: BoxShape.rectangle,
                                        borderRadius:
                                            new BorderRadius.circular(8.0),
                                        boxShadow: <BoxShadow>[
                                          new BoxShadow(
                                            color: Colors.black,
                                            blurRadius: 10.0,
                                            offset: new Offset(0.0, 10.0),
                                          ),
                                        ]),
                                    child: expansionTileSuratMasuk),
                                new Container(height: 16.0),
                                new Container(
                                    decoration: new BoxDecoration(
                                        color: Colors.purple,
                                        shape: BoxShape.rectangle,
                                        borderRadius:
                                            new BorderRadius.circular(8.0),
                                        boxShadow: <BoxShadow>[
                                          new BoxShadow(
                                            color: Colors.black,
                                            blurRadius: 10.0,
                                            offset: new Offset(0.0, 10.0),
                                          ),
                                        ]),
                                    child: expansionTileSuratKeluar),
                                new Container(height: 16.0),
                                new Container(
                                    decoration: new BoxDecoration(
                                        color: Colors.blueAccent,
                                        shape: BoxShape.rectangle,
                                        borderRadius:
                                            new BorderRadius.circular(8.0),
                                        boxShadow: <BoxShadow>[
                                          new BoxShadow(
                                            color: Colors.black,
                                            blurRadius: 10.0,
                                            offset: new Offset(0.0, 10.0),
                                          ),
                                        ]),
                                    child: expansionTileMemoDinas),
                                new Container(height: 24.0),
                              ],
                            ),
                          ),
                        ));
                  } else {
                    return new DefaultTabController(
                      length: 4,
                      child: new Scaffold(
                        appBar: new AppBar(
                          elevation: 0.0,
                          automaticallyImplyLeading: false,
                          actions: <Widget>[],
                          title: new TabBar(
                            tabs: [
                              new Tab(
                                  icon: new Icon(Icons.navigation,
                                      color: Colors.blue)),
                              new Tab(
                                  icon: new Icon(Icons.message,
                                      color: Colors.deepOrangeAccent)),
                              new Tab(
                                  icon: new Icon(Icons.send,
                                      color: Colors.pinkAccent)),
                              new Tab(
                                  icon: new Icon(Icons.mail,
                                      color: Colors.greenAccent)),
                            ],
                            indicatorColor: Colors.red,
                          ),
                        ),
                        body: new TabBarView(
                          children: [
                            new Container(
                                decoration: new BoxDecoration(
                                  image: new DecorationImage(
                                    image: new AssetImage("assets/bghk.jpg"),
                                    fit: BoxFit.cover,
                                    colorFilter: new ColorFilter.mode(
                                        Colors.black.withOpacity(0.5),
                                        BlendMode.dstATop),
                                  ),
                                ),
                                child: new Center(
                                  child: new SingleChildScrollView(
                                    padding: EdgeInsets.only(
                                        left: 48.0, right: 48.0),
                                    child: new Column(
                                      children: <Widget>[
                                        new Container(
                                            decoration: new BoxDecoration(
                                                color: Colors.red,
                                                shape: BoxShape.rectangle,
                                                borderRadius:
                                                    new BorderRadius.circular(
                                                        8.0),
                                                boxShadow: <BoxShadow>[
                                                  new BoxShadow(
                                                    color: Colors.black,
                                                    blurRadius: 10.0,
                                                    offset:
                                                        new Offset(0.0, 10.0),
                                                  ),
                                                ]),
                                            child: new ExpansionTile(
                                                trailing: Icon(
                                                    Icons.expand_more,
                                                    color: Colors.red),
                                                backgroundColor: Colors.red,
                                                leading: new InkWell(
                                                  child: CircleAvatar(
                                                      backgroundColor:
                                                          Colors.orange,
                                                      radius: 16.0,
                                                      child: new Icon(
                                                          Icons.message,
                                                          color: Colors.white,
                                                          size: 16.0)),
                                                ),
                                                title: new Text('Surat Masuk',
                                                    style: TextStyle(
                                                        fontFamily:
                                                            'Source Code Pro',
                                                        fontSize: 16.0,
                                                        color: Colors.white)),
                                                children: [
                                                  new Column(
                                                    children: <Widget>[
                                                      new ListTile(
                                                        leading: Container(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    left: 28.0),
                                                            child: Icon(
                                                                Icons
                                                                    .chevron_right,
                                                                color: Colors
                                                                    .white)),
                                                        title: new Text(
                                                            "Surat Masuk",
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    'Source Code Pro',
                                                                fontSize: 14.0,
                                                                color: Colors
                                                                    .white)),
                                                        onTap: () {
                                                          Navigator.of(context)
                                                              .push(
                                                                  new SuratMasukRoute());
                                                        },
                                                      ),
                                                      new ListTile(
                                                        leading: Container(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    left: 28.0),
                                                            child: Icon(
                                                                Icons
                                                                    .chevron_right,
                                                                color: Colors
                                                                    .white)),
                                                        title: new Text(
                                                            "Disposisi Surat",
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    'Source Code Pro',
                                                                fontSize: 14.0,
                                                                color: Colors
                                                                    .white)),
                                                        onTap: () {
                                                          Navigator.of(context)
                                                              .push(
                                                                  new DisposisiSuratMasukRoute());
                                                        },
                                                      ),
                                                      new ListTile(
                                                        leading: Container(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    left: 28.0),
                                                            child: Icon(
                                                                Icons
                                                                    .chevron_right,
                                                                color: Colors
                                                                    .white)),
                                                        title: new Text(
                                                            "Tracking/History",
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    'Source Code Pro',
                                                                fontSize: 14.0,
                                                                color: Colors
                                                                    .white)),
                                                        onTap: () {
                                                          Navigator.of(context)
                                                              .push(
                                                                  new TrackingHistoriSuratMasukRoute());
                                                        },
                                                      )
                                                    ],
                                                  ),
                                                ])),
                                        new Container(height: 16.0),
                                        new Container(
                                            decoration: new BoxDecoration(
                                                color: Colors.purple,
                                                shape: BoxShape.rectangle,
                                                borderRadius:
                                                    new BorderRadius.circular(
                                                        8.0),
                                                boxShadow: <BoxShadow>[
                                                  new BoxShadow(
                                                    color: Colors.black,
                                                    blurRadius: 10.0,
                                                    offset:
                                                        new Offset(0.0, 10.0),
                                                  ),
                                                ]),
                                            child: new ExpansionTile(
                                                trailing: Icon(
                                                    Icons.expand_more,
                                                    color: Colors.purple),
                                                backgroundColor: Colors.purple,
                                                leading: new InkWell(
                                                  child: CircleAvatar(
                                                      backgroundColor:
                                                          Colors.pinkAccent,
                                                      radius: 16.0,
                                                      child: new Icon(
                                                          Icons.send,
                                                          color: Colors.white,
                                                          size: 16.0)),
                                                ),
                                                title: new Text('Surat Keluar',
                                                    style: TextStyle(
                                                        fontFamily:
                                                            'Source Code Pro',
                                                        fontSize: 16.0,
                                                        color: Colors.white)),
                                                children: [
                                                  new Column(
                                                    children: <Widget>[
                                                      new ListTile(
                                                        leading: Container(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    left: 28.0),
                                                            child: Icon(
                                                                Icons
                                                                    .chevron_right,
                                                                color: Colors
                                                                    .white)),
                                                        title: new Text(
                                                            "Surat Keluar",
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    'Source Code Pro',
                                                                fontSize: 14.0,
                                                                color: Colors
                                                                    .white)),
                                                        onTap: () {
                                                          Navigator.of(context)
                                                              .push(
                                                                  new SuratKeluarRoute());
                                                        },
                                                      ),
                                                      new ListTile(
                                                        leading: Container(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    left: 28.0),
                                                            child: Icon(
                                                                Icons
                                                                    .chevron_right,
                                                                color: Colors
                                                                    .white)),
                                                        title: new Text(
                                                            "Distribusi Surat",
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    'Source Code Pro',
                                                                fontSize: 14.0,
                                                                color: Colors
                                                                    .white)),
                                                        onTap: () {
                                                          Navigator.of(context)
                                                              .push(
                                                                  new DistribusiSuratRoute());
                                                        },
                                                      ),
                                                      new ListTile(
                                                        leading: Container(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    left: 28.0),
                                                            child: Icon(
                                                                Icons
                                                                    .chevron_right,
                                                                color: Colors
                                                                    .white)),
                                                        title: new Text(
                                                            "Tracking/History",
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    'Source Code Pro',
                                                                fontSize: 14.0,
                                                                color: Colors
                                                                    .white)),
                                                        onTap: () {
                                                          Navigator.of(context)
                                                              .push(
                                                                  new TrackingHistoriSuratKeluarRoute());
                                                        },
                                                      )
                                                    ],
                                                  ),
                                                ])),
                                        new Container(height: 16.0),
                                        new Container(
                                            decoration: new BoxDecoration(
                                                color: Colors.blueAccent,
                                                shape: BoxShape.rectangle,
                                                borderRadius:
                                                    new BorderRadius.circular(
                                                        8.0),
                                                boxShadow: <BoxShadow>[
                                                  new BoxShadow(
                                                    color: Colors.black,
                                                    blurRadius: 10.0,
                                                    offset:
                                                        new Offset(0.0, 10.0),
                                                  ),
                                                ]),
                                            child: new ExpansionTile(
                                                trailing: Icon(
                                                    Icons.expand_more,
                                                    color: Colors.blueAccent),
                                                backgroundColor:
                                                    Colors.blueAccent,
                                                leading: new InkWell(
                                                  child: CircleAvatar(
                                                      backgroundColor:
                                                          Colors.greenAccent,
                                                      radius: 16.0,
                                                      child: new Icon(
                                                          Icons.mail,
                                                          color: Colors.white,
                                                          size: 16.0)),
                                                ),
                                                title: new Text('Memo Dinas',
                                                    style: TextStyle(
                                                        fontFamily:
                                                            'Source Code Pro',
                                                        fontSize: 16.0,
                                                        color: Colors.white)),
                                                children: [
                                                  new Column(
                                                    children: <Widget>[
                                                      new ListTile(
                                                        leading: Container(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    left: 28.0),
                                                            child: Icon(
                                                                Icons
                                                                    .chevron_right,
                                                                color: Colors
                                                                    .white)),
                                                        title: new Text(
                                                            "Memo Keluar",
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    'Source Code Pro',
                                                                fontSize: 14.0,
                                                                color: Colors
                                                                    .white)),
                                                        onTap: () {
                                                          Navigator.of(context)
                                                              .push(
                                                                  new MemoKeluarRoute());
                                                        },
                                                      ),
                                                      new ListTile(
                                                        leading: Container(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    left: 28.0),
                                                            child: Icon(
                                                                Icons
                                                                    .chevron_right,
                                                                color: Colors
                                                                    .white)),
                                                        title: new Text(
                                                            "Memo Masuk",
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    'Source Code Pro',
                                                                fontSize: 14.0,
                                                                color: Colors
                                                                    .white)),
                                                        onTap: () {
                                                          Navigator.of(context)
                                                              .push(
                                                                  new MemoMasukRoute());
                                                        },
                                                      )
                                                    ],
                                                  ),
                                                ])),
                                        new Container(height: 24.0),
                                      ],
                                    ),
                                  ),
                                )), //sini
                            SingleChildScrollView(
                              child: Stack(children: <Widget>[
                                new Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      Row(children: <Widget>[
                                        Expanded(
                                          child: Card(
                                            color: Colors.deepOrangeAccent,
                                            child: new InkWell(
                                                onTap: () {},
                                                child: new Column(
                                                  children: <Widget>[
                                                    new Center(
                                                      child: new Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(4.0),
                                                        child: new Icon(
                                                            Icons.message,
                                                            color: Colors.white,
                                                            size: 20.0),
                                                      ),
                                                    ),
                                                    new Center(
                                                      child: new Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(4.0),
                                                        child: new Text(
                                                            "Disposisi Surat Masuk",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white
                                                                    .withOpacity(
                                                                        0.8))),
                                                      ),
                                                    ),
                                                    new Center(
                                                      child: new Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(4.0),
                                                        child: new Text(
                                                            '${dash.jmlUnread.dismasuk}',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white
                                                                    .withOpacity(
                                                                        0.8))),
                                                      ),
                                                    )
                                                  ],
                                                )),
                                          ),
                                        ),
                                      ]),
                                      new Container(height: 10.0),
                                      ListView.builder(
                                        scrollDirection: Axis.vertical,
                                        shrinkWrap: true,
                                        itemCount: int.parse(
                                            '${dash.fiveMasuk.length}'),
                                        itemBuilder:
                                            (BuildContext context, int i) {
                                          return new Card(
                                            elevation: 8.0,
                                            margin: new EdgeInsets.symmetric(
                                                horizontal: 10.0,
                                                vertical: 6.0),
                                            child: Container(
                                                decoration: BoxDecoration(
                                                    // Box decoration takes a gradient
                                                    gradient: LinearGradient(
                                                  // Where the linear gradient begins and ends
                                                  begin: Alignment.topRight,
                                                  end: Alignment.bottomLeft,
                                                  // Add one stop for each color. Stops should increase from 0 to 1
                                                  stops: [0.1, 0.5, 0.7, 0.9],
                                                  colors: [
                                                    // Colors are easy thanks to Flutter's Colors class.
                                                    new Color(0xFFFFFFFF),
                                                    new Color(0xE6FFFFFF),
                                                    new Color(0xCCFFFFFF),
                                                    new Color(0x99FFFFFF),
                                                  ],
                                                )),
                                                child: new ListTile(
                                                    contentPadding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 20.0,
                                                            vertical: 10.0),
                                                    leading: Container(
                                                        padding:
                                                            EdgeInsets.only(
                                                                right: 12.0),
                                                        decoration: new BoxDecoration(
                                                            border: new Border(
                                                                right: new BorderSide(
                                                                    width: 2.0,
                                                                    color: Colors
                                                                        .deepPurpleAccent))),
                                                        child: new InkWell(
                                                          child: CircleAvatar(
                                                              backgroundColor:
                                                                  Colors
                                                                      .greenAccent,
                                                              radius: 16.0,
                                                              child: new Icon(
                                                                  Icons.search,
                                                                  color: Colors
                                                                      .white,
                                                                  size: 16.0)),
                                                          onTap: () {
                                                            Navigator.push(
                                                                context,
                                                                new MaterialPageRoute(
                                                                    builder: (BuildContext
                                                                            context) =>
                                                                        new DetailSuratMasuk(
                                                                            '${dash.fiveMasuk[i].masuk_id}')));
                                                          },
                                                        )),
                                                    title: Column(
                                                      children: <Widget>[
                                                        new Row(
                                                          children: <Widget>[
                                                            new Icon(
                                                                Icons
                                                                    .markunread_mailbox,
                                                                color: Colors
                                                                    .purple,
                                                                size: 16.0),
                                                            new Container(
                                                              width: 10.0,
                                                            ),
                                                            Text(
                                                                '${dash.fiveMasuk[i].masuk.no_surat}',
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontSize:
                                                                        14.0)),
                                                          ],
                                                        ),
                                                        new Separators(),
                                                      ],
                                                    ),
                                                    subtitle: Column(
                                                        children: <Widget>[
                                                          new Row(
                                                            children: <Widget>[
                                                              Text(
                                                                  '${dash.fiveMasuk[i].created_at}',
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .green,
                                                                      fontSize:
                                                                          12.0)),
                                                            ],
                                                          ),
                                                        ]),
                                                    onTap: () {
                                                      if ('${dash.fiveMasuk[i].satker_penerima}' ==
                                                          satkerLogin) {
                                                        Navigator.push(
                                                            context,
                                                            new MaterialPageRoute(
                                                                builder: (BuildContext
                                                                        context) =>
                                                                    new EditDisposisiSuratMasuk(
                                                                        '${dash.fiveMasuk[i].id}')));
                                                      } else {}
                                                    })),
                                          );
                                        },
                                      ),
                                      new Container(height: 10.0),
                                      chartWidgetMasuk,
                                    ])
                              ]),
                            ),
                            SingleChildScrollView(
                              child: Stack(children: <Widget>[
                                new Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      Row(children: <Widget>[
                                        Expanded(
                                          child: Card(
                                            color: Colors.pinkAccent,
                                            child: new InkWell(
                                                onTap: () {},
                                                child: new Column(
                                                  children: <Widget>[
                                                    new Center(
                                                      child: new Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(4.0),
                                                        child: new Icon(
                                                            Icons.message,
                                                            color: Colors.white,
                                                            size: 20.0),
                                                      ),
                                                    ),
                                                    new Center(
                                                      child: new Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(4.0),
                                                        child: new Text(
                                                            "Distribusi Surat Keluar",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white
                                                                    .withOpacity(
                                                                        0.8))),
                                                      ),
                                                    ),
                                                    new Center(
                                                      child: new Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(4.0),
                                                        child: new Text(
                                                            '${dash.jmlUnread.diskeluar}',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white
                                                                    .withOpacity(
                                                                        0.8))),
                                                      ),
                                                    )
                                                  ],
                                                )),
                                          ),
                                        ),
                                      ]),
                                      new Container(height: 10.0),
                                      ListView.builder(
                                        scrollDirection: Axis.vertical,
                                        shrinkWrap: true,
                                        itemCount: int.parse(
                                            '${dash.fiveKeluar.length}'),
                                        itemBuilder:
                                            (BuildContext context, int i) {
                                          return new Card(
                                            elevation: 8.0,
                                            margin: new EdgeInsets.symmetric(
                                                horizontal: 10.0,
                                                vertical: 6.0),
                                            child: Container(
                                                decoration: BoxDecoration(
                                                    // Box decoration takes a gradient
                                                    gradient: LinearGradient(
                                                  // Where the linear gradient begins and ends
                                                  begin: Alignment.topRight,
                                                  end: Alignment.bottomLeft,
                                                  // Add one stop for each color. Stops should increase from 0 to 1
                                                  stops: [0.1, 0.5, 0.7, 0.9],
                                                  colors: [
                                                    // Colors are easy thanks to Flutter's Colors class.
                                                    new Color(0xFFFFFFFF),
                                                    new Color(0xE6FFFFFF),
                                                    new Color(0xCCFFFFFF),
                                                    new Color(0x99FFFFFF),
                                                  ],
                                                )),
                                                child: new ListTile(
                                                    contentPadding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 20.0,
                                                            vertical: 10.0),
                                                    leading: Container(
                                                        padding:
                                                            EdgeInsets.only(
                                                                right: 12.0),
                                                        decoration: new BoxDecoration(
                                                            border: new Border(
                                                                right: new BorderSide(
                                                                    width: 2.0,
                                                                    color: Colors
                                                                        .deepPurpleAccent))),
                                                        child: new InkWell(
                                                          child: CircleAvatar(
                                                              backgroundColor:
                                                                  Colors
                                                                      .greenAccent,
                                                              radius: 16.0,
                                                              child: new Icon(
                                                                  Icons.search,
                                                                  color: Colors
                                                                      .white,
                                                                  size: 16.0)),
                                                          onTap: () async {
                                                            createFileOfPdfUrl(
                                                                '${dash.fiveKeluar[i].keluar.versi_akhir}');
                                                          },
                                                        )),
                                                    title: Column(
                                                      children: <Widget>[
                                                        new Row(
                                                          children: <Widget>[
                                                            new Icon(
                                                                Icons
                                                                    .markunread_mailbox,
                                                                color: Colors
                                                                    .purple,
                                                                size: 16.0),
                                                            new Container(
                                                              width: 10.0,
                                                            ),
                                                            Text(
                                                                '${dash.fiveKeluar[i].keluar.no_surat}',
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontSize:
                                                                        14.0)),
                                                          ],
                                                        ),
                                                        new Separators(),
                                                      ],
                                                    ),
                                                    subtitle: Column(
                                                        children: <Widget>[
                                                          new Row(
                                                            children: <Widget>[
                                                              Text(
                                                                  '${dash.fiveKeluar[i].created_at}',
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .green,
                                                                      fontSize:
                                                                          12.0)),
                                                            ],
                                                          ),
                                                        ]),
                                                    onTap: () {
                                                      Navigator.push(
                                                          context,
                                                          new MaterialPageRoute(
                                                              builder: (BuildContext
                                                                      context) =>
                                                                  new EditDistribusiSuratKeluar(
                                                                      '${dash.fiveKeluar[i].id}')));
                                                    })),
                                          );
                                        },
                                      ),
                                      new Container(height: 10.0),
                                      chartWidgetKeluar
                                    ])
                              ]),
                            ),
                            SingleChildScrollView(
                              child: Stack(children: <Widget>[
                                new Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      Row(children: <Widget>[
                                        Expanded(
                                          child: Card(
                                            color: Colors.greenAccent,
                                            child: new InkWell(
                                                onTap: () {},
                                                child: new Column(
                                                  children: <Widget>[
                                                    new Center(
                                                      child: new Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(4.0),
                                                        child: new Icon(
                                                            Icons.message,
                                                            color: Colors.white,
                                                            size: 20.0),
                                                      ),
                                                    ),
                                                    new Center(
                                                      child: new Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(4.0),
                                                        child: new Text(
                                                            "Memo Masuk",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white
                                                                    .withOpacity(
                                                                        0.8))),
                                                      ),
                                                    ),
                                                    new Center(
                                                      child: new Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(4.0),
                                                        child: new Text(
                                                            '${dash.jmlUnread.memo_masuk}',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white
                                                                    .withOpacity(
                                                                        0.8))),
                                                      ),
                                                    )
                                                  ],
                                                )),
                                          ),
                                        ),
                                      ]),
                                      new Container(height: 10.0),
                                      ListView.builder(
                                        scrollDirection: Axis.vertical,
                                        shrinkWrap: true,
                                        itemCount: int.parse(
                                            '${dash.fiveMemo.length}'),
                                        itemBuilder:
                                            (BuildContext context, int i) {
                                          return new Card(
                                            elevation: 8.0,
                                            margin: new EdgeInsets.symmetric(
                                                horizontal: 10.0,
                                                vertical: 6.0),
                                            child: Container(
                                                decoration: BoxDecoration(
                                                    // Box decoration takes a gradient
                                                    gradient: LinearGradient(
                                                  // Where the linear gradient begins and ends
                                                  begin: Alignment.topRight,
                                                  end: Alignment.bottomLeft,
                                                  // Add one stop for each color. Stops should increase from 0 to 1
                                                  stops: [0.1, 0.5, 0.7, 0.9],
                                                  colors: [
                                                    // Colors are easy thanks to Flutter's Colors class.
                                                    new Color(0xFFFFFFFF),
                                                    new Color(0xE6FFFFFF),
                                                    new Color(0xCCFFFFFF),
                                                    new Color(0x99FFFFFF),
                                                  ],
                                                )),
                                                child: new ListTile(
                                                    contentPadding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 20.0,
                                                            vertical: 10.0),
                                                    leading: Container(
                                                        padding:
                                                            EdgeInsets.only(
                                                                right: 12.0),
                                                        decoration: new BoxDecoration(
                                                            border: new Border(
                                                                right: new BorderSide(
                                                                    width: 2.0,
                                                                    color: Colors
                                                                        .deepPurpleAccent))),
                                                        child: new InkWell(
                                                          child: CircleAvatar(
                                                              backgroundColor:
                                                                  Colors
                                                                      .greenAccent,
                                                              radius: 16.0,
                                                              child: new Icon(
                                                                  Icons.search,
                                                                  color: Colors
                                                                      .white,
                                                                  size: 16.0)),
                                                          onTap: () {
                                                            Navigator.push(
                                                                context,
                                                                new MaterialPageRoute(
                                                                    builder: (BuildContext
                                                                            context) =>
                                                                        new DetailMemoMasuk(
                                                                            '${dash.fiveMemo[i].masuk_id}')));
                                                          },
                                                        )),
                                                    title: Column(
                                                      children: <Widget>[
                                                        new Row(
                                                          children: <Widget>[
                                                            new Icon(
                                                                Icons
                                                                    .markunread_mailbox,
                                                                color: Colors
                                                                    .purple,
                                                                size: 16.0),
                                                            new Container(
                                                              width: 10.0,
                                                            ),
                                                            Text(
                                                                '${dash.fiveMemo[i].masuk.no_surat}',
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontSize:
                                                                        14.0)),
                                                          ],
                                                        ),
                                                        new Separators(),
                                                      ],
                                                    ),
                                                    subtitle: Column(
                                                        children: <Widget>[
                                                          new Row(
                                                            children: <Widget>[
                                                              Text(
                                                                  '${dash.fiveMemo[i].created_at}',
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .green,
                                                                      fontSize:
                                                                          12.0)),
                                                            ],
                                                          ),
                                                        ]),
                                                    onTap: () {
                                                      if ('${dash.fiveMemo[i].satker_penerima}' ==
                                                          satkerLogin) {
                                                        Navigator.push(
                                                            context,
                                                            new MaterialPageRoute(
                                                                builder: (BuildContext
                                                                        context) =>
                                                                    new EditMemoMasuk(
                                                                        '${dash.fiveMasuk[i].id}')));
                                                      } else {
                                                        Navigator.push(
                                                            context,
                                                            new MaterialPageRoute(
                                                                builder: (BuildContext
                                                                        context) =>
                                                                    new DetailMemoMasuk(
                                                                        '${dash.fiveMemo[i].masuk_id}')));
                                                      }
                                                    })),
                                          );
                                        },
                                      ),
                                      new Container(height: 10.0),
                                      chartWidgetMemo
                                    ])
                              ]),
                            )
                          ],
                        ),
                      ),
                    );
                  }
                } else if (snapshot.hasError) {
                  return new Text("${snapshot.error}");
                }
                return new Center(
                  child: new Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: new SizedBox(
                        child: CircularProgressIndicator(),
                        height: 20.0,
                        width: 20.0,
                      )),
                );
                // By default, show a loading spinner
              },
            ),
          ),
          // floatingActionButton: new FloatingActionButton(
          //   onPressed: () {
          //     scan();
          //   },
          //   tooltip: 'Reader the QRCode',
          //   child: new Icon(Icons.settings_overscan),
          // ),
          drawer: new Drawer(
              child: Container(
            color: Colors.white,
            child: new FutureBuilder<DashboardChartModel>(
              future: _futures,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  Widget expansionTileSuratMasukDrawer;
                  Widget expansionTileSuratKeluarDrawer;
                  Widget expansionTileMemoDinasDrawer;

                  if (dash.menu[0].label != null) {
                    if ('${dash.menu[0].child.menu.menu1}' == "404" &&
                        '${dash.menu[0].child.menu.menu2}' == "200" &&
                        '${dash.menu[0].child.menu.menu3}' == "200") {
                      expansionTileSuratMasukDrawer = new ExpansionTile(
                          trailing: Icon(Icons.expand_more, color: Colors.red),
                          leading: new Icon(Icons.message,
                              color: Colors.red, size: 18.0),
                          title: new Text('Surat Masuk',
                              style: TextStyle(
                                  fontFamily: 'Source Code Pro',
                                  fontSize: 14.0,
                                  color: new Color(0xFF353c4e))),
                          children: [
                            new Column(
                              children: <Widget>[
                                new ListTile(
                                  leading: Container(
                                      padding: EdgeInsets.only(left: 24.0),
                                      child: Icon(Icons.chevron_right,
                                          color: Colors.red)),
                                  trailing: new InkWell(
                                    child: CircleAvatar(
                                        backgroundColor: Colors.red,
                                        radius: 12.0,
                                        child: new Text(
                                            '${dash.jmlUnread.dismasuk}',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 10.0))),
                                  ),
                                  title: new Text("Disposisi Surat",
                                      style: TextStyle(
                                          color: new Color(0xFF353c4e))),
                                  onTap: () {
                                    Navigator.of(context)
                                        .push(new DisposisiSuratMasukRoute());
                                  },
                                ),
                                new ListTile(
                                  leading: Container(
                                      padding: EdgeInsets.only(left: 24.0),
                                      child: Icon(Icons.chevron_right,
                                          color: Colors.red)),
                                  title: new Text("Tracking/History",
                                      style: TextStyle(
                                          color: new Color(0xFF353c4e))),
                                  onTap: () {
                                    Navigator.of(context).push(
                                        new TrackingHistoriSuratMasukRoute());
                                  },
                                )
                              ],
                            ),
                          ]);
                    } else if ('${dash.menu[0].child.menu.menu1}' == "200" &&
                        '${dash.menu[0].child.menu.menu2}' == "404" &&
                        '${dash.menu[0].child.menu.menu3}' == "200") {
                      expansionTileSuratMasukDrawer = new ExpansionTile(
                          trailing: Icon(Icons.expand_more, color: Colors.red),
                          leading: new Icon(Icons.message,
                              color: Colors.red, size: 18.0),
                          title: new Text('Surat Masuk',
                              style: TextStyle(
                                  fontFamily: 'Source Code Pro',
                                  fontSize: 14.0,
                                  color: new Color(0xFF353c4e))),
                          children: [
                            new Column(
                              children: <Widget>[
                                new ListTile(
                                  leading: Container(
                                      padding: EdgeInsets.only(left: 24.0),
                                      child: Icon(Icons.chevron_right,
                                          color: Colors.red)),
                                  title: new Text("Surat Masuk",
                                      style: TextStyle(
                                          color: new Color(0xFF353c4e))),
                                  onTap: () {
                                    Navigator.of(context)
                                        .push(new SuratMasukRoute());
                                  },
                                ),
                                new ListTile(
                                  leading: Container(
                                      padding: EdgeInsets.only(left: 24.0),
                                      child: Icon(Icons.chevron_right,
                                          color: Colors.red)),
                                  title: new Text("Tracking/History",
                                      style: TextStyle(
                                          color: new Color(0xFF353c4e))),
                                  onTap: () {
                                    Navigator.of(context).push(
                                        new TrackingHistoriSuratMasukRoute());
                                  },
                                )
                              ],
                            ),
                          ]);
                    } else if ('${dash.menu[0].child.menu.menu1}' == "200" &&
                        '${dash.menu[0].child.menu.menu2}' == "200" &&
                        '${dash.menu[0].child.menu.menu3}' == "404") {
                      expansionTileSuratMasukDrawer = new ExpansionTile(
                          trailing: Icon(Icons.expand_more, color: Colors.red),
                          leading: new Icon(Icons.message,
                              color: Colors.red, size: 18.0),
                          title: new Text('Surat Masuk',
                              style: TextStyle(
                                  fontFamily: 'Source Code Pro',
                                  fontSize: 14.0,
                                  color: new Color(0xFF353c4e))),
                          children: [
                            new Column(
                              children: <Widget>[
                                new ListTile(
                                  leading: Container(
                                      padding: EdgeInsets.only(left: 24.0),
                                      child: Icon(Icons.chevron_right,
                                          color: Colors.red)),
                                  title: new Text("Surat Masuk",
                                      style: TextStyle(
                                          color: new Color(0xFF353c4e))),
                                  onTap: () {
                                    Navigator.of(context)
                                        .push(new SuratMasukRoute());
                                  },
                                ),
                                new ListTile(
                                  leading: Container(
                                      padding: EdgeInsets.only(left: 24.0),
                                      child: Icon(Icons.chevron_right,
                                          color: Colors.red)),
                                  trailing: new InkWell(
                                    child: CircleAvatar(
                                        backgroundColor: Colors.red,
                                        radius: 12.0,
                                        child: new Text(
                                            '${dash.jmlUnread.dismasuk}',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 10.0))),
                                  ),
                                  title: new Text("Disposisi Surat",
                                      style: TextStyle(
                                          color: new Color(0xFF353c4e))),
                                  onTap: () {
                                    Navigator.of(context)
                                        .push(new DisposisiSuratMasukRoute());
                                  },
                                )
                              ],
                            ),
                          ]);
                    } else if ('${dash.menu[0].child.menu.menu1}' == "200" &&
                        '${dash.menu[0].child.menu.menu2}' == "404" &&
                        '${dash.menu[0].child.menu.menu3}' == "404") {
                      expansionTileSuratMasukDrawer = new ExpansionTile(
                          trailing: Icon(Icons.expand_more, color: Colors.red),
                          leading: new Icon(Icons.message,
                              color: Colors.red, size: 18.0),
                          title: new Text('Surat Masuk',
                              style: TextStyle(
                                  fontFamily: 'Source Code Pro',
                                  fontSize: 14.0,
                                  color: new Color(0xFF353c4e))),
                          children: [
                            new Column(
                              children: <Widget>[
                                new ListTile(
                                  leading: Container(
                                      padding: EdgeInsets.only(left: 24.0),
                                      child: Icon(Icons.chevron_right,
                                          color: Colors.red)),
                                  title: new Text("Surat Masuk",
                                      style: TextStyle(
                                          color: new Color(0xFF353c4e))),
                                  onTap: () {
                                    Navigator.of(context)
                                        .push(new SuratMasukRoute());
                                  },
                                )
                              ],
                            ),
                          ]);
                    } else if ('${dash.menu[0].child.menu.menu1}' == "404" &&
                        '${dash.menu[0].child.menu.menu2}' == "200" &&
                        '${dash.menu[0].child.menu.menu3}' == "404") {
                      expansionTileSuratMasukDrawer = new ExpansionTile(
                          trailing: Icon(Icons.expand_more, color: Colors.red),
                          leading: new Icon(Icons.message,
                              color: Colors.red, size: 18.0),
                          title: new Text('Surat Masuk',
                              style: TextStyle(
                                  fontFamily: 'Source Code Pro',
                                  fontSize: 14.0,
                                  color: new Color(0xFF353c4e))),
                          children: [
                            new Column(
                              children: <Widget>[
                                new ListTile(
                                  leading: Container(
                                      padding: EdgeInsets.only(left: 24.0),
                                      child: Icon(Icons.chevron_right,
                                          color: Colors.red)),
                                  trailing: new InkWell(
                                    child: CircleAvatar(
                                        backgroundColor: Colors.red,
                                        radius: 12.0,
                                        child: new Text(
                                            '${dash.jmlUnread.dismasuk}',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 10.0))),
                                  ),
                                  title: new Text("Disposisi Surat",
                                      style: TextStyle(
                                          color: new Color(0xFF353c4e))),
                                  onTap: () {
                                    Navigator.of(context)
                                        .push(new DisposisiSuratMasukRoute());
                                  },
                                )
                              ],
                            ),
                          ]);
                    } else if ('${dash.menu[0].child.menu.menu1}' == "404" &&
                        '${dash.menu[0].child.menu.menu2}' == "404" &&
                        '${dash.menu[0].child.menu.menu3}' == "200") {
                      expansionTileSuratMasukDrawer = new ExpansionTile(
                          trailing: Icon(Icons.expand_more, color: Colors.red),
                          leading: new Icon(Icons.message,
                              color: Colors.red, size: 18.0),
                          title: new Text('Surat Masuk',
                              style: TextStyle(
                                  fontFamily: 'Source Code Pro',
                                  fontSize: 14.0,
                                  color: new Color(0xFF353c4e))),
                          children: [
                            new Column(
                              children: <Widget>[
                                new ListTile(
                                  leading: Container(
                                      padding: EdgeInsets.only(left: 24.0),
                                      child: Icon(Icons.chevron_right,
                                          color: Colors.red)),
                                  title: new Text("Tracking/History",
                                      style: TextStyle(
                                          color: new Color(0xFF353c4e))),
                                  onTap: () {
                                    Navigator.of(context).push(
                                        new TrackingHistoriSuratMasukRoute());
                                  },
                                )
                              ],
                            ),
                          ]);
                    } else if ('${dash.menu[0].child.menu.menu1}' == "200" &&
                        '${dash.menu[0].child.menu.menu2}' == "200" &&
                        '${dash.menu[0].child.menu.menu3}' == "200") {
                      expansionTileSuratMasukDrawer = new ExpansionTile(
                          trailing: Icon(Icons.expand_more, color: Colors.red),
                          leading: new Icon(Icons.message,
                              color: Colors.red, size: 18.0),
                          title: new Text('Surat Masuk',
                              style: TextStyle(
                                  fontFamily: 'Source Code Pro',
                                  fontSize: 14.0,
                                  color: new Color(0xFF353c4e))),
                          children: [
                            new Column(
                              children: <Widget>[
                                new ListTile(
                                  leading: Container(
                                      padding: EdgeInsets.only(left: 24.0),
                                      child: Icon(Icons.chevron_right,
                                          color: Colors.red)),
                                  title: new Text("Surat Masuk",
                                      style: TextStyle(
                                          color: new Color(0xFF353c4e))),
                                  onTap: () {
                                    Navigator.of(context)
                                        .push(new SuratMasukRoute());
                                  },
                                ),
                                new ListTile(
                                  leading: Container(
                                      padding: EdgeInsets.only(left: 24.0),
                                      child: Icon(Icons.chevron_right,
                                          color: Colors.red)),
                                  trailing: new InkWell(
                                    child: CircleAvatar(
                                        backgroundColor: Colors.red,
                                        radius: 12.0,
                                        child: new Text(
                                            '${dash.jmlUnread.dismasuk}',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 10.0))),
                                  ),
                                  title: new Text("Disposisi Surat",
                                      style: TextStyle(
                                          color: new Color(0xFF353c4e))),
                                  onTap: () {
                                    Navigator.of(context)
                                        .push(new DisposisiSuratMasukRoute());
                                  },
                                ),
                                new ListTile(
                                  leading: Container(
                                      padding: EdgeInsets.only(left: 24.0),
                                      child: Icon(Icons.chevron_right,
                                          color: Colors.red)),
                                  title: new Text("Tracking/History",
                                      style: TextStyle(
                                          color: new Color(0xFF353c4e))),
                                  onTap: () {
                                    Navigator.of(context).push(
                                        new TrackingHistoriSuratMasukRoute());
                                  },
                                )
                              ],
                            ),
                          ]);
                    } else if ('${dash.menu[0].child.menu.menu1}' == "404" &&
                        '${dash.menu[0].child.menu.menu2}' == "404" &&
                        '${dash.menu[0].child.menu.menu3}' == "404") {
                      expansionTileSuratMasukDrawer = new ExpansionTile(
                          trailing: Icon(Icons.expand_more, color: Colors.red),
                          leading: new Icon(Icons.message,
                              color: Colors.red, size: 18.0),
                          title: new Text('Surat Masuk',
                              style: TextStyle(
                                  fontFamily: 'Source Code Pro',
                                  fontSize: 14.0,
                                  color: new Color(0xFF353c4e))),
                          children: [
                            new Column(
                              children: <Widget>[],
                            ),
                          ]);
                    }
                  } else {
                    expansionTileSuratMasukDrawer = new Container(
                      height: 0,
                    );
                  }

                  if (dash.menu[1].label != null) {
                    if ('${dash.menu[1].child.menu.menu1}' == "404" &&
                        '${dash.menu[1].child.menu.menu2}' == "200" &&
                        '${dash.menu[1].child.menu.menu3}' == "200") {
                      expansionTileSuratKeluarDrawer = new ExpansionTile(
                          trailing: Icon(Icons.expand_more, color: Colors.red),
                          leading: new Icon(Icons.send,
                              color: Colors.red, size: 18.0),
                          title: new Text('Surat Keluar',
                              style: TextStyle(
                                  fontFamily: 'Source Code Pro',
                                  fontSize: 14.0,
                                  color: new Color(0xFF353c4e))),
                          children: [
                            new Column(
                              children: <Widget>[
                                new ListTile(
                                  leading: Container(
                                      padding: EdgeInsets.only(left: 24.0),
                                      child: Icon(Icons.chevron_right,
                                          color: Colors.red)),
                                  trailing: new InkWell(
                                    child: CircleAvatar(
                                        backgroundColor: Colors.red,
                                        radius: 12.0,
                                        child: new Text(
                                            '${dash.jmlUnread.diskeluar}',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 10))),
                                  ),
                                  title: new Text("Distribusi Surat",
                                      style: TextStyle(
                                          color: new Color(0xFF353c4e))),
                                  onTap: () {
                                    Navigator.of(context)
                                        .push(new DistribusiSuratRoute());
                                  },
                                ),
                                new ListTile(
                                  leading: Container(
                                      padding: EdgeInsets.only(left: 24.0),
                                      child: Icon(Icons.chevron_right,
                                          color: Colors.red)),
                                  title: new Text("Tracking/History",
                                      style: TextStyle(
                                          color: new Color(0xFF353c4e))),
                                  onTap: () {
                                    Navigator.of(context).push(
                                        new TrackingHistoriSuratKeluarRoute());
                                  },
                                )
                              ],
                            ),
                          ]);
                    } else if ('${dash.menu[1].child.menu.menu1}' == "200" &&
                        '${dash.menu[1].child.menu.menu2}' == "404" &&
                        '${dash.menu[1].child.menu.menu3}' == "200") {
                      expansionTileSuratKeluarDrawer = new ExpansionTile(
                          trailing: Icon(Icons.expand_more, color: Colors.red),
                          leading: new Icon(Icons.send,
                              color: Colors.red, size: 18.0),
                          title: new Text('Surat Keluar',
                              style: TextStyle(
                                  fontFamily: 'Source Code Pro',
                                  fontSize: 14.0,
                                  color: new Color(0xFF353c4e))),
                          children: [
                            new Column(
                              children: <Widget>[
                                new ListTile(
                                  leading: Container(
                                      padding: EdgeInsets.only(left: 24.0),
                                      child: Icon(Icons.chevron_right,
                                          color: Colors.red)),
                                  title: new Text("Surat Keluar",
                                      style: TextStyle(
                                          color: new Color(0xFF353c4e))),
                                  onTap: () {
                                    Navigator.of(context)
                                        .push(new SuratKeluarRoute());
                                  },
                                ),
                                new ListTile(
                                  leading: Container(
                                      padding: EdgeInsets.only(left: 24.0),
                                      child: Icon(Icons.chevron_right,
                                          color: Colors.red)),
                                  title: new Text("Tracking/History",
                                      style: TextStyle(
                                          color: new Color(0xFF353c4e))),
                                  onTap: () {
                                    Navigator.of(context).push(
                                        new TrackingHistoriSuratKeluarRoute());
                                  },
                                )
                              ],
                            ),
                          ]);
                    } else if ('${dash.menu[1].child.menu.menu1}' == "200" &&
                        '${dash.menu[1].child.menu.menu2}' == "200" &&
                        '${dash.menu[1].child.menu.menu3}' == "404") {
                      expansionTileSuratKeluarDrawer = new ExpansionTile(
                          trailing: Icon(Icons.expand_more, color: Colors.red),
                          leading: new Icon(Icons.send,
                              color: Colors.red, size: 18.0),
                          title: new Text('Surat Keluar',
                              style: TextStyle(
                                  fontFamily: 'Source Code Pro',
                                  fontSize: 14.0,
                                  color: new Color(0xFF353c4e))),
                          children: [
                            new Column(
                              children: <Widget>[
                                new ListTile(
                                  leading: Container(
                                      padding: EdgeInsets.only(left: 24.0),
                                      child: Icon(Icons.chevron_right,
                                          color: Colors.red)),
                                  title: new Text("Surat Keluar",
                                      style: TextStyle(
                                          color: new Color(0xFF353c4e))),
                                  onTap: () {
                                    Navigator.of(context)
                                        .push(new SuratKeluarRoute());
                                  },
                                ),
                                new ListTile(
                                  leading: Container(
                                      padding: EdgeInsets.only(left: 24.0),
                                      child: Icon(Icons.chevron_right,
                                          color: Colors.red)),
                                  trailing: new InkWell(
                                    child: CircleAvatar(
                                        backgroundColor: Colors.red,
                                        radius: 12.0,
                                        child: new Text(
                                            '${dash.jmlUnread.diskeluar}',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 10))),
                                  ),
                                  title: new Text("Distribusi Surat",
                                      style: TextStyle(
                                          color: new Color(0xFF353c4e))),
                                  onTap: () {
                                    Navigator.of(context)
                                        .push(new DistribusiSuratRoute());
                                  },
                                )
                              ],
                            ),
                          ]);
                    } else if ('${dash.menu[1].child.menu.menu1}' == "200" &&
                        '${dash.menu[1].child.menu.menu2}' == "404" &&
                        '${dash.menu[1].child.menu.menu3}' == "404") {
                      expansionTileSuratKeluarDrawer = new ExpansionTile(
                          trailing: Icon(Icons.expand_more, color: Colors.red),
                          leading: new Icon(Icons.send,
                              color: Colors.red, size: 18.0),
                          title: new Text('Surat Keluar',
                              style: TextStyle(
                                  fontFamily: 'Source Code Pro',
                                  fontSize: 14.0,
                                  color: new Color(0xFF353c4e))),
                          children: [
                            new Column(
                              children: <Widget>[
                                new ListTile(
                                  leading: Container(
                                      padding: EdgeInsets.only(left: 24.0),
                                      child: Icon(Icons.chevron_right,
                                          color: Colors.red)),
                                  title: new Text("Surat Keluar",
                                      style: TextStyle(
                                          color: new Color(0xFF353c4e))),
                                  onTap: () {
                                    Navigator.of(context)
                                        .push(new SuratKeluarRoute());
                                  },
                                )
                              ],
                            ),
                          ]);
                    } else if ('${dash.menu[1].child.menu.menu1}' == "404" &&
                        '${dash.menu[1].child.menu.menu2}' == "200" &&
                        '${dash.menu[1].child.menu.menu3}' == "404") {
                      expansionTileSuratKeluarDrawer = new ExpansionTile(
                          trailing: Icon(Icons.expand_more, color: Colors.red),
                          leading: new Icon(Icons.send,
                              color: Colors.red, size: 18.0),
                          title: new Text('Surat Keluar',
                              style: TextStyle(
                                  fontFamily: 'Source Code Pro',
                                  fontSize: 14.0,
                                  color: new Color(0xFF353c4e))),
                          children: [
                            new Column(
                              children: <Widget>[
                                new ListTile(
                                  leading: Container(
                                      padding: EdgeInsets.only(left: 24.0),
                                      child: Icon(Icons.chevron_right,
                                          color: Colors.red)),
                                  trailing: new InkWell(
                                    child: CircleAvatar(
                                        backgroundColor: Colors.red,
                                        radius: 12.0,
                                        child: new Text(
                                            '${dash.jmlUnread.diskeluar}',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 10))),
                                  ),
                                  title: new Text("Distribusi Surat",
                                      style: TextStyle(
                                          color: new Color(0xFF353c4e))),
                                  onTap: () {
                                    Navigator.of(context)
                                        .push(new DistribusiSuratRoute());
                                  },
                                )
                              ],
                            ),
                          ]);
                    } else if ('${dash.menu[1].child.menu.menu1}' == "404" &&
                        '${dash.menu[1].child.menu.menu2}' == "404" &&
                        '${dash.menu[1].child.menu.menu3}' == "200") {
                      expansionTileSuratKeluarDrawer = new ExpansionTile(
                          trailing: Icon(Icons.expand_more, color: Colors.red),
                          leading: new Icon(Icons.send,
                              color: Colors.red, size: 18.0),
                          title: new Text('Surat Keluar',
                              style: TextStyle(
                                  fontFamily: 'Source Code Pro',
                                  fontSize: 14.0,
                                  color: new Color(0xFF353c4e))),
                          children: [
                            new Column(
                              children: <Widget>[
                                new ListTile(
                                  leading: Container(
                                      padding: EdgeInsets.only(left: 24.0),
                                      child: Icon(Icons.chevron_right,
                                          color: Colors.red)),
                                  title: new Text("Tracking/History",
                                      style: TextStyle(
                                          color: new Color(0xFF353c4e))),
                                  onTap: () {
                                    Navigator.of(context).push(
                                        new TrackingHistoriSuratKeluarRoute());
                                  },
                                )
                              ],
                            ),
                          ]);
                    } else if ('${dash.menu[1].child.menu.menu1}' == "200" &&
                        '${dash.menu[1].child.menu.menu2}' == "200" &&
                        '${dash.menu[1].child.menu.menu3}' == "200") {
                      expansionTileSuratKeluarDrawer = new ExpansionTile(
                          trailing: Icon(Icons.expand_more, color: Colors.red),
                          leading: new Icon(Icons.send,
                              color: Colors.red, size: 18.0),
                          title: new Text('Surat Keluar',
                              style: TextStyle(
                                  fontFamily: 'Source Code Pro',
                                  fontSize: 14.0,
                                  color: new Color(0xFF353c4e))),
                          children: [
                            new Column(
                              children: <Widget>[
                                new ListTile(
                                  leading: Container(
                                      padding: EdgeInsets.only(left: 24.0),
                                      child: Icon(Icons.chevron_right,
                                          color: Colors.red)),
                                  title: new Text("Surat Keluar",
                                      style: TextStyle(
                                          color: new Color(0xFF353c4e))),
                                  onTap: () {
                                    Navigator.of(context)
                                        .push(new SuratKeluarRoute());
                                  },
                                ),
                                new ListTile(
                                  leading: Container(
                                      padding: EdgeInsets.only(left: 24.0),
                                      child: Icon(Icons.chevron_right,
                                          color: Colors.red)),
                                  trailing: new InkWell(
                                    child: CircleAvatar(
                                        backgroundColor: Colors.red,
                                        radius: 12.0,
                                        child: new Text(
                                            '${dash.jmlUnread.diskeluar}',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 10))),
                                  ),
                                  title: new Text("Distribusi Surat",
                                      style: TextStyle(
                                          color: new Color(0xFF353c4e))),
                                  onTap: () {
                                    Navigator.of(context)
                                        .push(new DistribusiSuratRoute());
                                  },
                                ),
                                new ListTile(
                                  leading: Container(
                                      padding: EdgeInsets.only(left: 24.0),
                                      child: Icon(Icons.chevron_right,
                                          color: Colors.red)),
                                  title: new Text("Tracking/History",
                                      style: TextStyle(
                                          color: new Color(0xFF353c4e))),
                                  onTap: () {
                                    Navigator.of(context).push(
                                        new TrackingHistoriSuratKeluarRoute());
                                  },
                                )
                              ],
                            ),
                          ]);
                    } else if ('${dash.menu[1].child.menu.menu1}' == "404" &&
                        '${dash.menu[1].child.menu.menu2}' == "404" &&
                        '${dash.menu[1].child.menu.menu3}' == "404") {
                      expansionTileSuratKeluarDrawer = new ExpansionTile(
                          trailing: Icon(Icons.expand_more, color: Colors.red),
                          leading: new Icon(Icons.send,
                              color: Colors.red, size: 18.0),
                          title: new Text('Surat Keluar',
                              style: TextStyle(
                                  fontFamily: 'Source Code Pro',
                                  fontSize: 14.0,
                                  color: new Color(0xFF353c4e))),
                          children: [
                            new Column(
                              children: <Widget>[],
                            ),
                          ]);
                    }
                  } else {
                    expansionTileSuratKeluarDrawer = new Container(
                      height: 0,
                    );
                  }

                  if (dash.menu[2].label != null) {
                    if ('${dash.menu[2].child.menu.menu1}' == "404" &&
                        '${dash.menu[2].child.menu.menu2}' == "200") {
                      expansionTileMemoDinasDrawer = new ExpansionTile(
                          trailing: Icon(Icons.expand_more, color: Colors.red),
                          leading: new Icon(Icons.mail,
                              color: Colors.red, size: 18.0),
                          title: new Text('Memo Dinas',
                              style: TextStyle(
                                  fontFamily: 'Source Code Pro',
                                  fontSize: 14.0,
                                  color: new Color(0xFF353c4e))),
                          children: [
                            new Column(
                              children: <Widget>[
                                new ListTile(
                                  leading: Container(
                                      padding: EdgeInsets.only(left: 24.0),
                                      child: Icon(Icons.chevron_right,
                                          color: Colors.red)),
                                  trailing: new InkWell(
                                    child: CircleAvatar(
                                        backgroundColor: Colors.red,
                                        radius: 12.0,
                                        child: new Text(
                                            '${dash.jmlUnread.memo_masuk}',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 10.0))),
                                  ),
                                  title: new Text("Memo Masuk",
                                      style: TextStyle(
                                          color: new Color(0xFF353c4e))),
                                  onTap: () {
                                    Navigator.of(context)
                                        .push(new MemoMasukRoute());
                                  },
                                ),
                              ],
                            ),
                          ]);
                    } else if ('${dash.menu[2].child.menu.menu1}' == "200" &&
                        '${dash.menu[2].child.menu.menu2}' == "404") {
                      expansionTileMemoDinasDrawer = new ExpansionTile(
                          trailing: Icon(Icons.expand_more, color: Colors.red),
                          leading: new Icon(Icons.mail,
                              color: Colors.red, size: 18.0),
                          title: new Text('Memo Dinas',
                              style: TextStyle(
                                  fontFamily: 'Source Code Pro',
                                  fontSize: 14.0,
                                  color: new Color(0xFF353c4e))),
                          children: [
                            new Column(
                              children: <Widget>[
                                new ListTile(
                                  leading: Container(
                                      padding: EdgeInsets.only(left: 24.0),
                                      child: Icon(Icons.chevron_right,
                                          color: Colors.red)),
                                  title: new Text("Memo Keluar",
                                      style: TextStyle(
                                          color: new Color(0xFF353c4e))),
                                  onTap: () {
                                    Navigator.of(context)
                                        .push(new MemoKeluarRoute());
                                  },
                                )
                              ],
                            ),
                          ]);
                    } else if ('${dash.menu[2].child.menu.menu1}' == "200" &&
                        '${dash.menu[2].child.menu.menu2}' == "200") {
                      expansionTileMemoDinasDrawer = new ExpansionTile(
                          trailing: Icon(Icons.expand_more, color: Colors.red),
                          leading: new Icon(Icons.mail,
                              color: Colors.red, size: 18.0),
                          title: new Text('Memo Dinas',
                              style: TextStyle(
                                  fontFamily: 'Source Code Pro',
                                  fontSize: 14.0,
                                  color: new Color(0xFF353c4e))),
                          children: [
                            new Column(
                              children: <Widget>[
                                new ListTile(
                                  leading: Container(
                                      padding: EdgeInsets.only(left: 24.0),
                                      child: Icon(Icons.chevron_right,
                                          color: Colors.red)),
                                  title: new Text("Memo Keluar",
                                      style: TextStyle(
                                          color: new Color(0xFF353c4e))),
                                  onTap: () {
                                    Navigator.of(context)
                                        .push(new MemoKeluarRoute());
                                  },
                                ),
                                new ListTile(
                                  leading: Container(
                                      padding: EdgeInsets.only(left: 24.0),
                                      child: Icon(Icons.chevron_right,
                                          color: Colors.red)),
                                  trailing: new InkWell(
                                    child: CircleAvatar(
                                        backgroundColor: Colors.red,
                                        radius: 12.0,
                                        child: new Text(
                                            '${dash.jmlUnread.memo_masuk}',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 10.0))),
                                  ),
                                  title: new Text("Memo Masuk",
                                      style: TextStyle(
                                          color: new Color(0xFF353c4e))),
                                  onTap: () {
                                    Navigator.of(context)
                                        .push(new MemoMasukRoute());
                                  },
                                ),
                              ],
                            ),
                          ]);
                    } else if ('${dash.menu[2].child.menu.menu1}' == "404" &&
                        '${dash.menu[2].child.menu.menu2}' == "404") {
                      expansionTileMemoDinasDrawer = new ExpansionTile(
                          trailing: Icon(Icons.expand_more, color: Colors.red),
                          leading: new Icon(Icons.mail,
                              color: Colors.red, size: 18.0),
                          title: new Text('Memo Dinas',
                              style: TextStyle(
                                  fontFamily: 'Source Code Pro',
                                  fontSize: 14.0,
                                  color: new Color(0xFF353c4e))),
                          children: [
                            new Column(
                              children: <Widget>[],
                            ),
                          ]);
                    }
                  } else {
                    expansionTileMemoDinasDrawer = new Container(
                      height: 0,
                    );
                  }

                  Widget avatar;

                  if (gravatar == null || gravatar == '') {
                    avatar = new CircleAvatar(
                        backgroundImage: AssetImage('assets/none.jpg'));
                  } else {
                    avatar = new CircleAvatar(
                        backgroundImage:
                            new NetworkImage(URL_GET_AVATAR + gravatar));
                  }

                  return new ListView(
                    padding: const EdgeInsets.all(0.0),
                    children: <Widget>[
                      new UserAccountsDrawerHeader(
                          accountName: Text(data.toString(),
                              style: new TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w500,
                                  color: new Color(0xFF353c4e))),
                          accountEmail: Text(data2.toString(),
                              style: new TextStyle(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.w500,
                                  color: new Color(0xFF353c4e))),
                          currentAccountPicture: avatar,
                          decoration: BoxDecoration(color: Colors.white)),
                      new Container(
                          margin: new EdgeInsets.symmetric(vertical: 8.0),
                          height: 2.0,
                          width: double.infinity,
                          color: Colors.red),
                      expansionTileSuratMasukDrawer,
                      expansionTileSuratKeluarDrawer,
                      expansionTileMemoDinasDrawer,
                      new ListTile(
                        leading: Container(
                            child: Icon(Icons.close,
                                color: Colors.red, size: 18.0)),
                        title: new Text("Logout",
                            style: TextStyle(
                                fontFamily: 'Source Code Pro',
                                fontSize: 14.0,
                                color: new Color(0xFF353c4e))),
                        onTap: () {
                          onDrawerFooterTap();
                        },
                      )
                    ],
                  );
                } else if (snapshot.hasError) {
                  return new Text("${snapshot.error}");
                }
                return new Center(
                  child: new Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: new SizedBox(
                        child: CircularProgressIndicator(),
                        height: 20.0,
                        width: 20.0,
                      )),
                );
                // By default, show a loading spinner
              },
            ),
          ))),
    );
  }

  void onDrawerFooterTap() async {
    sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString("loginToken", null);
    sharedPreferences.setString("userLogin", null);
    sharedPreferences.setString("userPassword", null);
    sharedPreferences.setString("nameUser", null);
    sharedPreferences.setString("userNameUser", null);
    sharedPreferences.setString("emailUser", null);
    sharedPreferences.setInt("idUser", null);
    sharedPreferences.setString("satker", null);
    sharedPreferences.setString("gravatar", null);
    sharedPreferences.setString("tokenFirebase", null);
    sharedPreferences.commit();

    Navigator.of(context).pushReplacementNamed(LOGIN_SCREEN);
  }

  requestPermission() async {
    PermissionStatus result =
        await SimplePermissions.requestPermission(_permission);
    return result;
  }

  checkPermission() async {
    bool result = await SimplePermissions.checkPermission(_permission);
    return result;
  }

  getPermissionStatus() async {
    final result = await SimplePermissions.getPermissionStatus(_permission);
  }

  Future scan() async {
    // if (!(await checkPermission())) await requestPermission();

    // try {
    //   ScanResult barcodeResult = await BarcodeScanner.scan();
    //   String barcode2 = barcodeResult.rawContent;

    //   setState(() => this.barcode = barcode2);

    //   createFileOfPdfUrl(barcode2 + "?token=" + loginToken);
    // } on PlatformException catch (e) {
    //   if (e.code == BarcodeScanner.cameraAccessDenied) {
    //     setState(() {
    //       this.barcode = 'Tidak dapat mengakses kamera';
    //     });
    //   } else {
    //     setState(() => this.barcode = 'Unknown error: $e');
    //   }
    // } on FormatException {
    //   setState(() => this.barcode = '(Tidak dapat membaca kode)');
    // } catch (e) {
    //   setState(() => this.barcode = 'Unknown error: $e');
    // }
  }
}

class ClicksPerYear {
  final String year;
  final int clicks;
  final charts.Color color;

  ClicksPerYear(this.year, this.clicks, Color color)
      : this.color = new charts.Color(
            r: color.red, g: color.green, b: color.blue, a: color.alpha);
}

class Users {
  String name;
  String id;
  Users({this.name, this.id});
}

class DropDownMenu {
  const DropDownMenu(this.name);

  final String name;
}
