import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:eoffice/util/constants.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:eoffice/model/suratkeluar/DetailTrackingSuratKeluarModel.dart';
import 'package:eoffice/util/separator.dart';
import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class DetailTrackingSuratKeluarHistoryNotif extends StatefulWidget {
  final data;
  final dataUuid;

  final bool horizontal;
  DetailTrackingSuratKeluarHistoryNotif(this.dataUuid, this.data, {this.horizontal = true});
  DetailTrackingSuratKeluarHistoryNotif.vertical(this.dataUuid, this.data): horizontal = false;
  DetailTrackingSuratKeluarHistoryNotifState createState() => new DetailTrackingSuratKeluarHistoryNotifState(dataUuid, data);
}

class DetailTrackingSuratKeluarHistoryNotifState extends State<DetailTrackingSuratKeluarHistoryNotif> {

  final data;
  final dataUuid;

  final bool horizontal;

  DetailTrackingSuratKeluarHistoryNotifState(this.dataUuid, this.data, {this.horizontal = true});

  DetailTrackingSuratKeluarHistoryNotifState.vertical(this.dataUuid, this.data): horizontal = false;

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

  Future<DetailTrackingSuratKeluarModel> makeRequest() async {

    sharedPreferences = await SharedPreferences.getInstance();
    loginToken = sharedPreferences.getString("loginToken");

    final response =
    await http.get(URL_DETAIL_TRACKING_SURAT_KELUAR + data.toString() +"?token=" +loginToken+"&uuid="+dataUuid);

    if (response.statusCode == 200) {
      return DetailTrackingSuratKeluarModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load post.');
    }
  }

  @override
  Widget build(BuildContext context) {
    var formatter = new DateFormat('yyyy-MM-dd');
    final makeBody = Container(
        child: new FutureBuilder<DetailTrackingSuratKeluarModel>(
          future: _future,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return new RefreshIndicator(
                  key: _refreshIndicatorKey,
                  onRefresh: makeRequest,
                  child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: snapshot.data.detailTrackingSuratKeluar == null ? 0 : snapshot.data.detailTrackingSuratKeluar.length,
                    itemBuilder: (BuildContext context, int i) {
                      Widget child;
                      String stat;
                      if (snapshot.data.detailTrackingSuratKeluar[i].status == null) {
                        stat = "-";
                        child = new Icon(Icons.cloud, color: Colors.red, size: 20.0);
                      } else if (snapshot.data.detailTrackingSuratKeluar[i].status == true) {
                        stat = "Approve";
                        child = new Icon(Icons.cloud_done, color: Colors.green, size: 20.0);
                      } else if (snapshot.data.detailTrackingSuratKeluar[i].status == false) {
                        stat = "Not Approve";
                        child = new Icon(Icons.cloud, color: Colors.red, size: 20.0);
                      }

                      Widget center;
                      if (i == 0) {
                        center = new Center(
                          child: new Container(

                          ),
                        );
                      } else {
                        center = new Center(
                          child: new Container(
                              child: new Icon(Icons.arrow_downward, color: Colors.red, size: 16.0)
                          ),
                        );
                      }

                      Widget tanggapan;

                      if (snapshot.data.detailTrackingSuratKeluar[i].tanggapan == null) {
                        tanggapan = Text("-", style: TextStyle(color: Colors.black, fontSize: 12.0));
                      } else {
                        tanggapan = Html(
                            data: snapshot.data.detailTrackingSuratKeluar[i].tanggapan.toString()
                        );
                      }

                      return new Container(
                          margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
                          child: new Column(
                            children: <Widget>[
                              center,
                              Container(
                                  child: new ListTile(
                                      contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),

                                      title:
                                      Column(
                                        children: <Widget>[
                                          new Row(
                                            children: <Widget>[
                                              new Icon(Icons.markunread_mailbox, color: Colors.purple, size: 16.0),
                                              new Container(
                                                width: 10.0,
                                              ),
                                              Text(stat, style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 14.0)),
                                            ],
                                          ),
                                          new Separators()
                                        ],
                                      ),
                                      subtitle: Column(
                                          children: <Widget> [
                                            new Row(
                                              children: <Widget>[
                                                new Icon(Icons.arrow_forward, color: Colors.black, size: 16.0),
                                                new Container(
                                                  width: 5.0,
                                                ),
                                                new Expanded(
                                                  child:Text(snapshot.data.detailTrackingSuratKeluar[i].satker.name, style: TextStyle(color: Colors.green, fontSize: 12.0)),
                                                )
                                              ],
                                            ),
                                            new Container(
                                              height: 5.0,
                                            ),
                                            new Row(
                                              children: <Widget>[
                                                new Icon(Icons.event_note, color: Colors.black, size: 16.0),
                                                new Container(
                                                  width: 5.0,
                                                ),
                                                Text(snapshot.data.detailTrackingSuratKeluar[i].group, style: TextStyle(color: Colors.green, fontSize: 12.0)),
                                              ],
                                            ),
                                            new Container(
                                              height: 5.0,
                                            ),
                                            new Row(
                                              children: <Widget>[
                                                new Icon(Icons.assignment, color: Colors.orange, size: 16.0),
                                                new Container(
                                                  width: 5.0,
                                                ),
                                                Expanded(
                                                  child: tanggapan
                                                )
                                              ],
                                            )
                                          ]
                                      ),
                                      trailing:
                                      Text(formatter.format(DateTime.parse(snapshot.data.detailTrackingSuratKeluar[i].updated_at)), style: TextStyle(fontWeight: FontWeight.bold, color: Colors.brown, fontSize: 10.0)),
                                      onTap: () {

                                      }
                                  )
                              )
                            ],
                          )
                      );
                    },
                  )
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
                  )
              ),
            );
            // By default, show a loading spinner
          },
        )
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