import 'package:flutter/material.dart';
import 'package:eoffice/model/suratmasuk/DetailTrackingSuratMasukNew.dart';
import 'package:eoffice/util/constants.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:eoffice/util/separator.dart';
import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'DetailCatatanTrackingMasuk.dart';

class DetailTrackingHistory extends StatefulWidget {
  final data;
  final bool horizontal;
  DetailTrackingHistory(this.data, {this.horizontal = true});
  DetailTrackingHistory.vertical(this.data): horizontal = false;
  DetailTrackingHistoryState createState() => new DetailTrackingHistoryState(data);
}

class DetailTrackingHistoryState extends State<DetailTrackingHistory> {

  final data;
  final bool horizontal;

  DetailTrackingHistoryState(this.data, {this.horizontal = true});

  DetailTrackingHistoryState.vertical(this.data): horizontal = false;

  SharedPreferences sharedPreferences;
  String url;
  String loginToken;

  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = new GlobalKey<RefreshIndicatorState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  FirebaseMessaging _firebaseMessaging = new FirebaseMessaging();

  Future _future;

  @override
  initState() {
    super.initState();
    _future = makeRequest();
  }

  Future<DetailTrackingSuratMasukNew> makeRequest() async {

    sharedPreferences = await SharedPreferences.getInstance();
    loginToken = sharedPreferences.getString("loginToken");

    final response =
    await http.get(URL_DETAIL_TRACKING_SURAT_MASUK + data.toString() +"?token=" +loginToken);

    if (response.statusCode == 200) {
      return DetailTrackingSuratMasukNew.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load post.');
    }
  }

  @override
  Widget build(BuildContext context) {
    var formatter = new DateFormat('yyyy-MM-dd');
    final makeBody = ListView(
      padding: new EdgeInsets.fromLTRB(10.0, 12.0, 10.0, 12.0),
      children: <Widget>[
        Container(
            child: new FutureBuilder<DetailTrackingSuratMasukNew>(
              future: _future,
              builder: (context, snapshot) {
                if (snapshot.hasData) {

                  Widget expansionTileDetailTrackingSuratMasuk;

                  if (snapshot.data.childs != null) {

                    String dari;
                    String tanggalDikirim;
                    String status;
                    String read;
                    String catatanPengirim;
                    String catatanSendiri;
                    String tanggalBatas;
                    String tanggalTaggapan;

                    if (snapshot.data.satker_dari == null || snapshot.data.satker_dari == "") {
                      dari = "-";
                    } else {
                      dari = snapshot.data.satker_dari;
                    }

                    if (snapshot.data.tgl_disposisi == null || snapshot.data.tgl_disposisi == "") {
                      tanggalDikirim = "-";
                    } else {
                      tanggalDikirim = snapshot.data.tgl_disposisi;
                    }

                    if (snapshot.data.status == null || snapshot.data.status == "") {
                      status = "-";
                    } else {
                      status = snapshot.data.status;
                    }

                    if (snapshot.data.read == null || snapshot.data.read == "") {
                      read = "-";
                    } else {
                      if (snapshot.data.read == "READ") {
                        read = "Sudah";
                      } else if (snapshot.data.read == "UNREAD") {
                        read = "Belum";
                      } else {
                        read = snapshot.data.read;
                      }
                    }

                    if (snapshot.data.catatan_pengirim == null || snapshot.data.catatan_pengirim == "") {
                      catatanPengirim = "-";
                    } else {
                      catatanPengirim = snapshot.data.catatan_pengirim;
                    }

                    if (snapshot.data.catatan_sendiri == null || snapshot.data.catatan_sendiri == "") {
                      catatanSendiri = "-";
                    } else {
                      catatanSendiri = snapshot.data.catatan_sendiri;
                    }

                    if (snapshot.data.tgl_tanggapan == null || snapshot.data.tgl_tanggapan == "") {
                      tanggalTaggapan = "-";
                    } else {
                      tanggalTaggapan = snapshot.data.tgl_tanggapan;
                    }

                    if (snapshot.data.tgl_batas == null || snapshot.data.tgl_batas == "") {
                      tanggalBatas = "-";
                    } else {
                      tanggalBatas = snapshot.data.tgl_batas;
                    }

                    return new ExpansionTile(
                        initiallyExpanded: true,
                        trailing: Icon(Icons.expand_more, color: Colors.black),
                        backgroundColor: Colors.white,
                        leading: new InkWell(
                          child: CircleAvatar(
                              backgroundColor: Colors.orange,
                              radius: 16.0,
                              child: new Icon(Icons.message, color: Colors.white, size: 16.0)
                          ),
                        ),
                        title: new Text(snapshot.data.satker_name, style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 16.0, color: Colors.black)),
                        children: [
                          Column(
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.fromLTRB(16.0, 5.0, 16.0, 5.0),
                                child: Row(
                                  children: <Widget>[
                                    Expanded(
                                      child: new Text("Dari", style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black, fontWeight: FontWeight.bold)),
                                    ),
                                    Expanded(
                                      child: new Text("Tgl Dikirim", style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black, fontWeight: FontWeight.bold)),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 5.0),
                                child: Row(
                                  children: <Widget>[
                                    Expanded(
                                      child: new Text(dari, style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black)),
                                    ),
                                    Expanded(
                                      child: new Text(tanggalDikirim, style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black)),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.fromLTRB(16.0, 5.0, 16.0, 5.0),
                                child: Row(
                                  children: <Widget>[
                                    Expanded(
                                      child: new Text("Status", style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black, fontWeight: FontWeight.bold)),
                                    ),
                                    Expanded(
                                      child: new Text("Dibaca", style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black, fontWeight: FontWeight.bold)),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 5.0),
                                child: Row(
                                  children: <Widget>[
                                    Expanded(
                                      child: new Text(status, style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black)),
                                    ),
                                    Expanded(
                                      child: new Text(read, style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black)),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.fromLTRB(16.0, 5.0, 16.0, 5.0),
                                child: Row(
                                  children: <Widget>[
                                    Expanded(
                                      child: new Text("Catatan Pengirim", style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black, fontWeight: FontWeight.bold)),
                                    ),
                                    Expanded(
                                      child: new Text("Catatan Sendiri", style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black, fontWeight: FontWeight.bold)),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 5.0),
                                child: Row(
                                  children: <Widget>[
                                    Expanded(
                                      child: new Text(catatanPengirim, style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black)),
                                    ),
                                    Expanded(
                                      child: new Text(catatanSendiri, style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black)),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.fromLTRB(16.0, 5.0, 16.0, 5.0),
                                child: Row(
                                  children: <Widget>[
                                    Expanded(
                                      child: new Text("Tgl Tanggapan", style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black, fontWeight: FontWeight.bold)),
                                    ),
                                    Expanded(
                                      child: new Text("Tgl Batas", style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black, fontWeight: FontWeight.bold)),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 5.0),
                                child: Row(
                                  children: <Widget>[
                                    Expanded(
                                      child: new Text(tanggalTaggapan, style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black)),
                                    ),
                                    Expanded(
                                      child: new Text(tanggalBatas, style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black)),
                                    ),
                                  ],
                                ),
                              ),
                              new Separators(),
                              ListView.builder(
                                  scrollDirection: Axis.vertical,
                                  shrinkWrap: true,
                                  physics: ClampingScrollPhysics(),
                                  itemCount: snapshot.data.childs.length,
                                  itemBuilder: (BuildContext context, int i) {
                                    if (snapshot.data.childs[i].child != null) {

                                      String dari1;
                                      String tanggalDikirim1;
                                      String status1;
                                      String read1;
                                      String catatanPengirim1;
                                      String catatanSendiri1;
                                      String tanggalBatas1;
                                      String tanggalTaggapan1;

                                      if (snapshot.data.childs[i].satker_dari == null || snapshot.data.childs[i].satker_dari == "") {
                                        dari1 = "-";
                                      } else {
                                        dari1 = snapshot.data.childs[i].satker_dari;
                                      }

                                      if (snapshot.data.childs[i].tgl_disposisi == null || snapshot.data.childs[i].tgl_disposisi == "") {
                                        tanggalDikirim1 = "-";
                                      } else {
                                        tanggalDikirim1 = snapshot.data.childs[i].tgl_disposisi;
                                      }

                                      if (snapshot.data.childs[i].status == null || snapshot.data.childs[i].status == "") {
                                        status1 = "-";
                                      } else {
                                        status1 = snapshot.data.childs[i].status;
                                      }

                                      if (snapshot.data.childs[i].read == null || snapshot.data.childs[i].read == "") {
                                        read1 = "-";
                                      } else {
                                        if (snapshot.data.childs[i].read == "READ") {
                                          read1 = "Sudah";
                                        } else if (snapshot.data.childs[i].read == "UNREAD") {
                                          read1 = "Belum";
                                        } else {
                                          read1 = snapshot.data.childs[i].read;
                                        }
                                      }

                                      if (snapshot.data.childs[i].catatan_pengirim == null || snapshot.data.childs[i].catatan_pengirim == "") {
                                        catatanPengirim1 = "-";
                                      } else {
                                        catatanPengirim1 = snapshot.data.childs[i].catatan_pengirim;
                                      }

                                      if (snapshot.data.childs[i].catatan_sendiri == null || snapshot.data.childs[i].catatan_sendiri == "") {
                                        catatanSendiri1 = "-";
                                      } else {
                                        catatanSendiri1 = snapshot.data.childs[i].catatan_sendiri;
                                      }

                                      if (snapshot.data.childs[i].tgl_tanggapan == null || snapshot.data.childs[i].tgl_tanggapan == "") {
                                        tanggalTaggapan1 = "-";
                                      } else {
                                        tanggalTaggapan1 = snapshot.data.childs[i].tgl_tanggapan;
                                      }

                                      if (snapshot.data.childs[i].tgl_batas == null || snapshot.data.childs[i].tgl_batas == "") {
                                        tanggalBatas1 = "-";
                                      } else {
                                        tanggalBatas1 = snapshot.data.childs[i].tgl_batas;
                                      }

                                      return new ExpansionTile(
                                          trailing: Icon(Icons.expand_more, color: Colors.black),
                                          backgroundColor: Colors.white,
                                          leading: new InkWell(
                                            child: CircleAvatar(
                                                backgroundColor: Colors.orange,
                                                radius: 16.0,
                                                child: new Icon(Icons.message, color: Colors.white, size: 16.0)
                                            ),
                                          ),
                                          title: new Text(snapshot.data.childs[i].satker_name, style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 16.0, color: Colors.black)),
                                          children: [
                                            Column(
                                              children: <Widget>[
                                                Padding(
                                                  padding: EdgeInsets.fromLTRB(16.0, 5.0, 16.0, 5.0),
                                                  child: Row(
                                                    children: <Widget>[
                                                      Expanded(
                                                        child: new Text("Dari", style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black, fontWeight: FontWeight.bold)),
                                                      ),
                                                      Expanded(
                                                        child: new Text("Tgl Dikirim", style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black, fontWeight: FontWeight.bold)),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 5.0),
                                                  child: Row(
                                                    children: <Widget>[
                                                      Expanded(
                                                        child: new Text(dari1, style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black)),
                                                      ),
                                                      Expanded(
                                                        child: new Text(tanggalDikirim1, style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black)),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.fromLTRB(16.0, 5.0, 16.0, 5.0),
                                                  child: Row(
                                                    children: <Widget>[
                                                      Expanded(
                                                        child: new Text("Status", style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black, fontWeight: FontWeight.bold)),
                                                      ),
                                                      Expanded(
                                                        child: new Text("Dibaca", style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black, fontWeight: FontWeight.bold)),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 5.0),
                                                  child: Row(
                                                    children: <Widget>[
                                                      Expanded(
                                                        child: new Text(status1, style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black)),
                                                      ),
                                                      Expanded(
                                                        child: new Text(read1, style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black)),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.fromLTRB(16.0, 5.0, 16.0, 5.0),
                                                  child: Row(
                                                    children: <Widget>[
                                                      Expanded(
                                                        child: new Text("Catatan Pengirim", style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black, fontWeight: FontWeight.bold)),
                                                      ),
                                                      Expanded(
                                                        child: new Text("Catatan Sendiri", style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black, fontWeight: FontWeight.bold)),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 5.0),
                                                  child: Row(
                                                    children: <Widget>[
                                                      Expanded(
                                                        child: new Text(catatanPengirim1, style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black)),
                                                      ),
                                                      Expanded(
                                                        child: new Text(catatanSendiri1, style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black)),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.fromLTRB(16.0, 5.0, 16.0, 5.0),
                                                  child: Row(
                                                    children: <Widget>[
                                                      Expanded(
                                                        child: new Text("Tgl Tanggapan", style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black, fontWeight: FontWeight.bold)),
                                                      ),
                                                      Expanded(
                                                        child: new Text("Tgl Batas", style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black, fontWeight: FontWeight.bold)),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 5.0),
                                                  child: Row(
                                                    children: <Widget>[
                                                      Expanded(
                                                        child: new Text(tanggalTaggapan1, style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black)),
                                                      ),
                                                      Expanded(
                                                        child: new Text(tanggalBatas1, style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black)),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Container(
                                                  height: 10,
                                                ),
                                                new InkWell(
                                                  onTap: () {
                                                    Navigator.push(context, new MaterialPageRoute(builder: (BuildContext context) => new DetailCatatanTrackingMasuk(snapshot.data.childs[i].detail_catatan)));
                                                  },
                                                  child: new Container(
                                                      height: 42.0,
                                                      decoration: new BoxDecoration(
                                                        color: Colors.blueAccent,
                                                        border: new Border.all(color: Colors.white, width: 1.0),
                                                        borderRadius: new BorderRadius.circular(10.0),
                                                      ),
                                                      child: new Center(
                                                        child: Text('Detail Catatan', style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.white)),
                                                      )
                                                  ),
                                                ),
                                                new Separators(),
                                                ListView.builder(
                                                    scrollDirection: Axis.vertical,
                                                    shrinkWrap: true,
                                                    physics: ClampingScrollPhysics(),
                                                    itemCount: snapshot.data.childs[i].child.length,
                                                    itemBuilder: (BuildContext context, int ii) {
                                                      if (snapshot.data.childs[i].child[ii].child != null) {

                                                        String dari2;
                                                        String tanggalDikirim2;
                                                        String status2;
                                                        String read2;
                                                        String catatanPengirim2;
                                                        String catatanSendiri2;
                                                        String tanggalBatas2;
                                                        String tanggalTaggapan2;

                                                        if (snapshot.data.childs[i].child[ii].satker_dari == null || snapshot.data.childs[i].child[ii].satker_dari == "") {
                                                          dari2 = "-";
                                                        } else {
                                                          dari2 = snapshot.data.childs[i].child[ii].satker_dari;
                                                        }

                                                        if (snapshot.data.childs[i].child[ii].tgl_disposisi == null || snapshot.data.childs[i].child[ii].tgl_disposisi == "") {
                                                          tanggalDikirim2 = "-";
                                                        } else {
                                                          tanggalDikirim2 = snapshot.data.childs[i].child[ii].tgl_disposisi;
                                                        }

                                                        if (snapshot.data.childs[i].child[ii].status == null || snapshot.data.childs[i].child[ii].status == "") {
                                                          status2 = "-";
                                                        } else {
                                                          status2 = snapshot.data.childs[i].child[ii].status;
                                                        }

                                                        if (snapshot.data.childs[i].child[ii].read == null || snapshot.data.childs[i].child[ii].read == "") {
                                                          read2 = "-";
                                                        } else {
                                                          if (snapshot.data.childs[i].child[ii].read == "READ") {
                                                            read2 = "Sudah";
                                                          } else if (snapshot.data.childs[i].child[ii].read == "UNREAD") {
                                                            read2 = "Belum";
                                                          } else {
                                                            read2 = snapshot.data.childs[i].child[ii].read;
                                                          }
                                                        }

                                                        if (snapshot.data.childs[i].child[ii].catatan_pengirim == null || snapshot.data.childs[i].child[ii].catatan_pengirim == "") {
                                                          catatanPengirim2 = "-";
                                                        } else {
                                                          catatanPengirim2 = snapshot.data.childs[i].child[ii].catatan_pengirim;
                                                        }

                                                        if (snapshot.data.childs[i].child[ii].catatan_sendiri == null || snapshot.data.childs[i].child[ii].catatan_sendiri == "") {
                                                          catatanSendiri2 = "-";
                                                        } else {
                                                          catatanSendiri2 = snapshot.data.childs[i].child[ii].catatan_sendiri;
                                                        }

                                                        if (snapshot.data.childs[i].child[ii].tgl_tanggapan == null || snapshot.data.childs[i].child[ii].tgl_tanggapan == "") {
                                                          tanggalTaggapan2 = "-";
                                                        } else {
                                                          tanggalTaggapan2 = snapshot.data.childs[i].child[ii].tgl_tanggapan;
                                                        }

                                                        if (snapshot.data.childs[i].child[ii].tgl_batas == null || snapshot.data.childs[i].child[ii].tgl_batas == "") {
                                                          tanggalBatas2 = "-";
                                                        } else {
                                                          tanggalBatas2 = snapshot.data.childs[i].child[ii].tgl_batas;
                                                        }

                                                        return new ExpansionTile(
                                                            trailing: Icon(Icons.expand_more, color: Colors.black),
                                                            backgroundColor: Colors.white,
                                                            leading: new InkWell(
                                                              child: CircleAvatar(
                                                                  backgroundColor: Colors.orange,
                                                                  radius: 16.0,
                                                                  child: new Icon(Icons.message, color: Colors.white, size: 16.0)
                                                              ),
                                                            ),
                                                            title: new Text(snapshot.data.childs[i].child[ii].satker_name, style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 16.0, color: Colors.black)),
                                                            children: [
                                                              Column(
                                                                children: <Widget>[
                                                                  Padding(
                                                                    padding: EdgeInsets.fromLTRB(16.0, 5.0, 16.0, 5.0),
                                                                    child: Row(
                                                                      children: <Widget>[
                                                                        Expanded(
                                                                          child: new Text("Dari", style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black, fontWeight: FontWeight.bold)),
                                                                        ),
                                                                        Expanded(
                                                                          child: new Text("Tgl Dikirim", style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black, fontWeight: FontWeight.bold)),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  Padding(
                                                                    padding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 5.0),
                                                                    child: Row(
                                                                      children: <Widget>[
                                                                        Expanded(
                                                                          child: new Text(dari2, style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black)),
                                                                        ),
                                                                        Expanded(
                                                                          child: new Text(tanggalDikirim2, style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black)),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  Padding(
                                                                    padding: EdgeInsets.fromLTRB(16.0, 5.0, 16.0, 5.0),
                                                                    child: Row(
                                                                      children: <Widget>[
                                                                        Expanded(
                                                                          child: new Text("Status", style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black, fontWeight: FontWeight.bold)),
                                                                        ),
                                                                        Expanded(
                                                                          child: new Text("Dibaca", style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black, fontWeight: FontWeight.bold)),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  Padding(
                                                                    padding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 5.0),
                                                                    child: Row(
                                                                      children: <Widget>[
                                                                        Expanded(
                                                                          child: new Text(status2, style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black)),
                                                                        ),
                                                                        Expanded(
                                                                          child: new Text(read2, style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black)),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  Padding(
                                                                    padding: EdgeInsets.fromLTRB(16.0, 5.0, 16.0, 5.0),
                                                                    child: Row(
                                                                      children: <Widget>[
                                                                        Expanded(
                                                                          child: new Text("Catatan Pengirim", style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black, fontWeight: FontWeight.bold)),
                                                                        ),
                                                                        Expanded(
                                                                          child: new Text("Catatan Sendiri", style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black, fontWeight: FontWeight.bold)),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  Padding(
                                                                    padding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 5.0),
                                                                    child: Row(
                                                                      children: <Widget>[
                                                                        Expanded(
                                                                          child: new Text(catatanPengirim2, style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black)),
                                                                        ),
                                                                        Expanded(
                                                                          child: new Text(catatanSendiri2, style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black)),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  Padding(
                                                                    padding: EdgeInsets.fromLTRB(16.0, 5.0, 16.0, 5.0),
                                                                    child: Row(
                                                                      children: <Widget>[
                                                                        Expanded(
                                                                          child: new Text("Tgl Tanggapan", style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black, fontWeight: FontWeight.bold)),
                                                                        ),
                                                                        Expanded(
                                                                          child: new Text("Tgl Batas", style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black, fontWeight: FontWeight.bold)),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  Padding(
                                                                    padding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 5.0),
                                                                    child: Row(
                                                                      children: <Widget>[
                                                                        Expanded(
                                                                          child: new Text(tanggalTaggapan2, style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black)),
                                                                        ),
                                                                        Expanded(
                                                                          child: new Text(tanggalBatas2, style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black)),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  Container(
                                                                    height: 10,
                                                                  ),
                                                                  new InkWell(
                                                                    onTap: () {
                                                                      Navigator.push(context, new MaterialPageRoute(builder: (BuildContext context) => new DetailCatatanTrackingMasuk(snapshot.data.childs[i].child[ii].detail_catatan)));
                                                                    },
                                                                    child: new Container(
                                                                        height: 42.0,
                                                                        decoration: new BoxDecoration(
                                                                          color: Colors.blueAccent,
                                                                          border: new Border.all(color: Colors.white, width: 1.0),
                                                                          borderRadius: new BorderRadius.circular(10.0),
                                                                        ),
                                                                        child: new Center(
                                                                          child: Text('Detail Catatan', style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.white)),
                                                                        )
                                                                    ),
                                                                  ),
                                                                  new Separators(),
                                                                  ListView.builder(
                                                                      scrollDirection: Axis.vertical,
                                                                      shrinkWrap: true,
                                                                      physics: ClampingScrollPhysics(),
                                                                      itemCount: snapshot.data.childs[i].child[ii].child.length,
                                                                      itemBuilder: (BuildContext context, int iii) {
                                                                        if (snapshot.data.childs[i].child[ii].child[iii].child != null) {

                                                                          String dari3;
                                                                          String tanggalDikirim3;
                                                                          String status3;
                                                                          String read3;
                                                                          String catatanPengirim3;
                                                                          String catatanSendiri3;
                                                                          String tanggalBatas3;
                                                                          String tanggalTaggapan3;

                                                                          if (snapshot.data.childs[i].child[ii].child[iii].satker_dari == null || snapshot.data.childs[i].child[ii].child[iii].satker_dari == "") {
                                                                            dari3 = "-";
                                                                          } else {
                                                                            dari3 = snapshot.data.childs[i].child[ii].child[iii].satker_dari;
                                                                          }

                                                                          if (snapshot.data.childs[i].child[ii].child[iii].tgl_disposisi == null || snapshot.data.childs[i].child[ii].child[iii].tgl_disposisi == "") {
                                                                            tanggalDikirim3 = "-";
                                                                          } else {
                                                                            tanggalDikirim3 = snapshot.data.childs[i].child[ii].child[iii].tgl_disposisi;
                                                                          }

                                                                          if (snapshot.data.childs[i].child[ii].child[iii].status == null || snapshot.data.childs[i].child[ii].child[iii].status == "") {
                                                                            status3 = "-";
                                                                          } else {
                                                                            status3 = snapshot.data.childs[i].child[ii].child[iii].status;
                                                                          }

                                                                          if (snapshot.data.childs[i].child[ii].child[iii].read == null || snapshot.data.childs[i].child[ii].child[iii].read == "") {
                                                                            read3 = "-";
                                                                          } else {
                                                                            if (snapshot.data.childs[i].child[ii].child[iii].read == "READ") {
                                                                              read3 = "Sudah";
                                                                            } else if (snapshot.data.childs[i].child[ii].child[iii].read == "UNREAD") {
                                                                              read3 = "Belum";
                                                                            } else {
                                                                              read3 = snapshot.data.childs[i].child[ii].child[iii].read;
                                                                            }
                                                                          }

                                                                          if (snapshot.data.childs[i].child[ii].child[iii].catatan_pengirim == null || snapshot.data.childs[i].child[ii].child[iii].catatan_pengirim == "") {
                                                                            catatanPengirim3 = "-";
                                                                          } else {
                                                                            catatanPengirim3 = snapshot.data.childs[i].child[ii].child[iii].catatan_pengirim;
                                                                          }

                                                                          if (snapshot.data.childs[i].child[ii].child[iii].catatan_sendiri == null || snapshot.data.childs[i].child[ii].child[iii].catatan_sendiri == "") {
                                                                            catatanSendiri3 = "-";
                                                                          } else {
                                                                            catatanSendiri3 = snapshot.data.childs[i].child[ii].child[iii].catatan_sendiri;
                                                                          }

                                                                          if (snapshot.data.childs[i].child[ii].child[iii].tgl_tanggapan == null || snapshot.data.childs[i].child[ii].child[iii].tgl_tanggapan == "") {
                                                                            tanggalTaggapan3 = "-";
                                                                          } else {
                                                                            tanggalTaggapan3 = snapshot.data.childs[i].child[ii].child[iii].tgl_tanggapan;
                                                                          }

                                                                          if (snapshot.data.childs[i].child[ii].child[iii].tgl_batas == null || snapshot.data.childs[i].child[ii].child[iii].tgl_batas == "") {
                                                                            tanggalBatas3 = "-";
                                                                          } else {
                                                                            tanggalBatas3 = snapshot.data.childs[i].child[ii].child[iii].tgl_batas;
                                                                          }

                                                                          return new ExpansionTile(
                                                                              trailing: Icon(Icons.expand_more, color: Colors.black),
                                                                              backgroundColor: Colors.white,
                                                                              leading: new InkWell(
                                                                                child: CircleAvatar(
                                                                                    backgroundColor: Colors.orange,
                                                                                    radius: 16.0,
                                                                                    child: new Icon(Icons.message, color: Colors.white, size: 16.0)
                                                                                ),
                                                                              ),
                                                                              title: new Text(snapshot.data.childs[i].child[ii].child[iii].satker_name, style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 16.0, color: Colors.black)),
                                                                              children: [
                                                                                Column(
                                                                                  children: <Widget>[
                                                                                    Padding(
                                                                                      padding: EdgeInsets.fromLTRB(16.0, 5.0, 16.0, 5.0),
                                                                                      child: Row(
                                                                                        children: <Widget>[
                                                                                          Expanded(
                                                                                            child: new Text("Dari", style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black, fontWeight: FontWeight.bold)),
                                                                                          ),
                                                                                          Expanded(
                                                                                            child: new Text("Tgl Dikirim", style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black, fontWeight: FontWeight.bold)),
                                                                                          ),
                                                                                        ],
                                                                                      ),
                                                                                    ),
                                                                                    Padding(
                                                                                      padding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 5.0),
                                                                                      child: Row(
                                                                                        children: <Widget>[
                                                                                          Expanded(
                                                                                            child: new Text(dari3, style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black)),
                                                                                          ),
                                                                                          Expanded(
                                                                                            child: new Text(tanggalDikirim3, style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black)),
                                                                                          ),
                                                                                        ],
                                                                                      ),
                                                                                    ),
                                                                                    Padding(
                                                                                      padding: EdgeInsets.fromLTRB(16.0, 5.0, 16.0, 5.0),
                                                                                      child: Row(
                                                                                        children: <Widget>[
                                                                                          Expanded(
                                                                                            child: new Text("Status", style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black, fontWeight: FontWeight.bold)),
                                                                                          ),
                                                                                          Expanded(
                                                                                            child: new Text("Dibaca", style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black, fontWeight: FontWeight.bold)),
                                                                                          ),
                                                                                        ],
                                                                                      ),
                                                                                    ),
                                                                                    Padding(
                                                                                      padding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 5.0),
                                                                                      child: Row(
                                                                                        children: <Widget>[
                                                                                          Expanded(
                                                                                            child: new Text(status3, style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black)),
                                                                                          ),
                                                                                          Expanded(
                                                                                            child: new Text(read3, style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black)),
                                                                                          ),
                                                                                        ],
                                                                                      ),
                                                                                    ),
                                                                                    Padding(
                                                                                      padding: EdgeInsets.fromLTRB(16.0, 5.0, 16.0, 5.0),
                                                                                      child: Row(
                                                                                        children: <Widget>[
                                                                                          Expanded(
                                                                                            child: new Text("Catatan Pengirim", style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black, fontWeight: FontWeight.bold)),
                                                                                          ),
                                                                                          Expanded(
                                                                                            child: new Text("Catatan Sendiri", style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black, fontWeight: FontWeight.bold)),
                                                                                          ),
                                                                                        ],
                                                                                      ),
                                                                                    ),
                                                                                    Padding(
                                                                                      padding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 5.0),
                                                                                      child: Row(
                                                                                        children: <Widget>[
                                                                                          Expanded(
                                                                                            child: new Text(catatanPengirim3, style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black)),
                                                                                          ),
                                                                                          Expanded(
                                                                                            child: new Text(catatanSendiri3, style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black)),
                                                                                          ),
                                                                                        ],
                                                                                      ),
                                                                                    ),
                                                                                    Padding(
                                                                                      padding: EdgeInsets.fromLTRB(16.0, 5.0, 16.0, 5.0),
                                                                                      child: Row(
                                                                                        children: <Widget>[
                                                                                          Expanded(
                                                                                            child: new Text("Tgl Tanggapan", style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black, fontWeight: FontWeight.bold)),
                                                                                          ),
                                                                                          Expanded(
                                                                                            child: new Text("Tgl Batas", style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black, fontWeight: FontWeight.bold)),
                                                                                          ),
                                                                                        ],
                                                                                      ),
                                                                                    ),
                                                                                    Padding(
                                                                                      padding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 5.0),
                                                                                      child: Row(
                                                                                        children: <Widget>[
                                                                                          Expanded(
                                                                                            child: new Text(tanggalTaggapan3, style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black)),
                                                                                          ),
                                                                                          Expanded(
                                                                                            child: new Text(tanggalBatas3, style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black)),
                                                                                          ),
                                                                                        ],
                                                                                      ),
                                                                                    ),
                                                                                    Container(
                                                                                      height: 10,
                                                                                    ),
                                                                                    new InkWell(
                                                                                      onTap: () {
                                                                                        Navigator.push(context, new MaterialPageRoute(builder: (BuildContext context) => new DetailCatatanTrackingMasuk(snapshot.data.childs[i].child[ii].child[iii].detail_catatan)));
                                                                                      },
                                                                                      child: new Container(
                                                                                          height: 42.0,
                                                                                          decoration: new BoxDecoration(
                                                                                            color: Colors.blueAccent,
                                                                                            border: new Border.all(color: Colors.white, width: 1.0),
                                                                                            borderRadius: new BorderRadius.circular(10.0),
                                                                                          ),
                                                                                          child: new Center(
                                                                                            child: Text('Detail Catatan', style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.white)),
                                                                                          )
                                                                                      ),
                                                                                    ),
                                                                                    new Separators(),
                                                                                    ListView.builder(
                                                                                        scrollDirection: Axis.vertical,
                                                                                        shrinkWrap: true,
                                                                                        physics: ClampingScrollPhysics(),
                                                                                        itemCount: snapshot.data.childs[i].child[ii].child[iii].child.length,
                                                                                        itemBuilder: (BuildContext context, int iv) {
                                                                                          if (snapshot.data.childs[i].child[ii].child[iii].child[iv].child != null) {

                                                                                            String dari4;
                                                                                            String tanggalDikirim4;
                                                                                            String status4;
                                                                                            String read4;
                                                                                            String catatanPengirim4;
                                                                                            String catatanSendiri4;
                                                                                            String tanggalBatas4;
                                                                                            String tanggalTaggapan4;

                                                                                            if (snapshot.data.childs[i].child[ii].child[iii].child[iv].satker_dari == null || snapshot.data.childs[i].child[ii].child[iii].child[iv].satker_dari == "") {
                                                                                              dari4 = "-";
                                                                                            } else {
                                                                                              dari4 = snapshot.data.childs[i].child[ii].child[iii].child[iv].satker_dari;
                                                                                            }

                                                                                            if (snapshot.data.childs[i].child[ii].child[iii].child[iv].tgl_disposisi == null || snapshot.data.childs[i].child[ii].child[iii].child[iv].tgl_disposisi == "") {
                                                                                              tanggalDikirim4 = "-";
                                                                                            } else {
                                                                                              tanggalDikirim4 = snapshot.data.childs[i].child[ii].child[iii].child[iv].tgl_disposisi;
                                                                                            }

                                                                                            if (snapshot.data.childs[i].child[ii].child[iii].child[iv].status == null || snapshot.data.childs[i].child[ii].child[iii].child[iv].status == "") {
                                                                                              status4 = "-";
                                                                                            } else {
                                                                                              status4 = snapshot.data.childs[i].child[ii].child[iii].child[iv].status;
                                                                                            }

                                                                                            if (snapshot.data.childs[i].child[ii].child[iii].child[iv].read == null || snapshot.data.childs[i].child[ii].child[iii].child[iv].read == "") {
                                                                                              read4 = "-";
                                                                                            } else {
                                                                                              if (snapshot.data.childs[i].child[ii].child[iii].child[iv].read == "READ") {
                                                                                                read4 = "Sudah";
                                                                                              } else if (snapshot.data.childs[i].child[ii].child[iii].child[iv].read == "UNREAD") {
                                                                                                read4 = "Belum";
                                                                                              } else {
                                                                                                read4 = snapshot.data.childs[i].child[ii].child[iii].child[iv].read;
                                                                                              }
                                                                                            }

                                                                                            if (snapshot.data.childs[i].child[ii].child[iii].child[iv].catatan_pengirim == null || snapshot.data.childs[i].child[ii].child[iii].child[iv].catatan_pengirim == "") {
                                                                                              catatanPengirim4 = "-";
                                                                                            } else {
                                                                                              catatanPengirim4 = snapshot.data.childs[i].child[ii].child[iii].child[iv].catatan_pengirim;
                                                                                            }

                                                                                            if (snapshot.data.childs[i].child[ii].child[iii].child[iv].catatan_sendiri == null || snapshot.data.childs[i].child[ii].child[iii].child[iv].catatan_sendiri == "") {
                                                                                              catatanSendiri4 = "-";
                                                                                            } else {
                                                                                              catatanSendiri4 = snapshot.data.childs[i].child[ii].child[iii].child[iv].catatan_sendiri;
                                                                                            }

                                                                                            if (snapshot.data.childs[i].child[ii].child[iii].child[iv].tgl_tanggapan == null || snapshot.data.childs[i].child[ii].child[iii].child[iv].tgl_tanggapan == "") {
                                                                                              tanggalTaggapan4 = "-";
                                                                                            } else {
                                                                                              tanggalTaggapan4 = snapshot.data.childs[i].child[ii].child[iii].child[iv].tgl_tanggapan;
                                                                                            }

                                                                                            if (snapshot.data.childs[i].child[ii].child[iii].child[iv].tgl_batas == null || snapshot.data.childs[i].child[ii].child[iii].child[iv].tgl_batas == "") {
                                                                                              tanggalBatas4 = "-";
                                                                                            } else {
                                                                                              tanggalBatas4 = snapshot.data.childs[i].child[ii].child[iii].child[iv].tgl_batas;
                                                                                            }

                                                                                            return new ExpansionTile(
                                                                                                trailing: Icon(Icons.expand_more, color: Colors.black),
                                                                                                backgroundColor: Colors.white,
                                                                                                leading: new InkWell(
                                                                                                  child: CircleAvatar(
                                                                                                      backgroundColor: Colors.orange,
                                                                                                      radius: 16.0,
                                                                                                      child: new Icon(Icons.message, color: Colors.white, size: 16.0)
                                                                                                  ),
                                                                                                ),
                                                                                                title: new Text(snapshot.data.childs[i].child[ii].child[iii].child[iv].satker_name, style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 16.0, color: Colors.black)),
                                                                                                children: [
                                                                                                  Column(
                                                                                                    children: <Widget>[
                                                                                                      Padding(
                                                                                                        padding: EdgeInsets.fromLTRB(16.0, 5.0, 16.0, 5.0),
                                                                                                        child: Row(
                                                                                                          children: <Widget>[
                                                                                                            Expanded(
                                                                                                              child: new Text("Dari", style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black, fontWeight: FontWeight.bold)),
                                                                                                            ),
                                                                                                            Expanded(
                                                                                                              child: new Text("Tgl Dikirim", style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black, fontWeight: FontWeight.bold)),
                                                                                                            ),
                                                                                                          ],
                                                                                                        ),
                                                                                                      ),
                                                                                                      Padding(
                                                                                                        padding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 5.0),
                                                                                                        child: Row(
                                                                                                          children: <Widget>[
                                                                                                            Expanded(
                                                                                                              child: new Text(dari4, style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black)),
                                                                                                            ),
                                                                                                            Expanded(
                                                                                                              child: new Text(tanggalDikirim4, style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black)),
                                                                                                            ),
                                                                                                          ],
                                                                                                        ),
                                                                                                      ),
                                                                                                      Padding(
                                                                                                        padding: EdgeInsets.fromLTRB(16.0, 5.0, 16.0, 5.0),
                                                                                                        child: Row(
                                                                                                          children: <Widget>[
                                                                                                            Expanded(
                                                                                                              child: new Text("Status", style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black, fontWeight: FontWeight.bold)),
                                                                                                            ),
                                                                                                            Expanded(
                                                                                                              child: new Text("Dibaca", style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black, fontWeight: FontWeight.bold)),
                                                                                                            ),
                                                                                                          ],
                                                                                                        ),
                                                                                                      ),
                                                                                                      Padding(
                                                                                                        padding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 5.0),
                                                                                                        child: Row(
                                                                                                          children: <Widget>[
                                                                                                            Expanded(
                                                                                                              child: new Text(status4, style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black)),
                                                                                                            ),
                                                                                                            Expanded(
                                                                                                              child: new Text(read4, style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black)),
                                                                                                            ),
                                                                                                          ],
                                                                                                        ),
                                                                                                      ),
                                                                                                      Padding(
                                                                                                        padding: EdgeInsets.fromLTRB(16.0, 5.0, 16.0, 5.0),
                                                                                                        child: Row(
                                                                                                          children: <Widget>[
                                                                                                            Expanded(
                                                                                                              child: new Text("Catatan Pengirim", style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black, fontWeight: FontWeight.bold)),
                                                                                                            ),
                                                                                                            Expanded(
                                                                                                              child: new Text("Catatan Sendiri", style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black, fontWeight: FontWeight.bold)),
                                                                                                            ),
                                                                                                          ],
                                                                                                        ),
                                                                                                      ),
                                                                                                      Padding(
                                                                                                        padding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 5.0),
                                                                                                        child: Row(
                                                                                                          children: <Widget>[
                                                                                                            Expanded(
                                                                                                              child: new Text(catatanPengirim4, style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black)),
                                                                                                            ),
                                                                                                            Expanded(
                                                                                                              child: new Text(catatanSendiri4, style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black)),
                                                                                                            ),
                                                                                                          ],
                                                                                                        ),
                                                                                                      ),
                                                                                                      Padding(
                                                                                                        padding: EdgeInsets.fromLTRB(16.0, 5.0, 16.0, 5.0),
                                                                                                        child: Row(
                                                                                                          children: <Widget>[
                                                                                                            Expanded(
                                                                                                              child: new Text("Tgl Tanggapan", style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black, fontWeight: FontWeight.bold)),
                                                                                                            ),
                                                                                                            Expanded(
                                                                                                              child: new Text("Tgl Batas", style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black, fontWeight: FontWeight.bold)),
                                                                                                            ),
                                                                                                          ],
                                                                                                        ),
                                                                                                      ),
                                                                                                      Padding(
                                                                                                        padding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 5.0),
                                                                                                        child: Row(
                                                                                                          children: <Widget>[
                                                                                                            Expanded(
                                                                                                              child: new Text(tanggalTaggapan4, style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black)),
                                                                                                            ),
                                                                                                            Expanded(
                                                                                                              child: new Text(tanggalBatas4, style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black)),
                                                                                                            ),
                                                                                                          ],
                                                                                                        ),
                                                                                                      ),
                                                                                                      Container(
                                                                                                        height: 10,
                                                                                                      ),
                                                                                                      new InkWell(
                                                                                                        onTap: () {
                                                                                                          Navigator.push(context, new MaterialPageRoute(builder: (BuildContext context) => new DetailCatatanTrackingMasuk(snapshot.data.childs[i].child[ii].child[iii].child[iv].detail_catatan)));
                                                                                                        },
                                                                                                        child: new Container(
                                                                                                            height: 42.0,
                                                                                                            decoration: new BoxDecoration(
                                                                                                              color: Colors.blueAccent,
                                                                                                              border: new Border.all(color: Colors.white, width: 1.0),
                                                                                                              borderRadius: new BorderRadius.circular(10.0),
                                                                                                            ),
                                                                                                            child: new Center(
                                                                                                              child: Text('Detail Catatan', style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.white)),
                                                                                                            )
                                                                                                        ),
                                                                                                      ),
                                                                                                      new Separators(),
                                                                                                      ListView.builder(
                                                                                                          scrollDirection: Axis.vertical,
                                                                                                          shrinkWrap: true,
                                                                                                          physics: ClampingScrollPhysics(),
                                                                                                          itemCount: snapshot.data.childs[i].child[ii].child[iii].child[iv].child.length,
                                                                                                          itemBuilder: (BuildContext context, int v) {

                                                                                                            if (snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].child != null) {

                                                                                                              String dari5;
                                                                                                              String tanggalDikirim5;
                                                                                                              String status5;
                                                                                                              String read5;
                                                                                                              String catatanPengirim5;
                                                                                                              String catatanSendiri5;
                                                                                                              String tanggalBatas5;
                                                                                                              String tanggalTaggapan5;

                                                                                                              if (snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].satker_dari == null || snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].satker_dari == "") {
                                                                                                                dari5 = "-";
                                                                                                              } else {
                                                                                                                dari5 = snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].satker_dari;
                                                                                                              }

                                                                                                              if (snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].tgl_disposisi == null || snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].tgl_disposisi == "") {
                                                                                                                tanggalDikirim5 = "-";
                                                                                                              } else {
                                                                                                                tanggalDikirim5 = snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].tgl_disposisi;
                                                                                                              }

                                                                                                              if (snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].status == null || snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].status == "") {
                                                                                                                status5 = "-";
                                                                                                              } else {
                                                                                                                status5 = snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].status;
                                                                                                              }

                                                                                                              if (snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].read == null || snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].read == "") {
                                                                                                                read5 = "-";
                                                                                                              } else {
                                                                                                                if (snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].read == "READ") {
                                                                                                                  read5 = "Sudah";
                                                                                                                } else if (snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].read == "UNREAD") {
                                                                                                                  read5 = "Belum";
                                                                                                                } else {
                                                                                                                  read5 = snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].read;
                                                                                                                }
                                                                                                              }

                                                                                                              if (snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].catatan_pengirim == null || snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].catatan_pengirim == "") {
                                                                                                                catatanPengirim5 = "-";
                                                                                                              } else {
                                                                                                                catatanPengirim5 = snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].catatan_pengirim;
                                                                                                              }

                                                                                                              if (snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].catatan_sendiri == null || snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].catatan_sendiri == "") {
                                                                                                                catatanSendiri5 = "-";
                                                                                                              } else {
                                                                                                                catatanSendiri5 = snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].catatan_sendiri;
                                                                                                              }

                                                                                                              if (snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].tgl_tanggapan == null || snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].tgl_tanggapan == "") {
                                                                                                                tanggalTaggapan5 = "-";
                                                                                                              } else {
                                                                                                                tanggalTaggapan5 = snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].tgl_tanggapan;
                                                                                                              }

                                                                                                              if (snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].tgl_batas == null || snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].tgl_batas == "") {
                                                                                                                tanggalBatas5 = "-";
                                                                                                              } else {
                                                                                                                tanggalBatas5 = snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].tgl_batas;
                                                                                                              }

                                                                                                              return new ExpansionTile(
                                                                                                                  trailing: Icon(Icons.expand_more, color: Colors.black),
                                                                                                                  backgroundColor: Colors.white,
                                                                                                                  leading: new InkWell(
                                                                                                                    child: CircleAvatar(
                                                                                                                        backgroundColor: Colors.orange,
                                                                                                                        radius: 16.0,
                                                                                                                        child: new Icon(Icons.message, color: Colors.white, size: 16.0)
                                                                                                                    ),
                                                                                                                  ),
                                                                                                                  title: new Text(snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].satker_name, style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 16.0, color: Colors.black)),
                                                                                                                  children: [
                                                                                                                    Column(
                                                                                                                      children: <Widget>[
                                                                                                                        Padding(
                                                                                                                          padding: EdgeInsets.fromLTRB(16.0, 5.0, 16.0, 5.0),
                                                                                                                          child: Row(
                                                                                                                            children: <Widget>[
                                                                                                                              Expanded(
                                                                                                                                child: new Text("Dari", style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black, fontWeight: FontWeight.bold)),
                                                                                                                              ),
                                                                                                                              Expanded(
                                                                                                                                child: new Text("Tgl Dikirim", style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black, fontWeight: FontWeight.bold)),
                                                                                                                              ),
                                                                                                                            ],
                                                                                                                          ),
                                                                                                                        ),
                                                                                                                        Padding(
                                                                                                                          padding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 5.0),
                                                                                                                          child: Row(
                                                                                                                            children: <Widget>[
                                                                                                                              Expanded(
                                                                                                                                child: new Text(dari5, style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black)),
                                                                                                                              ),
                                                                                                                              Expanded(
                                                                                                                                child: new Text(tanggalDikirim5, style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black)),
                                                                                                                              ),
                                                                                                                            ],
                                                                                                                          ),
                                                                                                                        ),
                                                                                                                        Padding(
                                                                                                                          padding: EdgeInsets.fromLTRB(16.0, 5.0, 16.0, 5.0),
                                                                                                                          child: Row(
                                                                                                                            children: <Widget>[
                                                                                                                              Expanded(
                                                                                                                                child: new Text("Status", style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black, fontWeight: FontWeight.bold)),
                                                                                                                              ),
                                                                                                                              Expanded(
                                                                                                                                child: new Text("Dibaca", style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black, fontWeight: FontWeight.bold)),
                                                                                                                              ),
                                                                                                                            ],
                                                                                                                          ),
                                                                                                                        ),
                                                                                                                        Padding(
                                                                                                                          padding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 5.0),
                                                                                                                          child: Row(
                                                                                                                            children: <Widget>[
                                                                                                                              Expanded(
                                                                                                                                child: new Text(status5, style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black)),
                                                                                                                              ),
                                                                                                                              Expanded(
                                                                                                                                child: new Text(read5, style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black)),
                                                                                                                              ),
                                                                                                                            ],
                                                                                                                          ),
                                                                                                                        ),
                                                                                                                        Padding(
                                                                                                                          padding: EdgeInsets.fromLTRB(16.0, 5.0, 16.0, 5.0),
                                                                                                                          child: Row(
                                                                                                                            children: <Widget>[
                                                                                                                              Expanded(
                                                                                                                                child: new Text("Catatan Pengirim", style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black, fontWeight: FontWeight.bold)),
                                                                                                                              ),
                                                                                                                              Expanded(
                                                                                                                                child: new Text("Catatan Sendiri", style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black, fontWeight: FontWeight.bold)),
                                                                                                                              ),
                                                                                                                            ],
                                                                                                                          ),
                                                                                                                        ),
                                                                                                                        Padding(
                                                                                                                          padding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 5.0),
                                                                                                                          child: Row(
                                                                                                                            children: <Widget>[
                                                                                                                              Expanded(
                                                                                                                                child: new Text(catatanPengirim5, style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black)),
                                                                                                                              ),
                                                                                                                              Expanded(
                                                                                                                                child: new Text(catatanSendiri5, style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black)),
                                                                                                                              ),
                                                                                                                            ],
                                                                                                                          ),
                                                                                                                        ),
                                                                                                                        Padding(
                                                                                                                          padding: EdgeInsets.fromLTRB(16.0, 5.0, 16.0, 5.0),
                                                                                                                          child: Row(
                                                                                                                            children: <Widget>[
                                                                                                                              Expanded(
                                                                                                                                child: new Text("Tgl Tanggapan", style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black, fontWeight: FontWeight.bold)),
                                                                                                                              ),
                                                                                                                              Expanded(
                                                                                                                                child: new Text("Tgl Batas", style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black, fontWeight: FontWeight.bold)),
                                                                                                                              ),
                                                                                                                            ],
                                                                                                                          ),
                                                                                                                        ),
                                                                                                                        Padding(
                                                                                                                          padding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 5.0),
                                                                                                                          child: Row(
                                                                                                                            children: <Widget>[
                                                                                                                              Expanded(
                                                                                                                                child: new Text(tanggalTaggapan5, style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black)),
                                                                                                                              ),
                                                                                                                              Expanded(
                                                                                                                                child: new Text(tanggalBatas5, style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black)),
                                                                                                                              ),
                                                                                                                            ],
                                                                                                                          ),
                                                                                                                        ),
                                                                                                                        Container(
                                                                                                                          height: 10,
                                                                                                                        ),
                                                                                                                        new InkWell(
                                                                                                                          onTap: () {
                                                                                                                            Navigator.push(context, new MaterialPageRoute(builder: (BuildContext context) => new DetailCatatanTrackingMasuk(snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].detail_catatan)));
                                                                                                                          },
                                                                                                                          child: new Container(
                                                                                                                              height: 42.0,
                                                                                                                              decoration: new BoxDecoration(
                                                                                                                                color: Colors.blueAccent,
                                                                                                                                border: new Border.all(color: Colors.white, width: 1.0),
                                                                                                                                borderRadius: new BorderRadius.circular(10.0),
                                                                                                                              ),
                                                                                                                              child: new Center(
                                                                                                                                child: Text('Detail Catatan', style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.white)),
                                                                                                                              )
                                                                                                                          ),
                                                                                                                        ),
                                                                                                                        new Separators(),
                                                                                                                        ListView.builder(
                                                                                                                            scrollDirection: Axis.vertical,
                                                                                                                            shrinkWrap: true,
                                                                                                                            physics: ClampingScrollPhysics(),
                                                                                                                            itemCount: snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].child.length,
                                                                                                                            itemBuilder: (BuildContext context, int vi) {

                                                                                                                              if (snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].child[vi].child != null) {

                                                                                                                                String dari6;
                                                                                                                                String tanggalDikirim6;
                                                                                                                                String status6;
                                                                                                                                String read6;
                                                                                                                                String catatanPengirim6;
                                                                                                                                String catatanSendiri6;
                                                                                                                                String tanggalBatas6;
                                                                                                                                String tanggalTaggapan6;

                                                                                                                                if (snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].child[vi].satker_dari == null || snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].child[vi].satker_dari == "") {
                                                                                                                                  dari6 = "-";
                                                                                                                                } else {
                                                                                                                                  dari6 = snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].child[vi].satker_dari;
                                                                                                                                }

                                                                                                                                if (snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].child[vi].tgl_disposisi == null || snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].child[vi].tgl_disposisi == "") {
                                                                                                                                  tanggalDikirim6 = "-";
                                                                                                                                } else {
                                                                                                                                  tanggalDikirim6 = snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].child[vi].tgl_disposisi;
                                                                                                                                }

                                                                                                                                if (snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].child[vi].status == null || snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].child[vi].status == "") {
                                                                                                                                  status6 = "-";
                                                                                                                                } else {
                                                                                                                                  status6 = snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].child[vi].status;
                                                                                                                                }

                                                                                                                                if (snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].child[vi].read == null || snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].child[vi].read == "") {
                                                                                                                                  read6 = "-";
                                                                                                                                } else {
                                                                                                                                  if (snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].child[vi].read == "READ") {
                                                                                                                                    read6 = "Sudah";
                                                                                                                                  } else if (snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].child[vi].read == "UNREAD") {
                                                                                                                                    read6 = "Belum";
                                                                                                                                  } else {
                                                                                                                                    read6 = snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].child[vi].read;
                                                                                                                                  }
                                                                                                                                }

                                                                                                                                if (snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].child[vi].catatan_pengirim == null || snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].child[vi].catatan_pengirim == "") {
                                                                                                                                  catatanPengirim6 = "-";
                                                                                                                                } else {
                                                                                                                                  catatanPengirim6 = snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].child[vi].catatan_pengirim;
                                                                                                                                }

                                                                                                                                if (snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].child[vi].catatan_sendiri == null || snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].child[vi].catatan_sendiri == "") {
                                                                                                                                  catatanSendiri6 = "-";
                                                                                                                                } else {
                                                                                                                                  catatanSendiri6 = snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].child[vi].catatan_sendiri;
                                                                                                                                }

                                                                                                                                if (snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].child[vi].tgl_tanggapan == null || snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].child[vi].tgl_tanggapan == "") {
                                                                                                                                  tanggalTaggapan6 = "-";
                                                                                                                                } else {
                                                                                                                                  tanggalTaggapan6 = snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].child[vi].tgl_tanggapan;
                                                                                                                                }

                                                                                                                                if (snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].child[vi].tgl_batas == null || snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].child[vi].tgl_batas == "") {
                                                                                                                                  tanggalBatas6 = "-";
                                                                                                                                } else {
                                                                                                                                  tanggalBatas6 = snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].child[vi].tgl_batas;
                                                                                                                                }

                                                                                                                                return new ExpansionTile(
                                                                                                                                    trailing: Icon(Icons.expand_more, color: Colors.black),
                                                                                                                                    backgroundColor: Colors.white,
                                                                                                                                    leading: new InkWell(
                                                                                                                                      child: CircleAvatar(
                                                                                                                                          backgroundColor: Colors.orange,
                                                                                                                                          radius: 16.0,
                                                                                                                                          child: new Icon(Icons.message, color: Colors.white, size: 16.0)
                                                                                                                                      ),
                                                                                                                                    ),
                                                                                                                                    title: new Text(snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].child[vi].satker_name, style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 16.0, color: Colors.black)),
                                                                                                                                    children: [
                                                                                                                                      Column(
                                                                                                                                        children: <Widget>[
                                                                                                                                          Padding(
                                                                                                                                            padding: EdgeInsets.fromLTRB(16.0, 5.0, 16.0, 5.0),
                                                                                                                                            child: Row(
                                                                                                                                              children: <Widget>[
                                                                                                                                                Expanded(
                                                                                                                                                  child: new Text("Dari", style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black, fontWeight: FontWeight.bold)),
                                                                                                                                                ),
                                                                                                                                                Expanded(
                                                                                                                                                  child: new Text("Tgl Dikirim", style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black, fontWeight: FontWeight.bold)),
                                                                                                                                                ),
                                                                                                                                              ],
                                                                                                                                            ),
                                                                                                                                          ),
                                                                                                                                          Padding(
                                                                                                                                            padding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 5.0),
                                                                                                                                            child: Row(
                                                                                                                                              children: <Widget>[
                                                                                                                                                Expanded(
                                                                                                                                                  child: new Text(dari6, style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black)),
                                                                                                                                                ),
                                                                                                                                                Expanded(
                                                                                                                                                  child: new Text(tanggalDikirim6, style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black)),
                                                                                                                                                ),
                                                                                                                                              ],
                                                                                                                                            ),
                                                                                                                                          ),
                                                                                                                                          Padding(
                                                                                                                                            padding: EdgeInsets.fromLTRB(16.0, 5.0, 16.0, 5.0),
                                                                                                                                            child: Row(
                                                                                                                                              children: <Widget>[
                                                                                                                                                Expanded(
                                                                                                                                                  child: new Text("Status", style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black, fontWeight: FontWeight.bold)),
                                                                                                                                                ),
                                                                                                                                                Expanded(
                                                                                                                                                  child: new Text("Dibaca", style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black, fontWeight: FontWeight.bold)),
                                                                                                                                                ),
                                                                                                                                              ],
                                                                                                                                            ),
                                                                                                                                          ),
                                                                                                                                          Padding(
                                                                                                                                            padding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 5.0),
                                                                                                                                            child: Row(
                                                                                                                                              children: <Widget>[
                                                                                                                                                Expanded(
                                                                                                                                                  child: new Text(status6, style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black)),
                                                                                                                                                ),
                                                                                                                                                Expanded(
                                                                                                                                                  child: new Text(read6, style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black)),
                                                                                                                                                ),
                                                                                                                                              ],
                                                                                                                                            ),
                                                                                                                                          ),
                                                                                                                                          Padding(
                                                                                                                                            padding: EdgeInsets.fromLTRB(16.0, 5.0, 16.0, 5.0),
                                                                                                                                            child: Row(
                                                                                                                                              children: <Widget>[
                                                                                                                                                Expanded(
                                                                                                                                                  child: new Text("Catatan Pengirim", style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black, fontWeight: FontWeight.bold)),
                                                                                                                                                ),
                                                                                                                                                Expanded(
                                                                                                                                                  child: new Text("Catatan Sendiri", style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black, fontWeight: FontWeight.bold)),
                                                                                                                                                ),
                                                                                                                                              ],
                                                                                                                                            ),
                                                                                                                                          ),
                                                                                                                                          Padding(
                                                                                                                                            padding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 5.0),
                                                                                                                                            child: Row(
                                                                                                                                              children: <Widget>[
                                                                                                                                                Expanded(
                                                                                                                                                  child: new Text(catatanPengirim6, style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black)),
                                                                                                                                                ),
                                                                                                                                                Expanded(
                                                                                                                                                  child: new Text(catatanSendiri6, style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black)),
                                                                                                                                                ),
                                                                                                                                              ],
                                                                                                                                            ),
                                                                                                                                          ),
                                                                                                                                          Padding(
                                                                                                                                            padding: EdgeInsets.fromLTRB(16.0, 5.0, 16.0, 5.0),
                                                                                                                                            child: Row(
                                                                                                                                              children: <Widget>[
                                                                                                                                                Expanded(
                                                                                                                                                  child: new Text("Tgl Tanggapan", style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black, fontWeight: FontWeight.bold)),
                                                                                                                                                ),
                                                                                                                                                Expanded(
                                                                                                                                                  child: new Text("Tgl Batas", style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black, fontWeight: FontWeight.bold)),
                                                                                                                                                ),
                                                                                                                                              ],
                                                                                                                                            ),
                                                                                                                                          ),
                                                                                                                                          Padding(
                                                                                                                                            padding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 5.0),
                                                                                                                                            child: Row(
                                                                                                                                              children: <Widget>[
                                                                                                                                                Expanded(
                                                                                                                                                  child: new Text(tanggalTaggapan6, style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black)),
                                                                                                                                                ),
                                                                                                                                                Expanded(
                                                                                                                                                  child: new Text(tanggalBatas6, style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black)),
                                                                                                                                                ),
                                                                                                                                              ],
                                                                                                                                            ),
                                                                                                                                          ),
                                                                                                                                          Container(
                                                                                                                                            height: 10,
                                                                                                                                          ),
                                                                                                                                          new InkWell(
                                                                                                                                            onTap: () {
                                                                                                                                              Navigator.push(context, new MaterialPageRoute(builder: (BuildContext context) => new DetailCatatanTrackingMasuk(snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].child[vi].detail_catatan)));
                                                                                                                                            },
                                                                                                                                            child: new Container(
                                                                                                                                                height: 42.0,
                                                                                                                                                decoration: new BoxDecoration(
                                                                                                                                                  color: Colors.blueAccent,
                                                                                                                                                  border: new Border.all(color: Colors.white, width: 1.0),
                                                                                                                                                  borderRadius: new BorderRadius.circular(10.0),
                                                                                                                                                ),
                                                                                                                                                child: new Center(
                                                                                                                                                  child: Text('Detail Catatan', style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.white)),
                                                                                                                                                )
                                                                                                                                            ),
                                                                                                                                          ),
                                                                                                                                          new Separators(),
                                                                                                                                          ListView.builder(
                                                                                                                                              scrollDirection: Axis.vertical,
                                                                                                                                              shrinkWrap: true,
                                                                                                                                              physics: ClampingScrollPhysics(),
                                                                                                                                              itemCount: snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].child[vi].child.length,
                                                                                                                                              itemBuilder: (BuildContext context, int vii) {

                                                                                                                                                if (snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].child[vi].child[vii].child != null) {

                                                                                                                                                  String dari7;
                                                                                                                                                  String tanggalDikirim7;
                                                                                                                                                  String status7;
                                                                                                                                                  String read7;
                                                                                                                                                  String catatanPengirim7;
                                                                                                                                                  String catatanSendiri7;
                                                                                                                                                  String tanggalBatas7;
                                                                                                                                                  String tanggalTaggapan7;

                                                                                                                                                  if (snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].child[vi].child[vii].satker_dari == null || snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].child[vi].child[vii].satker_dari == "") {
                                                                                                                                                    dari7 = "-";
                                                                                                                                                  } else {
                                                                                                                                                    dari7 = snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].child[vi].child[vii].satker_dari;
                                                                                                                                                  }

                                                                                                                                                  if (snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].child[vi].child[vii].tgl_disposisi == null || snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].child[vi].child[vii].tgl_disposisi == "") {
                                                                                                                                                    tanggalDikirim7 = "-";
                                                                                                                                                  } else {
                                                                                                                                                    tanggalDikirim7 = snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].child[vi].child[vii].tgl_disposisi;
                                                                                                                                                  }

                                                                                                                                                  if (snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].child[vi].child[vii].status == null || snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].child[vi].child[vii].status == "") {
                                                                                                                                                    status7 = "-";
                                                                                                                                                  } else {
                                                                                                                                                    status7 = snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].child[vi].child[vii].status;
                                                                                                                                                  }

                                                                                                                                                  if (snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].child[vi].child[vii].read == null || snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].child[vi].child[vii].read == "") {
                                                                                                                                                    read7 = "-";
                                                                                                                                                  } else {
                                                                                                                                                    if (snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].child[vi].child[vii].read == "READ") {
                                                                                                                                                      read7 = "Sudah";
                                                                                                                                                    } else if (snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].child[vi].child[vii].read == "UNREAD") {
                                                                                                                                                      read7 = "Belum";
                                                                                                                                                    } else {
                                                                                                                                                      read7 = snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].child[vi].child[vii].read;
                                                                                                                                                    }
                                                                                                                                                  }

                                                                                                                                                  if (snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].child[vi].child[vii].catatan_pengirim == null || snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].child[vi].child[vii].catatan_pengirim == "") {
                                                                                                                                                    catatanPengirim7 = "-";
                                                                                                                                                  } else {
                                                                                                                                                    catatanPengirim7 = snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].child[vi].child[vii].catatan_pengirim;
                                                                                                                                                  }

                                                                                                                                                  if (snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].child[vi].child[vii].catatan_sendiri == null || snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].child[vi].child[vii].catatan_sendiri == "") {
                                                                                                                                                    catatanSendiri7 = "-";
                                                                                                                                                  } else {
                                                                                                                                                    catatanSendiri7 = snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].child[vi].child[vii].catatan_sendiri;
                                                                                                                                                  }

                                                                                                                                                  if (snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].child[vi].child[vii].tgl_tanggapan == null || snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].child[vi].child[vii].tgl_tanggapan == "") {
                                                                                                                                                    tanggalTaggapan7 = "-";
                                                                                                                                                  } else {
                                                                                                                                                    tanggalTaggapan7 = snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].child[vi].child[vii].tgl_tanggapan;
                                                                                                                                                  }

                                                                                                                                                  if (snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].child[vi].child[vii].tgl_batas == null || snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].child[vi].child[vii].tgl_batas == "") {
                                                                                                                                                    tanggalBatas7 = "-";
                                                                                                                                                  } else {
                                                                                                                                                    tanggalBatas7 = snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].child[vi].child[vii].tgl_batas;
                                                                                                                                                  }

                                                                                                                                                  return new ExpansionTile(
                                                                                                                                                      trailing: Icon(Icons.expand_more, color: Colors.black),
                                                                                                                                                      backgroundColor: Colors.white,
                                                                                                                                                      leading: new InkWell(
                                                                                                                                                        child: CircleAvatar(
                                                                                                                                                            backgroundColor: Colors.orange,
                                                                                                                                                            radius: 16.0,
                                                                                                                                                            child: new Icon(Icons.message, color: Colors.white, size: 16.0)
                                                                                                                                                        ),
                                                                                                                                                      ),
                                                                                                                                                      title: new Text(snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].child[vi].child[vii].satker_name, style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 16.0, color: Colors.black)),
                                                                                                                                                      children: [
                                                                                                                                                        Column(
                                                                                                                                                          children: <Widget>[
                                                                                                                                                            Padding(
                                                                                                                                                              padding: EdgeInsets.fromLTRB(16.0, 5.0, 16.0, 5.0),
                                                                                                                                                              child: Row(
                                                                                                                                                                children: <Widget>[
                                                                                                                                                                  Expanded(
                                                                                                                                                                    child: new Text("Dari", style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black, fontWeight: FontWeight.bold)),
                                                                                                                                                                  ),
                                                                                                                                                                  Expanded(
                                                                                                                                                                    child: new Text("Tgl Dikirim", style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black, fontWeight: FontWeight.bold)),
                                                                                                                                                                  ),
                                                                                                                                                                ],
                                                                                                                                                              ),
                                                                                                                                                            ),
                                                                                                                                                            Padding(
                                                                                                                                                              padding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 5.0),
                                                                                                                                                              child: Row(
                                                                                                                                                                children: <Widget>[
                                                                                                                                                                  Expanded(
                                                                                                                                                                    child: new Text(dari7, style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black)),
                                                                                                                                                                  ),
                                                                                                                                                                  Expanded(
                                                                                                                                                                    child: new Text(tanggalDikirim7, style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black)),
                                                                                                                                                                  ),
                                                                                                                                                                ],
                                                                                                                                                              ),
                                                                                                                                                            ),
                                                                                                                                                            Padding(
                                                                                                                                                              padding: EdgeInsets.fromLTRB(16.0, 5.0, 16.0, 5.0),
                                                                                                                                                              child: Row(
                                                                                                                                                                children: <Widget>[
                                                                                                                                                                  Expanded(
                                                                                                                                                                    child: new Text("Status", style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black, fontWeight: FontWeight.bold)),
                                                                                                                                                                  ),
                                                                                                                                                                  Expanded(
                                                                                                                                                                    child: new Text("Dibaca", style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black, fontWeight: FontWeight.bold)),
                                                                                                                                                                  ),
                                                                                                                                                                ],
                                                                                                                                                              ),
                                                                                                                                                            ),
                                                                                                                                                            Padding(
                                                                                                                                                              padding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 5.0),
                                                                                                                                                              child: Row(
                                                                                                                                                                children: <Widget>[
                                                                                                                                                                  Expanded(
                                                                                                                                                                    child: new Text(status7, style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black)),
                                                                                                                                                                  ),
                                                                                                                                                                  Expanded(
                                                                                                                                                                    child: new Text(read7, style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black)),
                                                                                                                                                                  ),
                                                                                                                                                                ],
                                                                                                                                                              ),
                                                                                                                                                            ),
                                                                                                                                                            Padding(
                                                                                                                                                              padding: EdgeInsets.fromLTRB(16.0, 5.0, 16.0, 5.0),
                                                                                                                                                              child: Row(
                                                                                                                                                                children: <Widget>[
                                                                                                                                                                  Expanded(
                                                                                                                                                                    child: new Text("Catatan Pengirim", style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black, fontWeight: FontWeight.bold)),
                                                                                                                                                                  ),
                                                                                                                                                                  Expanded(
                                                                                                                                                                    child: new Text("Catatan Sendiri", style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black, fontWeight: FontWeight.bold)),
                                                                                                                                                                  ),
                                                                                                                                                                ],
                                                                                                                                                              ),
                                                                                                                                                            ),
                                                                                                                                                            Padding(
                                                                                                                                                              padding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 5.0),
                                                                                                                                                              child: Row(
                                                                                                                                                                children: <Widget>[
                                                                                                                                                                  Expanded(
                                                                                                                                                                    child: new Text(catatanPengirim7, style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black)),
                                                                                                                                                                  ),
                                                                                                                                                                  Expanded(
                                                                                                                                                                    child: new Text(catatanSendiri7, style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black)),
                                                                                                                                                                  ),
                                                                                                                                                                ],
                                                                                                                                                              ),
                                                                                                                                                            ),
                                                                                                                                                            Padding(
                                                                                                                                                              padding: EdgeInsets.fromLTRB(16.0, 5.0, 16.0, 5.0),
                                                                                                                                                              child: Row(
                                                                                                                                                                children: <Widget>[
                                                                                                                                                                  Expanded(
                                                                                                                                                                    child: new Text("Tgl Tanggapan", style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black, fontWeight: FontWeight.bold)),
                                                                                                                                                                  ),
                                                                                                                                                                  Expanded(
                                                                                                                                                                    child: new Text("Tgl Batas", style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black, fontWeight: FontWeight.bold)),
                                                                                                                                                                  ),
                                                                                                                                                                ],
                                                                                                                                                              ),
                                                                                                                                                            ),
                                                                                                                                                            Padding(
                                                                                                                                                              padding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 5.0),
                                                                                                                                                              child: Row(
                                                                                                                                                                children: <Widget>[
                                                                                                                                                                  Expanded(
                                                                                                                                                                    child: new Text(tanggalTaggapan7, style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black)),
                                                                                                                                                                  ),
                                                                                                                                                                  Expanded(
                                                                                                                                                                    child: new Text(tanggalBatas7, style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black)),
                                                                                                                                                                  ),
                                                                                                                                                                ],
                                                                                                                                                              ),
                                                                                                                                                            ),
                                                                                                                                                            Container(
                                                                                                                                                              height: 10,
                                                                                                                                                            ),
                                                                                                                                                            new InkWell(
                                                                                                                                                              onTap: () {
                                                                                                                                                                Navigator.push(context, new MaterialPageRoute(builder: (BuildContext context) => new DetailCatatanTrackingMasuk(snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].child[vi].child[vii].detail_catatan)));
                                                                                                                                                              },
                                                                                                                                                              child: new Container(
                                                                                                                                                                  height: 42.0,
                                                                                                                                                                  decoration: new BoxDecoration(
                                                                                                                                                                    color: Colors.blueAccent,
                                                                                                                                                                    border: new Border.all(color: Colors.white, width: 1.0),
                                                                                                                                                                    borderRadius: new BorderRadius.circular(10.0),
                                                                                                                                                                  ),
                                                                                                                                                                  child: new Center(
                                                                                                                                                                    child: Text('Detail Catatan', style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.white)),
                                                                                                                                                                  )
                                                                                                                                                              ),
                                                                                                                                                            ),
                                                                                                                                                            new Separators(),
                                                                                                                                                            ListView.builder(
                                                                                                                                                                scrollDirection: Axis.vertical,
                                                                                                                                                                shrinkWrap: true,
                                                                                                                                                                physics: ClampingScrollPhysics(),
                                                                                                                                                                itemCount: snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].child[vi].child[vii].child.length,
                                                                                                                                                                itemBuilder: (BuildContext context, int viii) {

                                                                                                                                                                  if (snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].child[vi].child[vii].child[viii].child != null) {

                                                                                                                                                                    String dari8;
                                                                                                                                                                    String tanggalDikirim8;
                                                                                                                                                                    String status8;
                                                                                                                                                                    String read8;
                                                                                                                                                                    String catatanPengirim8;
                                                                                                                                                                    String catatanSendiri8;
                                                                                                                                                                    String tanggalBatas8;
                                                                                                                                                                    String tanggalTaggapan8;

                                                                                                                                                                    if (snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].child[vi].child[vii].child[viii].satker_dari == null || snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].child[vi].child[vii].child[viii].satker_dari == "") {
                                                                                                                                                                      dari8 = "-";
                                                                                                                                                                    } else {
                                                                                                                                                                      dari8 = snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].child[vi].child[vii].child[viii].satker_dari;
                                                                                                                                                                    }

                                                                                                                                                                    if (snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].child[vi].child[vii].child[viii].tgl_disposisi == null || snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].child[vi].child[vii].child[viii].tgl_disposisi == "") {
                                                                                                                                                                      tanggalDikirim8 = "-";
                                                                                                                                                                    } else {
                                                                                                                                                                      tanggalDikirim8 = snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].child[vi].child[vii].child[viii].tgl_disposisi;
                                                                                                                                                                    }

                                                                                                                                                                    if (snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].child[vi].child[vii].child[viii].status == null || snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].child[vi].child[vii].child[viii].status == "") {
                                                                                                                                                                      status8 = "-";
                                                                                                                                                                    } else {
                                                                                                                                                                      status8 = snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].child[vi].child[vii].child[viii].status;
                                                                                                                                                                    }

                                                                                                                                                                    if (snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].child[vi].child[vii].child[viii].read == null || snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].child[vi].child[vii].child[viii].read == "") {
                                                                                                                                                                      read8 = "-";
                                                                                                                                                                    } else {
                                                                                                                                                                      if (snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].child[vi].child[vii].child[viii].read == "READ") {
                                                                                                                                                                        read8 = "Sudah";
                                                                                                                                                                      } else if (snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].child[vi].child[vii].child[viii].read == "UNREAD") {
                                                                                                                                                                        read8 = "Belum";
                                                                                                                                                                      } else {
                                                                                                                                                                        read8 = snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].child[vi].child[vii].child[viii].read;
                                                                                                                                                                      }
                                                                                                                                                                    }

                                                                                                                                                                    if (snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].child[vi].child[vii].child[viii].catatan_pengirim == null || snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].child[vi].child[vii].child[viii].catatan_pengirim == "") {
                                                                                                                                                                      catatanPengirim8 = "-";
                                                                                                                                                                    } else {
                                                                                                                                                                      catatanPengirim8 = snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].child[vi].child[vii].child[viii].catatan_pengirim;
                                                                                                                                                                    }

                                                                                                                                                                    if (snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].child[vi].child[vii].child[viii].catatan_sendiri == null || snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].child[vi].child[vii].child[viii].catatan_sendiri == "") {
                                                                                                                                                                      catatanSendiri8 = "-";
                                                                                                                                                                    } else {
                                                                                                                                                                      catatanSendiri8 = snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].child[vi].child[vii].child[viii].catatan_sendiri;
                                                                                                                                                                    }

                                                                                                                                                                    if (snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].child[vi].child[vii].child[viii].tgl_tanggapan == null || snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].child[vi].child[vii].child[viii].tgl_tanggapan == "") {
                                                                                                                                                                      tanggalTaggapan8 = "-";
                                                                                                                                                                    } else {
                                                                                                                                                                      tanggalTaggapan8 = snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].child[vi].child[vii].child[viii].tgl_tanggapan;
                                                                                                                                                                    }

                                                                                                                                                                    if (snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].child[vi].child[vii].child[viii].tgl_batas == null || snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].child[vi].child[vii].child[viii].tgl_batas == "") {
                                                                                                                                                                      tanggalBatas8 = "-";
                                                                                                                                                                    } else {
                                                                                                                                                                      tanggalBatas8 = snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].child[vi].child[vii].child[viii].tgl_batas;
                                                                                                                                                                    }

                                                                                                                                                                    return new ExpansionTile(
                                                                                                                                                                        trailing: Icon(Icons.expand_more, color: Colors.black),
                                                                                                                                                                        backgroundColor: Colors.white,
                                                                                                                                                                        leading: new InkWell(
                                                                                                                                                                          child: CircleAvatar(
                                                                                                                                                                              backgroundColor: Colors.orange,
                                                                                                                                                                              radius: 16.0,
                                                                                                                                                                              child: new Icon(Icons.message, color: Colors.white, size: 16.0)
                                                                                                                                                                          ),
                                                                                                                                                                        ),
                                                                                                                                                                        title: new Text(snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].child[vi].child[vii].child[viii].satker_name, style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 16.0, color: Colors.black)),
                                                                                                                                                                        children: [
                                                                                                                                                                          Column(
                                                                                                                                                                            children: <Widget>[
                                                                                                                                                                              Padding(
                                                                                                                                                                                padding: EdgeInsets.fromLTRB(16.0, 5.0, 16.0, 5.0),
                                                                                                                                                                                child: Row(
                                                                                                                                                                                  children: <Widget>[
                                                                                                                                                                                    Expanded(
                                                                                                                                                                                      child: new Text("Dari", style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black, fontWeight: FontWeight.bold)),
                                                                                                                                                                                    ),
                                                                                                                                                                                    Expanded(
                                                                                                                                                                                      child: new Text("Tgl Dikirim", style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black, fontWeight: FontWeight.bold)),
                                                                                                                                                                                    ),
                                                                                                                                                                                  ],
                                                                                                                                                                                ),
                                                                                                                                                                              ),
                                                                                                                                                                              Padding(
                                                                                                                                                                                padding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 5.0),
                                                                                                                                                                                child: Row(
                                                                                                                                                                                  children: <Widget>[
                                                                                                                                                                                    Expanded(
                                                                                                                                                                                      child: new Text(dari8, style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black)),
                                                                                                                                                                                    ),
                                                                                                                                                                                    Expanded(
                                                                                                                                                                                      child: new Text(tanggalDikirim8, style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black)),
                                                                                                                                                                                    ),
                                                                                                                                                                                  ],
                                                                                                                                                                                ),
                                                                                                                                                                              ),
                                                                                                                                                                              Padding(
                                                                                                                                                                                padding: EdgeInsets.fromLTRB(16.0, 5.0, 16.0, 5.0),
                                                                                                                                                                                child: Row(
                                                                                                                                                                                  children: <Widget>[
                                                                                                                                                                                    Expanded(
                                                                                                                                                                                      child: new Text("Status", style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black, fontWeight: FontWeight.bold)),
                                                                                                                                                                                    ),
                                                                                                                                                                                    Expanded(
                                                                                                                                                                                      child: new Text("Dibaca", style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black, fontWeight: FontWeight.bold)),
                                                                                                                                                                                    ),
                                                                                                                                                                                  ],
                                                                                                                                                                                ),
                                                                                                                                                                              ),
                                                                                                                                                                              Padding(
                                                                                                                                                                                padding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 5.0),
                                                                                                                                                                                child: Row(
                                                                                                                                                                                  children: <Widget>[
                                                                                                                                                                                    Expanded(
                                                                                                                                                                                      child: new Text(status8, style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black)),
                                                                                                                                                                                    ),
                                                                                                                                                                                    Expanded(
                                                                                                                                                                                      child: new Text(read8, style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black)),
                                                                                                                                                                                    ),
                                                                                                                                                                                  ],
                                                                                                                                                                                ),
                                                                                                                                                                              ),
                                                                                                                                                                              Padding(
                                                                                                                                                                                padding: EdgeInsets.fromLTRB(16.0, 5.0, 16.0, 5.0),
                                                                                                                                                                                child: Row(
                                                                                                                                                                                  children: <Widget>[
                                                                                                                                                                                    Expanded(
                                                                                                                                                                                      child: new Text("Catatan Pengirim", style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black, fontWeight: FontWeight.bold)),
                                                                                                                                                                                    ),
                                                                                                                                                                                    Expanded(
                                                                                                                                                                                      child: new Text("Catatan Sendiri", style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black, fontWeight: FontWeight.bold)),
                                                                                                                                                                                    ),
                                                                                                                                                                                  ],
                                                                                                                                                                                ),
                                                                                                                                                                              ),
                                                                                                                                                                              Padding(
                                                                                                                                                                                padding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 5.0),
                                                                                                                                                                                child: Row(
                                                                                                                                                                                  children: <Widget>[
                                                                                                                                                                                    Expanded(
                                                                                                                                                                                      child: new Text(catatanPengirim8, style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black)),
                                                                                                                                                                                    ),
                                                                                                                                                                                    Expanded(
                                                                                                                                                                                      child: new Text(catatanSendiri8, style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black)),
                                                                                                                                                                                    ),
                                                                                                                                                                                  ],
                                                                                                                                                                                ),
                                                                                                                                                                              ),
                                                                                                                                                                              Padding(
                                                                                                                                                                                padding: EdgeInsets.fromLTRB(16.0, 5.0, 16.0, 5.0),
                                                                                                                                                                                child: Row(
                                                                                                                                                                                  children: <Widget>[
                                                                                                                                                                                    Expanded(
                                                                                                                                                                                      child: new Text("Tgl Tanggapan", style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black, fontWeight: FontWeight.bold)),
                                                                                                                                                                                    ),
                                                                                                                                                                                    Expanded(
                                                                                                                                                                                      child: new Text("Tgl Batas", style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black, fontWeight: FontWeight.bold)),
                                                                                                                                                                                    ),
                                                                                                                                                                                  ],
                                                                                                                                                                                ),
                                                                                                                                                                              ),
                                                                                                                                                                              Padding(
                                                                                                                                                                                padding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 5.0),
                                                                                                                                                                                child: Row(
                                                                                                                                                                                  children: <Widget>[
                                                                                                                                                                                    Expanded(
                                                                                                                                                                                      child: new Text(tanggalTaggapan8, style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black)),
                                                                                                                                                                                    ),
                                                                                                                                                                                    Expanded(
                                                                                                                                                                                      child: new Text(tanggalBatas8, style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black)),
                                                                                                                                                                                    ),
                                                                                                                                                                                  ],
                                                                                                                                                                                ),
                                                                                                                                                                              ),
                                                                                                                                                                              Container(
                                                                                                                                                                                height: 10,
                                                                                                                                                                              ),
                                                                                                                                                                              new InkWell(
                                                                                                                                                                                onTap: () {
                                                                                                                                                                                  Navigator.push(context, new MaterialPageRoute(builder: (BuildContext context) => new DetailCatatanTrackingMasuk(snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].child[vi].child[vii].child[viii].detail_catatan)));
                                                                                                                                                                                },
                                                                                                                                                                                child: new Container(
                                                                                                                                                                                    height: 42.0,
                                                                                                                                                                                    decoration: new BoxDecoration(
                                                                                                                                                                                      color: Colors.blueAccent,
                                                                                                                                                                                      border: new Border.all(color: Colors.white, width: 1.0),
                                                                                                                                                                                      borderRadius: new BorderRadius.circular(10.0),
                                                                                                                                                                                    ),
                                                                                                                                                                                    child: new Center(
                                                                                                                                                                                      child: Text('Detail Catatan', style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.white)),
                                                                                                                                                                                    )
                                                                                                                                                                                ),
                                                                                                                                                                              ),
                                                                                                                                                                              new Separators(),
                                                                                                                                                                              ListView.builder(
                                                                                                                                                                                  scrollDirection: Axis.vertical,
                                                                                                                                                                                  shrinkWrap: true,
                                                                                                                                                                                  physics: ClampingScrollPhysics(),
                                                                                                                                                                                  itemCount: snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].child[vi].child[vii].child[viii].child.length,
                                                                                                                                                                                  itemBuilder: (BuildContext context, int ix) {

                                                                                                                                                                                    if (snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].child[vi].child[vii].child[viii].child[ix].child != null) {

                                                                                                                                                                                      String dari9;
                                                                                                                                                                                      String tanggalDikirim9;
                                                                                                                                                                                      String status9;
                                                                                                                                                                                      String read9;
                                                                                                                                                                                      String catatanPengirim9;
                                                                                                                                                                                      String catatanSendiri9;
                                                                                                                                                                                      String tanggalBatas9;
                                                                                                                                                                                      String tanggalTaggapan9;

                                                                                                                                                                                      if (snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].child[vi].child[vii].child[viii].child[ix].satker_dari == null || snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].child[vi].child[vii].child[viii].child[ix].satker_dari == "") {
                                                                                                                                                                                        dari9 = "-";
                                                                                                                                                                                      } else {
                                                                                                                                                                                        dari9 = snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].child[vi].child[vii].child[viii].child[ix].satker_dari;
                                                                                                                                                                                      }

                                                                                                                                                                                      if (snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].child[vi].child[vii].child[viii].child[ix].tgl_disposisi == null || snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].child[vi].child[vii].child[viii].child[ix].tgl_disposisi == "") {
                                                                                                                                                                                        tanggalDikirim9 = "-";
                                                                                                                                                                                      } else {
                                                                                                                                                                                        tanggalDikirim9 = snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].child[vi].child[vii].child[viii].child[ix].tgl_disposisi;
                                                                                                                                                                                      }

                                                                                                                                                                                      if (snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].child[vi].child[vii].child[viii].child[ix].status == null || snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].child[vi].child[vii].child[viii].child[ix].status == "") {
                                                                                                                                                                                        status9 = "-";
                                                                                                                                                                                      } else {
                                                                                                                                                                                        status9 = snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].child[vi].child[vii].child[viii].child[ix].status;
                                                                                                                                                                                      }

                                                                                                                                                                                      if (snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].child[vi].child[vii].child[viii].child[ix].read == null || snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].child[vi].child[vii].child[viii].child[ix].read == "") {
                                                                                                                                                                                        read9 = "-";
                                                                                                                                                                                      } else {
                                                                                                                                                                                        if (snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].child[vi].child[vii].child[viii].child[ix].read == "READ") {
                                                                                                                                                                                          read9 = "Sudah";
                                                                                                                                                                                        } else if (snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].child[vi].child[vii].child[viii].child[ix].read == "UNREAD") {
                                                                                                                                                                                          read9 = "Belum";
                                                                                                                                                                                        } else {
                                                                                                                                                                                          read9 = snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].child[vi].child[vii].child[viii].child[ix].read;
                                                                                                                                                                                        }
                                                                                                                                                                                      }

                                                                                                                                                                                      if (snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].child[vi].child[vii].child[viii].child[ix].catatan_pengirim == null || snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].child[vi].child[vii].child[viii].child[ix].catatan_pengirim == "") {
                                                                                                                                                                                        catatanPengirim9 = "-";
                                                                                                                                                                                      } else {
                                                                                                                                                                                        catatanPengirim9 = snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].child[vi].child[vii].child[viii].child[ix].catatan_pengirim;
                                                                                                                                                                                      }

                                                                                                                                                                                      if (snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].child[vi].child[vii].child[viii].child[ix].catatan_sendiri == null || snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].child[vi].child[vii].child[viii].child[ix].catatan_sendiri == "") {
                                                                                                                                                                                        catatanSendiri9 = "-";
                                                                                                                                                                                      } else {
                                                                                                                                                                                        catatanSendiri9 = snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].child[vi].child[vii].child[viii].child[ix].catatan_sendiri;
                                                                                                                                                                                      }

                                                                                                                                                                                      if (snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].child[vi].child[vii].child[viii].child[ix].tgl_tanggapan == null || snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].child[vi].child[vii].child[viii].child[ix].tgl_tanggapan == "") {
                                                                                                                                                                                        tanggalTaggapan9 = "-";
                                                                                                                                                                                      } else {
                                                                                                                                                                                        tanggalTaggapan9 = snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].child[vi].child[vii].child[viii].child[ix].tgl_tanggapan;
                                                                                                                                                                                      }

                                                                                                                                                                                      if (snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].child[vi].child[vii].child[viii].child[ix].tgl_batas == null || snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].child[vi].child[vii].child[viii].child[ix].tgl_batas == "") {
                                                                                                                                                                                        tanggalBatas9 = "-";
                                                                                                                                                                                      } else {
                                                                                                                                                                                        tanggalBatas9 = snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].child[vi].child[vii].child[viii].child[ix].tgl_batas;
                                                                                                                                                                                      }

                                                                                                                                                                                      return new ExpansionTile(
                                                                                                                                                                                          trailing: Icon(Icons.expand_more, color: Colors.black),
                                                                                                                                                                                          backgroundColor: Colors.white,
                                                                                                                                                                                          leading: new InkWell(
                                                                                                                                                                                            child: CircleAvatar(
                                                                                                                                                                                                backgroundColor: Colors.orange,
                                                                                                                                                                                                radius: 16.0,
                                                                                                                                                                                                child: new Icon(Icons.message, color: Colors.white, size: 16.0)
                                                                                                                                                                                            ),
                                                                                                                                                                                          ),
                                                                                                                                                                                          title: new Text(snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].child[vi].child[vii].child[viii].child[ix].satker_name, style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 16.0, color: Colors.black)),
                                                                                                                                                                                          children: [
                                                                                                                                                                                            Column(
                                                                                                                                                                                              children: <Widget>[
                                                                                                                                                                                                Padding(
                                                                                                                                                                                                  padding: EdgeInsets.fromLTRB(16.0, 5.0, 16.0, 5.0),
                                                                                                                                                                                                  child: Row(
                                                                                                                                                                                                    children: <Widget>[
                                                                                                                                                                                                      Expanded(
                                                                                                                                                                                                        child: new Text("Dari", style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black, fontWeight: FontWeight.bold)),
                                                                                                                                                                                                      ),
                                                                                                                                                                                                      Expanded(
                                                                                                                                                                                                        child: new Text("Tgl Dikirim", style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black, fontWeight: FontWeight.bold)),
                                                                                                                                                                                                      ),
                                                                                                                                                                                                    ],
                                                                                                                                                                                                  ),
                                                                                                                                                                                                ),
                                                                                                                                                                                                Padding(
                                                                                                                                                                                                  padding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 5.0),
                                                                                                                                                                                                  child: Row(
                                                                                                                                                                                                    children: <Widget>[
                                                                                                                                                                                                      Expanded(
                                                                                                                                                                                                        child: new Text(dari9, style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black)),
                                                                                                                                                                                                      ),
                                                                                                                                                                                                      Expanded(
                                                                                                                                                                                                        child: new Text(tanggalDikirim9, style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black)),
                                                                                                                                                                                                      ),
                                                                                                                                                                                                    ],
                                                                                                                                                                                                  ),
                                                                                                                                                                                                ),
                                                                                                                                                                                                Padding(
                                                                                                                                                                                                  padding: EdgeInsets.fromLTRB(16.0, 5.0, 16.0, 5.0),
                                                                                                                                                                                                  child: Row(
                                                                                                                                                                                                    children: <Widget>[
                                                                                                                                                                                                      Expanded(
                                                                                                                                                                                                        child: new Text("Status", style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black, fontWeight: FontWeight.bold)),
                                                                                                                                                                                                      ),
                                                                                                                                                                                                      Expanded(
                                                                                                                                                                                                        child: new Text("Dibaca", style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black, fontWeight: FontWeight.bold)),
                                                                                                                                                                                                      ),
                                                                                                                                                                                                    ],
                                                                                                                                                                                                  ),
                                                                                                                                                                                                ),
                                                                                                                                                                                                Padding(
                                                                                                                                                                                                  padding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 5.0),
                                                                                                                                                                                                  child: Row(
                                                                                                                                                                                                    children: <Widget>[
                                                                                                                                                                                                      Expanded(
                                                                                                                                                                                                        child: new Text(status9, style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black)),
                                                                                                                                                                                                      ),
                                                                                                                                                                                                      Expanded(
                                                                                                                                                                                                        child: new Text(read9, style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black)),
                                                                                                                                                                                                      ),
                                                                                                                                                                                                    ],
                                                                                                                                                                                                  ),
                                                                                                                                                                                                ),
                                                                                                                                                                                                Padding(
                                                                                                                                                                                                  padding: EdgeInsets.fromLTRB(16.0, 5.0, 16.0, 5.0),
                                                                                                                                                                                                  child: Row(
                                                                                                                                                                                                    children: <Widget>[
                                                                                                                                                                                                      Expanded(
                                                                                                                                                                                                        child: new Text("Catatan Pengirim", style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black, fontWeight: FontWeight.bold)),
                                                                                                                                                                                                      ),
                                                                                                                                                                                                      Expanded(
                                                                                                                                                                                                        child: new Text("Catatan Sendiri", style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black, fontWeight: FontWeight.bold)),
                                                                                                                                                                                                      ),
                                                                                                                                                                                                    ],
                                                                                                                                                                                                  ),
                                                                                                                                                                                                ),
                                                                                                                                                                                                Padding(
                                                                                                                                                                                                  padding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 5.0),
                                                                                                                                                                                                  child: Row(
                                                                                                                                                                                                    children: <Widget>[
                                                                                                                                                                                                      Expanded(
                                                                                                                                                                                                        child: new Text(catatanPengirim9, style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black)),
                                                                                                                                                                                                      ),
                                                                                                                                                                                                      Expanded(
                                                                                                                                                                                                        child: new Text(catatanSendiri9, style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black)),
                                                                                                                                                                                                      ),
                                                                                                                                                                                                    ],
                                                                                                                                                                                                  ),
                                                                                                                                                                                                ),
                                                                                                                                                                                                Padding(
                                                                                                                                                                                                  padding: EdgeInsets.fromLTRB(16.0, 5.0, 16.0, 5.0),
                                                                                                                                                                                                  child: Row(
                                                                                                                                                                                                    children: <Widget>[
                                                                                                                                                                                                      Expanded(
                                                                                                                                                                                                        child: new Text("Tgl Tanggapan", style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black, fontWeight: FontWeight.bold)),
                                                                                                                                                                                                      ),
                                                                                                                                                                                                      Expanded(
                                                                                                                                                                                                        child: new Text("Tgl Batas", style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black, fontWeight: FontWeight.bold)),
                                                                                                                                                                                                      ),
                                                                                                                                                                                                    ],
                                                                                                                                                                                                  ),
                                                                                                                                                                                                ),
                                                                                                                                                                                                Padding(
                                                                                                                                                                                                  padding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 5.0),
                                                                                                                                                                                                  child: Row(
                                                                                                                                                                                                    children: <Widget>[
                                                                                                                                                                                                      Expanded(
                                                                                                                                                                                                        child: new Text(tanggalTaggapan9, style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black)),
                                                                                                                                                                                                      ),
                                                                                                                                                                                                      Expanded(
                                                                                                                                                                                                        child: new Text(tanggalBatas9, style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black)),
                                                                                                                                                                                                      ),
                                                                                                                                                                                                    ],
                                                                                                                                                                                                  ),
                                                                                                                                                                                                ),
                                                                                                                                                                                                Container(
                                                                                                                                                                                                  height: 10,
                                                                                                                                                                                                ),
                                                                                                                                                                                                new InkWell(
                                                                                                                                                                                                  onTap: () {
                                                                                                                                                                                                    Navigator.push(context, new MaterialPageRoute(builder: (BuildContext context) => new DetailCatatanTrackingMasuk(snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].child[vi].child[vii].child[viii].child[ix].detail_catatan)));
                                                                                                                                                                                                  },
                                                                                                                                                                                                  child: new Container(
                                                                                                                                                                                                      height: 42.0,
                                                                                                                                                                                                      decoration: new BoxDecoration(
                                                                                                                                                                                                        color: Colors.blueAccent,
                                                                                                                                                                                                        border: new Border.all(color: Colors.white, width: 1.0),
                                                                                                                                                                                                        borderRadius: new BorderRadius.circular(10.0),
                                                                                                                                                                                                      ),
                                                                                                                                                                                                      child: new Center(
                                                                                                                                                                                                        child: Text('Detail Catatan', style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.white)),
                                                                                                                                                                                                      )
                                                                                                                                                                                                  ),
                                                                                                                                                                                                ),
                                                                                                                                                                                                new Separators(),
                                                                                                                                                                                                ListView.builder(
                                                                                                                                                                                                    scrollDirection: Axis.vertical,
                                                                                                                                                                                                    shrinkWrap: true,
                                                                                                                                                                                                    physics: ClampingScrollPhysics(),
                                                                                                                                                                                                    itemCount: snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].child[vi].child[vii].child[viii].child[ix].child.length,
                                                                                                                                                                                                    itemBuilder: (BuildContext context, int x) {

                                                                                                                                                                                                      if (snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].child[vi].child[vii].child[viii].child[ix].child[x].child != null) {

                                                                                                                                                                                                        String dari10;
                                                                                                                                                                                                        String tanggalDikirim10;
                                                                                                                                                                                                        String status10;
                                                                                                                                                                                                        String read10;
                                                                                                                                                                                                        String catatanPengirim10;
                                                                                                                                                                                                        String catatanSendiri10;
                                                                                                                                                                                                        String tanggalBatas10;
                                                                                                                                                                                                        String tanggalTaggapan10;

                                                                                                                                                                                                        if (snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].child[vi].child[vii].child[viii].child[ix].child[x].satker_dari == null || snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].child[vi].child[vii].child[viii].child[ix].child[x].satker_dari == "") {
                                                                                                                                                                                                          dari10 = "-";
                                                                                                                                                                                                        } else {
                                                                                                                                                                                                          dari10 = snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].child[vi].child[vii].child[viii].child[ix].child[x].satker_dari;
                                                                                                                                                                                                        }

                                                                                                                                                                                                        if (snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].child[vi].child[vii].child[viii].child[ix].child[x].tgl_disposisi == null || snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].child[vi].child[vii].child[viii].child[ix].child[x].tgl_disposisi == "") {
                                                                                                                                                                                                          tanggalDikirim10 = "-";
                                                                                                                                                                                                        } else {
                                                                                                                                                                                                          tanggalDikirim10 = snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].child[vi].child[vii].child[viii].child[ix].child[x].tgl_disposisi;
                                                                                                                                                                                                        }

                                                                                                                                                                                                        if (snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].child[vi].child[vii].child[viii].child[ix].child[x].status == null || snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].child[vi].child[vii].child[viii].child[ix].child[x].status == "") {
                                                                                                                                                                                                          status10 = "-";
                                                                                                                                                                                                        } else {
                                                                                                                                                                                                          status10 = snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].child[vi].child[vii].child[viii].child[ix].child[x].status;
                                                                                                                                                                                                        }

                                                                                                                                                                                                        if (snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].child[vi].child[vii].child[viii].child[ix].child[x].read == null || snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].child[vi].child[vii].child[viii].child[ix].child[x].read == "") {
                                                                                                                                                                                                          read10 = "-";
                                                                                                                                                                                                        } else {
                                                                                                                                                                                                          if (snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].child[vi].child[vii].child[viii].child[ix].child[x].read == "READ") {
                                                                                                                                                                                                            read10 = "Sudah";
                                                                                                                                                                                                          } else if (snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].child[vi].child[vii].child[viii].child[ix].child[x].read == "UNREAD") {
                                                                                                                                                                                                            read10 = "Belum";
                                                                                                                                                                                                          } else {
                                                                                                                                                                                                            read10 = snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].child[vi].child[vii].child[viii].child[ix].child[x].read;
                                                                                                                                                                                                          }
                                                                                                                                                                                                        }

                                                                                                                                                                                                        if (snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].child[vi].child[vii].child[viii].child[ix].child[x].catatan_pengirim == null || snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].child[vi].child[vii].child[viii].child[ix].child[x].catatan_pengirim == "") {
                                                                                                                                                                                                          catatanPengirim10 = "-";
                                                                                                                                                                                                        } else {
                                                                                                                                                                                                          catatanPengirim10 = snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].child[vi].child[vii].child[viii].child[ix].child[x].catatan_pengirim;
                                                                                                                                                                                                        }

                                                                                                                                                                                                        if (snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].child[vi].child[vii].child[viii].child[ix].child[x].catatan_sendiri == null || snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].child[vi].child[vii].child[viii].child[ix].child[x].catatan_sendiri == "") {
                                                                                                                                                                                                          catatanSendiri10 = "-";
                                                                                                                                                                                                        } else {
                                                                                                                                                                                                          catatanSendiri10 = snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].child[vi].child[vii].child[viii].child[ix].child[x].catatan_sendiri;
                                                                                                                                                                                                        }

                                                                                                                                                                                                        if (snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].child[vi].child[vii].child[viii].child[ix].child[x].tgl_tanggapan == null || snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].child[vi].child[vii].child[viii].child[ix].child[x].tgl_tanggapan == "") {
                                                                                                                                                                                                          tanggalTaggapan10 = "-";
                                                                                                                                                                                                        } else {
                                                                                                                                                                                                          tanggalTaggapan10 = snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].child[vi].child[vii].child[viii].child[ix].child[x].tgl_tanggapan;
                                                                                                                                                                                                        }

                                                                                                                                                                                                        if (snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].child[vi].child[vii].child[viii].child[ix].child[x].tgl_batas == null || snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].child[vi].child[vii].child[viii].child[ix].child[x].tgl_batas == "") {
                                                                                                                                                                                                          tanggalBatas10 = "-";
                                                                                                                                                                                                        } else {
                                                                                                                                                                                                          tanggalBatas10 = snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].child[vi].child[vii].child[viii].child[ix].child[x].tgl_batas;
                                                                                                                                                                                                        }

                                                                                                                                                                                                        return new ExpansionTile(
                                                                                                                                                                                                            trailing: Icon(Icons.expand_more, color: Colors.black),
                                                                                                                                                                                                            backgroundColor: Colors.white,
                                                                                                                                                                                                            leading: new InkWell(
                                                                                                                                                                                                              child: CircleAvatar(
                                                                                                                                                                                                                  backgroundColor: Colors.orange,
                                                                                                                                                                                                                  radius: 16.0,
                                                                                                                                                                                                                  child: new Icon(Icons.message, color: Colors.white, size: 16.0)
                                                                                                                                                                                                              ),
                                                                                                                                                                                                            ),
                                                                                                                                                                                                            title: new Text(snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].child[vi].child[vii].child[viii].child[ix].child[x].satker_name, style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 16.0, color: Colors.black)),
                                                                                                                                                                                                            children: [
                                                                                                                                                                                                              Column(
                                                                                                                                                                                                                children: <Widget>[
                                                                                                                                                                                                                  Padding(
                                                                                                                                                                                                                    padding: EdgeInsets.fromLTRB(16.0, 5.0, 16.0, 5.0),
                                                                                                                                                                                                                    child: Row(
                                                                                                                                                                                                                      children: <Widget>[
                                                                                                                                                                                                                        Expanded(
                                                                                                                                                                                                                          child: new Text("Dari", style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black, fontWeight: FontWeight.bold)),
                                                                                                                                                                                                                        ),
                                                                                                                                                                                                                        Expanded(
                                                                                                                                                                                                                          child: new Text("Tgl Dikirim", style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black, fontWeight: FontWeight.bold)),
                                                                                                                                                                                                                        ),
                                                                                                                                                                                                                      ],
                                                                                                                                                                                                                    ),
                                                                                                                                                                                                                  ),
                                                                                                                                                                                                                  Padding(
                                                                                                                                                                                                                    padding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 5.0),
                                                                                                                                                                                                                    child: Row(
                                                                                                                                                                                                                      children: <Widget>[
                                                                                                                                                                                                                        Expanded(
                                                                                                                                                                                                                          child: new Text(dari10, style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black)),
                                                                                                                                                                                                                        ),
                                                                                                                                                                                                                        Expanded(
                                                                                                                                                                                                                          child: new Text(tanggalDikirim10, style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black)),
                                                                                                                                                                                                                        ),
                                                                                                                                                                                                                      ],
                                                                                                                                                                                                                    ),
                                                                                                                                                                                                                  ),
                                                                                                                                                                                                                  Padding(
                                                                                                                                                                                                                    padding: EdgeInsets.fromLTRB(16.0, 5.0, 16.0, 5.0),
                                                                                                                                                                                                                    child: Row(
                                                                                                                                                                                                                      children: <Widget>[
                                                                                                                                                                                                                        Expanded(
                                                                                                                                                                                                                          child: new Text("Status", style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black, fontWeight: FontWeight.bold)),
                                                                                                                                                                                                                        ),
                                                                                                                                                                                                                        Expanded(
                                                                                                                                                                                                                          child: new Text("Dibaca", style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black, fontWeight: FontWeight.bold)),
                                                                                                                                                                                                                        ),
                                                                                                                                                                                                                      ],
                                                                                                                                                                                                                    ),
                                                                                                                                                                                                                  ),
                                                                                                                                                                                                                  Padding(
                                                                                                                                                                                                                    padding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 5.0),
                                                                                                                                                                                                                    child: Row(
                                                                                                                                                                                                                      children: <Widget>[
                                                                                                                                                                                                                        Expanded(
                                                                                                                                                                                                                          child: new Text(status10, style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black)),
                                                                                                                                                                                                                        ),
                                                                                                                                                                                                                        Expanded(
                                                                                                                                                                                                                          child: new Text(read10, style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black)),
                                                                                                                                                                                                                        ),
                                                                                                                                                                                                                      ],
                                                                                                                                                                                                                    ),
                                                                                                                                                                                                                  ),
                                                                                                                                                                                                                  Padding(
                                                                                                                                                                                                                    padding: EdgeInsets.fromLTRB(16.0, 5.0, 16.0, 5.0),
                                                                                                                                                                                                                    child: Row(
                                                                                                                                                                                                                      children: <Widget>[
                                                                                                                                                                                                                        Expanded(
                                                                                                                                                                                                                          child: new Text("Catatan Pengirim", style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black, fontWeight: FontWeight.bold)),
                                                                                                                                                                                                                        ),
                                                                                                                                                                                                                        Expanded(
                                                                                                                                                                                                                          child: new Text("Catatan Sendiri", style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black, fontWeight: FontWeight.bold)),
                                                                                                                                                                                                                        ),
                                                                                                                                                                                                                      ],
                                                                                                                                                                                                                    ),
                                                                                                                                                                                                                  ),
                                                                                                                                                                                                                  Padding(
                                                                                                                                                                                                                    padding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 5.0),
                                                                                                                                                                                                                    child: Row(
                                                                                                                                                                                                                      children: <Widget>[
                                                                                                                                                                                                                        Expanded(
                                                                                                                                                                                                                          child: new Text(catatanPengirim10, style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black)),
                                                                                                                                                                                                                        ),
                                                                                                                                                                                                                        Expanded(
                                                                                                                                                                                                                          child: new Text(catatanSendiri10, style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black)),
                                                                                                                                                                                                                        ),
                                                                                                                                                                                                                      ],
                                                                                                                                                                                                                    ),
                                                                                                                                                                                                                  ),
                                                                                                                                                                                                                  Padding(
                                                                                                                                                                                                                    padding: EdgeInsets.fromLTRB(16.0, 5.0, 16.0, 5.0),
                                                                                                                                                                                                                    child: Row(
                                                                                                                                                                                                                      children: <Widget>[
                                                                                                                                                                                                                        Expanded(
                                                                                                                                                                                                                          child: new Text("Tgl Tanggapan", style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black, fontWeight: FontWeight.bold)),
                                                                                                                                                                                                                        ),
                                                                                                                                                                                                                        Expanded(
                                                                                                                                                                                                                          child: new Text("Tgl Batas", style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black, fontWeight: FontWeight.bold)),
                                                                                                                                                                                                                        ),
                                                                                                                                                                                                                      ],
                                                                                                                                                                                                                    ),
                                                                                                                                                                                                                  ),
                                                                                                                                                                                                                  Padding(
                                                                                                                                                                                                                    padding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 5.0),
                                                                                                                                                                                                                    child: Row(
                                                                                                                                                                                                                      children: <Widget>[
                                                                                                                                                                                                                        Expanded(
                                                                                                                                                                                                                          child: new Text(tanggalTaggapan10, style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black)),
                                                                                                                                                                                                                        ),
                                                                                                                                                                                                                        Expanded(
                                                                                                                                                                                                                          child: new Text(tanggalBatas10, style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black)),
                                                                                                                                                                                                                        ),
                                                                                                                                                                                                                      ],
                                                                                                                                                                                                                    ),
                                                                                                                                                                                                                  ),
                                                                                                                                                                                                                  Container(
                                                                                                                                                                                                                    height: 10,
                                                                                                                                                                                                                  ),
                                                                                                                                                                                                                  new InkWell(
                                                                                                                                                                                                                    onTap: () {
                                                                                                                                                                                                                      Navigator.push(context, new MaterialPageRoute(builder: (BuildContext context) => new DetailCatatanTrackingMasuk(snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].child[vi].child[vii].child[viii].child[ix].child[x].detail_catatan)));
                                                                                                                                                                                                                    },
                                                                                                                                                                                                                    child: new Container(
                                                                                                                                                                                                                        height: 42.0,
                                                                                                                                                                                                                        decoration: new BoxDecoration(
                                                                                                                                                                                                                          color: Colors.blueAccent,
                                                                                                                                                                                                                          border: new Border.all(color: Colors.white, width: 1.0),
                                                                                                                                                                                                                          borderRadius: new BorderRadius.circular(10.0),
                                                                                                                                                                                                                        ),
                                                                                                                                                                                                                        child: new Center(
                                                                                                                                                                                                                          child: Text('Detail Catatan', style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.white)),
                                                                                                                                                                                                                        )
                                                                                                                                                                                                                    ),
                                                                                                                                                                                                                  ),
                                                                                                                                                                                                                  new Separators(),
                                                                                                                                                                                                                  ListView.builder(
                                                                                                                                                                                                                      scrollDirection: Axis.vertical,
                                                                                                                                                                                                                      shrinkWrap: true,
                                                                                                                                                                                                                      physics: ClampingScrollPhysics(),
                                                                                                                                                                                                                      itemCount: snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].child[vi].child[vii].child[viii].child[ix].child[x].child.length,
                                                                                                                                                                                                                      itemBuilder: (BuildContext context, int xi) {

                                                                                                                                                                                                                        if (snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].child[vi].child[vii].child[viii].child[ix].child[x].child[xi].child != null) {

                                                                                                                                                                                                                          String dari11;
                                                                                                                                                                                                                          String tanggalDikirim11;
                                                                                                                                                                                                                          String status11;
                                                                                                                                                                                                                          String read11;
                                                                                                                                                                                                                          String catatanPengirim11;
                                                                                                                                                                                                                          String catatanSendiri11;
                                                                                                                                                                                                                          String tanggalBatas11;
                                                                                                                                                                                                                          String tanggalTaggapan11;

                                                                                                                                                                                                                          if (snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].child[vi].child[vii].child[viii].child[ix].child[x].child[xi].satker_dari == null || snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].child[vi].child[vii].child[viii].child[ix].child[x].child[xi].satker_dari == "") {
                                                                                                                                                                                                                            dari11 = "-";
                                                                                                                                                                                                                          } else {
                                                                                                                                                                                                                            dari11 = snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].child[vi].child[vii].child[viii].child[ix].child[x].child[xi].satker_dari;
                                                                                                                                                                                                                          }

                                                                                                                                                                                                                          if (snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].child[vi].child[vii].child[viii].child[ix].child[x].child[xi].tgl_disposisi == null || snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].child[vi].child[vii].child[viii].child[ix].child[x].child[xi].tgl_disposisi == "") {
                                                                                                                                                                                                                            tanggalDikirim11 = "-";
                                                                                                                                                                                                                          } else {
                                                                                                                                                                                                                            tanggalDikirim11 = snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].child[vi].child[vii].child[viii].child[ix].child[x].child[xi].tgl_disposisi;
                                                                                                                                                                                                                          }

                                                                                                                                                                                                                          if (snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].child[vi].child[vii].child[viii].child[ix].child[x].child[xi].status == null || snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].child[vi].child[vii].child[viii].child[ix].child[x].child[xi].status == "") {
                                                                                                                                                                                                                            status11 = "-";
                                                                                                                                                                                                                          } else {
                                                                                                                                                                                                                            status11 = snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].child[vi].child[vii].child[viii].child[ix].child[x].child[xi].status;
                                                                                                                                                                                                                          }

                                                                                                                                                                                                                          if (snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].child[vi].child[vii].child[viii].child[ix].child[x].child[xi].read == null || snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].child[vi].child[vii].child[viii].child[ix].child[x].child[xi].read == "") {
                                                                                                                                                                                                                            read11 = "-";
                                                                                                                                                                                                                          } else {
                                                                                                                                                                                                                            if (snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].child[vi].child[vii].child[viii].child[ix].child[x].child[xi].read == "READ") {
                                                                                                                                                                                                                              read11 = "Sudah";
                                                                                                                                                                                                                            } else if (snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].child[vi].child[vii].child[viii].child[ix].child[x].child[xi].read == "UNREAD") {
                                                                                                                                                                                                                              read11 = "Belum";
                                                                                                                                                                                                                            } else {
                                                                                                                                                                                                                              read11 = snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].child[vi].child[vii].child[viii].child[ix].child[x].child[xi].read;
                                                                                                                                                                                                                            }
                                                                                                                                                                                                                          }

                                                                                                                                                                                                                          if (snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].child[vi].child[vii].child[viii].child[ix].child[x].child[xi].catatan_pengirim == null || snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].child[vi].child[vii].child[viii].child[ix].child[x].child[xi].catatan_pengirim == "") {
                                                                                                                                                                                                                            catatanPengirim11 = "-";
                                                                                                                                                                                                                          } else {
                                                                                                                                                                                                                            catatanPengirim11 = snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].child[vi].child[vii].child[viii].child[ix].child[x].child[xi].catatan_pengirim;
                                                                                                                                                                                                                          }

                                                                                                                                                                                                                          if (snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].child[vi].child[vii].child[viii].child[ix].child[x].child[xi].catatan_sendiri == null || snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].child[vi].child[vii].child[viii].child[ix].child[x].child[xi].catatan_sendiri == "") {
                                                                                                                                                                                                                            catatanSendiri11 = "-";
                                                                                                                                                                                                                          } else {
                                                                                                                                                                                                                            catatanSendiri11 = snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].child[vi].child[vii].child[viii].child[ix].child[x].child[xi].catatan_sendiri;
                                                                                                                                                                                                                          }

                                                                                                                                                                                                                          if (snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].child[vi].child[vii].child[viii].child[ix].child[x].child[xi].tgl_tanggapan == null || snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].child[vi].child[vii].child[viii].child[ix].child[x].child[xi].tgl_tanggapan == "") {
                                                                                                                                                                                                                            tanggalTaggapan11 = "-";
                                                                                                                                                                                                                          } else {
                                                                                                                                                                                                                            tanggalTaggapan11 = snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].child[vi].child[vii].child[viii].child[ix].child[x].child[xi].tgl_tanggapan;
                                                                                                                                                                                                                          }

                                                                                                                                                                                                                          if (snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].child[vi].child[vii].child[viii].child[ix].child[x].child[xi].tgl_batas == null || snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].child[vi].child[vii].child[viii].child[ix].child[x].child[xi].tgl_batas == "") {
                                                                                                                                                                                                                            tanggalBatas11 = "-";
                                                                                                                                                                                                                          } else {
                                                                                                                                                                                                                            tanggalBatas11 = snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].child[vi].child[vii].child[viii].child[ix].child[x].child[xi].tgl_batas;
                                                                                                                                                                                                                          }

                                                                                                                                                                                                                          return new ExpansionTile(
                                                                                                                                                                                                                              trailing: Icon(Icons.expand_more, color: Colors.black),
                                                                                                                                                                                                                              backgroundColor: Colors.white,
                                                                                                                                                                                                                              leading: new InkWell(
                                                                                                                                                                                                                                child: CircleAvatar(
                                                                                                                                                                                                                                    backgroundColor: Colors.orange,
                                                                                                                                                                                                                                    radius: 16.0,
                                                                                                                                                                                                                                    child: new Icon(Icons.message, color: Colors.white, size: 16.0)
                                                                                                                                                                                                                                ),
                                                                                                                                                                                                                              ),
                                                                                                                                                                                                                              title: new Text(snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].child[vi].child[vii].child[viii].child[ix].child[x].child[xi].satker_name, style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 16.0, color: Colors.black)),
                                                                                                                                                                                                                              children: [
                                                                                                                                                                                                                                Column(
                                                                                                                                                                                                                                  children: <Widget>[
                                                                                                                                                                                                                                    Padding(
                                                                                                                                                                                                                                      padding: EdgeInsets.fromLTRB(16.0, 5.0, 16.0, 5.0),
                                                                                                                                                                                                                                      child: Row(
                                                                                                                                                                                                                                        children: <Widget>[
                                                                                                                                                                                                                                          Expanded(
                                                                                                                                                                                                                                            child: new Text("Dari", style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black, fontWeight: FontWeight.bold)),
                                                                                                                                                                                                                                          ),
                                                                                                                                                                                                                                          Expanded(
                                                                                                                                                                                                                                            child: new Text("Tgl Dikirim", style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black, fontWeight: FontWeight.bold)),
                                                                                                                                                                                                                                          ),
                                                                                                                                                                                                                                        ],
                                                                                                                                                                                                                                      ),
                                                                                                                                                                                                                                    ),
                                                                                                                                                                                                                                    Padding(
                                                                                                                                                                                                                                      padding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 5.0),
                                                                                                                                                                                                                                      child: Row(
                                                                                                                                                                                                                                        children: <Widget>[
                                                                                                                                                                                                                                          Expanded(
                                                                                                                                                                                                                                            child: new Text(dari11, style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black)),
                                                                                                                                                                                                                                          ),
                                                                                                                                                                                                                                          Expanded(
                                                                                                                                                                                                                                            child: new Text(tanggalDikirim11, style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black)),
                                                                                                                                                                                                                                          ),
                                                                                                                                                                                                                                        ],
                                                                                                                                                                                                                                      ),
                                                                                                                                                                                                                                    ),
                                                                                                                                                                                                                                    Padding(
                                                                                                                                                                                                                                      padding: EdgeInsets.fromLTRB(16.0, 5.0, 16.0, 5.0),
                                                                                                                                                                                                                                      child: Row(
                                                                                                                                                                                                                                        children: <Widget>[
                                                                                                                                                                                                                                          Expanded(
                                                                                                                                                                                                                                            child: new Text("Status", style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black, fontWeight: FontWeight.bold)),
                                                                                                                                                                                                                                          ),
                                                                                                                                                                                                                                          Expanded(
                                                                                                                                                                                                                                            child: new Text("Dibaca", style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black, fontWeight: FontWeight.bold)),
                                                                                                                                                                                                                                          ),
                                                                                                                                                                                                                                        ],
                                                                                                                                                                                                                                      ),
                                                                                                                                                                                                                                    ),
                                                                                                                                                                                                                                    Padding(
                                                                                                                                                                                                                                      padding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 5.0),
                                                                                                                                                                                                                                      child: Row(
                                                                                                                                                                                                                                        children: <Widget>[
                                                                                                                                                                                                                                          Expanded(
                                                                                                                                                                                                                                            child: new Text(status11, style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black)),
                                                                                                                                                                                                                                          ),
                                                                                                                                                                                                                                          Expanded(
                                                                                                                                                                                                                                            child: new Text(read11, style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black)),
                                                                                                                                                                                                                                          ),
                                                                                                                                                                                                                                        ],
                                                                                                                                                                                                                                      ),
                                                                                                                                                                                                                                    ),
                                                                                                                                                                                                                                    Padding(
                                                                                                                                                                                                                                      padding: EdgeInsets.fromLTRB(16.0, 5.0, 16.0, 5.0),
                                                                                                                                                                                                                                      child: Row(
                                                                                                                                                                                                                                        children: <Widget>[
                                                                                                                                                                                                                                          Expanded(
                                                                                                                                                                                                                                            child: new Text("Catatan Pengirim", style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black, fontWeight: FontWeight.bold)),
                                                                                                                                                                                                                                          ),
                                                                                                                                                                                                                                          Expanded(
                                                                                                                                                                                                                                            child: new Text("Catatan Sendiri", style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black, fontWeight: FontWeight.bold)),
                                                                                                                                                                                                                                          ),
                                                                                                                                                                                                                                        ],
                                                                                                                                                                                                                                      ),
                                                                                                                                                                                                                                    ),
                                                                                                                                                                                                                                    Padding(
                                                                                                                                                                                                                                      padding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 5.0),
                                                                                                                                                                                                                                      child: Row(
                                                                                                                                                                                                                                        children: <Widget>[
                                                                                                                                                                                                                                          Expanded(
                                                                                                                                                                                                                                            child: new Text(catatanPengirim11, style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black)),
                                                                                                                                                                                                                                          ),
                                                                                                                                                                                                                                          Expanded(
                                                                                                                                                                                                                                            child: new Text(catatanSendiri11, style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black)),
                                                                                                                                                                                                                                          ),
                                                                                                                                                                                                                                        ],
                                                                                                                                                                                                                                      ),
                                                                                                                                                                                                                                    ),
                                                                                                                                                                                                                                    Padding(
                                                                                                                                                                                                                                      padding: EdgeInsets.fromLTRB(16.0, 5.0, 16.0, 5.0),
                                                                                                                                                                                                                                      child: Row(
                                                                                                                                                                                                                                        children: <Widget>[
                                                                                                                                                                                                                                          Expanded(
                                                                                                                                                                                                                                            child: new Text("Tgl Tanggapan", style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black, fontWeight: FontWeight.bold)),
                                                                                                                                                                                                                                          ),
                                                                                                                                                                                                                                          Expanded(
                                                                                                                                                                                                                                            child: new Text("Tgl Batas", style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black, fontWeight: FontWeight.bold)),
                                                                                                                                                                                                                                          ),
                                                                                                                                                                                                                                        ],
                                                                                                                                                                                                                                      ),
                                                                                                                                                                                                                                    ),
                                                                                                                                                                                                                                    Padding(
                                                                                                                                                                                                                                      padding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 5.0),
                                                                                                                                                                                                                                      child: Row(
                                                                                                                                                                                                                                        children: <Widget>[
                                                                                                                                                                                                                                          Expanded(
                                                                                                                                                                                                                                            child: new Text(tanggalTaggapan11, style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black)),
                                                                                                                                                                                                                                          ),
                                                                                                                                                                                                                                          Expanded(
                                                                                                                                                                                                                                            child: new Text(tanggalBatas11, style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black)),
                                                                                                                                                                                                                                          ),
                                                                                                                                                                                                                                        ],
                                                                                                                                                                                                                                      ),
                                                                                                                                                                                                                                    ),
                                                                                                                                                                                                                                  ],
                                                                                                                                                                                                                                )
                                                                                                                                                                                                                              ]
                                                                                                                                                                                                                          );
                                                                                                                                                                                                                        } else {

                                                                                                                                                                                                                          String dari11;
                                                                                                                                                                                                                          String tanggalDikirim11;
                                                                                                                                                                                                                          String status11;
                                                                                                                                                                                                                          String read11;
                                                                                                                                                                                                                          String catatanPengirim11;
                                                                                                                                                                                                                          String catatanSendiri11;
                                                                                                                                                                                                                          String tanggalBatas11;
                                                                                                                                                                                                                          String tanggalTaggapan11;

                                                                                                                                                                                                                          if (snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].child[vi].child[vii].child[viii].child[ix].child[x].child[xi].satker_dari == null || snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].child[vi].child[vii].child[viii].child[ix].child[x].child[xi].satker_dari == "") {
                                                                                                                                                                                                                            dari11 = "-";
                                                                                                                                                                                                                          } else {
                                                                                                                                                                                                                            dari11 = snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].child[vi].child[vii].child[viii].child[ix].child[x].child[xi].satker_dari;
                                                                                                                                                                                                                          }

                                                                                                                                                                                                                          if (snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].child[vi].child[vii].child[viii].child[ix].child[x].child[xi].tgl_disposisi == null || snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].child[vi].child[vii].child[viii].child[ix].child[x].child[xi].tgl_disposisi == "") {
                                                                                                                                                                                                                            tanggalDikirim11 = "-";
                                                                                                                                                                                                                          } else {
                                                                                                                                                                                                                            tanggalDikirim11 = snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].child[vi].child[vii].child[viii].child[ix].child[x].child[xi].tgl_disposisi;
                                                                                                                                                                                                                          }

                                                                                                                                                                                                                          if (snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].child[vi].child[vii].child[viii].child[ix].child[x].child[xi].status == null || snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].child[vi].child[vii].child[viii].child[ix].child[x].child[xi].status == "") {
                                                                                                                                                                                                                            status11 = "-";
                                                                                                                                                                                                                          } else {
                                                                                                                                                                                                                            status11 = snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].child[vi].child[vii].child[viii].child[ix].child[x].child[xi].status;
                                                                                                                                                                                                                          }

                                                                                                                                                                                                                          if (snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].child[vi].child[vii].child[viii].child[ix].child[x].child[xi].read == null || snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].child[vi].child[vii].child[viii].child[ix].child[x].child[xi].read == "") {
                                                                                                                                                                                                                            read11 = "-";
                                                                                                                                                                                                                          } else {
                                                                                                                                                                                                                            if (snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].child[vi].child[vii].child[viii].child[ix].child[x].child[xi].read == "READ") {
                                                                                                                                                                                                                              read11 = "Sudah";
                                                                                                                                                                                                                            } else if (snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].child[vi].child[vii].child[viii].child[ix].child[x].child[xi].read == "UNREAD") {
                                                                                                                                                                                                                              read11 = "Belum";
                                                                                                                                                                                                                            } else {
                                                                                                                                                                                                                              read11 = snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].child[vi].child[vii].child[viii].child[ix].child[x].child[xi].read;
                                                                                                                                                                                                                            }
                                                                                                                                                                                                                          }

                                                                                                                                                                                                                          if (snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].child[vi].child[vii].child[viii].child[ix].child[x].child[xi].catatan_pengirim == null || snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].child[vi].child[vii].child[viii].child[ix].child[x].child[xi].catatan_pengirim == "") {
                                                                                                                                                                                                                            catatanPengirim11 = "-";
                                                                                                                                                                                                                          } else {
                                                                                                                                                                                                                            catatanPengirim11 = snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].child[vi].child[vii].child[viii].child[ix].child[x].child[xi].catatan_pengirim;
                                                                                                                                                                                                                          }

                                                                                                                                                                                                                          if (snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].child[vi].child[vii].child[viii].child[ix].child[x].child[xi].catatan_sendiri == null || snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].child[vi].child[vii].child[viii].child[ix].child[x].child[xi].catatan_sendiri == "") {
                                                                                                                                                                                                                            catatanSendiri11 = "-";
                                                                                                                                                                                                                          } else {
                                                                                                                                                                                                                            catatanSendiri11 = snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].child[vi].child[vii].child[viii].child[ix].child[x].child[xi].catatan_sendiri;
                                                                                                                                                                                                                          }

                                                                                                                                                                                                                          if (snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].child[vi].child[vii].child[viii].child[ix].child[x].child[xi].tgl_tanggapan == null || snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].child[vi].child[vii].child[viii].child[ix].child[x].child[xi].tgl_tanggapan == "") {
                                                                                                                                                                                                                            tanggalTaggapan11 = "-";
                                                                                                                                                                                                                          } else {
                                                                                                                                                                                                                            tanggalTaggapan11 = snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].child[vi].child[vii].child[viii].child[ix].child[x].child[xi].tgl_tanggapan;
                                                                                                                                                                                                                          }

                                                                                                                                                                                                                          if (snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].child[vi].child[vii].child[viii].child[ix].child[x].child[xi].tgl_batas == null || snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].child[vi].child[vii].child[viii].child[ix].child[x].child[xi].tgl_batas == "") {
                                                                                                                                                                                                                            tanggalBatas11 = "-";
                                                                                                                                                                                                                          } else {
                                                                                                                                                                                                                            tanggalBatas11 = snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].child[vi].child[vii].child[viii].child[ix].child[x].child[xi].tgl_batas;
                                                                                                                                                                                                                          }

                                                                                                                                                                                                                          return new ExpansionTile(
                                                                                                                                                                                                                              trailing: Icon(Icons.expand_more, color: Colors.black),
                                                                                                                                                                                                                              backgroundColor: Colors.white,
                                                                                                                                                                                                                              leading: new InkWell(
                                                                                                                                                                                                                                child: CircleAvatar(
                                                                                                                                                                                                                                    backgroundColor: Colors.orange,
                                                                                                                                                                                                                                    radius: 16.0,
                                                                                                                                                                                                                                    child: new Icon(Icons.message, color: Colors.white, size: 16.0)
                                                                                                                                                                                                                                ),
                                                                                                                                                                                                                              ),
                                                                                                                                                                                                                              title: new Text(snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].child[vi].child[vii].child[viii].child[ix].child[x].child[xi].satker_name, style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 16.0, color: Colors.black)),
                                                                                                                                                                                                                              children: [
                                                                                                                                                                                                                                Column(
                                                                                                                                                                                                                                  children: <Widget>[
                                                                                                                                                                                                                                    Padding(
                                                                                                                                                                                                                                      padding: EdgeInsets.fromLTRB(16.0, 5.0, 16.0, 5.0),
                                                                                                                                                                                                                                      child: Row(
                                                                                                                                                                                                                                        children: <Widget>[
                                                                                                                                                                                                                                          Expanded(
                                                                                                                                                                                                                                            child: new Text("Dari", style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black, fontWeight: FontWeight.bold)),
                                                                                                                                                                                                                                          ),
                                                                                                                                                                                                                                          Expanded(
                                                                                                                                                                                                                                            child: new Text("Tgl Dikirim", style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black, fontWeight: FontWeight.bold)),
                                                                                                                                                                                                                                          ),
                                                                                                                                                                                                                                        ],
                                                                                                                                                                                                                                      ),
                                                                                                                                                                                                                                    ),
                                                                                                                                                                                                                                    Padding(
                                                                                                                                                                                                                                      padding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 5.0),
                                                                                                                                                                                                                                      child: Row(
                                                                                                                                                                                                                                        children: <Widget>[
                                                                                                                                                                                                                                          Expanded(
                                                                                                                                                                                                                                            child: new Text(dari11, style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black)),
                                                                                                                                                                                                                                          ),
                                                                                                                                                                                                                                          Expanded(
                                                                                                                                                                                                                                            child: new Text(tanggalDikirim11, style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black)),
                                                                                                                                                                                                                                          ),
                                                                                                                                                                                                                                        ],
                                                                                                                                                                                                                                      ),
                                                                                                                                                                                                                                    ),
                                                                                                                                                                                                                                    Padding(
                                                                                                                                                                                                                                      padding: EdgeInsets.fromLTRB(16.0, 5.0, 16.0, 5.0),
                                                                                                                                                                                                                                      child: Row(
                                                                                                                                                                                                                                        children: <Widget>[
                                                                                                                                                                                                                                          Expanded(
                                                                                                                                                                                                                                            child: new Text("Status", style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black, fontWeight: FontWeight.bold)),
                                                                                                                                                                                                                                          ),
                                                                                                                                                                                                                                          Expanded(
                                                                                                                                                                                                                                            child: new Text("Dibaca", style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black, fontWeight: FontWeight.bold)),
                                                                                                                                                                                                                                          ),
                                                                                                                                                                                                                                        ],
                                                                                                                                                                                                                                      ),
                                                                                                                                                                                                                                    ),
                                                                                                                                                                                                                                    Padding(
                                                                                                                                                                                                                                      padding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 5.0),
                                                                                                                                                                                                                                      child: Row(
                                                                                                                                                                                                                                        children: <Widget>[
                                                                                                                                                                                                                                          Expanded(
                                                                                                                                                                                                                                            child: new Text(status11, style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black)),
                                                                                                                                                                                                                                          ),
                                                                                                                                                                                                                                          Expanded(
                                                                                                                                                                                                                                            child: new Text(read11, style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black)),
                                                                                                                                                                                                                                          ),
                                                                                                                                                                                                                                        ],
                                                                                                                                                                                                                                      ),
                                                                                                                                                                                                                                    ),
                                                                                                                                                                                                                                    Padding(
                                                                                                                                                                                                                                      padding: EdgeInsets.fromLTRB(16.0, 5.0, 16.0, 5.0),
                                                                                                                                                                                                                                      child: Row(
                                                                                                                                                                                                                                        children: <Widget>[
                                                                                                                                                                                                                                          Expanded(
                                                                                                                                                                                                                                            child: new Text("Catatan Pengirim", style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black, fontWeight: FontWeight.bold)),
                                                                                                                                                                                                                                          ),
                                                                                                                                                                                                                                          Expanded(
                                                                                                                                                                                                                                            child: new Text("Catatan Sendiri", style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black, fontWeight: FontWeight.bold)),
                                                                                                                                                                                                                                          ),
                                                                                                                                                                                                                                        ],
                                                                                                                                                                                                                                      ),
                                                                                                                                                                                                                                    ),
                                                                                                                                                                                                                                    Padding(
                                                                                                                                                                                                                                      padding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 5.0),
                                                                                                                                                                                                                                      child: Row(
                                                                                                                                                                                                                                        children: <Widget>[
                                                                                                                                                                                                                                          Expanded(
                                                                                                                                                                                                                                            child: new Text(catatanPengirim11, style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black)),
                                                                                                                                                                                                                                          ),
                                                                                                                                                                                                                                          Expanded(
                                                                                                                                                                                                                                            child: new Text(catatanSendiri11, style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black)),
                                                                                                                                                                                                                                          ),
                                                                                                                                                                                                                                        ],
                                                                                                                                                                                                                                      ),
                                                                                                                                                                                                                                    ),
                                                                                                                                                                                                                                    Padding(
                                                                                                                                                                                                                                      padding: EdgeInsets.fromLTRB(16.0, 5.0, 16.0, 5.0),
                                                                                                                                                                                                                                      child: Row(
                                                                                                                                                                                                                                        children: <Widget>[
                                                                                                                                                                                                                                          Expanded(
                                                                                                                                                                                                                                            child: new Text("Tgl Tanggapan", style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black, fontWeight: FontWeight.bold)),
                                                                                                                                                                                                                                          ),
                                                                                                                                                                                                                                          Expanded(
                                                                                                                                                                                                                                            child: new Text("Tgl Batas", style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black, fontWeight: FontWeight.bold)),
                                                                                                                                                                                                                                          ),
                                                                                                                                                                                                                                        ],
                                                                                                                                                                                                                                      ),
                                                                                                                                                                                                                                    ),
                                                                                                                                                                                                                                    Padding(
                                                                                                                                                                                                                                      padding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 5.0),
                                                                                                                                                                                                                                      child: Row(
                                                                                                                                                                                                                                        children: <Widget>[
                                                                                                                                                                                                                                          Expanded(
                                                                                                                                                                                                                                            child: new Text(tanggalTaggapan11, style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black)),
                                                                                                                                                                                                                                          ),
                                                                                                                                                                                                                                          Expanded(
                                                                                                                                                                                                                                            child: new Text(tanggalBatas11, style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black)),
                                                                                                                                                                                                                                          ),
                                                                                                                                                                                                                                        ],
                                                                                                                                                                                                                                      ),
                                                                                                                                                                                                                                    ),
                                                                                                                                                                                                                                  ],
                                                                                                                                                                                                                                )
                                                                                                                                                                                                                              ]
                                                                                                                                                                                                                          );
                                                                                                                                                                                                                        }

                                                                                                                                                                                                                      }
                                                                                                                                                                                                                  )
                                                                                                                                                                                                                ],
                                                                                                                                                                                                              )
                                                                                                                                                                                                            ]
                                                                                                                                                                                                        );
                                                                                                                                                                                                      } else {

                                                                                                                                                                                                        String dari10;
                                                                                                                                                                                                        String tanggalDikirim10;
                                                                                                                                                                                                        String status10;
                                                                                                                                                                                                        String read10;
                                                                                                                                                                                                        String catatanPengirim10;
                                                                                                                                                                                                        String catatanSendiri10;
                                                                                                                                                                                                        String tanggalBatas10;
                                                                                                                                                                                                        String tanggalTaggapan10;

                                                                                                                                                                                                        if (snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].child[vi].child[vii].child[viii].child[ix].child[x].satker_dari == null || snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].child[vi].child[vii].child[viii].child[ix].child[x].satker_dari == "") {
                                                                                                                                                                                                          dari10 = "-";
                                                                                                                                                                                                        } else {
                                                                                                                                                                                                          dari10 = snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].child[vi].child[vii].child[viii].child[ix].child[x].satker_dari;
                                                                                                                                                                                                        }

                                                                                                                                                                                                        if (snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].child[vi].child[vii].child[viii].child[ix].child[x].tgl_disposisi == null || snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].child[vi].child[vii].child[viii].child[ix].child[x].tgl_disposisi == "") {
                                                                                                                                                                                                          tanggalDikirim10 = "-";
                                                                                                                                                                                                        } else {
                                                                                                                                                                                                          tanggalDikirim10 = snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].child[vi].child[vii].child[viii].child[ix].child[x].tgl_disposisi;
                                                                                                                                                                                                        }

                                                                                                                                                                                                        if (snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].child[vi].child[vii].child[viii].child[ix].child[x].status == null || snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].child[vi].child[vii].child[viii].child[ix].child[x].status == "") {
                                                                                                                                                                                                          status10 = "-";
                                                                                                                                                                                                        } else {
                                                                                                                                                                                                          status10 = snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].child[vi].child[vii].child[viii].child[ix].child[x].status;
                                                                                                                                                                                                        }

                                                                                                                                                                                                        if (snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].child[vi].child[vii].child[viii].child[ix].child[x].read == null || snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].child[vi].child[vii].child[viii].child[ix].child[x].read == "") {
                                                                                                                                                                                                          read10 = "-";
                                                                                                                                                                                                        } else {
                                                                                                                                                                                                          if (snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].child[vi].child[vii].child[viii].child[ix].child[x].read == "READ") {
                                                                                                                                                                                                            read10 = "Sudah";
                                                                                                                                                                                                          } else if (snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].child[vi].child[vii].child[viii].child[ix].child[x].read == "UNREAD") {
                                                                                                                                                                                                            read10 = "Belum";
                                                                                                                                                                                                          } else {
                                                                                                                                                                                                            read10 = snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].child[vi].child[vii].child[viii].child[ix].child[x].read;
                                                                                                                                                                                                          }
                                                                                                                                                                                                        }

                                                                                                                                                                                                        if (snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].child[vi].child[vii].child[viii].child[ix].child[x].catatan_pengirim == null || snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].child[vi].child[vii].child[viii].child[ix].child[x].catatan_pengirim == "") {
                                                                                                                                                                                                          catatanPengirim10 = "-";
                                                                                                                                                                                                        } else {
                                                                                                                                                                                                          catatanPengirim10 = snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].child[vi].child[vii].child[viii].child[ix].child[x].catatan_pengirim;
                                                                                                                                                                                                        }

                                                                                                                                                                                                        if (snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].child[vi].child[vii].child[viii].child[ix].child[x].catatan_sendiri == null || snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].child[vi].child[vii].child[viii].child[ix].child[x].catatan_sendiri == "") {
                                                                                                                                                                                                          catatanSendiri10 = "-";
                                                                                                                                                                                                        } else {
                                                                                                                                                                                                          catatanSendiri10 = snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].child[vi].child[vii].child[viii].child[ix].child[x].catatan_sendiri;
                                                                                                                                                                                                        }

                                                                                                                                                                                                        if (snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].child[vi].child[vii].child[viii].child[ix].child[x].tgl_tanggapan == null || snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].child[vi].child[vii].child[viii].child[ix].child[x].tgl_tanggapan == "") {
                                                                                                                                                                                                          tanggalTaggapan10 = "-";
                                                                                                                                                                                                        } else {
                                                                                                                                                                                                          tanggalTaggapan10 = snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].child[vi].child[vii].child[viii].child[ix].child[x].tgl_tanggapan;
                                                                                                                                                                                                        }

                                                                                                                                                                                                        if (snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].child[vi].child[vii].child[viii].child[ix].child[x].tgl_batas == null || snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].child[vi].child[vii].child[viii].child[ix].child[x].tgl_batas == "") {
                                                                                                                                                                                                          tanggalBatas10 = "-";
                                                                                                                                                                                                        } else {
                                                                                                                                                                                                          tanggalBatas10 = snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].child[vi].child[vii].child[viii].child[ix].child[x].tgl_batas;
                                                                                                                                                                                                        }

                                                                                                                                                                                                        return new ExpansionTile(
                                                                                                                                                                                                            trailing: Icon(Icons.expand_more, color: Colors.black),
                                                                                                                                                                                                            backgroundColor: Colors.white,
                                                                                                                                                                                                            leading: new InkWell(
                                                                                                                                                                                                              child: CircleAvatar(
                                                                                                                                                                                                                  backgroundColor: Colors.orange,
                                                                                                                                                                                                                  radius: 16.0,
                                                                                                                                                                                                                  child: new Icon(Icons.message, color: Colors.white, size: 16.0)
                                                                                                                                                                                                              ),
                                                                                                                                                                                                            ),
                                                                                                                                                                                                            title: new Text(snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].child[vi].child[vii].child[viii].child[ix].child[x].satker_name, style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 16.0, color: Colors.black)),
                                                                                                                                                                                                            children: [
                                                                                                                                                                                                              Column(
                                                                                                                                                                                                                children: <Widget>[
                                                                                                                                                                                                                  Padding(
                                                                                                                                                                                                                    padding: EdgeInsets.fromLTRB(16.0, 5.0, 16.0, 5.0),
                                                                                                                                                                                                                    child: Row(
                                                                                                                                                                                                                      children: <Widget>[
                                                                                                                                                                                                                        Expanded(
                                                                                                                                                                                                                          child: new Text("Dari", style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black, fontWeight: FontWeight.bold)),
                                                                                                                                                                                                                        ),
                                                                                                                                                                                                                        Expanded(
                                                                                                                                                                                                                          child: new Text("Tgl Dikirim", style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black, fontWeight: FontWeight.bold)),
                                                                                                                                                                                                                        ),
                                                                                                                                                                                                                      ],
                                                                                                                                                                                                                    ),
                                                                                                                                                                                                                  ),
                                                                                                                                                                                                                  Padding(
                                                                                                                                                                                                                    padding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 5.0),
                                                                                                                                                                                                                    child: Row(
                                                                                                                                                                                                                      children: <Widget>[
                                                                                                                                                                                                                        Expanded(
                                                                                                                                                                                                                          child: new Text(dari10, style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black)),
                                                                                                                                                                                                                        ),
                                                                                                                                                                                                                        Expanded(
                                                                                                                                                                                                                          child: new Text(tanggalDikirim10, style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black)),
                                                                                                                                                                                                                        ),
                                                                                                                                                                                                                      ],
                                                                                                                                                                                                                    ),
                                                                                                                                                                                                                  ),
                                                                                                                                                                                                                  Padding(
                                                                                                                                                                                                                    padding: EdgeInsets.fromLTRB(16.0, 5.0, 16.0, 5.0),
                                                                                                                                                                                                                    child: Row(
                                                                                                                                                                                                                      children: <Widget>[
                                                                                                                                                                                                                        Expanded(
                                                                                                                                                                                                                          child: new Text("Status", style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black, fontWeight: FontWeight.bold)),
                                                                                                                                                                                                                        ),
                                                                                                                                                                                                                        Expanded(
                                                                                                                                                                                                                          child: new Text("Dibaca", style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black, fontWeight: FontWeight.bold)),
                                                                                                                                                                                                                        ),
                                                                                                                                                                                                                      ],
                                                                                                                                                                                                                    ),
                                                                                                                                                                                                                  ),
                                                                                                                                                                                                                  Padding(
                                                                                                                                                                                                                    padding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 5.0),
                                                                                                                                                                                                                    child: Row(
                                                                                                                                                                                                                      children: <Widget>[
                                                                                                                                                                                                                        Expanded(
                                                                                                                                                                                                                          child: new Text(status10, style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black)),
                                                                                                                                                                                                                        ),
                                                                                                                                                                                                                        Expanded(
                                                                                                                                                                                                                          child: new Text(read10, style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black)),
                                                                                                                                                                                                                        ),
                                                                                                                                                                                                                      ],
                                                                                                                                                                                                                    ),
                                                                                                                                                                                                                  ),
                                                                                                                                                                                                                  Padding(
                                                                                                                                                                                                                    padding: EdgeInsets.fromLTRB(16.0, 5.0, 16.0, 5.0),
                                                                                                                                                                                                                    child: Row(
                                                                                                                                                                                                                      children: <Widget>[
                                                                                                                                                                                                                        Expanded(
                                                                                                                                                                                                                          child: new Text("Catatan Pengirim", style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black, fontWeight: FontWeight.bold)),
                                                                                                                                                                                                                        ),
                                                                                                                                                                                                                        Expanded(
                                                                                                                                                                                                                          child: new Text("Catatan Sendiri", style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black, fontWeight: FontWeight.bold)),
                                                                                                                                                                                                                        ),
                                                                                                                                                                                                                      ],
                                                                                                                                                                                                                    ),
                                                                                                                                                                                                                  ),
                                                                                                                                                                                                                  Padding(
                                                                                                                                                                                                                    padding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 5.0),
                                                                                                                                                                                                                    child: Row(
                                                                                                                                                                                                                      children: <Widget>[
                                                                                                                                                                                                                        Expanded(
                                                                                                                                                                                                                          child: new Text(catatanPengirim10, style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black)),
                                                                                                                                                                                                                        ),
                                                                                                                                                                                                                        Expanded(
                                                                                                                                                                                                                          child: new Text(catatanSendiri10, style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black)),
                                                                                                                                                                                                                        ),
                                                                                                                                                                                                                      ],
                                                                                                                                                                                                                    ),
                                                                                                                                                                                                                  ),
                                                                                                                                                                                                                  Padding(
                                                                                                                                                                                                                    padding: EdgeInsets.fromLTRB(16.0, 5.0, 16.0, 5.0),
                                                                                                                                                                                                                    child: Row(
                                                                                                                                                                                                                      children: <Widget>[
                                                                                                                                                                                                                        Expanded(
                                                                                                                                                                                                                          child: new Text("Tgl Tanggapan", style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black, fontWeight: FontWeight.bold)),
                                                                                                                                                                                                                        ),
                                                                                                                                                                                                                        Expanded(
                                                                                                                                                                                                                          child: new Text("Tgl Batas", style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black, fontWeight: FontWeight.bold)),
                                                                                                                                                                                                                        ),
                                                                                                                                                                                                                      ],
                                                                                                                                                                                                                    ),
                                                                                                                                                                                                                  ),
                                                                                                                                                                                                                  Padding(
                                                                                                                                                                                                                    padding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 5.0),
                                                                                                                                                                                                                    child: Row(
                                                                                                                                                                                                                      children: <Widget>[
                                                                                                                                                                                                                        Expanded(
                                                                                                                                                                                                                          child: new Text(tanggalTaggapan10, style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black)),
                                                                                                                                                                                                                        ),
                                                                                                                                                                                                                        Expanded(
                                                                                                                                                                                                                          child: new Text(tanggalBatas10, style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black)),
                                                                                                                                                                                                                        ),
                                                                                                                                                                                                                      ],
                                                                                                                                                                                                                    ),
                                                                                                                                                                                                                  ),
                                                                                                                                                                                                                ],
                                                                                                                                                                                                              )
                                                                                                                                                                                                            ]
                                                                                                                                                                                                        );
                                                                                                                                                                                                      }

                                                                                                                                                                                                    }
                                                                                                                                                                                                )
                                                                                                                                                                                              ],
                                                                                                                                                                                            )
                                                                                                                                                                                          ]
                                                                                                                                                                                      );
                                                                                                                                                                                    } else {

                                                                                                                                                                                      String dari9;
                                                                                                                                                                                      String tanggalDikirim9;
                                                                                                                                                                                      String status9;
                                                                                                                                                                                      String read9;
                                                                                                                                                                                      String catatanPengirim9;
                                                                                                                                                                                      String catatanSendiri9;
                                                                                                                                                                                      String tanggalBatas9;
                                                                                                                                                                                      String tanggalTaggapan9;

                                                                                                                                                                                      if (snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].child[vi].child[vii].child[viii].child[ix].satker_dari == null || snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].child[vi].child[vii].child[viii].child[ix].satker_dari == "") {
                                                                                                                                                                                        dari9 = "-";
                                                                                                                                                                                      } else {
                                                                                                                                                                                        dari9 = snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].child[vi].child[vii].child[viii].child[ix].satker_dari;
                                                                                                                                                                                      }

                                                                                                                                                                                      if (snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].child[vi].child[vii].child[viii].child[ix].tgl_disposisi == null || snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].child[vi].child[vii].child[viii].child[ix].tgl_disposisi == "") {
                                                                                                                                                                                        tanggalDikirim9 = "-";
                                                                                                                                                                                      } else {
                                                                                                                                                                                        tanggalDikirim9 = snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].child[vi].child[vii].child[viii].child[ix].tgl_disposisi;
                                                                                                                                                                                      }

                                                                                                                                                                                      if (snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].child[vi].child[vii].child[viii].child[ix].status == null || snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].child[vi].child[vii].child[viii].child[ix].status == "") {
                                                                                                                                                                                        status9 = "-";
                                                                                                                                                                                      } else {
                                                                                                                                                                                        status9 = snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].child[vi].child[vii].child[viii].child[ix].status;
                                                                                                                                                                                      }

                                                                                                                                                                                      if (snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].child[vi].child[vii].child[viii].child[ix].read == null || snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].child[vi].child[vii].child[viii].child[ix].read == "") {
                                                                                                                                                                                        read9 = "-";
                                                                                                                                                                                      } else {
                                                                                                                                                                                        if (snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].child[vi].child[vii].child[viii].child[ix].read == "READ") {
                                                                                                                                                                                          read9 = "Sudah";
                                                                                                                                                                                        } else if (snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].child[vi].child[vii].child[viii].child[ix].read == "UNREAD") {
                                                                                                                                                                                          read9 = "Belum";
                                                                                                                                                                                        } else {
                                                                                                                                                                                          read9 = snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].child[vi].child[vii].child[viii].child[ix].read;
                                                                                                                                                                                        }
                                                                                                                                                                                      }

                                                                                                                                                                                      if (snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].child[vi].child[vii].child[viii].child[ix].catatan_pengirim == null || snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].child[vi].child[vii].child[viii].child[ix].catatan_pengirim == "") {
                                                                                                                                                                                        catatanPengirim9 = "-";
                                                                                                                                                                                      } else {
                                                                                                                                                                                        catatanPengirim9 = snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].child[vi].child[vii].child[viii].child[ix].catatan_pengirim;
                                                                                                                                                                                      }

                                                                                                                                                                                      if (snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].child[vi].child[vii].child[viii].child[ix].catatan_sendiri == null || snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].child[vi].child[vii].child[viii].child[ix].catatan_sendiri == "") {
                                                                                                                                                                                        catatanSendiri9 = "-";
                                                                                                                                                                                      } else {
                                                                                                                                                                                        catatanSendiri9 = snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].child[vi].child[vii].child[viii].child[ix].catatan_sendiri;
                                                                                                                                                                                      }

                                                                                                                                                                                      if (snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].child[vi].child[vii].child[viii].child[ix].tgl_tanggapan == null || snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].child[vi].child[vii].child[viii].child[ix].tgl_tanggapan == "") {
                                                                                                                                                                                        tanggalTaggapan9 = "-";
                                                                                                                                                                                      } else {
                                                                                                                                                                                        tanggalTaggapan9 = snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].child[vi].child[vii].child[viii].child[ix].tgl_tanggapan;
                                                                                                                                                                                      }

                                                                                                                                                                                      if (snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].child[vi].child[vii].child[viii].child[ix].tgl_batas == null || snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].child[vi].child[vii].child[viii].child[ix].tgl_batas == "") {
                                                                                                                                                                                        tanggalBatas9 = "-";
                                                                                                                                                                                      } else {
                                                                                                                                                                                        tanggalBatas9 = snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].child[vi].child[vii].child[viii].child[ix].tgl_batas;
                                                                                                                                                                                      }

                                                                                                                                                                                      return new ExpansionTile(
                                                                                                                                                                                          trailing: Icon(Icons.expand_more, color: Colors.black),
                                                                                                                                                                                          backgroundColor: Colors.white,
                                                                                                                                                                                          leading: new InkWell(
                                                                                                                                                                                            child: CircleAvatar(
                                                                                                                                                                                                backgroundColor: Colors.orange,
                                                                                                                                                                                                radius: 16.0,
                                                                                                                                                                                                child: new Icon(Icons.message, color: Colors.white, size: 16.0)
                                                                                                                                                                                            ),
                                                                                                                                                                                          ),
                                                                                                                                                                                          title: new Text(snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].child[vi].child[vii].child[viii].child[ix].satker_name, style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 16.0, color: Colors.black)),
                                                                                                                                                                                          children: [
                                                                                                                                                                                            Column(
                                                                                                                                                                                              children: <Widget>[
                                                                                                                                                                                                Padding(
                                                                                                                                                                                                  padding: EdgeInsets.fromLTRB(16.0, 5.0, 16.0, 5.0),
                                                                                                                                                                                                  child: Row(
                                                                                                                                                                                                    children: <Widget>[
                                                                                                                                                                                                      Expanded(
                                                                                                                                                                                                        child: new Text("Dari", style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black, fontWeight: FontWeight.bold)),
                                                                                                                                                                                                      ),
                                                                                                                                                                                                      Expanded(
                                                                                                                                                                                                        child: new Text("Tgl Dikirim", style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black, fontWeight: FontWeight.bold)),
                                                                                                                                                                                                      ),
                                                                                                                                                                                                    ],
                                                                                                                                                                                                  ),
                                                                                                                                                                                                ),
                                                                                                                                                                                                Padding(
                                                                                                                                                                                                  padding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 5.0),
                                                                                                                                                                                                  child: Row(
                                                                                                                                                                                                    children: <Widget>[
                                                                                                                                                                                                      Expanded(
                                                                                                                                                                                                        child: new Text(dari9, style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black)),
                                                                                                                                                                                                      ),
                                                                                                                                                                                                      Expanded(
                                                                                                                                                                                                        child: new Text(tanggalDikirim9, style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black)),
                                                                                                                                                                                                      ),
                                                                                                                                                                                                    ],
                                                                                                                                                                                                  ),
                                                                                                                                                                                                ),
                                                                                                                                                                                                Padding(
                                                                                                                                                                                                  padding: EdgeInsets.fromLTRB(16.0, 5.0, 16.0, 5.0),
                                                                                                                                                                                                  child: Row(
                                                                                                                                                                                                    children: <Widget>[
                                                                                                                                                                                                      Expanded(
                                                                                                                                                                                                        child: new Text("Status", style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black, fontWeight: FontWeight.bold)),
                                                                                                                                                                                                      ),
                                                                                                                                                                                                      Expanded(
                                                                                                                                                                                                        child: new Text("Dibaca", style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black, fontWeight: FontWeight.bold)),
                                                                                                                                                                                                      ),
                                                                                                                                                                                                    ],
                                                                                                                                                                                                  ),
                                                                                                                                                                                                ),
                                                                                                                                                                                                Padding(
                                                                                                                                                                                                  padding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 5.0),
                                                                                                                                                                                                  child: Row(
                                                                                                                                                                                                    children: <Widget>[
                                                                                                                                                                                                      Expanded(
                                                                                                                                                                                                        child: new Text(status9, style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black)),
                                                                                                                                                                                                      ),
                                                                                                                                                                                                      Expanded(
                                                                                                                                                                                                        child: new Text(read9, style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black)),
                                                                                                                                                                                                      ),
                                                                                                                                                                                                    ],
                                                                                                                                                                                                  ),
                                                                                                                                                                                                ),
                                                                                                                                                                                                Padding(
                                                                                                                                                                                                  padding: EdgeInsets.fromLTRB(16.0, 5.0, 16.0, 5.0),
                                                                                                                                                                                                  child: Row(
                                                                                                                                                                                                    children: <Widget>[
                                                                                                                                                                                                      Expanded(
                                                                                                                                                                                                        child: new Text("Catatan Pengirim", style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black, fontWeight: FontWeight.bold)),
                                                                                                                                                                                                      ),
                                                                                                                                                                                                      Expanded(
                                                                                                                                                                                                        child: new Text("Catatan Sendiri", style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black, fontWeight: FontWeight.bold)),
                                                                                                                                                                                                      ),
                                                                                                                                                                                                    ],
                                                                                                                                                                                                  ),
                                                                                                                                                                                                ),
                                                                                                                                                                                                Padding(
                                                                                                                                                                                                  padding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 5.0),
                                                                                                                                                                                                  child: Row(
                                                                                                                                                                                                    children: <Widget>[
                                                                                                                                                                                                      Expanded(
                                                                                                                                                                                                        child: new Text(catatanPengirim9, style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black)),
                                                                                                                                                                                                      ),
                                                                                                                                                                                                      Expanded(
                                                                                                                                                                                                        child: new Text(catatanSendiri9, style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black)),
                                                                                                                                                                                                      ),
                                                                                                                                                                                                    ],
                                                                                                                                                                                                  ),
                                                                                                                                                                                                ),
                                                                                                                                                                                                Padding(
                                                                                                                                                                                                  padding: EdgeInsets.fromLTRB(16.0, 5.0, 16.0, 5.0),
                                                                                                                                                                                                  child: Row(
                                                                                                                                                                                                    children: <Widget>[
                                                                                                                                                                                                      Expanded(
                                                                                                                                                                                                        child: new Text("Tgl Tanggapan", style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black, fontWeight: FontWeight.bold)),
                                                                                                                                                                                                      ),
                                                                                                                                                                                                      Expanded(
                                                                                                                                                                                                        child: new Text("Tgl Batas", style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black, fontWeight: FontWeight.bold)),
                                                                                                                                                                                                      ),
                                                                                                                                                                                                    ],
                                                                                                                                                                                                  ),
                                                                                                                                                                                                ),
                                                                                                                                                                                                Padding(
                                                                                                                                                                                                  padding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 5.0),
                                                                                                                                                                                                  child: Row(
                                                                                                                                                                                                    children: <Widget>[
                                                                                                                                                                                                      Expanded(
                                                                                                                                                                                                        child: new Text(tanggalTaggapan9, style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black)),
                                                                                                                                                                                                      ),
                                                                                                                                                                                                      Expanded(
                                                                                                                                                                                                        child: new Text(tanggalBatas9, style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black)),
                                                                                                                                                                                                      ),
                                                                                                                                                                                                    ],
                                                                                                                                                                                                  ),
                                                                                                                                                                                                ),
                                                                                                                                                                                              ],
                                                                                                                                                                                            )
                                                                                                                                                                                          ]
                                                                                                                                                                                      );
                                                                                                                                                                                    }

                                                                                                                                                                                  }
                                                                                                                                                                              )
                                                                                                                                                                            ],
                                                                                                                                                                          )
                                                                                                                                                                        ]
                                                                                                                                                                    );
                                                                                                                                                                  } else {

                                                                                                                                                                    String dari8;
                                                                                                                                                                    String tanggalDikirim8;
                                                                                                                                                                    String status8;
                                                                                                                                                                    String read8;
                                                                                                                                                                    String catatanPengirim8;
                                                                                                                                                                    String catatanSendiri8;
                                                                                                                                                                    String tanggalBatas8;
                                                                                                                                                                    String tanggalTaggapan8;

                                                                                                                                                                    if (snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].child[vi].child[vii].child[viii].satker_dari == null || snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].child[vi].child[vii].child[viii].satker_dari == "") {
                                                                                                                                                                      dari8 = "-";
                                                                                                                                                                    } else {
                                                                                                                                                                      dari8 = snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].child[vi].child[vii].child[viii].satker_dari;
                                                                                                                                                                    }

                                                                                                                                                                    if (snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].child[vi].child[vii].child[viii].tgl_disposisi == null || snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].child[vi].child[vii].child[viii].tgl_disposisi == "") {
                                                                                                                                                                      tanggalDikirim8 = "-";
                                                                                                                                                                    } else {
                                                                                                                                                                      tanggalDikirim8 = snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].child[vi].child[vii].child[viii].tgl_disposisi;
                                                                                                                                                                    }

                                                                                                                                                                    if (snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].child[vi].child[vii].child[viii].status == null || snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].child[vi].child[vii].child[viii].status == "") {
                                                                                                                                                                      status8 = "-";
                                                                                                                                                                    } else {
                                                                                                                                                                      status8 = snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].child[vi].child[vii].child[viii].status;
                                                                                                                                                                    }

                                                                                                                                                                    if (snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].child[vi].child[vii].child[viii].read == null || snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].child[vi].child[vii].child[viii].read == "") {
                                                                                                                                                                      read8 = "-";
                                                                                                                                                                    } else {
                                                                                                                                                                      if (snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].child[vi].child[vii].child[viii].read == "READ") {
                                                                                                                                                                        read8 = "Sudah";
                                                                                                                                                                      } else if (snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].child[vi].child[vii].child[viii].read == "UNREAD") {
                                                                                                                                                                        read8 = "Belum";
                                                                                                                                                                      } else {
                                                                                                                                                                        read8 = snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].child[vi].child[vii].child[viii].read;
                                                                                                                                                                      }
                                                                                                                                                                    }

                                                                                                                                                                    if (snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].child[vi].child[vii].child[viii].catatan_pengirim == null || snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].child[vi].child[vii].child[viii].catatan_pengirim == "") {
                                                                                                                                                                      catatanPengirim8 = "-";
                                                                                                                                                                    } else {
                                                                                                                                                                      catatanPengirim8 = snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].child[vi].child[vii].child[viii].catatan_pengirim;
                                                                                                                                                                    }

                                                                                                                                                                    if (snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].child[vi].child[vii].child[viii].catatan_sendiri == null || snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].child[vi].child[vii].child[viii].catatan_sendiri == "") {
                                                                                                                                                                      catatanSendiri8 = "-";
                                                                                                                                                                    } else {
                                                                                                                                                                      catatanSendiri8 = snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].child[vi].child[vii].child[viii].catatan_sendiri;
                                                                                                                                                                    }

                                                                                                                                                                    if (snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].child[vi].child[vii].child[viii].tgl_tanggapan == null || snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].child[vi].child[vii].child[viii].tgl_tanggapan == "") {
                                                                                                                                                                      tanggalTaggapan8 = "-";
                                                                                                                                                                    } else {
                                                                                                                                                                      tanggalTaggapan8 = snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].child[vi].child[vii].child[viii].tgl_tanggapan;
                                                                                                                                                                    }

                                                                                                                                                                    if (snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].child[vi].child[vii].child[viii].tgl_batas == null || snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].child[vi].child[vii].child[viii].tgl_batas == "") {
                                                                                                                                                                      tanggalBatas8 = "-";
                                                                                                                                                                    } else {
                                                                                                                                                                      tanggalBatas8 = snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].child[vi].child[vii].child[viii].tgl_batas;
                                                                                                                                                                    }

                                                                                                                                                                    return new ExpansionTile(
                                                                                                                                                                        trailing: Icon(Icons.expand_more, color: Colors.black),
                                                                                                                                                                        backgroundColor: Colors.white,
                                                                                                                                                                        leading: new InkWell(
                                                                                                                                                                          child: CircleAvatar(
                                                                                                                                                                              backgroundColor: Colors.orange,
                                                                                                                                                                              radius: 16.0,
                                                                                                                                                                              child: new Icon(Icons.message, color: Colors.white, size: 16.0)
                                                                                                                                                                          ),
                                                                                                                                                                        ),
                                                                                                                                                                        title: new Text(snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].child[vi].child[vii].child[viii].satker_name, style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 16.0, color: Colors.black)),
                                                                                                                                                                        children: [
                                                                                                                                                                          Column(
                                                                                                                                                                            children: <Widget>[
                                                                                                                                                                              Padding(
                                                                                                                                                                                padding: EdgeInsets.fromLTRB(16.0, 5.0, 16.0, 5.0),
                                                                                                                                                                                child: Row(
                                                                                                                                                                                  children: <Widget>[
                                                                                                                                                                                    Expanded(
                                                                                                                                                                                      child: new Text("Dari", style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black, fontWeight: FontWeight.bold)),
                                                                                                                                                                                    ),
                                                                                                                                                                                    Expanded(
                                                                                                                                                                                      child: new Text("Tgl Dikirim", style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black, fontWeight: FontWeight.bold)),
                                                                                                                                                                                    ),
                                                                                                                                                                                  ],
                                                                                                                                                                                ),
                                                                                                                                                                              ),
                                                                                                                                                                              Padding(
                                                                                                                                                                                padding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 5.0),
                                                                                                                                                                                child: Row(
                                                                                                                                                                                  children: <Widget>[
                                                                                                                                                                                    Expanded(
                                                                                                                                                                                      child: new Text(dari8, style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black)),
                                                                                                                                                                                    ),
                                                                                                                                                                                    Expanded(
                                                                                                                                                                                      child: new Text(tanggalDikirim8, style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black)),
                                                                                                                                                                                    ),
                                                                                                                                                                                  ],
                                                                                                                                                                                ),
                                                                                                                                                                              ),
                                                                                                                                                                              Padding(
                                                                                                                                                                                padding: EdgeInsets.fromLTRB(16.0, 5.0, 16.0, 5.0),
                                                                                                                                                                                child: Row(
                                                                                                                                                                                  children: <Widget>[
                                                                                                                                                                                    Expanded(
                                                                                                                                                                                      child: new Text("Status", style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black, fontWeight: FontWeight.bold)),
                                                                                                                                                                                    ),
                                                                                                                                                                                    Expanded(
                                                                                                                                                                                      child: new Text("Dibaca", style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black, fontWeight: FontWeight.bold)),
                                                                                                                                                                                    ),
                                                                                                                                                                                  ],
                                                                                                                                                                                ),
                                                                                                                                                                              ),
                                                                                                                                                                              Padding(
                                                                                                                                                                                padding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 5.0),
                                                                                                                                                                                child: Row(
                                                                                                                                                                                  children: <Widget>[
                                                                                                                                                                                    Expanded(
                                                                                                                                                                                      child: new Text(status8, style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black)),
                                                                                                                                                                                    ),
                                                                                                                                                                                    Expanded(
                                                                                                                                                                                      child: new Text(read8, style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black)),
                                                                                                                                                                                    ),
                                                                                                                                                                                  ],
                                                                                                                                                                                ),
                                                                                                                                                                              ),
                                                                                                                                                                              Padding(
                                                                                                                                                                                padding: EdgeInsets.fromLTRB(16.0, 5.0, 16.0, 5.0),
                                                                                                                                                                                child: Row(
                                                                                                                                                                                  children: <Widget>[
                                                                                                                                                                                    Expanded(
                                                                                                                                                                                      child: new Text("Catatan Pengirim", style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black, fontWeight: FontWeight.bold)),
                                                                                                                                                                                    ),
                                                                                                                                                                                    Expanded(
                                                                                                                                                                                      child: new Text("Catatan Sendiri", style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black, fontWeight: FontWeight.bold)),
                                                                                                                                                                                    ),
                                                                                                                                                                                  ],
                                                                                                                                                                                ),
                                                                                                                                                                              ),
                                                                                                                                                                              Padding(
                                                                                                                                                                                padding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 5.0),
                                                                                                                                                                                child: Row(
                                                                                                                                                                                  children: <Widget>[
                                                                                                                                                                                    Expanded(
                                                                                                                                                                                      child: new Text(catatanPengirim8, style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black)),
                                                                                                                                                                                    ),
                                                                                                                                                                                    Expanded(
                                                                                                                                                                                      child: new Text(catatanSendiri8, style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black)),
                                                                                                                                                                                    ),
                                                                                                                                                                                  ],
                                                                                                                                                                                ),
                                                                                                                                                                              ),
                                                                                                                                                                              Padding(
                                                                                                                                                                                padding: EdgeInsets.fromLTRB(16.0, 5.0, 16.0, 5.0),
                                                                                                                                                                                child: Row(
                                                                                                                                                                                  children: <Widget>[
                                                                                                                                                                                    Expanded(
                                                                                                                                                                                      child: new Text("Tgl Tanggapan", style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black, fontWeight: FontWeight.bold)),
                                                                                                                                                                                    ),
                                                                                                                                                                                    Expanded(
                                                                                                                                                                                      child: new Text("Tgl Batas", style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black, fontWeight: FontWeight.bold)),
                                                                                                                                                                                    ),
                                                                                                                                                                                  ],
                                                                                                                                                                                ),
                                                                                                                                                                              ),
                                                                                                                                                                              Padding(
                                                                                                                                                                                padding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 5.0),
                                                                                                                                                                                child: Row(
                                                                                                                                                                                  children: <Widget>[
                                                                                                                                                                                    Expanded(
                                                                                                                                                                                      child: new Text(tanggalTaggapan8, style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black)),
                                                                                                                                                                                    ),
                                                                                                                                                                                    Expanded(
                                                                                                                                                                                      child: new Text(tanggalBatas8, style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black)),
                                                                                                                                                                                    ),
                                                                                                                                                                                  ],
                                                                                                                                                                                ),
                                                                                                                                                                              ),
                                                                                                                                                                            ],
                                                                                                                                                                          )
                                                                                                                                                                        ]
                                                                                                                                                                    );
                                                                                                                                                                  }

                                                                                                                                                                }
                                                                                                                                                            )
                                                                                                                                                          ],
                                                                                                                                                        )
                                                                                                                                                      ]
                                                                                                                                                  );
                                                                                                                                                } else {

                                                                                                                                                  String dari7;
                                                                                                                                                  String tanggalDikirim7;
                                                                                                                                                  String status7;
                                                                                                                                                  String read7;
                                                                                                                                                  String catatanPengirim7;
                                                                                                                                                  String catatanSendiri7;
                                                                                                                                                  String tanggalBatas7;
                                                                                                                                                  String tanggalTaggapan7;

                                                                                                                                                  if (snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].child[vi].child[vii].satker_dari == null || snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].child[vi].child[vii].satker_dari == "") {
                                                                                                                                                    dari7 = "-";
                                                                                                                                                  } else {
                                                                                                                                                    dari7 = snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].child[vi].child[vii].satker_dari;
                                                                                                                                                  }

                                                                                                                                                  if (snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].child[vi].child[vii].tgl_disposisi == null || snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].child[vi].child[vii].tgl_disposisi == "") {
                                                                                                                                                    tanggalDikirim7 = "-";
                                                                                                                                                  } else {
                                                                                                                                                    tanggalDikirim7 = snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].child[vi].child[vii].tgl_disposisi;
                                                                                                                                                  }

                                                                                                                                                  if (snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].child[vi].child[vii].status == null || snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].child[vi].child[vii].status == "") {
                                                                                                                                                    status7 = "-";
                                                                                                                                                  } else {
                                                                                                                                                    status7 = snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].child[vi].child[vii].status;
                                                                                                                                                  }

                                                                                                                                                  if (snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].child[vi].child[vii].read == null || snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].child[vi].child[vii].read == "") {
                                                                                                                                                    read7 = "-";
                                                                                                                                                  } else {
                                                                                                                                                    if (snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].child[vi].child[vii].read == "READ") {
                                                                                                                                                      read7 = "Sudah";
                                                                                                                                                    } else if (snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].child[vi].child[vii].read == "UNREAD") {
                                                                                                                                                      read7 = "Belum";
                                                                                                                                                    } else {
                                                                                                                                                      read7 = snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].child[vi].child[vii].read;
                                                                                                                                                    }
                                                                                                                                                  }

                                                                                                                                                  if (snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].child[vi].child[vii].catatan_pengirim == null || snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].child[vi].child[vii].catatan_pengirim == "") {
                                                                                                                                                    catatanPengirim7 = "-";
                                                                                                                                                  } else {
                                                                                                                                                    catatanPengirim7 = snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].child[vi].child[vii].catatan_pengirim;
                                                                                                                                                  }

                                                                                                                                                  if (snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].child[vi].child[vii].catatan_sendiri == null || snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].child[vi].child[vii].catatan_sendiri == "") {
                                                                                                                                                    catatanSendiri7 = "-";
                                                                                                                                                  } else {
                                                                                                                                                    catatanSendiri7 = snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].child[vi].child[vii].catatan_sendiri;
                                                                                                                                                  }

                                                                                                                                                  if (snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].child[vi].child[vii].tgl_tanggapan == null || snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].child[vi].child[vii].tgl_tanggapan == "") {
                                                                                                                                                    tanggalTaggapan7 = "-";
                                                                                                                                                  } else {
                                                                                                                                                    tanggalTaggapan7 = snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].child[vi].child[vii].tgl_tanggapan;
                                                                                                                                                  }

                                                                                                                                                  if (snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].child[vi].child[vii].tgl_batas == null || snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].child[vi].child[vii].tgl_batas == "") {
                                                                                                                                                    tanggalBatas7 = "-";
                                                                                                                                                  } else {
                                                                                                                                                    tanggalBatas7 = snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].child[vi].child[vii].tgl_batas;
                                                                                                                                                  }

                                                                                                                                                  return new ExpansionTile(
                                                                                                                                                      trailing: Icon(Icons.expand_more, color: Colors.black),
                                                                                                                                                      backgroundColor: Colors.white,
                                                                                                                                                      leading: new InkWell(
                                                                                                                                                        child: CircleAvatar(
                                                                                                                                                            backgroundColor: Colors.orange,
                                                                                                                                                            radius: 16.0,
                                                                                                                                                            child: new Icon(Icons.message, color: Colors.white, size: 16.0)
                                                                                                                                                        ),
                                                                                                                                                      ),
                                                                                                                                                      title: new Text(snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].child[vi].child[vii].satker_name, style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 16.0, color: Colors.black)),
                                                                                                                                                      children: [
                                                                                                                                                        Column(
                                                                                                                                                          children: <Widget>[
                                                                                                                                                            Padding(
                                                                                                                                                              padding: EdgeInsets.fromLTRB(16.0, 5.0, 16.0, 5.0),
                                                                                                                                                              child: Row(
                                                                                                                                                                children: <Widget>[
                                                                                                                                                                  Expanded(
                                                                                                                                                                    child: new Text("Dari", style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black, fontWeight: FontWeight.bold)),
                                                                                                                                                                  ),
                                                                                                                                                                  Expanded(
                                                                                                                                                                    child: new Text("Tgl Dikirim", style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black, fontWeight: FontWeight.bold)),
                                                                                                                                                                  ),
                                                                                                                                                                ],
                                                                                                                                                              ),
                                                                                                                                                            ),
                                                                                                                                                            Padding(
                                                                                                                                                              padding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 5.0),
                                                                                                                                                              child: Row(
                                                                                                                                                                children: <Widget>[
                                                                                                                                                                  Expanded(
                                                                                                                                                                    child: new Text(dari7, style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black)),
                                                                                                                                                                  ),
                                                                                                                                                                  Expanded(
                                                                                                                                                                    child: new Text(tanggalDikirim7, style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black)),
                                                                                                                                                                  ),
                                                                                                                                                                ],
                                                                                                                                                              ),
                                                                                                                                                            ),
                                                                                                                                                            Padding(
                                                                                                                                                              padding: EdgeInsets.fromLTRB(16.0, 5.0, 16.0, 5.0),
                                                                                                                                                              child: Row(
                                                                                                                                                                children: <Widget>[
                                                                                                                                                                  Expanded(
                                                                                                                                                                    child: new Text("Status", style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black, fontWeight: FontWeight.bold)),
                                                                                                                                                                  ),
                                                                                                                                                                  Expanded(
                                                                                                                                                                    child: new Text("Dibaca", style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black, fontWeight: FontWeight.bold)),
                                                                                                                                                                  ),
                                                                                                                                                                ],
                                                                                                                                                              ),
                                                                                                                                                            ),
                                                                                                                                                            Padding(
                                                                                                                                                              padding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 5.0),
                                                                                                                                                              child: Row(
                                                                                                                                                                children: <Widget>[
                                                                                                                                                                  Expanded(
                                                                                                                                                                    child: new Text(status7, style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black)),
                                                                                                                                                                  ),
                                                                                                                                                                  Expanded(
                                                                                                                                                                    child: new Text(read7, style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black)),
                                                                                                                                                                  ),
                                                                                                                                                                ],
                                                                                                                                                              ),
                                                                                                                                                            ),
                                                                                                                                                            Padding(
                                                                                                                                                              padding: EdgeInsets.fromLTRB(16.0, 5.0, 16.0, 5.0),
                                                                                                                                                              child: Row(
                                                                                                                                                                children: <Widget>[
                                                                                                                                                                  Expanded(
                                                                                                                                                                    child: new Text("Catatan Pengirim", style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black, fontWeight: FontWeight.bold)),
                                                                                                                                                                  ),
                                                                                                                                                                  Expanded(
                                                                                                                                                                    child: new Text("Catatan Sendiri", style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black, fontWeight: FontWeight.bold)),
                                                                                                                                                                  ),
                                                                                                                                                                ],
                                                                                                                                                              ),
                                                                                                                                                            ),
                                                                                                                                                            Padding(
                                                                                                                                                              padding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 5.0),
                                                                                                                                                              child: Row(
                                                                                                                                                                children: <Widget>[
                                                                                                                                                                  Expanded(
                                                                                                                                                                    child: new Text(catatanPengirim7, style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black)),
                                                                                                                                                                  ),
                                                                                                                                                                  Expanded(
                                                                                                                                                                    child: new Text(catatanSendiri7, style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black)),
                                                                                                                                                                  ),
                                                                                                                                                                ],
                                                                                                                                                              ),
                                                                                                                                                            ),
                                                                                                                                                            Padding(
                                                                                                                                                              padding: EdgeInsets.fromLTRB(16.0, 5.0, 16.0, 5.0),
                                                                                                                                                              child: Row(
                                                                                                                                                                children: <Widget>[
                                                                                                                                                                  Expanded(
                                                                                                                                                                    child: new Text("Tgl Tanggapan", style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black, fontWeight: FontWeight.bold)),
                                                                                                                                                                  ),
                                                                                                                                                                  Expanded(
                                                                                                                                                                    child: new Text("Tgl Batas", style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black, fontWeight: FontWeight.bold)),
                                                                                                                                                                  ),
                                                                                                                                                                ],
                                                                                                                                                              ),
                                                                                                                                                            ),
                                                                                                                                                            Padding(
                                                                                                                                                              padding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 5.0),
                                                                                                                                                              child: Row(
                                                                                                                                                                children: <Widget>[
                                                                                                                                                                  Expanded(
                                                                                                                                                                    child: new Text(tanggalTaggapan7, style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black)),
                                                                                                                                                                  ),
                                                                                                                                                                  Expanded(
                                                                                                                                                                    child: new Text(tanggalBatas7, style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black)),
                                                                                                                                                                  ),
                                                                                                                                                                ],
                                                                                                                                                              ),
                                                                                                                                                            ),
                                                                                                                                                          ],
                                                                                                                                                        )
                                                                                                                                                      ]
                                                                                                                                                  );
                                                                                                                                                }

                                                                                                                                              }
                                                                                                                                          )
                                                                                                                                        ],
                                                                                                                                      )
                                                                                                                                    ]
                                                                                                                                );
                                                                                                                              } else {

                                                                                                                                String dari6;
                                                                                                                                String tanggalDikirim6;
                                                                                                                                String status6;
                                                                                                                                String read6;
                                                                                                                                String catatanPengirim6;
                                                                                                                                String catatanSendiri6;
                                                                                                                                String tanggalBatas6;
                                                                                                                                String tanggalTaggapan6;

                                                                                                                                if (snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].child[vi].satker_dari == null || snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].child[vi].satker_dari == "") {
                                                                                                                                  dari6 = "-";
                                                                                                                                } else {
                                                                                                                                  dari6 = snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].child[vi].satker_dari;
                                                                                                                                }

                                                                                                                                if (snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].child[vi].tgl_disposisi == null || snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].child[vi].tgl_disposisi == "") {
                                                                                                                                  tanggalDikirim6 = "-";
                                                                                                                                } else {
                                                                                                                                  tanggalDikirim6 = snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].child[vi].tgl_disposisi;
                                                                                                                                }

                                                                                                                                if (snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].child[vi].status == null || snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].child[vi].status == "") {
                                                                                                                                  status6 = "-";
                                                                                                                                } else {
                                                                                                                                  status6 = snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].child[vi].status;
                                                                                                                                }

                                                                                                                                if (snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].child[vi].read == null || snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].child[vi].read == "") {
                                                                                                                                  read6 = "-";
                                                                                                                                } else {
                                                                                                                                  if (snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].child[vi].read == "READ") {
                                                                                                                                    read6 = "Sudah";
                                                                                                                                  } else if (snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].child[vi].read == "UNREAD") {
                                                                                                                                    read6 = "Belum";
                                                                                                                                  } else {
                                                                                                                                    read6 = snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].child[vi].read;
                                                                                                                                  }
                                                                                                                                }

                                                                                                                                if (snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].child[vi].catatan_pengirim == null || snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].child[vi].catatan_pengirim == "") {
                                                                                                                                  catatanPengirim6 = "-";
                                                                                                                                } else {
                                                                                                                                  catatanPengirim6 = snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].child[vi].catatan_pengirim;
                                                                                                                                }

                                                                                                                                if (snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].child[vi].catatan_sendiri == null || snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].child[vi].catatan_sendiri == "") {
                                                                                                                                  catatanSendiri6 = "-";
                                                                                                                                } else {
                                                                                                                                  catatanSendiri6 = snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].child[vi].catatan_sendiri;
                                                                                                                                }

                                                                                                                                if (snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].child[vi].tgl_tanggapan == null || snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].child[vi].tgl_tanggapan == "") {
                                                                                                                                  tanggalTaggapan6 = "-";
                                                                                                                                } else {
                                                                                                                                  tanggalTaggapan6 = snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].child[vi].tgl_tanggapan;
                                                                                                                                }

                                                                                                                                if (snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].child[vi].tgl_batas == null || snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].child[vi].tgl_batas == "") {
                                                                                                                                  tanggalBatas6 = "-";
                                                                                                                                } else {
                                                                                                                                  tanggalBatas6 = snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].child[vi].tgl_batas;
                                                                                                                                }

                                                                                                                                return new ExpansionTile(
                                                                                                                                    trailing: Icon(Icons.expand_more, color: Colors.black),
                                                                                                                                    backgroundColor: Colors.white,
                                                                                                                                    leading: new InkWell(
                                                                                                                                      child: CircleAvatar(
                                                                                                                                          backgroundColor: Colors.orange,
                                                                                                                                          radius: 16.0,
                                                                                                                                          child: new Icon(Icons.message, color: Colors.white, size: 16.0)
                                                                                                                                      ),
                                                                                                                                    ),
                                                                                                                                    title: new Text(snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].child[vi].satker_name, style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 16.0, color: Colors.black)),
                                                                                                                                    children: [
                                                                                                                                      Column(
                                                                                                                                        children: <Widget>[
                                                                                                                                          Padding(
                                                                                                                                            padding: EdgeInsets.fromLTRB(16.0, 5.0, 16.0, 5.0),
                                                                                                                                            child: Row(
                                                                                                                                              children: <Widget>[
                                                                                                                                                Expanded(
                                                                                                                                                  child: new Text("Dari", style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black, fontWeight: FontWeight.bold)),
                                                                                                                                                ),
                                                                                                                                                Expanded(
                                                                                                                                                  child: new Text("Tgl Dikirim", style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black, fontWeight: FontWeight.bold)),
                                                                                                                                                ),
                                                                                                                                              ],
                                                                                                                                            ),
                                                                                                                                          ),
                                                                                                                                          Padding(
                                                                                                                                            padding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 5.0),
                                                                                                                                            child: Row(
                                                                                                                                              children: <Widget>[
                                                                                                                                                Expanded(
                                                                                                                                                  child: new Text(dari6, style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black)),
                                                                                                                                                ),
                                                                                                                                                Expanded(
                                                                                                                                                  child: new Text(tanggalDikirim6, style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black)),
                                                                                                                                                ),
                                                                                                                                              ],
                                                                                                                                            ),
                                                                                                                                          ),
                                                                                                                                          Padding(
                                                                                                                                            padding: EdgeInsets.fromLTRB(16.0, 5.0, 16.0, 5.0),
                                                                                                                                            child: Row(
                                                                                                                                              children: <Widget>[
                                                                                                                                                Expanded(
                                                                                                                                                  child: new Text("Status", style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black, fontWeight: FontWeight.bold)),
                                                                                                                                                ),
                                                                                                                                                Expanded(
                                                                                                                                                  child: new Text("Dibaca", style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black, fontWeight: FontWeight.bold)),
                                                                                                                                                ),
                                                                                                                                              ],
                                                                                                                                            ),
                                                                                                                                          ),
                                                                                                                                          Padding(
                                                                                                                                            padding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 5.0),
                                                                                                                                            child: Row(
                                                                                                                                              children: <Widget>[
                                                                                                                                                Expanded(
                                                                                                                                                  child: new Text(status6, style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black)),
                                                                                                                                                ),
                                                                                                                                                Expanded(
                                                                                                                                                  child: new Text(read6, style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black)),
                                                                                                                                                ),
                                                                                                                                              ],
                                                                                                                                            ),
                                                                                                                                          ),
                                                                                                                                          Padding(
                                                                                                                                            padding: EdgeInsets.fromLTRB(16.0, 5.0, 16.0, 5.0),
                                                                                                                                            child: Row(
                                                                                                                                              children: <Widget>[
                                                                                                                                                Expanded(
                                                                                                                                                  child: new Text("Catatan Pengirim", style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black, fontWeight: FontWeight.bold)),
                                                                                                                                                ),
                                                                                                                                                Expanded(
                                                                                                                                                  child: new Text("Catatan Sendiri", style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black, fontWeight: FontWeight.bold)),
                                                                                                                                                ),
                                                                                                                                              ],
                                                                                                                                            ),
                                                                                                                                          ),
                                                                                                                                          Padding(
                                                                                                                                            padding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 5.0),
                                                                                                                                            child: Row(
                                                                                                                                              children: <Widget>[
                                                                                                                                                Expanded(
                                                                                                                                                  child: new Text(catatanPengirim6, style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black)),
                                                                                                                                                ),
                                                                                                                                                Expanded(
                                                                                                                                                  child: new Text(catatanSendiri6, style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black)),
                                                                                                                                                ),
                                                                                                                                              ],
                                                                                                                                            ),
                                                                                                                                          ),
                                                                                                                                          Padding(
                                                                                                                                            padding: EdgeInsets.fromLTRB(16.0, 5.0, 16.0, 5.0),
                                                                                                                                            child: Row(
                                                                                                                                              children: <Widget>[
                                                                                                                                                Expanded(
                                                                                                                                                  child: new Text("Tgl Tanggapan", style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black, fontWeight: FontWeight.bold)),
                                                                                                                                                ),
                                                                                                                                                Expanded(
                                                                                                                                                  child: new Text("Tgl Batas", style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black, fontWeight: FontWeight.bold)),
                                                                                                                                                ),
                                                                                                                                              ],
                                                                                                                                            ),
                                                                                                                                          ),
                                                                                                                                          Padding(
                                                                                                                                            padding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 5.0),
                                                                                                                                            child: Row(
                                                                                                                                              children: <Widget>[
                                                                                                                                                Expanded(
                                                                                                                                                  child: new Text(tanggalTaggapan6, style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black)),
                                                                                                                                                ),
                                                                                                                                                Expanded(
                                                                                                                                                  child: new Text(tanggalBatas6, style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black)),
                                                                                                                                                ),
                                                                                                                                              ],
                                                                                                                                            ),
                                                                                                                                          ),
                                                                                                                                        ],
                                                                                                                                      )
                                                                                                                                    ]
                                                                                                                                );
                                                                                                                              }

                                                                                                                            }
                                                                                                                        )
                                                                                                                      ],
                                                                                                                    )
                                                                                                                  ]
                                                                                                              );
                                                                                                            } else {

                                                                                                              String dari5;
                                                                                                              String tanggalDikirim5;
                                                                                                              String status5;
                                                                                                              String read5;
                                                                                                              String catatanPengirim5;
                                                                                                              String catatanSendiri5;
                                                                                                              String tanggalBatas5;
                                                                                                              String tanggalTaggapan5;

                                                                                                              if (snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].satker_dari == null || snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].satker_dari == "") {
                                                                                                                dari5 = "-";
                                                                                                              } else {
                                                                                                                dari5 = snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].satker_dari;
                                                                                                              }

                                                                                                              if (snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].tgl_disposisi == null || snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].tgl_disposisi == "") {
                                                                                                                tanggalDikirim5 = "-";
                                                                                                              } else {
                                                                                                                tanggalDikirim5 = snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].tgl_disposisi;
                                                                                                              }

                                                                                                              if (snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].status == null || snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].status == "") {
                                                                                                                status5 = "-";
                                                                                                              } else {
                                                                                                                status5 = snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].status;
                                                                                                              }

                                                                                                              if (snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].read == null || snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].read == "") {
                                                                                                                read5 = "-";
                                                                                                              } else {
                                                                                                                if (snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].read == "READ") {
                                                                                                                  read5 = "Sudah";
                                                                                                                } else if (snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].read == "UNREAD") {
                                                                                                                  read5 = "Belum";
                                                                                                                } else {
                                                                                                                  read5 = snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].read;
                                                                                                                }
                                                                                                              }

                                                                                                              if (snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].catatan_pengirim == null || snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].catatan_pengirim == "") {
                                                                                                                catatanPengirim5 = "-";
                                                                                                              } else {
                                                                                                                catatanPengirim5 = snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].catatan_pengirim;
                                                                                                              }

                                                                                                              if (snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].catatan_sendiri == null || snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].catatan_sendiri == "") {
                                                                                                                catatanSendiri5 = "-";
                                                                                                              } else {
                                                                                                                catatanSendiri5 = snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].catatan_sendiri;
                                                                                                              }

                                                                                                              if (snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].tgl_tanggapan == null || snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].tgl_tanggapan == "") {
                                                                                                                tanggalTaggapan5 = "-";
                                                                                                              } else {
                                                                                                                tanggalTaggapan5 = snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].tgl_tanggapan;
                                                                                                              }

                                                                                                              if (snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].tgl_batas == null || snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].tgl_batas == "") {
                                                                                                                tanggalBatas5 = "-";
                                                                                                              } else {
                                                                                                                tanggalBatas5 = snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].tgl_batas;
                                                                                                              }

                                                                                                              return new ExpansionTile(
                                                                                                                  trailing: Icon(Icons.expand_more, color: Colors.black),
                                                                                                                  backgroundColor: Colors.white,
                                                                                                                  leading: new InkWell(
                                                                                                                    child: CircleAvatar(
                                                                                                                        backgroundColor: Colors.orange,
                                                                                                                        radius: 16.0,
                                                                                                                        child: new Icon(Icons.message, color: Colors.white, size: 16.0)
                                                                                                                    ),
                                                                                                                  ),
                                                                                                                  title: new Text(snapshot.data.childs[i].child[ii].child[iii].child[iv].child[v].satker_name, style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 16.0, color: Colors.black)),
                                                                                                                  children: [
                                                                                                                    Column(
                                                                                                                      children: <Widget>[
                                                                                                                        Padding(
                                                                                                                          padding: EdgeInsets.fromLTRB(16.0, 5.0, 16.0, 5.0),
                                                                                                                          child: Row(
                                                                                                                            children: <Widget>[
                                                                                                                              Expanded(
                                                                                                                                child: new Text("Dari", style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black, fontWeight: FontWeight.bold)),
                                                                                                                              ),
                                                                                                                              Expanded(
                                                                                                                                child: new Text("Tgl Dikirim", style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black, fontWeight: FontWeight.bold)),
                                                                                                                              ),
                                                                                                                            ],
                                                                                                                          ),
                                                                                                                        ),
                                                                                                                        Padding(
                                                                                                                          padding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 5.0),
                                                                                                                          child: Row(
                                                                                                                            children: <Widget>[
                                                                                                                              Expanded(
                                                                                                                                child: new Text(dari5, style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black)),
                                                                                                                              ),
                                                                                                                              Expanded(
                                                                                                                                child: new Text(tanggalDikirim5, style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black)),
                                                                                                                              ),
                                                                                                                            ],
                                                                                                                          ),
                                                                                                                        ),
                                                                                                                        Padding(
                                                                                                                          padding: EdgeInsets.fromLTRB(16.0, 5.0, 16.0, 5.0),
                                                                                                                          child: Row(
                                                                                                                            children: <Widget>[
                                                                                                                              Expanded(
                                                                                                                                child: new Text("Status", style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black, fontWeight: FontWeight.bold)),
                                                                                                                              ),
                                                                                                                              Expanded(
                                                                                                                                child: new Text("Dibaca", style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black, fontWeight: FontWeight.bold)),
                                                                                                                              ),
                                                                                                                            ],
                                                                                                                          ),
                                                                                                                        ),
                                                                                                                        Padding(
                                                                                                                          padding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 5.0),
                                                                                                                          child: Row(
                                                                                                                            children: <Widget>[
                                                                                                                              Expanded(
                                                                                                                                child: new Text(status5, style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black)),
                                                                                                                              ),
                                                                                                                              Expanded(
                                                                                                                                child: new Text(read5, style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black)),
                                                                                                                              ),
                                                                                                                            ],
                                                                                                                          ),
                                                                                                                        ),
                                                                                                                        Padding(
                                                                                                                          padding: EdgeInsets.fromLTRB(16.0, 5.0, 16.0, 5.0),
                                                                                                                          child: Row(
                                                                                                                            children: <Widget>[
                                                                                                                              Expanded(
                                                                                                                                child: new Text("Catatan Pengirim", style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black, fontWeight: FontWeight.bold)),
                                                                                                                              ),
                                                                                                                              Expanded(
                                                                                                                                child: new Text("Catatan Sendiri", style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black, fontWeight: FontWeight.bold)),
                                                                                                                              ),
                                                                                                                            ],
                                                                                                                          ),
                                                                                                                        ),
                                                                                                                        Padding(
                                                                                                                          padding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 5.0),
                                                                                                                          child: Row(
                                                                                                                            children: <Widget>[
                                                                                                                              Expanded(
                                                                                                                                child: new Text(catatanPengirim5, style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black)),
                                                                                                                              ),
                                                                                                                              Expanded(
                                                                                                                                child: new Text(catatanSendiri5, style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black)),
                                                                                                                              ),
                                                                                                                            ],
                                                                                                                          ),
                                                                                                                        ),
                                                                                                                        Padding(
                                                                                                                          padding: EdgeInsets.fromLTRB(16.0, 5.0, 16.0, 5.0),
                                                                                                                          child: Row(
                                                                                                                            children: <Widget>[
                                                                                                                              Expanded(
                                                                                                                                child: new Text("Tgl Tanggapan", style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black, fontWeight: FontWeight.bold)),
                                                                                                                              ),
                                                                                                                              Expanded(
                                                                                                                                child: new Text("Tgl Batas", style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black, fontWeight: FontWeight.bold)),
                                                                                                                              ),
                                                                                                                            ],
                                                                                                                          ),
                                                                                                                        ),
                                                                                                                        Padding(
                                                                                                                          padding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 5.0),
                                                                                                                          child: Row(
                                                                                                                            children: <Widget>[
                                                                                                                              Expanded(
                                                                                                                                child: new Text(tanggalTaggapan5, style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black)),
                                                                                                                              ),
                                                                                                                              Expanded(
                                                                                                                                child: new Text(tanggalBatas5, style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black)),
                                                                                                                              ),
                                                                                                                            ],
                                                                                                                          ),
                                                                                                                        ),
                                                                                                                      ],
                                                                                                                    )
                                                                                                                  ]
                                                                                                              );
                                                                                                            }

                                                                                                          }
                                                                                                      )
                                                                                                    ],
                                                                                                  )
                                                                                                ]
                                                                                            );
                                                                                          } else {

                                                                                            String dari4;
                                                                                            String tanggalDikirim4;
                                                                                            String status4;
                                                                                            String read4;
                                                                                            String catatanPengirim4;
                                                                                            String catatanSendiri4;
                                                                                            String tanggalBatas4;
                                                                                            String tanggalTaggapan4;

                                                                                            if (snapshot.data.childs[i].child[ii].child[iii].child[iv].satker_dari == null || snapshot.data.childs[i].child[ii].child[iii].child[iv].satker_dari == "") {
                                                                                              dari4 = "-";
                                                                                            } else {
                                                                                              dari4 = snapshot.data.childs[i].child[ii].child[iii].child[iv].satker_dari;
                                                                                            }

                                                                                            if (snapshot.data.childs[i].child[ii].child[iii].child[iv].tgl_disposisi == null || snapshot.data.childs[i].child[ii].child[iii].child[iv].tgl_disposisi == "") {
                                                                                              tanggalDikirim4 = "-";
                                                                                            } else {
                                                                                              tanggalDikirim4 = snapshot.data.childs[i].child[ii].child[iii].child[iv].tgl_disposisi;
                                                                                            }

                                                                                            if (snapshot.data.childs[i].child[ii].child[iii].child[iv].status == null || snapshot.data.childs[i].child[ii].child[iii].child[iv].status == "") {
                                                                                              status4 = "-";
                                                                                            } else {
                                                                                              status4 = snapshot.data.childs[i].child[ii].child[iii].child[iv].status;
                                                                                            }

                                                                                            if (snapshot.data.childs[i].child[ii].child[iii].child[iv].read == null || snapshot.data.childs[i].child[ii].child[iii].child[iv].read == "") {
                                                                                              read4 = "-";
                                                                                            } else {
                                                                                              if (snapshot.data.childs[i].child[ii].child[iii].child[iv].read == "READ") {
                                                                                                read4 = "Sudah";
                                                                                              } else if (snapshot.data.childs[i].child[ii].child[iii].child[iv].read == "UNREAD") {
                                                                                                read4 = "Belum";
                                                                                              } else {
                                                                                                read4 = snapshot.data.childs[i].child[ii].child[iii].child[iv].read;
                                                                                              }
                                                                                            }

                                                                                            if (snapshot.data.childs[i].child[ii].child[iii].child[iv].catatan_pengirim == null || snapshot.data.childs[i].child[ii].child[iii].child[iv].catatan_pengirim == "") {
                                                                                              catatanPengirim4 = "-";
                                                                                            } else {
                                                                                              catatanPengirim4 = snapshot.data.childs[i].child[ii].child[iii].child[iv].catatan_pengirim;
                                                                                            }

                                                                                            if (snapshot.data.childs[i].child[ii].child[iii].child[iv].catatan_sendiri == null || snapshot.data.childs[i].child[ii].child[iii].child[iv].catatan_sendiri == "") {
                                                                                              catatanSendiri4 = "-";
                                                                                            } else {
                                                                                              catatanSendiri4 = snapshot.data.childs[i].child[ii].child[iii].child[iv].catatan_sendiri;
                                                                                            }

                                                                                            if (snapshot.data.childs[i].child[ii].child[iii].child[iv].tgl_tanggapan == null || snapshot.data.childs[i].child[ii].child[iii].child[iv].tgl_tanggapan == "") {
                                                                                              tanggalTaggapan4 = "-";
                                                                                            } else {
                                                                                              tanggalTaggapan4 = snapshot.data.childs[i].child[ii].child[iii].child[iv].tgl_tanggapan;
                                                                                            }

                                                                                            if (snapshot.data.childs[i].child[ii].child[iii].child[iv].tgl_batas == null || snapshot.data.childs[i].child[ii].child[iii].child[iv].tgl_batas == "") {
                                                                                              tanggalBatas4 = "-";
                                                                                            } else {
                                                                                              tanggalBatas4 = snapshot.data.childs[i].child[ii].child[iii].child[iv].tgl_batas;
                                                                                            }

                                                                                            return new ExpansionTile(
                                                                                                trailing: Icon(Icons.expand_more, color: Colors.black),
                                                                                                backgroundColor: Colors.white,
                                                                                                leading: new InkWell(
                                                                                                  child: CircleAvatar(
                                                                                                      backgroundColor: Colors.orange,
                                                                                                      radius: 16.0,
                                                                                                      child: new Icon(Icons.message, color: Colors.white, size: 16.0)
                                                                                                  ),
                                                                                                ),
                                                                                                title: new Text(snapshot.data.childs[i].child[ii].child[iii].child[iv].satker_name, style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 16.0, color: Colors.black)),
                                                                                                children: [
                                                                                                  Column(
                                                                                                    children: <Widget>[
                                                                                                      Padding(
                                                                                                        padding: EdgeInsets.fromLTRB(16.0, 5.0, 16.0, 5.0),
                                                                                                        child: Row(
                                                                                                          children: <Widget>[
                                                                                                            Expanded(
                                                                                                              child: new Text("Dari", style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black, fontWeight: FontWeight.bold)),
                                                                                                            ),
                                                                                                            Expanded(
                                                                                                              child: new Text("Tgl Dikirim", style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black, fontWeight: FontWeight.bold)),
                                                                                                            ),
                                                                                                          ],
                                                                                                        ),
                                                                                                      ),
                                                                                                      Padding(
                                                                                                        padding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 5.0),
                                                                                                        child: Row(
                                                                                                          children: <Widget>[
                                                                                                            Expanded(
                                                                                                              child: new Text(dari4, style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black)),
                                                                                                            ),
                                                                                                            Expanded(
                                                                                                              child: new Text(tanggalDikirim4, style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black)),
                                                                                                            ),
                                                                                                          ],
                                                                                                        ),
                                                                                                      ),
                                                                                                      Padding(
                                                                                                        padding: EdgeInsets.fromLTRB(16.0, 5.0, 16.0, 5.0),
                                                                                                        child: Row(
                                                                                                          children: <Widget>[
                                                                                                            Expanded(
                                                                                                              child: new Text("Status", style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black, fontWeight: FontWeight.bold)),
                                                                                                            ),
                                                                                                            Expanded(
                                                                                                              child: new Text("Dibaca", style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black, fontWeight: FontWeight.bold)),
                                                                                                            ),
                                                                                                          ],
                                                                                                        ),
                                                                                                      ),
                                                                                                      Padding(
                                                                                                        padding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 5.0),
                                                                                                        child: Row(
                                                                                                          children: <Widget>[
                                                                                                            Expanded(
                                                                                                              child: new Text(status4, style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black)),
                                                                                                            ),
                                                                                                            Expanded(
                                                                                                              child: new Text(read4, style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black)),
                                                                                                            ),
                                                                                                          ],
                                                                                                        ),
                                                                                                      ),
                                                                                                      Padding(
                                                                                                        padding: EdgeInsets.fromLTRB(16.0, 5.0, 16.0, 5.0),
                                                                                                        child: Row(
                                                                                                          children: <Widget>[
                                                                                                            Expanded(
                                                                                                              child: new Text("Catatan Pengirim", style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black, fontWeight: FontWeight.bold)),
                                                                                                            ),
                                                                                                            Expanded(
                                                                                                              child: new Text("Catatan Sendiri", style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black, fontWeight: FontWeight.bold)),
                                                                                                            ),
                                                                                                          ],
                                                                                                        ),
                                                                                                      ),
                                                                                                      Padding(
                                                                                                        padding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 5.0),
                                                                                                        child: Row(
                                                                                                          children: <Widget>[
                                                                                                            Expanded(
                                                                                                              child: new Text(catatanPengirim4, style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black)),
                                                                                                            ),
                                                                                                            Expanded(
                                                                                                              child: new Text(catatanSendiri4, style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black)),
                                                                                                            ),
                                                                                                          ],
                                                                                                        ),
                                                                                                      ),
                                                                                                      Padding(
                                                                                                        padding: EdgeInsets.fromLTRB(16.0, 5.0, 16.0, 5.0),
                                                                                                        child: Row(
                                                                                                          children: <Widget>[
                                                                                                            Expanded(
                                                                                                              child: new Text("Tgl Tanggapan", style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black, fontWeight: FontWeight.bold)),
                                                                                                            ),
                                                                                                            Expanded(
                                                                                                              child: new Text("Tgl Batas", style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black, fontWeight: FontWeight.bold)),
                                                                                                            ),
                                                                                                          ],
                                                                                                        ),
                                                                                                      ),
                                                                                                      Padding(
                                                                                                        padding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 5.0),
                                                                                                        child: Row(
                                                                                                          children: <Widget>[
                                                                                                            Expanded(
                                                                                                              child: new Text(tanggalTaggapan4, style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black)),
                                                                                                            ),
                                                                                                            Expanded(
                                                                                                              child: new Text(tanggalBatas4, style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black)),
                                                                                                            ),
                                                                                                          ],
                                                                                                        ),
                                                                                                      ),
                                                                                                    ],
                                                                                                  )
                                                                                                ]
                                                                                            );
                                                                                          }
                                                                                        }
                                                                                    )
                                                                                  ],
                                                                                )
                                                                              ]
                                                                          );
                                                                        } else {

                                                                          String dari3;
                                                                          String tanggalDikirim3;
                                                                          String status3;
                                                                          String read3;
                                                                          String catatanPengirim3;
                                                                          String catatanSendiri3;
                                                                          String tanggalBatas3;
                                                                          String tanggalTaggapan3;

                                                                          if (snapshot.data.childs[i].child[ii].child[iii].satker_dari == null || snapshot.data.childs[i].child[ii].child[iii].satker_dari == "") {
                                                                            dari3 = "-";
                                                                          } else {
                                                                            dari3 = snapshot.data.childs[i].child[ii].child[iii].satker_dari;
                                                                          }

                                                                          if (snapshot.data.childs[i].child[ii].child[iii].tgl_disposisi == null || snapshot.data.childs[i].child[ii].child[iii].tgl_disposisi == "") {
                                                                            tanggalDikirim3 = "-";
                                                                          } else {
                                                                            tanggalDikirim3 = snapshot.data.childs[i].child[ii].child[iii].tgl_disposisi;
                                                                          }

                                                                          if (snapshot.data.childs[i].child[ii].child[iii].status == null || snapshot.data.childs[i].child[ii].child[iii].status == "") {
                                                                            status3 = "-";
                                                                          } else {
                                                                            status3 = snapshot.data.childs[i].child[ii].child[iii].status;
                                                                          }

                                                                          if (snapshot.data.childs[i].child[ii].child[iii].read == null || snapshot.data.childs[i].child[ii].child[iii].read == "") {
                                                                            read3 = "-";
                                                                          } else {
                                                                            if (snapshot.data.childs[i].child[ii].child[iii].read == "READ") {
                                                                              read3 = "Sudah";
                                                                            } else if (snapshot.data.childs[i].child[ii].child[iii].read == "UNREAD") {
                                                                              read3 = "Belum";
                                                                            } else {
                                                                              read3 = snapshot.data.childs[i].child[ii].child[iii].read;
                                                                            }
                                                                          }

                                                                          if (snapshot.data.childs[i].child[ii].child[iii].catatan_pengirim == null || snapshot.data.childs[i].child[ii].child[iii].catatan_pengirim == "") {
                                                                            catatanPengirim3 = "-";
                                                                          } else {
                                                                            catatanPengirim3 = snapshot.data.childs[i].child[ii].child[iii].catatan_pengirim;
                                                                          }

                                                                          if (snapshot.data.childs[i].child[ii].child[iii].catatan_sendiri == null || snapshot.data.childs[i].child[ii].child[iii].catatan_sendiri == "") {
                                                                            catatanSendiri3 = "-";
                                                                          } else {
                                                                            catatanSendiri3 = snapshot.data.childs[i].child[ii].child[iii].catatan_sendiri;
                                                                          }

                                                                          if (snapshot.data.childs[i].child[ii].child[iii].tgl_tanggapan == null || snapshot.data.childs[i].child[ii].child[iii].tgl_tanggapan == "") {
                                                                            tanggalTaggapan3 = "-";
                                                                          } else {
                                                                            tanggalTaggapan3 = snapshot.data.childs[i].child[ii].child[iii].tgl_tanggapan;
                                                                          }

                                                                          if (snapshot.data.childs[i].child[ii].child[iii].tgl_batas == null || snapshot.data.childs[i].child[ii].child[iii].tgl_batas == "") {
                                                                            tanggalBatas3 = "-";
                                                                          } else {
                                                                            tanggalBatas3 = snapshot.data.childs[i].child[ii].child[iii].tgl_batas;
                                                                          }

                                                                          return new ExpansionTile(
                                                                              trailing: Icon(Icons.expand_more, color: Colors.black),
                                                                              backgroundColor: Colors.white,
                                                                              leading: new InkWell(
                                                                                child: CircleAvatar(
                                                                                    backgroundColor: Colors.orange,
                                                                                    radius: 16.0,
                                                                                    child: new Icon(Icons.message, color: Colors.white, size: 16.0)
                                                                                ),
                                                                              ),
                                                                              title: new Text(snapshot.data.childs[i].child[ii].child[iii].satker_name, style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 16.0, color: Colors.black)),
                                                                              children: [
                                                                                Column(
                                                                                  children: <Widget>[
                                                                                    Padding(
                                                                                      padding: EdgeInsets.fromLTRB(16.0, 5.0, 16.0, 5.0),
                                                                                      child: Row(
                                                                                        children: <Widget>[
                                                                                          Expanded(
                                                                                            child: new Text("Dari", style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black, fontWeight: FontWeight.bold)),
                                                                                          ),
                                                                                          Expanded(
                                                                                            child: new Text("Tgl Dikirim", style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black, fontWeight: FontWeight.bold)),
                                                                                          ),
                                                                                        ],
                                                                                      ),
                                                                                    ),
                                                                                    Padding(
                                                                                      padding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 5.0),
                                                                                      child: Row(
                                                                                        children: <Widget>[
                                                                                          Expanded(
                                                                                            child: new Text(dari3, style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black)),
                                                                                          ),
                                                                                          Expanded(
                                                                                            child: new Text(tanggalDikirim3, style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black)),
                                                                                          ),
                                                                                        ],
                                                                                      ),
                                                                                    ),
                                                                                    Padding(
                                                                                      padding: EdgeInsets.fromLTRB(16.0, 5.0, 16.0, 5.0),
                                                                                      child: Row(
                                                                                        children: <Widget>[
                                                                                          Expanded(
                                                                                            child: new Text("Status", style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black, fontWeight: FontWeight.bold)),
                                                                                          ),
                                                                                          Expanded(
                                                                                            child: new Text("Dibaca", style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black, fontWeight: FontWeight.bold)),
                                                                                          ),
                                                                                        ],
                                                                                      ),
                                                                                    ),
                                                                                    Padding(
                                                                                      padding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 5.0),
                                                                                      child: Row(
                                                                                        children: <Widget>[
                                                                                          Expanded(
                                                                                            child: new Text(status3, style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black)),
                                                                                          ),
                                                                                          Expanded(
                                                                                            child: new Text(read3, style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black)),
                                                                                          ),
                                                                                        ],
                                                                                      ),
                                                                                    ),
                                                                                    Padding(
                                                                                      padding: EdgeInsets.fromLTRB(16.0, 5.0, 16.0, 5.0),
                                                                                      child: Row(
                                                                                        children: <Widget>[
                                                                                          Expanded(
                                                                                            child: new Text("Catatan Pengirim", style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black, fontWeight: FontWeight.bold)),
                                                                                          ),
                                                                                          Expanded(
                                                                                            child: new Text("Catatan Sendiri", style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black, fontWeight: FontWeight.bold)),
                                                                                          ),
                                                                                        ],
                                                                                      ),
                                                                                    ),
                                                                                    Padding(
                                                                                      padding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 5.0),
                                                                                      child: Row(
                                                                                        children: <Widget>[
                                                                                          Expanded(
                                                                                            child: new Text(catatanPengirim3, style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black)),
                                                                                          ),
                                                                                          Expanded(
                                                                                            child: new Text(catatanSendiri3, style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black)),
                                                                                          ),
                                                                                        ],
                                                                                      ),
                                                                                    ),
                                                                                    Padding(
                                                                                      padding: EdgeInsets.fromLTRB(16.0, 5.0, 16.0, 5.0),
                                                                                      child: Row(
                                                                                        children: <Widget>[
                                                                                          Expanded(
                                                                                            child: new Text("Tgl Tanggapan", style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black, fontWeight: FontWeight.bold)),
                                                                                          ),
                                                                                          Expanded(
                                                                                            child: new Text("Tgl Batas", style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black, fontWeight: FontWeight.bold)),
                                                                                          ),
                                                                                        ],
                                                                                      ),
                                                                                    ),
                                                                                    Padding(
                                                                                      padding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 5.0),
                                                                                      child: Row(
                                                                                        children: <Widget>[
                                                                                          Expanded(
                                                                                            child: new Text(tanggalTaggapan3, style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black)),
                                                                                          ),
                                                                                          Expanded(
                                                                                            child: new Text(tanggalBatas3, style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black)),
                                                                                          ),
                                                                                        ],
                                                                                      ),
                                                                                    ),
                                                                                  ],
                                                                                )
                                                                              ]
                                                                          );
                                                                        }
                                                                      }
                                                                  )
                                                                ],
                                                              )
                                                            ]
                                                        );
                                                      } else {

                                                        String dari2;
                                                        String tanggalDikirim2;
                                                        String status2;
                                                        String read2;
                                                        String catatanPengirim2;
                                                        String catatanSendiri2;
                                                        String tanggalBatas2;
                                                        String tanggalTaggapan2;

                                                        if (snapshot.data.childs[i].child[ii].status == null || snapshot.data.childs[i].child[ii].status == "") {
                                                          status2 = "-";
                                                        } else {
                                                          status2 = snapshot.data.childs[i].child[ii].status;
                                                        }

                                                        if (snapshot.data.childs[i].child[ii].read == null || snapshot.data.childs[i].child[ii].read == "") {
                                                          read2 = "-";
                                                        } else {
                                                          if (snapshot.data.childs[i].child[ii].read == "READ") {
                                                            read2 = "Sudah";
                                                          } else if (snapshot.data.childs[i].child[ii].read == "UNREAD") {
                                                            read2 = "Belum";
                                                          } else {
                                                            read2 = snapshot.data.childs[i].child[ii].read;
                                                          }
                                                        }

                                                        if (snapshot.data.childs[i].child[ii].catatan_pengirim == null || snapshot.data.childs[i].child[ii].catatan_pengirim == "") {
                                                          catatanPengirim2 = "-";
                                                        } else {
                                                          catatanPengirim2 = snapshot.data.childs[i].child[ii].catatan_pengirim;
                                                        }

                                                        if (snapshot.data.childs[i].child[ii].catatan_sendiri == null || snapshot.data.childs[i].child[ii].catatan_sendiri == "") {
                                                          catatanSendiri2 = "-";
                                                        } else {
                                                          catatanSendiri2 = snapshot.data.childs[i].child[ii].catatan_sendiri;
                                                        }

                                                        if (snapshot.data.childs[i].child[ii].tgl_tanggapan == null || snapshot.data.childs[i].child[ii].tgl_tanggapan == "") {
                                                          tanggalTaggapan2 = "-";
                                                        } else {
                                                          tanggalTaggapan2 = snapshot.data.childs[i].child[ii].tgl_tanggapan;
                                                        }

                                                        if (snapshot.data.childs[i].child[ii].tgl_batas == null || snapshot.data.childs[i].child[ii].tgl_batas == "") {
                                                          tanggalBatas2 = "-";
                                                        } else {
                                                          tanggalBatas2 = snapshot.data.childs[i].child[ii].tgl_batas;
                                                        }

                                                        return new ExpansionTile(
                                                            trailing: Icon(Icons.expand_more, color: Colors.black),
                                                            backgroundColor: Colors.white,
                                                            leading: new InkWell(
                                                              child: CircleAvatar(
                                                                  backgroundColor: Colors.orange,
                                                                  radius: 16.0,
                                                                  child: new Icon(Icons.message, color: Colors.white, size: 16.0)
                                                              ),
                                                            ),
                                                            title: new Text(snapshot.data.childs[i].child[ii].satker_name, style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 16.0, color: Colors.black)),
                                                            children: [
                                                              Column(
                                                                children: <Widget>[
                                                                  Padding(
                                                                    padding: EdgeInsets.fromLTRB(16.0, 5.0, 16.0, 5.0),
                                                                    child: Row(
                                                                      children: <Widget>[
                                                                        Expanded(
                                                                          child: new Text("Dari", style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black, fontWeight: FontWeight.bold)),
                                                                        ),
                                                                        Expanded(
                                                                          child: new Text("Tgl Dikirim", style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black, fontWeight: FontWeight.bold)),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  Padding(
                                                                    padding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 5.0),
                                                                    child: Row(
                                                                      children: <Widget>[
                                                                        Expanded(
                                                                          child: new Text(dari2, style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black)),
                                                                        ),
                                                                        Expanded(
                                                                          child: new Text(tanggalDikirim2, style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black)),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  Padding(
                                                                    padding: EdgeInsets.fromLTRB(16.0, 5.0, 16.0, 5.0),
                                                                    child: Row(
                                                                      children: <Widget>[
                                                                        Expanded(
                                                                          child: new Text("Status", style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black, fontWeight: FontWeight.bold)),
                                                                        ),
                                                                        Expanded(
                                                                          child: new Text("Dibaca", style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black, fontWeight: FontWeight.bold)),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  Padding(
                                                                    padding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 5.0),
                                                                    child: Row(
                                                                      children: <Widget>[
                                                                        Expanded(
                                                                          child: new Text(status2, style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black)),
                                                                        ),
                                                                        Expanded(
                                                                          child: new Text(read2, style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black)),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  Padding(
                                                                    padding: EdgeInsets.fromLTRB(16.0, 5.0, 16.0, 5.0),
                                                                    child: Row(
                                                                      children: <Widget>[
                                                                        Expanded(
                                                                          child: new Text("Catatan Pengirim", style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black, fontWeight: FontWeight.bold)),
                                                                        ),
                                                                        Expanded(
                                                                          child: new Text("Catatan Sendiri", style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black, fontWeight: FontWeight.bold)),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  Padding(
                                                                    padding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 5.0),
                                                                    child: Row(
                                                                      children: <Widget>[
                                                                        Expanded(
                                                                          child: new Text(catatanPengirim2, style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black)),
                                                                        ),
                                                                        Expanded(
                                                                          child: new Text(catatanSendiri2, style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black)),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  Padding(
                                                                    padding: EdgeInsets.fromLTRB(16.0, 5.0, 16.0, 5.0),
                                                                    child: Row(
                                                                      children: <Widget>[
                                                                        Expanded(
                                                                          child: new Text("Tgl Tanggapan", style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black, fontWeight: FontWeight.bold)),
                                                                        ),
                                                                        Expanded(
                                                                          child: new Text("Tgl Batas", style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black, fontWeight: FontWeight.bold)),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  Padding(
                                                                    padding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 5.0),
                                                                    child: Row(
                                                                      children: <Widget>[
                                                                        Expanded(
                                                                          child: new Text(tanggalTaggapan2, style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black)),
                                                                        ),
                                                                        Expanded(
                                                                          child: new Text(tanggalBatas2, style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black)),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ],
                                                              )
                                                            ]
                                                        );
                                                      }
                                                    }
                                                )
                                              ],
                                            )
                                          ]
                                      );
                                    } else {

                                      String dari1;
                                      String tanggalDikirim1;
                                      String status1;
                                      String read1;
                                      String catatanPengirim1;
                                      String catatanSendiri1;
                                      String tanggalBatas1;
                                      String tanggalTaggapan1;

                                      if (snapshot.data.childs[i].satker_dari == null || snapshot.data.childs[i].satker_dari == "") {
                                        dari1 = "-";
                                      } else {
                                        dari1 = snapshot.data.childs[i].satker_dari;
                                      }

                                      if (snapshot.data.childs[i].tgl_disposisi == null || snapshot.data.childs[i].tgl_disposisi == "") {
                                        tanggalDikirim1 = "-";
                                      } else {
                                        tanggalDikirim1 = snapshot.data.childs[i].tgl_disposisi;
                                      }

                                      if (snapshot.data.childs[i].status == null || snapshot.data.childs[i].status == "") {
                                        status1 = "-";
                                      } else {
                                        status1 = snapshot.data.childs[i].status;
                                      }

                                      if (snapshot.data.childs[i].read == null || snapshot.data.childs[i].read == "") {
                                        read1 = "-";
                                      } else {
                                        if (snapshot.data.childs[i].read == "READ") {
                                          read1 = "Sudah";
                                        } else if (snapshot.data.childs[i].read == "UNREAD") {
                                          read1 = "Belum";
                                        } else {
                                          read1 = snapshot.data.childs[i].read;
                                        }
                                      }

                                      if (snapshot.data.childs[i].catatan_pengirim == null || snapshot.data.childs[i].catatan_pengirim == "") {
                                        catatanPengirim1 = "-";
                                      } else {
                                        catatanPengirim1 = snapshot.data.childs[i].catatan_pengirim;
                                      }

                                      if (snapshot.data.childs[i].catatan_sendiri == null || snapshot.data.childs[i].catatan_sendiri == "") {
                                        catatanSendiri1 = "-";
                                      } else {
                                        catatanSendiri1 = snapshot.data.childs[i].catatan_sendiri;
                                      }

                                      if (snapshot.data.childs[i].tgl_tanggapan == null || snapshot.data.childs[i].tgl_tanggapan == "") {
                                        tanggalTaggapan1 = "-";
                                      } else {
                                        tanggalTaggapan1 = snapshot.data.childs[i].tgl_tanggapan;
                                      }

                                      if (snapshot.data.childs[i].tgl_batas == null || snapshot.data.childs[i].tgl_batas == "") {
                                        tanggalBatas1 = "-";
                                      } else {
                                        tanggalBatas1 = snapshot.data.childs[i].tgl_batas;
                                      }

                                      return new ExpansionTile(
                                          trailing: Icon(Icons.expand_more, color: Colors.black),
                                          backgroundColor: Colors.white,
                                          leading: new InkWell(
                                            child: CircleAvatar(
                                                backgroundColor: Colors.orange,
                                                radius: 16.0,
                                                child: new Icon(Icons.message, color: Colors.white, size: 16.0)
                                            ),
                                          ),
                                          title: new Text(snapshot.data.childs[i].satker_name, style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 16.0, color: Colors.black)),
                                          children: [
                                            Column(
                                              children: <Widget>[
                                                Padding(
                                                  padding: EdgeInsets.fromLTRB(16.0, 5.0, 16.0, 5.0),
                                                  child: Row(
                                                    children: <Widget>[
                                                      Expanded(
                                                        child: new Text("Dari", style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black, fontWeight: FontWeight.bold)),
                                                      ),
                                                      Expanded(
                                                        child: new Text("Tgl Dikirim", style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black, fontWeight: FontWeight.bold)),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 5.0),
                                                  child: Row(
                                                    children: <Widget>[
                                                      Expanded(
                                                        child: new Text(dari1, style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black)),
                                                      ),
                                                      Expanded(
                                                        child: new Text(tanggalDikirim1, style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black)),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.fromLTRB(16.0, 5.0, 16.0, 5.0),
                                                  child: Row(
                                                    children: <Widget>[
                                                      Expanded(
                                                        child: new Text("Status", style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black, fontWeight: FontWeight.bold)),
                                                      ),
                                                      Expanded(
                                                        child: new Text("Dibaca", style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black, fontWeight: FontWeight.bold)),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 5.0),
                                                  child: Row(
                                                    children: <Widget>[
                                                      Expanded(
                                                        child: new Text(status1, style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black)),
                                                      ),
                                                      Expanded(
                                                        child: new Text(read1, style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black)),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.fromLTRB(16.0, 5.0, 16.0, 5.0),
                                                  child: Row(
                                                    children: <Widget>[
                                                      Expanded(
                                                        child: new Text("Catatan Pengirim", style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black, fontWeight: FontWeight.bold)),
                                                      ),
                                                      Expanded(
                                                        child: new Text("Catatan Sendiri", style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black, fontWeight: FontWeight.bold)),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 5.0),
                                                  child: Row(
                                                    children: <Widget>[
                                                      Expanded(
                                                        child: new Text(catatanPengirim1, style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black)),
                                                      ),
                                                      Expanded(
                                                        child: new Text(catatanSendiri1, style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black)),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.fromLTRB(16.0, 5.0, 16.0, 5.0),
                                                  child: Row(
                                                    children: <Widget>[
                                                      Expanded(
                                                        child: new Text("Tgl Tanggapan", style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black, fontWeight: FontWeight.bold)),
                                                      ),
                                                      Expanded(
                                                        child: new Text("Tgl Batas", style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black, fontWeight: FontWeight.bold)),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 5.0),
                                                  child: Row(
                                                    children: <Widget>[
                                                      Expanded(
                                                        child: new Text(tanggalTaggapan1, style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black)),
                                                      ),
                                                      Expanded(
                                                        child: new Text(tanggalBatas1, style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black)),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            )
                                          ]
                                      );
                                    }
                                  }
                              )
                            ],
                          )
                        ]);

                  } else {

                    String dari;
                    String tanggalDikirim;
                    String status;
                    String read;
                    String catatanPengirim;
                    String catatanSendiri;
                    String tanggalBatas;
                    String tanggalTaggapan;

                    if (snapshot.data.satker_dari == null || snapshot.data.satker_dari == "") {
                      dari = "-";
                    } else {
                      dari = snapshot.data.satker_dari;
                    }

                    if (snapshot.data.tgl_disposisi == null || snapshot.data.tgl_disposisi == "") {
                      tanggalDikirim = "-";
                    } else {
                      tanggalDikirim = snapshot.data.tgl_disposisi;
                    }

                    if (snapshot.data.status == null || snapshot.data.status == "") {
                      status = "-";
                    } else {
                      status = snapshot.data.status;
                    }

                    if (snapshot.data.read == null || snapshot.data.read == "") {
                      read = "-";
                    } else {
                      if (snapshot.data.read == "READ") {
                        read = "Sudah";
                      } else if (snapshot.data.read == "UNREAD") {
                        read = "Belum";
                      } else {
                        read = snapshot.data.read;
                      }
                    }

                    if (snapshot.data.catatan_pengirim == null || snapshot.data.catatan_pengirim == "") {
                      catatanPengirim = "-";
                    } else {
                      catatanPengirim = snapshot.data.catatan_pengirim;
                    }

                    if (snapshot.data.catatan_sendiri == null || snapshot.data.catatan_sendiri == "") {
                      catatanSendiri = "-";
                    } else {
                      catatanSendiri = snapshot.data.catatan_sendiri;
                    }

                    if (snapshot.data.tgl_tanggapan == null || snapshot.data.tgl_tanggapan == "") {
                      tanggalTaggapan = "-";
                    } else {
                      tanggalTaggapan = snapshot.data.tgl_tanggapan;
                    }

                    if (snapshot.data.tgl_batas == null || snapshot.data.tgl_batas == "") {
                      tanggalBatas = "-";
                    } else {
                      tanggalBatas = snapshot.data.tgl_batas;
                    }

                    return expansionTileDetailTrackingSuratMasuk = new ExpansionTile(
                        trailing: Icon(Icons.expand_more, color: Colors.black),
                        backgroundColor: Colors.white,
                        leading: new InkWell(
                          child: CircleAvatar(
                              backgroundColor: Colors.orange,
                              radius: 16.0,
                              child: new Icon(Icons.message, color: Colors.white, size: 16.0)
                          ),
                        ),
                        title: new Text(snapshot.data.satker_name, style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 16.0, color: Colors.black)),
                        children: [
                          Column(
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.fromLTRB(16.0, 5.0, 16.0, 5.0),
                                child: Row(
                                  children: <Widget>[
                                    Expanded(
                                      child: new Text("Dari", style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black, fontWeight: FontWeight.bold)),
                                    ),
                                    Expanded(
                                      child: new Text("Tgl Dikirim", style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black, fontWeight: FontWeight.bold)),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 5.0),
                                child: Row(
                                  children: <Widget>[
                                    Expanded(
                                      child: new Text(dari, style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black)),
                                    ),
                                    Expanded(
                                      child: new Text(tanggalDikirim, style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black)),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.fromLTRB(16.0, 5.0, 16.0, 5.0),
                                child: Row(
                                  children: <Widget>[
                                    Expanded(
                                      child: new Text("Status", style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black, fontWeight: FontWeight.bold)),
                                    ),
                                    Expanded(
                                      child: new Text("Dibaca", style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black, fontWeight: FontWeight.bold)),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 5.0),
                                child: Row(
                                  children: <Widget>[
                                    Expanded(
                                      child: new Text(status, style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black)),
                                    ),
                                    Expanded(
                                      child: new Text(read, style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black)),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.fromLTRB(16.0, 5.0, 16.0, 5.0),
                                child: Row(
                                  children: <Widget>[
                                    Expanded(
                                      child: new Text("Catatan Pengirim", style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black, fontWeight: FontWeight.bold)),
                                    ),
                                    Expanded(
                                      child: new Text("Catatan Sendiri", style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black, fontWeight: FontWeight.bold)),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 5.0),
                                child: Row(
                                  children: <Widget>[
                                    Expanded(
                                      child: new Text(catatanPengirim, style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black)),
                                    ),
                                    Expanded(
                                      child: new Text(catatanSendiri, style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black)),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.fromLTRB(16.0, 5.0, 16.0, 5.0),
                                child: Row(
                                  children: <Widget>[
                                    Expanded(
                                      child: new Text("Tgl Tanggapan", style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black, fontWeight: FontWeight.bold)),
                                    ),
                                    Expanded(
                                      child: new Text("Tgl Batas", style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black, fontWeight: FontWeight.bold)),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 5.0),
                                child: Row(
                                  children: <Widget>[
                                    Expanded(
                                      child: new Text(tanggalTaggapan, style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black)),
                                    ),
                                    Expanded(
                                      child: new Text(tanggalBatas, style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 12.0, color: Colors.black)),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          )
                        ]);
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
                      )
                  ),
                );
                // By default, show a loading spinner
              },
            )
        )
      ],
    );

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
                  padding: const EdgeInsets.all(8.0), child: Text('Detail Tracking/History', style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 16.0, color: Colors.red)))
            ],

          ),
          actions: <Widget>[
            new IconButton(
                icon: const Icon(Icons.refresh),
                tooltip: 'Refresh',
                onPressed: () {
                  _refreshIndicatorKey.currentState.show();
                }),
          ]),
      body: makeBody,
    );
  }

}