import 'package:flutter/material.dart';
import 'package:eoffice/activity/main/ShowPDF.dart';
import 'package:eoffice/library/src/indicator/custom_indicator.dart';
import 'package:eoffice/library/src/indicator/waterdrop_header.dart';
import 'package:eoffice/library/src/smart_refresher.dart';
import 'package:eoffice/util/beauty_textfield.dart';
import 'package:eoffice/util/constants.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:eoffice/model/suratkeluar/TrackingSuratKeluarModel.dart';
import 'package:eoffice/util/separator.dart';
import 'package:eoffice/activity/suratkeluar/trackingkeluar/DetailTrackingSuratKeluarHistory.dart';
import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:path_provider/path_provider.dart';
import 'package:simple_permissions/simple_permissions.dart';

const directoryName = 'Download';

class TrackingHistoriSuratKeluarRoute extends CupertinoPageRoute {
  TrackingHistoriSuratKeluarRoute()
      : super(
            builder: (BuildContext context) =>
                new TrackingHistoriSuratKeluar());

  // OPTIONAL IF YOU WISH TO HAVE SOME EXTRA ANIMATION WHILE ROUTING
  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return new FadeTransition(
        opacity: animation, child: new TrackingHistoriSuratKeluar());
  }
}

class TrackingHistoriSuratKeluar extends StatefulWidget {
  static const String routeName = "/TrackingHistoriSuratKeluar";

  @override
  TrackingHistoriSuratKeluarState createState() =>
      TrackingHistoriSuratKeluarState();
}

class TrackingHistoriSuratKeluarState extends State<TrackingHistoriSuratKeluar>
    with WidgetsBindingObserver {
  SharedPreferences sharedPreferences;
  String url;
  String loginToken;

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  String pathPDF = "";

  Future _future;

  TextEditingController editingController = TextEditingController();

  static List<TrackingSuratKeluar> items = new List();
  static List<TrackingSuratKeluar> itemss = new List();

  static int refreshList = 0;
  static String query = "";

  static RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  static bool rfrsh = true;

  String _platformVersion = 'Unknown';
  Permission _permission = Permission.WriteExternalStorage;
  String filePath;

  @override
  void initState() {
    super.initState();
    _future = makeRequest();
    WidgetsBinding.instance.addObserver(this);
  }

  Future<TrackingSuratKeluarModel> makeRequest() async {
    sharedPreferences = await SharedPreferences.getInstance();
    loginToken = sharedPreferences.getString("loginToken");

    final response = await http.get(URL_DOMAIN +
        '/api/keluar/tracking?page=' +
        refreshList.toString() +
        '&q=' +
        query +
        '&token=' +
        loginToken);

    if (response.statusCode == 200) {
      itemss.clear();
      itemss.addAll(TrackingSuratKeluarModel.fromJson(jsonDecode(response.body))
          .trackingSuratKeluar);
      items.clear();
      items.addAll(itemss);
      if (!rfrsh) {
        _refreshController.loadComplete();
      } else {
        _refreshController.refreshCompleted();
      }
      return TrackingSuratKeluarModel.fromJson(jsonDecode(response.body));
    } else {
      if (!rfrsh) {
        _refreshController.loadComplete();
      } else {
        _refreshController.refreshCompleted();
      }
      throw Exception('Failed to load post.');
    }
  }

  @override
  void dispose() {
    itemss.clear();
    items.clear();
    refreshList = 0;
    query = "";
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  didPopRoute() {}

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

  Future<File> downloadFileOfPdfUrl(String url) async {
    ProgressDialog pr = new ProgressDialog(context, ProgressDialogType.Normal);
    pr.setMessage('Downloading..');
    pr.show();

    var now = new DateTime.now();
    var formatter = new DateFormat('yyyy-MM-dd HH:mm:ss');
    String formatted = formatter.format(now);

    var request = await HttpClient().getUrl(Uri.parse(url));
    var response = await request.close();
    var bytes = await consolidateHttpClientResponseBytes(response);
    if (!(await checkPermission())) await requestPermission();
    // Use plugin [path_provider] to export image to storage
    Directory directory = await getExternalStorageDirectory();
    String path = directory.path;
    await Directory('$path/$directoryName').create(recursive: true);

    File file = new File('$path/$directoryName/$formatted.pdf');
    await file.writeAsBytes(bytes);
    String f = file.path;
    pr.hide();
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text('File tersimpan pada folder download'),
      duration: Duration(seconds: 3),
    ));
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

  @override
  Widget build(BuildContext context) {
    var formatter = new DateFormat('dd-MM-yyyy');
    final makeBody = Container(
        child: new FutureBuilder<TrackingSuratKeluarModel>(
      future: _future,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          String noSurat;

          return new Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(0.0),
                child: BeautyTextfield(
                  width: double.maxFinite,
                  height: 40,
                  backgroundColor: Colors.white,
                  textColor: Colors.red,
                  accentColor: Colors.red,
                  duration: Duration(milliseconds: 300),
                  inputType: TextInputType.text,
                  prefixIcon: Icon(
                    Icons.search,
                  ),
                  placeholder: "Cari",
                  onChanged: (value) {},
                  onSubmitted: (d) {
                    setState(() {
                      query = d.toString();
                      _future = makeRequest();
                    });
                  },
                ),
              ),
              Expanded(
                  child: SmartRefresher(
                enablePullDown: true,
                enablePullUp: true,
                header: WaterDropHeader(),
                footer: CustomFooter(
                  builder: (BuildContext context, LoadStatus mode) {
                    Widget body;
                    if (mode == LoadStatus.idle) {
                      body = Text("pull up load");
                    } else if (mode == LoadStatus.loading) {
                      body = CupertinoActivityIndicator();
                    } else if (mode == LoadStatus.failed) {
                      body = Text("Load Failed!Click retry!");
                    } else {
                      body = Text("No more Data");
                    }
                    return Container(
                      height: 55.0,
                      child: Center(child: body),
                    );
                  },
                ),
                controller: _refreshController,
                onRefresh: () {
                  setState(() {
                    rfrsh = true;
                    refreshList = 0;
                    _future = makeRequest();
                  });
                },
                onLoading: () {
                  setState(() {
                    rfrsh = false;
                    refreshList = refreshList + 1;
                    _future = makeRequest();
                  });
                },
                child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: int.parse('${items.length}'),
                  itemBuilder: (BuildContext context, int i) {
                    if ('${items[i].no_surat}' == 'null') {
                      noSurat = "-";
                    } else {
                      noSurat = '${items[i].no_surat}';
                    }
                    return new Card(
                      elevation: 8.0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0)),
                      margin: new EdgeInsets.symmetric(
                          horizontal: 10.0, vertical: 6.0),
                      child: Container(
                          child: new ListTile(
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 5.0, vertical: 5.0),
                              leading: Container(
                                  padding: EdgeInsets.only(right: 12.0),
                                  decoration: new BoxDecoration(
                                      border: new Border(
                                          right: new BorderSide(
                                              width: 2.0,
                                              color: Colors.deepPurpleAccent))),
                                  child: new InkWell(
                                    child: CircleAvatar(
                                        backgroundColor: Colors.greenAccent,
                                        radius: 16.0,
                                        child: new Icon(Icons.border_color,
                                            color: Colors.white, size: 16.0)),
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          new MaterialPageRoute(
                                              builder: (BuildContext context) =>
                                                  new DetailTrackingSuratKeluarHistory(
                                                      '${items[i].id}')));
                                    },
                                  )),
                              title: Column(
                                children: <Widget>[
                                  new Row(
                                    children: <Widget>[
                                      new Icon(Icons.markunread_mailbox,
                                          color: Colors.purple, size: 16.0),
                                      new Container(
                                        width: 10.0,
                                      ),
                                      Expanded(
                                          child: Text(noSurat,
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 12.0)))
                                    ],
                                  ),
                                  new Separators()
                                ],
                              ),
                              subtitle: Column(children: <Widget>[
                                new Row(
                                  children: <Widget>[
                                    new Icon(Icons.arrow_forward,
                                        color: Colors.black, size: 16.0),
                                    new Container(
                                      width: 5.0,
                                    ),
                                    Expanded(
                                      child: Text(
                                          '${items[i].pembuat_awal.name}',
                                          style: TextStyle(
                                              color: Colors.green,
                                              fontSize: 11.0)),
                                    )
                                  ],
                                ),
                                new Container(
                                  height: 5.0,
                                ),
                                new Row(
                                  children: <Widget>[
                                    new Icon(Icons.event_note,
                                        color: Colors.purple, size: 16.0),
                                    new Container(
                                      width: 5.0,
                                    ),
                                    new Expanded(
                                      child: Text('${items[i].perihal}',
                                          style: TextStyle(
                                              color: Colors.red,
                                              fontSize: 11.0)),
                                    )
                                  ],
                                )
                              ]),
                              trailing: Column(
                                children: <Widget>[
                                  Text(
                                      formatter.format(DateTime.parse(
                                          '${items[i].surat_at}')),
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.brown,
                                          fontSize: 10.0)),
                                  // Expanded(
                                  //   child: new IconButton(
                                  //       icon: const Icon(Icons.file_download, color: Colors.red, size: 20.0),
                                  //       onPressed: () {
                                  //         downloadFileOfPdfUrl('${items[i].versi_akhir}');
                                  //       }),
                                  // )
                                ],
                              ),
                              onTap: () async {
                                createFileOfPdfUrl('${items[i].versi_akhir}');
                              })),
                    );
                  },
                ),
              ))
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
    ));

    return new Scaffold(
      key: _scaffoldKey,
      appBar: new AppBar(
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
                child: Text('Tracking/History',
                    style: TextStyle(
                        fontFamily: 'Source Code Pro',
                        fontSize: 16.0,
                        color: Colors.red)))
          ],
        ),
      ),
      body: makeBody,
    );
  }
}
