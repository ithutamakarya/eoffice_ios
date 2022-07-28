import 'package:flutter/material.dart';
import 'package:eoffice/activity/suratmasuk/memomasuk/MemoMasuk.dart';
import 'package:eoffice/util/constants.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:eoffice/model/suratmasuk/DetailMemoMasukModel.dart';
import 'package:eoffice/util/separator.dart';
import 'package:eoffice/activity/main/home.dart';
import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';
import 'package:progress_dialog/progress_dialog.dart';

class EditMemoMasuk extends StatefulWidget {
  final dataId;

  final bool horizontal;

  EditMemoMasuk(this.dataId, {this.horizontal = true});

  EditMemoMasuk.vertical(this.dataId) : horizontal = false;

  EditMemoMasukState createState() => new EditMemoMasukState(dataId);
}

class EditMemoMasukState extends State<EditMemoMasuk> {
  final dataId;
  final bool horizontal;

  EditMemoMasukState(this.dataId, {this.horizontal = true});

  EditMemoMasukState.vertical(this.dataId) : horizontal = false;

  SharedPreferences sharedPreferences;
  String url;
  String loginToken;

  final _catatanController = TextEditingController();

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  Future _future;

  @override
  initState() {
    super.initState();
    _future = makeRequest();
  }

  Future<DetailMemoMasukModel> makeRequest() async {
    sharedPreferences = await SharedPreferences.getInstance();
    loginToken = sharedPreferences.getString("loginToken");

    final response = await http.get(
        URL_DETAIL_MEMO_MASUK + dataId.toString() + "?token=" + loginToken);

    if (response.statusCode == 200) {
      return DetailMemoMasukModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load post.');
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
                  child: Text('Edit Memo Masuk',
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
              child: new FutureBuilder<DetailMemoMasukModel>(
                future: _future,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    Widget revisiApprove;

                    DateFormat formatter = new DateFormat('dd-MM-yyyy');

                    String dateNow = DateTime.now().toString();
                    String dateBatas = snapshot.data.disposisi.masuk.batas_at;

                    DateTime before = DateTime.parse(dateBatas);
                    DateTime now = DateTime.parse(dateNow);

                    if (now.difference(before).inDays > 0) {
                      revisiApprove = new Row(
                        children: <Widget>[],
                      );
                    } else {
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
                                            snapshot
                                                .data.disposisi.masuk.no_surat,
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
                                                      snapshot.data.disposisi
                                                          .masuk.surat_at,
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 9.0)))
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
                                                    child: new Text(
                                                        "Catatan Dari " +
                                                            snapshot
                                                                .data
                                                                .disposisi
                                                                .satker_dari,
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
                                                              .disposisi
                                                              .masuk
                                                              .catatan,
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

  Approve() async {
    HomeScreenState.dialogNotif = "Edit Memo Masuk";
    ProgressDialog pr = new ProgressDialog(context, ProgressDialogType.Normal);
    pr.setMessage('Please wait...');
    pr.show();

    var formatter = new DateFormat('dd/MM/yyyy');
    Map datas = {
      'token': loginToken,
      'status': "selesai",
      'catatan': _catatanController.text
    };

    var url = URL_DETAIL_MEMO_MASUK + dataId.toString() + "/update";
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
          MemoMasukState.makeRequest();
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

class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}
