import 'package:flutter/material.dart';
import 'package:eoffice/activity/main/ShowPDF.dart';
import 'package:eoffice/util/constants.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:eoffice/model/suratmasuk/DetailSuratMasukModel.dart';
import 'package:eoffice/util/separator.dart';
import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:path_provider/path_provider.dart';
import 'package:simple_permissions/simple_permissions.dart';

const directoryName = 'Download';

class DetailSuratMasuk extends StatefulWidget {
  final data;

  final bool horizontal;

  DetailSuratMasuk(this.data, {this.horizontal = true});

  DetailSuratMasuk.vertical(this.data) : horizontal = false;

  DetailSuratMasukState createState() => new DetailSuratMasukState(data);
}

class DetailSuratMasukState extends State<DetailSuratMasuk> {
  final data;
  final bool horizontal;
  String _platformVersion = 'Unknown';
  Permission _permission = Permission.WriteExternalStorage;
  String filePath;
  DetailSuratMasukState(this.data, {this.horizontal = true});

  DetailSuratMasukState.vertical(this.data) : horizontal = false;

  SharedPreferences sharedPreferences;
  String url;
  String loginToken;

  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  String pathPDF = "";

  Future _future;

  @override
  initState() {
    super.initState();
    _future = makeRequest();
  }

  Future<DetailSuratModel> makeRequest() async {
    sharedPreferences = await SharedPreferences.getInstance();
    loginToken = sharedPreferences.getString("loginToken");

    final response = await http
        .get(URL_DETAIL_SURAT_MASUK + data.toString() + "?token=" + loginToken);

    if (response.statusCode == 200) {
      print(jsonDecode(response.body));
      return DetailSuratModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load post.');
    }
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
    final pThumbnail = new Container(
      margin: new EdgeInsets.symmetric(vertical: 16.0),
      alignment:
          horizontal ? FractionalOffset.centerLeft : FractionalOffset.center,
      child: new Hero(
          tag: "HK",
          child: new Stack(
            children: <Widget>[
              CircleAvatar(
                  backgroundColor: new Color(0xFF353c4e),
                  radius: 52.0,
                  child: new Image(
                    image: new AssetImage("assets/logohk.png"),
                    height: 280.0,
                    width: 280.0,
                  )),
            ],
          )),
    );

    Container _getGradient() {
      return new Container(
        margin: new EdgeInsets.only(top: 190.0),
        height: 110.0,
        decoration: new BoxDecoration(
          gradient: new LinearGradient(
            colors: <Color>[new Color(0xFFFFFFFF), new Color(0xFFFFFFFF)],
            stops: [0.0, 0.9],
            begin: const FractionalOffset(0.0, 0.0),
            end: const FractionalOffset(0.0, 1.0),
          ),
        ),
      );
    }

    return new Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
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
                  child: Text('Detail',
                      style: TextStyle(
                          fontFamily: 'Source Code Pro',
                          fontSize: 16.0,
                          color: Colors.red)))
            ],
          )),
      body: new Container(
        constraints: new BoxConstraints.expand(),
        color: Colors.white,
        child: new Stack(
          children: <Widget>[
            _getGradient(),
            new Container(
              child: new FutureBuilder<DetailSuratModel>(
                future: _future,
                builder: (context, snapshot) {
                  var formatter = new DateFormat('dd-MM-yyyy HH:mm');
                  if (snapshot.hasData) {
                    String active;
                    Widget textActiveAt;
                    if (snapshot.data.detail_surat.active_at == null) {
                      active = "Tidak Diatur";
                      textActiveAt = new Text(active,
                          style: TextStyle(color: Colors.white, fontSize: 9.0));
                    } else {
                      active = snapshot.data.detail_surat.active_at ?? '';
                      textActiveAt = new Text(
                          formatter.format(DateTime.parse(active)),
                          style: TextStyle(color: Colors.white, fontSize: 9.0));
                    }
                    return Container(
                      child: new ListView(
                        padding: new EdgeInsets.fromLTRB(0.0, 12.0, 0.0, 32.0),
                        children: <Widget>[
                          new GestureDetector(
                              child: new Container(
                            margin: const EdgeInsets.symmetric(
                              vertical: 16.0,
                              horizontal: 24.0,
                            ),
                            child: new Stack(
                              children: <Widget>[
                                new Container(
                                  child: new Container(
                                    margin: new EdgeInsets.fromLTRB(
                                        horizontal ? 76.0 : 16.0,
                                        horizontal ? 2.0 : 42.0,
                                        16.0,
                                        2.0),
                                    constraints: new BoxConstraints.expand(),
                                    child: new Column(
                                      crossAxisAlignment: horizontal
                                          ? CrossAxisAlignment.start
                                          : CrossAxisAlignment.center,
                                      children: <Widget>[
                                        new Container(height: 4.0),
                                        new Text("No. Surat",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 18.0,
                                                fontWeight: FontWeight.w600)),
                                        new Container(height: 12.0),
                                        new Text(
                                            snapshot.data.detail_surat
                                                    .no_surat ??
                                                '',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 14.0,
                                                fontWeight: FontWeight.w400)),
                                        new Separator(),
                                        new Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: <Widget>[
                                              new Icon(Icons.timelapse,
                                                  color: Colors.white,
                                                  size: 12.0),
                                              new Container(width: 0.0),
                                              Padding(
                                                  padding: EdgeInsets.all(5.0),
                                                  child: textActiveAt)
                                            ])
                                      ],
                                    ),
                                  ),
                                  height: horizontal ? 124.0 : 154.0,
                                  margin: horizontal
                                      ? new EdgeInsets.only(left: 46.0)
                                      : new EdgeInsets.only(top: 72.0),
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
                                    ],
                                  ),
                                ),
                                pThumbnail,
                              ],
                            ),
                          )),
                          new Container(
                            padding: new EdgeInsets.symmetric(horizontal: 5.0),
                            child: new Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                new Column(
                                  children: <Widget>[
                                    new Card(
                                      elevation: 8.0,
                                      child: Container(
                                          padding: new EdgeInsets.symmetric(
                                              horizontal: 10.0),
                                          child: new Column(
                                            children: <Widget>[
                                              new Container(height: 10.0),
                                              Row(
                                                children: <Widget>[
                                                  new Text("Atribut Surat",
                                                      style: TextStyle(
                                                          color: Colors.red,
                                                          fontSize: 16.0,
                                                          fontWeight:
                                                              FontWeight.w400)),
                                                  Padding(
                                                      padding:
                                                          new EdgeInsets.only(
                                                              left: 10.0),
                                                      child: new Icon(
                                                          Icons.contact_mail,
                                                          color: Colors.green,
                                                          size: 16.0))
                                                ],
                                              ),
                                              new Row(
                                                children: <Widget>[
                                                  new Separator()
                                                ],
                                              ),
                                              new Row(
                                                children: <Widget>[
                                                  Expanded(
                                                    child: new Text(
                                                        "Sifat Surat",
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 14.0,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w400)),
                                                  ),
                                                  Expanded(
                                                    child: new Text(
                                                        snapshot
                                                                .data
                                                                .detail_surat
                                                                .sifat_surat ??
                                                            '',
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 14.0,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w400)),
                                                  )
                                                ],
                                              ),
                                              new Container(height: 10.0),
                                              new Row(
                                                children: <Widget>[
                                                  Expanded(
                                                    child: new Text(
                                                        "Jenis Surat",
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 14.0,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w400)),
                                                  ),
                                                  Expanded(
                                                    child: new Text(
                                                        snapshot
                                                                .data
                                                                .detail_surat
                                                                .jenis_surat ??
                                                            '',
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 14.0,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w400)),
                                                  )
                                                ],
                                              ),
                                              new Container(height: 10.0),
                                              new Row(
                                                children: <Widget>[
                                                  Expanded(
                                                    child: new Text(
                                                        "Kode Ordner",
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 14.0,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w400)),
                                                  ),
                                                  Expanded(
                                                    child: new Text(
                                                        snapshot
                                                                .data
                                                                .detail_surat
                                                                .code ??
                                                            '',
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 14.0,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w400)),
                                                  )
                                                ],
                                              ),
                                              new Container(height: 10.0)
                                            ],
                                          )),
                                    ),
                                    new Center(
                                        child: new Icon(Icons.arrow_downward,
                                            color: Colors.purple, size: 16.0)),
                                    new Card(
                                      elevation: 8.0,
                                      child: Container(
                                          padding: new EdgeInsets.symmetric(
                                              horizontal: 10.0),
                                          child: new Column(
                                            children: <Widget>[
                                              new Container(height: 10.0),
                                              Row(
                                                children: <Widget>[
                                                  new Text("Identitas Surat",
                                                      style: TextStyle(
                                                          color: Colors.red,
                                                          fontSize: 16.0,
                                                          fontWeight:
                                                              FontWeight.w400)),
                                                  Padding(
                                                      padding:
                                                          new EdgeInsets.only(
                                                              left: 10.0),
                                                      child: new Icon(
                                                          Icons.mail_outline,
                                                          color: Colors.green,
                                                          size: 16.0))
                                                ],
                                              ),
                                              new Row(
                                                children: <Widget>[
                                                  new Separator()
                                                ],
                                              ),
                                              new Row(
                                                children: <Widget>[
                                                  Expanded(
                                                    child: new Text("No. Surat",
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 14.0,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w400)),
                                                  ),
                                                  Expanded(
                                                    child: new Text(
                                                        snapshot
                                                                .data
                                                                .detail_surat
                                                                .no_surat ??
                                                            '',
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 14.0,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w400)),
                                                  )
                                                ],
                                              ),
                                              new Container(height: 10.0),
                                              new Row(
                                                children: <Widget>[
                                                  Expanded(
                                                    child: new Text("Tgl Surat",
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 14.0,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w400)),
                                                  ),
                                                  Expanded(
                                                    child: new Text(
                                                        formatter.format(DateTime
                                                            .parse(snapshot
                                                                    .data
                                                                    .detail_surat
                                                                    .surat_at ??
                                                                '')),
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 14.0,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w400)),
                                                  )
                                                ],
                                              ),
                                              new Container(height: 10.0),
                                              new Row(
                                                children: <Widget>[
                                                  Expanded(
                                                    child: new Text(
                                                        "Tgl Kirim Sekper",
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 14.0,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w400)),
                                                  ),
                                                  Expanded(
                                                    child: new Text(
                                                        formatter.format(DateTime
                                                            .parse(snapshot
                                                                    .data
                                                                    .detail_surat
                                                                    .created_at ??
                                                                '')),
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 14.0,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w400)),
                                                  )
                                                ],
                                              ),
                                              new Container(height: 10.0),
                                              new Row(
                                                children: <Widget>[
                                                  Expanded(
                                                    child: new Text(
                                                        "Batas Waktu Tanggapan",
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 14.0,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w400)),
                                                  ),
                                                  Expanded(
                                                    child: new Text(
                                                        formatter.format(DateTime
                                                            .parse(snapshot
                                                                    .data
                                                                    .detail_surat
                                                                    .batas_at ??
                                                                '')),
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 14.0,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w400)),
                                                  )
                                                ],
                                              ),
                                              new Container(height: 10.0),
                                              new Separators(),
                                              new Container(height: 10.0),
                                              new Row(
                                                children: <Widget>[
                                                  Expanded(
                                                    child: new Text(
                                                        "Dari/Pengirim",
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 14.0,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w400)),
                                                  ),
                                                  Expanded(
                                                    child: new Text(
                                                        "" +
                                                                snapshot
                                                                    .data
                                                                    .detail_surat
                                                                    .mailer_name ??
                                                            '',
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 14.0,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w400)),
                                                  )
                                                ],
                                              ),
                                              new Container(height: 10.0),
                                              new Row(
                                                children: <Widget>[
                                                  Expanded(
                                                    child: new Text("Kepada",
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 14.0,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w400)),
                                                  ),
                                                  Expanded(
                                                    child: new Text(
                                                        snapshot
                                                                .data
                                                                .detail_surat
                                                                .untuk ??
                                                            '',
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 14.0,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w400)),
                                                  )
                                                ],
                                              ),
                                              new Container(height: 10.0),
                                              new Row(
                                                children: <Widget>[
                                                  Expanded(
                                                    child: new Text("Perihal",
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 14.0,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w400)),
                                                  ),
                                                  Expanded(
                                                    child: new Text(
                                                        snapshot
                                                                .data
                                                                .detail_surat
                                                                .perihal ??
                                                            '',
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 14.0,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w400)),
                                                  )
                                                ],
                                              ),
                                              new Container(height: 10.0),
                                              new Row(
                                                children: <Widget>[
                                                  Expanded(
                                                    child: new Text("Catatan",
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 14.0,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w400)),
                                                  ),
                                                  Expanded(
                                                    child: new Text(
                                                        snapshot
                                                                .data
                                                                .detail_surat
                                                                .catatan ??
                                                            '',
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 14.0,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w400)),
                                                  )
                                                ],
                                              ),
                                              new Container(height: 10.0)
                                            ],
                                          )),
                                    ),
                                    new Center(
                                        child: new Icon(Icons.arrow_downward,
                                            color: Colors.purple, size: 16.0)),
                                    new Card(
                                      elevation: 8.0,
                                      child: Container(
                                          padding: new EdgeInsets.symmetric(
                                              horizontal: 10.0),
                                          child: new Column(
                                            children: <Widget>[
                                              new Container(height: 10.0),
                                              Row(
                                                children: <Widget>[
                                                  new Text("File Lampiran",
                                                      style: TextStyle(
                                                          color: Colors.red,
                                                          fontSize: 16.0,
                                                          fontWeight:
                                                              FontWeight.w400)),
                                                  Padding(
                                                      padding:
                                                          new EdgeInsets.only(
                                                              left: 10.0),
                                                      child: new Icon(
                                                          Icons.attach_file,
                                                          color: Colors.green,
                                                          size: 16.0))
                                                ],
                                              ),
                                              new Row(
                                                children: <Widget>[
                                                  new Separator()
                                                ],
                                              ),
                                              ListView.builder(
                                                scrollDirection: Axis.vertical,
                                                shrinkWrap: true,
                                                itemCount: snapshot
                                                            .data
                                                            .detail_surat
                                                            .filesListFiles ==
                                                        null
                                                    ? 0
                                                    : snapshot.data.detail_surat
                                                        .filesListFiles.length,
                                                itemBuilder:
                                                    (BuildContext context,
                                                        int i) {
                                                  return new Container(
                                                    child: Row(
                                                      children: <Widget>[
                                                        Expanded(
                                                          child: new InkWell(
                                                            child: new Text(
                                                                snapshot
                                                                        .data
                                                                        .detail_surat
                                                                        .filesListFiles[
                                                                            i]
                                                                        .name ??
                                                                    '',
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .blue,
                                                                    fontSize:
                                                                        14.0,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400)),
                                                            onTap: () async {
                                                              createFileOfPdfUrl(URL_DETAIL_SURAT_MASUK_PDF +
                                                                      snapshot
                                                                          .data
                                                                          .detail_surat
                                                                          .filesListFiles[
                                                                              i]
                                                                          .path ??
                                                                  '');
                                                            },
                                                          ),
                                                        ),
                                                        // Padding(
                                                        //   padding:
                                                        //       new EdgeInsets
                                                        //               .only(
                                                        //           left: 10.0),
                                                        //   child: new IconButton(
                                                        //       icon: const Icon(
                                                        //           Icons
                                                        //               .file_download,
                                                        //           color: Colors
                                                        //               .red,
                                                        //           size: 30.0),
                                                        //       onPressed: () {
                                                        //         downloadFileOfPdfUrl(URL_DETAIL_SURAT_MASUK_PDF +
                                                        //                 snapshot
                                                        //                     .data
                                                        //                     .detail_surat
                                                        //                     .filesListFiles[i]
                                                        //                     .path ??
                                                        //             '');
                                                        //       }),
                                                        // )
                                                      ],
                                                    ),
                                                  );
                                                },
                                              ),
                                              new Container(height: 10.0)
                                            ],
                                          )),
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
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
            )
          ],
        ),
      ),
    );
  }
}
