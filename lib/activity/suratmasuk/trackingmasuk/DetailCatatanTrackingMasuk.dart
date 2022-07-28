import 'package:flutter/material.dart';
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
import 'package:flutter_html/flutter_html.dart';

class DetailCatatanTrackingMasuk extends StatefulWidget {
  final data;
  final bool horizontal;
  DetailCatatanTrackingMasuk(this.data, {this.horizontal = true});
  DetailCatatanTrackingMasuk.vertical(this.data): horizontal = false;
  DetailCatatanTrackingMasukState createState() => new DetailCatatanTrackingMasukState(data);
}

class DetailCatatanTrackingMasukState extends State<DetailCatatanTrackingMasuk> {

  final data;
  final bool horizontal;

  DetailCatatanTrackingMasukState(this.data, {this.horizontal = true});

  DetailCatatanTrackingMasukState.vertical(this.data): horizontal = false;

  SharedPreferences sharedPreferences;
  String url;
  String loginToken;

  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = new GlobalKey<RefreshIndicatorState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    var formatter = new DateFormat('yyyy-MM-dd');
    final makeBody = Container(
        child: ListView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: data == null ? 0 : data.length,
          itemBuilder: (BuildContext context, int i) {
            String stat;

            return new Container(
                margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
                child: new Column(
                  children: <Widget>[
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
                                    Expanded(
                                      child: Text(data[i].penerima, style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 14.0)),
                                    )
                                  ],
                                ),
                                new Separators()
                              ],
                            ),
                            subtitle: Column(
                                children: <Widget> [
                                  new Row(
                                    children: <Widget>[
                                      new Icon(Icons.assignment, color: Colors.orange, size: 16.0),
                                      new Container(
                                        width: 5.0,
                                      ),
                                      new Expanded(
                                        child:Text(data[i].catatan, style: TextStyle(color: Colors.green, fontSize: 12.0)),
                                      )
                                    ],
                                  ),
                                  new Container(
                                    height: 5.0,
                                  ),
                                  new Row(
                                    children: <Widget>[
                                      new Icon(Icons.date_range, color: Colors.brown, size: 16.0),
                                      new Container(
                                        width: 5.0,
                                      ),
                                      Expanded(
                                        child:Text(data[i].tgl_kirim, style: TextStyle(color: Colors.red, fontSize: 10.0)),
                                      )
                                    ],
                                  )
                                ]
                            )
                        )
                    )
                  ],
                )
            );
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
                  padding: const EdgeInsets.all(8.0), child: Text('Detail Catatan', style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 16.0, color: Colors.red)))
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