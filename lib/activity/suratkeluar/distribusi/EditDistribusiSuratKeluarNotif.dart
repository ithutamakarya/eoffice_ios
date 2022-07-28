import 'package:flutter/material.dart';
import 'package:eoffice/activity/suratkeluar/distribusi/DistribusiSurat.dart';
import 'package:eoffice/activity/main/ShowPDF.dart';
import 'package:eoffice/util/constants.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:eoffice/model/suratkeluar/EditDistribusiSuratKeluarModel.dart';
import 'package:eoffice/activity/suratkeluar/distribusi/DrawSignature.dart';
import 'package:eoffice/activity/suratkeluar/distribusi/DrawSignatureApproveRevisi.dart';
import 'package:eoffice/util/separator.dart';
import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';
import 'package:eoffice/activity/main/home.dart';
import 'package:html/parser.dart';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:path_provider/path_provider.dart';
import 'package:simple_permissions/simple_permissions.dart';

const directoryName = 'Download';

class EditDistribusiSuratKeluarNotif extends StatefulWidget {
  final dataId;
  final dataUuid;

  final bool horizontal;

  EditDistribusiSuratKeluarNotif(this.dataUuid, this.dataId,
      {this.horizontal = true});

  EditDistribusiSuratKeluarNotif.vertical(this.dataUuid, this.dataId)
      : horizontal = false;

  EditDistribusiSuratKeluarNotifState createState() =>
      new EditDistribusiSuratKeluarNotifState(dataUuid, dataId);
}

class EditDistribusiSuratKeluarNotifState
    extends State<EditDistribusiSuratKeluarNotif> {
  final dataId;
  final dataUuid;
  final bool horizontal;

  EditDistribusiSuratKeluarNotifState(this.dataUuid, this.dataId,
      {this.horizontal = true});

  EditDistribusiSuratKeluarNotifState.vertical(this.dataUuid, this.dataId)
      : horizontal = false;

  SharedPreferences sharedPreferences;
  String url;
  String loginToken;

  TextEditingController _catatanController = TextEditingController();

  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  String pathPDF = "";

  Future _future;
  int idUser;

  String _platformVersion = 'Unknown';
  Permission _permission = Permission.WriteExternalStorage;
  String filePath;

  @override
  initState() {
    super.initState();
    _future = makeRequest();
  }

  Future<EditDistribusiSuratKeluarModel> makeRequest() async {
    sharedPreferences = await SharedPreferences.getInstance();
    loginToken = sharedPreferences.getString("loginToken");
    idUser = sharedPreferences.getInt("idUser");

    final response = await http.get(URL_EDIT_DISTRIBUSI_SURAT +
        dataId.toString() +
        "?token=" +
        loginToken +
        "&uuid=" +
        dataUuid);

    if (response.statusCode == 200) {
      return EditDistribusiSuratKeluarModel.fromJson(jsonDecode(response.body));
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
                  child: Text('Edit Distribusi Surat',
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
              child: new FutureBuilder<EditDistribusiSuratKeluarModel>(
                future: _future,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    String parsedString;

                    if (snapshot.data.dis.keluar.catatan != null) {
                      if (snapshot.data.dis.keluar.catatan != "") {
                        var document = parse(snapshot.data.dis.keluar.catatan);
                        parsedString =
                            parse(document.body.text).documentElement.text;
                      } else {
                        parsedString = "-";
                      }
                    } else {
                      parsedString = "-";
                    }

                    Widget revisiApprove;
                    Widget textSetuju;

                    var formatter = new DateFormat('dd-MM-yyyy');

                    String dateNow = DateTime.now().toString();
                    String dateBatas = snapshot.data.dis.batas_at;

                    DateTime before = DateTime.parse(dateBatas);
                    DateTime now = DateTime.parse(dateNow);

                    if (idUser == snapshot.data.dis.satker_detail.user_id) {
                      print("untuk user");
                      if (now.difference(before).inDays > 0) {
                        print("out of date");
                        if (snapshot.data.dis.group == "persetujuan") {
                          textSetuju = new Row(children: <Widget>[]);

                          revisiApprove = new Row(
                            children: <Widget>[],
                          );
                        } else if (snapshot.data.dis.group == "pemeriksa") {
                          textSetuju = new Row(children: <Widget>[]);
                          revisiApprove = new Row(
                            children: <Widget>[],
                          );
                        } else {
                          textSetuju = new Row(children: <Widget>[]);
                          revisiApprove = new Row(
                            children: <Widget>[],
                          );
                        }
                      } else {
                        print("not out of date");
                        if (snapshot.data.dis.group == "persetujuan") {
                          if (snapshot.data.dis.status == false) {
                            textSetuju = new Row(children: <Widget>[]);

                            if (snapshot.data.countttd != 1) {
                              revisiApprove = new Row(
                                children: <Widget>[
                                  Expanded(
                                      child: Padding(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 16.0),
                                          child: new InkWell(
                                            onTap: () {
                                              Revisi();
                                            },
                                            child: new Container(
                                                height: 42.0,
                                                decoration: new BoxDecoration(
                                                  color: Colors.blueAccent,
                                                  border: new Border.all(
                                                      color: Colors.white,
                                                      width: 1.0),
                                                  borderRadius:
                                                      new BorderRadius.circular(
                                                          10.0),
                                                ),
                                                child: new Center(
                                                    child: Text('Revisi',
                                                        style: TextStyle(
                                                            color: Colors
                                                                .white)))),
                                          ))),
                                  Expanded(
                                      child: Padding(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 16.0),
                                          child: new InkWell(
                                            onTap: () {
                                              Approve();
                                            },
                                            child: new Container(
                                                height: 42.0,
                                                decoration: new BoxDecoration(
                                                  color: Colors.greenAccent,
                                                  border: new Border.all(
                                                      color: Colors.white,
                                                      width: 1.0),
                                                  borderRadius:
                                                      new BorderRadius.circular(
                                                          10.0),
                                                ),
                                                child: new Center(
                                                    child: Text('Approve Surat',
                                                        style: TextStyle(
                                                            color: Colors
                                                                .white)))),
                                          )))
                                ],
                              );
                            } else {
                              revisiApprove = new Row(
                                children: <Widget>[
                                  Expanded(
                                      child: Padding(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 16.0),
                                          child: new InkWell(
                                            onTap: () {
                                              Approve();
                                            },
                                            child: new Container(
                                                height: 42.0,
                                                decoration: new BoxDecoration(
                                                  color: Colors.greenAccent,
                                                  border: new Border.all(
                                                      color: Colors.white,
                                                      width: 1.0),
                                                  borderRadius:
                                                      new BorderRadius.circular(
                                                          10.0),
                                                ),
                                                child: new Center(
                                                    child: Text('Approve Surat',
                                                        style: TextStyle(
                                                            color: Colors
                                                                .white)))),
                                          )))
                                ],
                              );
                            }
                          } else if (snapshot.data.dis.status == true &&
                              snapshot.data.dis.approve_at != null) {
                            textSetuju = new Row(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  new Icon(Icons.check,
                                      color: Colors.green, size: 14.0),
                                  new Container(width: 5.0),
                                  Expanded(
                                      child: new Text(
                                          "Anda telah menyetujui surat ini",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 10.0)))
                                ]);

                            revisiApprove = new Row(
                              children: <Widget>[
                                Expanded(
                                    child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 16.0),
                                        child: new InkWell(
                                          onTap: () {
                                            Cancel();
                                          },
                                          child: new Container(
                                              height: 42.0,
                                              decoration: new BoxDecoration(
                                                color: Colors.blueAccent,
                                                border: new Border.all(
                                                    color: Colors.white,
                                                    width: 1.0),
                                                borderRadius:
                                                    new BorderRadius.circular(
                                                        10.0),
                                              ),
                                              child: new Center(
                                                  child: Text('Cancel',
                                                      style: TextStyle(
                                                          color:
                                                              Colors.white)))),
                                        )))
                              ],
                            );
                          }
                        } else if (snapshot.data.dis.group == "penandatangan") {
                          if (snapshot.data.dis.status == false) {
                            textSetuju = new Row(children: <Widget>[]);

                            if (snapshot.data.countttd != 1) {
                              revisiApprove = new Row(
                                children: <Widget>[
                                  Expanded(
                                      child: Padding(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 16.0),
                                          child: new InkWell(
                                            onTap: () {
                                              Revisi();
                                            },
                                            child: new Container(
                                                height: 42.0,
                                                decoration: new BoxDecoration(
                                                  color: Colors.blueAccent,
                                                  border: new Border.all(
                                                      color: Colors.white,
                                                      width: 1.0),
                                                  borderRadius:
                                                      new BorderRadius.circular(
                                                          10.0),
                                                ),
                                                child: new Center(
                                                    child: Text('Revisi',
                                                        style: TextStyle(
                                                            color: Colors
                                                                .white)))),
                                          ))),
                                  Expanded(
                                      child: Padding(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 16.0),
                                          child: new InkWell(
                                            onTap: () {
                                              Approve();
                                            },
                                            child: new Container(
                                                height: 42.0,
                                                decoration: new BoxDecoration(
                                                  color: Colors.greenAccent,
                                                  border: new Border.all(
                                                      color: Colors.white,
                                                      width: 1.0),
                                                  borderRadius:
                                                      new BorderRadius.circular(
                                                          10.0),
                                                ),
                                                child: new Center(
                                                    child: Text(
                                                        'Tanda Tangani Surat',
                                                        style: TextStyle(
                                                            color: Colors
                                                                .white)))),
                                          )))
                                ],
                              );
                            } else {
                              revisiApprove = new Row(
                                children: <Widget>[
                                  Expanded(
                                      child: Padding(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 16.0),
                                          child: new InkWell(
                                            onTap: () {
                                              Approve();
                                            },
                                            child: new Container(
                                                height: 42.0,
                                                decoration: new BoxDecoration(
                                                  color: Colors.greenAccent,
                                                  border: new Border.all(
                                                      color: Colors.white,
                                                      width: 1.0),
                                                  borderRadius:
                                                      new BorderRadius.circular(
                                                          10.0),
                                                ),
                                                child: new Center(
                                                    child: Text(
                                                        'Tanda Tangani Surat',
                                                        style: TextStyle(
                                                            color: Colors
                                                                .white)))),
                                          )))
                                ],
                              );
                            }
                          } else if (snapshot.data.dis.status == true &&
                              snapshot.data.dis.approve_at != null) {
                            textSetuju = new Row(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  new Icon(Icons.check,
                                      color: Colors.green, size: 14.0),
                                  new Container(width: 5.0),
                                  Expanded(
                                      child: new Text(
                                          "Anda telah menyetujui surat ini",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 10.0)))
                                ]);

                            revisiApprove = new Row(
                              children: <Widget>[
                                Expanded(
                                    child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 16.0),
                                        child: new InkWell(
                                          onTap: () {
                                            Cancel();
                                          },
                                          child: new Container(
                                              height: 42.0,
                                              decoration: new BoxDecoration(
                                                color: Colors.blueAccent,
                                                border: new Border.all(
                                                    color: Colors.white,
                                                    width: 1.0),
                                                borderRadius:
                                                    new BorderRadius.circular(
                                                        10.0),
                                              ),
                                              child: new Center(
                                                  child: Text('Cancel',
                                                      style: TextStyle(
                                                          color:
                                                              Colors.white)))),
                                        )))
                              ],
                            );
                          }
                        } else if (snapshot.data.dis.group == "pemeriksa") {
                          if (snapshot.data.dis.status == false) {
                            textSetuju = new Row(children: <Widget>[]);

                            if (snapshot.data.countttd != 1) {
                              revisiApprove = new Row(
                                children: <Widget>[
                                  Expanded(
                                      child: Padding(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 16.0),
                                          child: new InkWell(
                                            onTap: () {
                                              Revisi();
                                            },
                                            child: new Container(
                                                height: 42.0,
                                                decoration: new BoxDecoration(
                                                  color: Colors.blueAccent,
                                                  border: new Border.all(
                                                      color: Colors.white,
                                                      width: 1.0),
                                                  borderRadius:
                                                      new BorderRadius.circular(
                                                          10.0),
                                                ),
                                                child: new Center(
                                                    child: Text('Revisi',
                                                        style: TextStyle(
                                                            color: Colors
                                                                .white)))),
                                          ))),
                                  Expanded(
                                      child: Padding(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 16.0),
                                          child: new InkWell(
                                            onTap: () {
                                              ApproveRevisi();
                                            },
                                            child: new Container(
                                                height: 42.0,
                                                decoration: new BoxDecoration(
                                                  color: Colors.greenAccent,
                                                  border: new Border.all(
                                                      color: Colors.white,
                                                      width: 1.0),
                                                  borderRadius:
                                                      new BorderRadius.circular(
                                                          10.0),
                                                ),
                                                child: new Center(
                                                    child: Text(
                                                        'Approve Revisi',
                                                        style: TextStyle(
                                                            color: Colors
                                                                .white)))),
                                          )))
                                ],
                              );
                            } else {
                              revisiApprove = new Row(
                                children: <Widget>[
                                  Expanded(
                                      child: Padding(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 16.0),
                                          child: new InkWell(
                                            onTap: () {
                                              ApproveRevisi();
                                            },
                                            child: new Container(
                                                height: 42.0,
                                                decoration: new BoxDecoration(
                                                  color: Colors.greenAccent,
                                                  border: new Border.all(
                                                      color: Colors.white,
                                                      width: 1.0),
                                                  borderRadius:
                                                      new BorderRadius.circular(
                                                          10.0),
                                                ),
                                                child: new Center(
                                                    child: Text(
                                                        'Approve Revisi',
                                                        style: TextStyle(
                                                            color: Colors
                                                                .white)))),
                                          )))
                                ],
                              );
                            }
                          } else if (snapshot.data.dis.status == true &&
                              snapshot.data.dis.approve_at != null) {
                            textSetuju = new Row(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  new Icon(Icons.check,
                                      color: Colors.green, size: 14.0),
                                  new Container(width: 5.0),
                                  Expanded(
                                      child: new Text(
                                          "Anda telah menyetujui surat ini",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 10.0)))
                                ]);

                            revisiApprove = new Row(
                              children: <Widget>[
                                Expanded(
                                    child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 16.0),
                                        child: new InkWell(
                                          onTap: () {
                                            Cancel();
                                          },
                                          child: new Container(
                                              height: 42.0,
                                              decoration: new BoxDecoration(
                                                color: Colors.blueAccent,
                                                border: new Border.all(
                                                    color: Colors.white,
                                                    width: 1.0),
                                                borderRadius:
                                                    new BorderRadius.circular(
                                                        10.0),
                                              ),
                                              child: new Center(
                                                  child: Text('Cancel',
                                                      style: TextStyle(
                                                          color:
                                                              Colors.white)))),
                                        )))
                              ],
                            );
                          }
                        } else {
                          textSetuju = new Row(children: <Widget>[]);

                          revisiApprove = new Row(
                            children: <Widget>[],
                          );
                        }
                      }
                    } else {
                      print("bukan untuk user");
                      textSetuju = new Row(children: <Widget>[]);

                      revisiApprove = new Row(
                        children: <Widget>[],
                      );
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
                                                fontSize: 16.0,
                                                fontWeight: FontWeight.w600)),
                                        new Container(height: 10.0),
                                        new Text(
                                            snapshot.data.dis.keluar.no_surat,
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
                                                  child: new Text(
                                                      formatter.format(
                                                          DateTime.parse(
                                                              snapshot
                                                                  .data
                                                                  .dis
                                                                  .keluar
                                                                  .surat_at)),
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 9.0)))
                                            ]),
                                        new Separator(),
                                        textSetuju,
                                        new Container(height: 4.0),
                                      ],
                                    ),
                                  ),
                                  height: horizontal ? 130.0 : 160.0,
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
                                                    child: new Text("Pengirim",
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
                                                          initialValue: snapshot
                                                              .data
                                                              .dis
                                                              .keluar
                                                              .pengirim,
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .black45,
                                                              fontSize: 14.0,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400)))
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
                                                    child: new TextFormField(
                                                        focusNode:
                                                            new AlwaysDisabledFocusNode(),
                                                        keyboardType:
                                                            TextInputType
                                                                .multiline,
                                                        maxLines: null,
                                                        autofocus: false,
                                                        initialValue: snapshot
                                                            .data
                                                            .dis
                                                            .keluar
                                                            .kepada,
                                                        style: TextStyle(
                                                            color:
                                                                Colors.black45,
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
                                                    child: new TextFormField(
                                                        focusNode:
                                                            new AlwaysDisabledFocusNode(),
                                                        keyboardType:
                                                            TextInputType
                                                                .multiline,
                                                        maxLines: null,
                                                        autofocus: false,
                                                        initialValue: snapshot
                                                            .data
                                                            .dis
                                                            .keluar
                                                            .perihal,
                                                        style: TextStyle(
                                                            color:
                                                                Colors.black45,
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
                                                    child: new Text("Isi Surat",
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
                                                        initialValue: snapshot
                                                            .data
                                                            .dis
                                                            .keluar
                                                            .isi,
                                                        style: TextStyle(
                                                            color:
                                                                Colors.black45,
                                                            fontSize: 14.0,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w400)),
                                                  )
                                                ],
                                              ),
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
                                                      child: Padding(
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  vertical:
                                                                      16.0),
                                                          child: new InkWell(
                                                            onTap: () async {
                                                              createFileOfPdfUrl(
                                                                  URL_EDIT_DISTRIBUSI_SURAT_PDF +
                                                                      snapshot
                                                                          .data
                                                                          .versi_files
                                                                          .path);
                                                            },
                                                            child:
                                                                new Container(
                                                                    height:
                                                                        42.0,
                                                                    decoration:
                                                                        new BoxDecoration(
                                                                      color: Colors
                                                                          .greenAccent,
                                                                      border: new Border
                                                                              .all(
                                                                          color: Colors
                                                                              .white,
                                                                          width:
                                                                              1.0),
                                                                      borderRadius:
                                                                          new BorderRadius.circular(
                                                                              10.0),
                                                                    ),
                                                                    child: new Center(
                                                                        child: Text(
                                                                            'View Surat',
                                                                            style:
                                                                                TextStyle(color: Colors.white)))),
                                                          )))
                                                ],
                                              ),
                                              new Container(height: 10.0),
                                              new Row(
                                                children: <Widget>[
                                                  Expanded(
                                                    child: new Text(
                                                        "Catatan Originator",
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
                                                            parsedString,
                                                        style: TextStyle(
                                                            color:
                                                                Colors.black45,
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
                                                    child: new TextFormField(
                                                        controller:
                                                            _catatanController,
                                                        keyboardType:
                                                            TextInputType
                                                                .multiline,
                                                        maxLines: null,
                                                        autofocus: false),
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
                                                  new Text("FILE TERLAMPIR",
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
                                              new Container(height: 10.0),
                                              ListView.builder(
                                                scrollDirection: Axis.vertical,
                                                shrinkWrap: true,
                                                itemCount: snapshot.data.dis
                                                            .keluar.json_pdf ==
                                                        null
                                                    ? 0
                                                    : snapshot.data.dis.keluar
                                                        .json_pdf.length,
                                                itemBuilder:
                                                    (BuildContext context,
                                                        int i) {
                                                  return new Container(
                                                      child: new InkWell(
                                                    child: new Text(
                                                        (i + 1).toString() +
                                                            ". " +
                                                            snapshot
                                                                .data
                                                                .dis
                                                                .keluar
                                                                .json_pdf[i]
                                                                .name,
                                                        style: TextStyle(
                                                            color: Colors.blue,
                                                            fontSize: 14.0,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w400)),
                                                    onTap: () async {
                                                      createFileOfPdfUrl(
                                                          URL_EDIT_DISTRIBUSI_SURAT_PDF +
                                                              snapshot
                                                                  .data
                                                                  .dis
                                                                  .keluar
                                                                  .json_pdf[i]
                                                                  .path);
                                                    },
                                                  ));
                                                },
                                              ),
                                              new Container(height: 10.0),
                                            ],
                                          )),
                                    ),
                                    new Center(
                                        child: new Icon(Icons.arrow_downward,
                                            color: Colors.purple, size: 16.0)),
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

  Cancel() async {
    HomeScreenState.dialogNotif = "Edit Disposisi Surat Keluar";

    ProgressDialog pr = new ProgressDialog(context, ProgressDialogType.Normal);
    pr.setMessage('Menunggu..');
    pr.show();

    var url = URL_EDIT_DISTRIBUSI_SURAT_UPDATE +
        dataId.toString() +
        "/cancel?token=" +
        loginToken;
    http.post(
      url,
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
          DistribusiSuratState.refreshing();
          HomeScreenState.dialogNotif = "";
        });
        Navigator.pop(context);
        ;
      } else {
        _scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text('Revisi gagal'),
          duration: Duration(seconds: 3),
        ));
      }
    });
  }

  Revisi() async {
    HomeScreenState.dialogNotif = "Edit Disposisi Surat Keluar";

    ProgressDialog pr = new ProgressDialog(context, ProgressDialogType.Normal);
    pr.setMessage('Menunggu..');
    pr.show();

    Map datas = {
      'token': loginToken,
      '_method': 'PUT',
      'catatan': _catatanController.text,
    };

    var url = URL_EDIT_DISTRIBUSI_SURAT_UPDATE + dataId.toString() + "/update";
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
          DistribusiSuratState.refreshing();
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

  Approve() async {
    Navigator.push(
        context,
        new MaterialPageRoute(
            builder: (BuildContext context) =>
                new DrawSignature(dataId, _catatanController.text)));
  }

  ApproveRevisi() async {
    Navigator.push(
        context,
        new MaterialPageRoute(
            builder: (BuildContext context) => new DrawSignatureApproveRevisi(
                dataId, _catatanController.text)));
  }
}

class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}
