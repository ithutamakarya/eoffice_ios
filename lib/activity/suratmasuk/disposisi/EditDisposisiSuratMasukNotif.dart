import 'package:http/http.dart' as http;
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:eoffice/activity/main/ShowPDF.dart';
import 'package:eoffice/util/constants.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:eoffice/model/suratmasuk/EditDisposisiSuratMasukModel.dart';
import 'package:eoffice/util/separator.dart';
import 'package:eoffice/model/ListStatusModel.dart';
import 'package:eoffice/activity/main/home.dart';
import 'package:eoffice/model/ListMengetahuiModel.dart';
import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:path_provider/path_provider.dart';
import 'package:simple_permissions/simple_permissions.dart';
import 'package:multiselect_formfield/multiselect_formfield.dart';

const directoryName = 'Download';

class EditDisposisiSuratMasukNotif extends StatefulWidget {
  final dataId, dataUuid;

  final bool horizontal;

  EditDisposisiSuratMasukNotif(this.dataUuid, this.dataId,
      {this.horizontal = true});

  EditDisposisiSuratMasukNotif.vertical(this.dataUuid, this.dataId)
      : horizontal = false;

  EditDisposisiSuratMasukNotifState createState() =>
      new EditDisposisiSuratMasukNotifState(dataUuid, dataId);
}

class EditDisposisiSuratMasukNotifState
    extends State<EditDisposisiSuratMasukNotif> {
  final dataId, dataUuid;
  final bool horizontal;

  EditDisposisiSuratMasukNotifState(this.dataUuid, this.dataId,
      {this.horizontal = true});

  EditDisposisiSuratMasukNotifState.vertical(this.dataUuid, this.dataId)
      : horizontal = false;

  SharedPreferences sharedPreferences;
  String url;
  String loginToken;

  final _catatanController = TextEditingController();

  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  String pathPDF = "";

  List<EditDisposisiSuratMasukModel> list = new List();
  String _mySelection, _mySelectionMengetahui;

  final formats = {InputType.date: DateFormat('dd/MM/yyyy')};

  // Changeable in demo
  InputType inputType = InputType.date;
  bool editable = true;
  DateTime date;

  List<String> arrayMengetahui = new List();

  List<Widget> visibleText = new List();

  FirebaseMessaging _firebaseMessaging = new FirebaseMessaging();
  bool visibilityTag = false;

  String stringStatus;

  Future _future;

  String _platformVersion = 'Unknown';
  Permission _permission = Permission.WriteExternalStorage;
  String filePath;

  List _myActivities;
  String _myActivitiesResult;
  final formKey = new GlobalKey<FormState>();

  @override
  initState() {
    super.initState();
    _future = makeRequest();
    _myActivities = [];
    _myActivitiesResult = '';
  }

  Future<EditDisposisiSuratMasukModel> makeRequest() async {
    sharedPreferences = await SharedPreferences.getInstance();
    loginToken = sharedPreferences.getString("loginToken");

    final response = await http.get(
      URL_EDIT_DISPOSISI_SURAT_MASUK +
          dataId.toString() +
          "?token=" +
          loginToken +
          "&uuid=" +
          dataUuid,
    );

    if (response.statusCode == 200) {
      return EditDisposisiSuratMasukModel.fromJson(jsonDecode(response.body));
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

  void _changed(String s) {
    if (s == "Selesai" || s == "selesai") {
      setState(() {
        visibilityTag = false;
      });
    } else {
      setState(() {
        visibilityTag = true;
      });
    }
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
                  child: Text('Edit Disposisi Surat',
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
              child: new FutureBuilder<EditDisposisiSuratMasukModel>(
                future: _future,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    Widget revisiApprove;
                    Widget ignoreStatus;
                    Widget ignoreMengetahui;
                    Widget hintStatus;
                    String catatanDari;
                    Widget batasSurat;
                    String satkerDari;
                    String perihalSurat;

                    DateFormat formatter = new DateFormat('dd-MM-yyyy');

                    List<ListStatusModel> list = new List();
                    List<Map<String, dynamic>> listMengetahui = [];

                    String name;
                    int id;

                    if (snapshot.data.mengetahui.length != 0) {
                      Map<String, dynamic> myObjectPilihSemua = {
                        'id': -1,
                        'name': 'Pilih Semua'
                      };
                      listMengetahui.add(myObjectPilihSemua);
                    }

                    for (int i = 0; i < snapshot.data.mengetahui.length; i++) {
                      name = snapshot.data.mengetahui[i].name;
                      id = snapshot.data.mengetahui[i].id;
                      Map<String, dynamic> myObject = {'id': id, 'name': name};
                      listMengetahui.add(myObject);

                      if (snapshot.data.mengetahui[i].child != null) {
                        for (int a = 0;
                            a < snapshot.data.mengetahui[i].child.length;
                            a++) {
                          name = snapshot.data.mengetahui[i].child[a].name;
                          id = snapshot.data.mengetahui[i].child[a].id;
                          Map<String, dynamic> myObjects = {
                            'id': id,
                            'name': name
                          };
                          listMengetahui.add(myObjects);

                          if (snapshot.data.mengetahui[i].child[a].childs !=
                              null) {
                            for (int b = 0;
                                b <
                                    snapshot.data.mengetahui[i].child[a].childs
                                        .length;
                                b++) {
                              name = snapshot
                                  .data.mengetahui[i].child[a].childs[b].name;
                              id = snapshot
                                  .data.mengetahui[i].child[a].childs[b].id;
                              Map<String, dynamic> myObjectss = {
                                'id': id,
                                'name': name
                              };
                              listMengetahui.add(myObjectss);

                              if (snapshot.data.mengetahui[i].child[a].childs[b]
                                      .childss !=
                                  null) {
                                for (int c = 0;
                                    c <
                                        snapshot.data.mengetahui[i].child[a]
                                            .childs[b].childss.length;
                                    c++) {
                                  name = snapshot.data.mengetahui[i].child[a]
                                      .childs[b].childss[c].name;
                                  id = snapshot.data.mengetahui[i].child[a]
                                      .childs[b].childss[c].id;
                                  Map<String, dynamic> myObjectsss = {
                                    'id': id,
                                    'name': name
                                  };
                                  listMengetahui.add(myObjectsss);
                                }
                              }
                            }
                          }
                        }
                      }
                    }

                    if (snapshot.data.disposisi.batas_at == null) {
                      batasSurat = new Text("-",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 14.0,
                              fontWeight: FontWeight.w400));
                      revisiApprove = new Row(
                        children: <Widget>[
                          Expanded(
                              child: Padding(
                                  padding: EdgeInsets.symmetric(vertical: 16.0),
                                  child: new InkWell(
                                    onTap: () {
                                      Approve();
                                    },
                                    child: new Container(
                                        height: 42.0,
                                        decoration: new BoxDecoration(
                                          color: Colors.blueAccent,
                                          border: new Border.all(
                                              color: Colors.white, width: 1.0),
                                          borderRadius:
                                              new BorderRadius.circular(10.0),
                                        ),
                                        child: new Center(
                                            child: Text('Tanggapi',
                                                style: TextStyle(
                                                    color: Colors.white)))),
                                  )))
                        ],
                      );
                    } else {
                      String dateNow = DateTime.now().toString();
                      String dateBatas = snapshot.data.disposisi.batas_at;

                      DateTime before = DateTime.parse(dateBatas);
                      DateTime now = DateTime.parse(dateNow);

                      batasSurat = new Text(
                          formatter.format(
                              DateTime.parse(snapshot.data.disposisi.batas_at)),
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 9.0,
                              fontWeight: FontWeight.w400));

                      if (now.difference(before).inDays > 0) {
                        revisiApprove = new Row(
                          children: <Widget>[],
                        );
                      } else {
                        revisiApprove = new Row(
                          children: <Widget>[
                            Expanded(
                                child: Padding(
                                    padding:
                                        EdgeInsets.symmetric(vertical: 16.0),
                                    child: new InkWell(
                                      onTap: () {
                                        Approve();
                                      },
                                      child: new Container(
                                          height: 42.0,
                                          decoration: new BoxDecoration(
                                            color: Colors.blueAccent,
                                            border: new Border.all(
                                                color: Colors.white,
                                                width: 1.0),
                                            borderRadius:
                                                new BorderRadius.circular(10.0),
                                          ),
                                          child: new Center(
                                              child: Text('Tanggapi',
                                                  style: TextStyle(
                                                      color: Colors.white)))),
                                    )))
                          ],
                        );
                      }
                    }

                    if (snapshot.data.disposisi.status == null) {
                      stringStatus = "Belum Menanggapi";
                      hintStatus = new Text("Pilih Status",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 12.0,
                              fontWeight: FontWeight.w400));

                      for (int i = 0; i < snapshot.data.status.length; i++) {
                        String name = snapshot.data.status[i];

                        ListStatusModel status =
                            new ListStatusModel(name: name);
                        list.add(status);
                      }
                    } else if (snapshot.data.disposisi.status == "Selesai" ||
                        snapshot.data.disposisi.status == "selesai") {
                      stringStatus = "Selesai";
                      hintStatus = new Text("Selesai",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 12.0,
                              fontWeight: FontWeight.w400));

                      for (int i = 0; i < snapshot.data.status.length; i++) {
                        String name = snapshot.data.status[i];

                        ListStatusModel status =
                            new ListStatusModel(name: name);
                        list.add(status);
                      }

                      revisiApprove = new Row(
                        children: <Widget>[],
                      );
                    } else {
                      if (snapshot.data.hitung != 0) {
                        stringStatus = "Diteruskan";
                        hintStatus = new Text("Pilih Status",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 12.0,
                                fontWeight: FontWeight.w400));

                        for (int i = 0; i < snapshot.data.status.length; i++) {
                          String name = snapshot.data.status[i];

                          ListStatusModel status =
                              new ListStatusModel(name: name);
                          list.add(status);
                        }
                      } else {
                        stringStatus = "Selesai";
                        hintStatus = new Text("Pilih Status",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 12.0,
                                fontWeight: FontWeight.w400));

                        String name = "Selesai";

                        ListStatusModel status =
                            new ListStatusModel(name: name);

                        list.add(status);
                      }
                    }

                    ignoreStatus = new IgnorePointer(
                        ignoring: false,
                        child: new DropdownButtonHideUnderline(
                            child: ButtonTheme(
                                alignedDropdown: true,
                                child: new DropdownButton(
                                  isDense: true,
                                  hint: hintStatus,
                                  items: list.map((item) {
                                    return new DropdownMenuItem(
                                      child: new Text(item.name,
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 14.0,
                                              fontWeight: FontWeight.w400)),
                                      value: item.name,
                                    );
                                  }).toList(),
                                  onChanged: (newVal) {
                                    _changed(newVal);
                                    setState(() {
                                      _mySelection = newVal;
                                    });
                                  },
                                  value: _mySelection,
                                ))));

                    if (snapshot.data.disposisi.parent_id == 0) {
                      if (snapshot.data.disposisi.masuk.catatan == null) {
                        satkerDari = "";
                        catatanDari = "-";
                      } else {
                        satkerDari = snapshot.data.disposisi.satker_dari;
                        catatanDari = snapshot.data.disposisi.masuk.catatan;
                      }
                    } else {
                      if (snapshot.data.disposisi.tanggapan == null) {
                        satkerDari = "";
                        catatanDari = "-";
                      } else {
                        satkerDari = snapshot.data.disposisi.satker_dari;
                        catatanDari = snapshot.data.disposisi.tanggapan;
                      }
                    }

                    if (snapshot.data.disposisi.masuk.perihal == null) {
                      perihalSurat = "-";
                    } else {
                      perihalSurat = snapshot.data.disposisi.masuk.perihal;
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
                                        horizontal ? 62.0 : 4.0,
                                        horizontal ? 2.0 : 42.0,
                                        4.0,
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
                                        Expanded(
                                          child: new Text(
                                              snapshot.data.disposisi.masuk
                                                  .no_surat,
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 14.0,
                                                  fontWeight: FontWeight.w400)),
                                        ),
                                        new Separators(),
                                        new Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: <Widget>[
                                              new Column(
                                                children: <Widget>[
                                                  new Text("Tanggal Surat",
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 12.0,
                                                          fontWeight:
                                                              FontWeight.w400)),
                                                  new Container(height: 12.0),
                                                  new Row(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: <Widget>[
                                                        new Icon(
                                                            Icons.timelapse,
                                                            color: Colors.white,
                                                            size: 12.0),
                                                        new Container(
                                                            width: 0.0),
                                                        Padding(
                                                            padding:
                                                                EdgeInsets.all(
                                                                    5.0),
                                                            child: new Text(
                                                                formatter.format(
                                                                    DateTime.parse(snapshot
                                                                        .data
                                                                        .disposisi
                                                                        .masuk
                                                                        .surat_at)),
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize:
                                                                        9.0)))
                                                      ])
                                                ],
                                              ),
                                              new Separator(),
                                              new Column(
                                                children: <Widget>[
                                                  new Text("Batas Tanggapan",
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 11.0,
                                                          fontWeight:
                                                              FontWeight.w400)),
                                                  new Container(height: 12.0),
                                                  new Row(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: <Widget>[
                                                        new Icon(
                                                            Icons.timelapse,
                                                            color: Colors.white,
                                                            size: 12.0),
                                                        new Container(
                                                            width: 0.0),
                                                        Padding(
                                                            padding:
                                                                EdgeInsets.all(
                                                                    5.0),
                                                            child: batasSurat)
                                                      ])
                                                ],
                                              )
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
                                                  new Text("FILE SURAT",
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
                                                            .disposisi
                                                            .masuk
                                                            .files ==
                                                        null
                                                    ? 0
                                                    : snapshot.data.disposisi
                                                        .masuk.files.length,
                                                itemBuilder:
                                                    (BuildContext context,
                                                        int i) {
                                                  return new Container(
                                                    child: Row(
                                                      children: <Widget>[
                                                        Expanded(
                                                            child: new InkWell(
                                                          child: new Row(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .min,
                                                              children: <
                                                                  Widget>[
                                                                new Icon(
                                                                    Icons.album,
                                                                    color: Colors
                                                                        .black,
                                                                    size: 6.0),
                                                                new Container(
                                                                    width: 5.0),
                                                                Expanded(
                                                                  child: new Text(
                                                                      snapshot
                                                                          .data
                                                                          .disposisi
                                                                          .masuk
                                                                          .files[
                                                                              i]
                                                                          .name,
                                                                      style: TextStyle(
                                                                          color: Colors
                                                                              .blue,
                                                                          fontSize:
                                                                              12.0,
                                                                          fontWeight:
                                                                              FontWeight.w400)),
                                                                )
                                                              ]),
                                                          onTap: () async {
                                                            createFileOfPdfUrl(
                                                                URL_DETAIL_SURAT_MASUK_PDF +
                                                                    snapshot
                                                                        .data
                                                                        .disposisi
                                                                        .masuk
                                                                        .files[
                                                                            i]
                                                                        .path);
                                                          },
                                                        )),
                                                        Padding(
                                                          padding:
                                                              new EdgeInsets
                                                                      .only(
                                                                  left: 10.0),
                                                          child: new IconButton(
                                                              icon: const Icon(
                                                                  Icons
                                                                      .file_download,
                                                                  color: Colors
                                                                      .red,
                                                                  size: 30.0),
                                                              onPressed: () {
                                                                downloadFileOfPdfUrl(URL_DETAIL_SURAT_MASUK_PDF +
                                                                    snapshot
                                                                        .data
                                                                        .disposisi
                                                                        .masuk
                                                                        .files[
                                                                            i]
                                                                        .path);
                                                              }),
                                                        )
                                                      ],
                                                    ),
                                                  );
                                                },
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
                                                  new Text("IDENTITAS SURAT",
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
                                                    child: new Text("Perihal",
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 14.0,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w400)),
                                                  ),
                                                  Expanded(
                                                      child: new TextFormField(
                                                          focusNode:
                                                              new AlwaysDisabledFocusNode(),
                                                          keyboardType:
                                                              TextInputType
                                                                  .multiline,
                                                          maxLines: null,
                                                          autofocus: false,
                                                          initialValue:
                                                              perihalSurat,
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .black45,
                                                              fontSize: 14.0,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400)))
                                                ],
                                              ),
                                              new Container(height: 20.0),
                                              new Row(
                                                children: <Widget>[
                                                  Expanded(
                                                    child: new Text(
                                                        "Catatan Dari " +
                                                            satkerDari,
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 14.0,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w400)),
                                                  ),
                                                  Expanded(
                                                      child: new TextFormField(
                                                          focusNode:
                                                              new AlwaysDisabledFocusNode(),
                                                          keyboardType:
                                                              TextInputType
                                                                  .multiline,
                                                          maxLines: null,
                                                          autofocus: false,
                                                          initialValue:
                                                              catatanDari,
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .black45,
                                                              fontSize: 14.0,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400)))
                                                ],
                                              ),
                                              new Container(height: 20.0),
                                              new Row(
                                                children: <Widget>[
                                                  Expanded(
                                                    child: new Text(
                                                        "Status : " +
                                                            stringStatus,
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
                                                  Expanded(child: ignoreStatus)
                                                ],
                                              ),
                                              visibilityTag
                                                  ? new Column(
                                                      children: <Widget>[
                                                        new Container(
                                                            height: 20.0),
                                                        Form(
                                                          key: formKey,
                                                          child: Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            children: <Widget>[
                                                              Container(
                                                                padding:
                                                                    EdgeInsets
                                                                        .all(
                                                                            16),
                                                                child:
                                                                    MultiSelectFormField(
                                                                  autovalidate:
                                                                      false,
                                                                  titleText:
                                                                      'Diteruskan',
                                                                  validator:
                                                                      (value) {},
                                                                  dataSource:
                                                                      listMengetahui,
                                                                  textField:
                                                                      'name',
                                                                  valueField:
                                                                      'id',
                                                                  okButtonLabel:
                                                                      'OK',
                                                                  cancelButtonLabel:
                                                                      'CANCEL',
                                                                  // required: true,
                                                                  hintText:
                                                                      'Pilih diteruskan',
                                                                  value:
                                                                      _myActivities,
                                                                  onSaved:
                                                                      (value) {
                                                                    if (value ==
                                                                        null)
                                                                      return;
                                                                    setState(
                                                                        () {
                                                                      if (value
                                                                          .contains(
                                                                              -1)) {
                                                                        _myActivities
                                                                            .clear();
                                                                        for (int i =
                                                                                0;
                                                                            i < snapshot.data.mengetahui.length;
                                                                            i++) {
                                                                          int id = snapshot
                                                                              .data
                                                                              .mengetahui[i]
                                                                              .id;
                                                                          _myActivities
                                                                              .add(id);
                                                                        }
                                                                      } else {
                                                                        _myActivities =
                                                                            value;
                                                                      }
                                                                    });
                                                                  },
                                                                ),
                                                              ),
                                                              Container(
                                                                padding:
                                                                    EdgeInsets
                                                                        .all(
                                                                            16),
                                                                child: Text(
                                                                    _myActivitiesResult),
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                        new Container(
                                                            height: 10.0),
                                                        new Column(
                                                            children:
                                                                visibleText),
                                                        new Container(
                                                            height: 10.0),
                                                        new Row(
                                                          children: <Widget>[
                                                            Expanded(
                                                              child: new Text(
                                                                  "Batas Waktu Tindak Lanjut",
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .black,
                                                                      fontSize:
                                                                          14.0,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w400)),
                                                            )
                                                          ],
                                                        ),
                                                        new Row(
                                                          children: <Widget>[
                                                            Expanded(
                                                                child:
                                                                    DateTimePickerFormField(
                                                              inputType:
                                                                  inputType,
                                                              format: formats[
                                                                  inputType],
                                                              editable:
                                                                  editable,
                                                              decoration: InputDecoration(
                                                                  border:
                                                                      InputBorder
                                                                          .none,
                                                                  labelText:
                                                                      "--Pilih Tanggal--",
                                                                  labelStyle: TextStyle(
                                                                      color: Colors
                                                                          .black,
                                                                      fontSize:
                                                                          14.0,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w400)),
                                                              onChanged: (dt) =>
                                                                  setState(() =>
                                                                      date =
                                                                          dt),
                                                            ))
                                                          ],
                                                        ),
                                                      ],
                                                    )
                                                  : new Container(),
                                              new Container(height: 10.0),
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
                                                  new Text("CATATAN",
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
                                                          Icons.event_note,
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
                                                    child: new Text("Catatan",
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 14.0,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w400)),
                                                  ),
                                                  Expanded(
                                                    child: new TextFormField(
                                                        controller:
                                                            _catatanController,
                                                        keyboardType:
                                                            TextInputType
                                                                .multiline,
                                                        maxLines: null,
                                                        autofocus: false,
                                                        decoration: InputDecoration(
                                                            hintText: "",
                                                            hintStyle: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontSize: 14.0,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400))),
                                                  )
                                                ],
                                              ),
                                              new Container(height: 10.0)
                                            ],
                                          )),
                                    ),
                                    revisiApprove,
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

  Approve() async {
    HomeScreenState.dialogNotif = "Edit Disposisi Surat Masuk";

    if (_mySelection == null) {
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text('Pilih Status'),
        duration: Duration(seconds: 3),
      ));
    } else {
      var formatter = new DateFormat('dd/MM/yyyy');

      String datePost;
      Map datas;

      if (_mySelection == "Selesai" || _mySelection == "selesai") {
        ProgressDialog pr =
            new ProgressDialog(context, ProgressDialogType.Normal);
        pr.setMessage('Menunggu..');
        pr.show();

        datePost = "00/00/0000";
        datas = {
          'token': loginToken,
          'status': _mySelection,
          'catatan': _catatanController.text,
          'batas_at': datePost,
        };

        var url =
            URL_EDIT_DISPOSISI_SURAT_MASUK + dataId.toString() + "/update";
        http.post(
          url,
          body: datas,
          headers: {
            'Accept-Language': 'id',
            'Connection': 'keep-alive',
            'Content-Type': 'application/x-www-form-urlencoded',
            'Accept': 'application/json',
            'Charset': 'utf-8',
          },
        ).then((response) {
          final data = json.decode(response.body);
          bool success = data['success'];

          if (success) {
            pr.hide();
            setState(() {
              HomeScreenState.dialogNotif = "";
            });
            Navigator.pop(context);
          } else {
            pr.hide();
            _scaffoldKey.currentState.showSnackBar(SnackBar(
              content: Text('Revisi gagal'),
              duration: Duration(seconds: 3),
            ));
          }
        });
      } else {
        if (date.toString() == "null") {
          _scaffoldKey.currentState.showSnackBar(SnackBar(
            content: Text('Pilih Tanggal'),
            duration: Duration(seconds: 3),
          ));
        } else {
          datePost =
              formatter.format(DateTime.parse(date.toString())).toString();

          if (_myActivities.length == 0) {
            _scaffoldKey.currentState.showSnackBar(SnackBar(
              content: Text('Pilih Diteruskan'),
              duration: Duration(seconds: 3),
            ));
          } else {
            ProgressDialog pr =
                new ProgressDialog(context, ProgressDialogType.Normal);
            pr.setMessage('Menunggu..');
            pr.show();

            datas = {
              'token': loginToken,
              'status': _mySelection,
              'catatan': _catatanController.text,
              'mengetahui': _myActivities.toString(),
              'batas_at': datePost,
            };

            var url =
                URL_EDIT_DISPOSISI_SURAT_MASUK + dataId.toString() + "/update";
            http.post(
              url,
              body: datas,
              headers: {
                'Accept-Language': 'id',
                'Connection': 'keep-alive',
                'Content-Type': 'application/x-www-form-urlencoded',
                'Accept': 'application/json',
                'Charset': 'utf-8',
              },
            ).then((response) {
              final data = json.decode(response.body);
              bool success = data['success'];

              if (success) {
                pr.hide();
                setState(() {
                  HomeScreenState.dialogNotif = "";
                });
                Navigator.pop(context);
              } else {
                pr.hide();
                _scaffoldKey.currentState.showSnackBar(SnackBar(
                  content: Text('Revisi gagal'),
                  duration: Duration(seconds: 3),
                ));
              }
            });
          }
        }
      }
    }
  }
}

class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}
