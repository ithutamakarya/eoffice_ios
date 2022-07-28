import 'package:flutter/material.dart';
import 'package:eoffice/library/src/indicator/custom_indicator.dart';
import 'package:eoffice/library/src/indicator/waterdrop_header.dart';
import 'package:eoffice/library/src/smart_refresher.dart';
import 'package:eoffice/util/beauty_textfield.dart';
import 'package:eoffice/util/constants.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:eoffice/model/suratmasuk/TrackingSuratMasukModel.dart';
import 'package:eoffice/util/separator.dart';
import 'package:eoffice/activity/suratmasuk/masuk/DetailSuratMasuk.dart';
import 'package:eoffice/activity/suratmasuk/trackingmasuk/DetailTrackingHistory.dart';
import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class TrackingHistoriSuratMasukRoute extends CupertinoPageRoute {
  TrackingHistoriSuratMasukRoute()
      : super(builder: (BuildContext context) => new TrackingHistoriSuratMasuk());


  // OPTIONAL IF YOU WISH TO HAVE SOME EXTRA ANIMATION WHILE ROUTING
  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return new FadeTransition(opacity: animation, child: new TrackingHistoriSuratMasuk());
  }
}

class TrackingHistoriSuratMasuk extends StatefulWidget {
  static const String routeName = "/TrackingHistoriSuratMasuk";

  @override
  TrackingHistoriSuratMasukState createState() => TrackingHistoriSuratMasukState();

}

class TrackingHistoriSuratMasukState extends State<TrackingHistoriSuratMasuk> with WidgetsBindingObserver {
  static SharedPreferences sharedPreferences;
  String url;
  static String loginToken;

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  static Future<TrackingSuratMasukModel> _future;

  TextEditingController editingController = TextEditingController();

  static List<TrackingSuratMasuk> items = new List();
  static List<TrackingSuratMasuk> itemss = new List();

  static int refreshList = 0;
  static String query = "";

  static RefreshController _refreshController = RefreshController(initialRefresh: false);
  static bool rfrsh = true;

  @override
  void initState() {
    super.initState();
    _future = makeRequest();
    WidgetsBinding.instance.addObserver(this);
  }

  static Future<TrackingSuratMasukModel> makeRequest() async {
    sharedPreferences = await SharedPreferences.getInstance();
    loginToken = sharedPreferences.getString("loginToken");

    final response =
    await http.get(URL_DOMAIN + '/api/masuk/tracking?page=' + refreshList.toString() + '&q=' + query + '&token=' +loginToken);

    if (response.statusCode == 200) {
      itemss.clear();
      itemss.addAll(TrackingSuratMasukModel.fromJson(jsonDecode(response.body)).trackingSuratMasukModel);
      items.clear();
      items.addAll(itemss);

      if (!rfrsh) {
        _refreshController.loadComplete();
      } else {
        _refreshController.refreshCompleted();
      }

      return TrackingSuratMasukModel.fromJson(jsonDecode(response.body));

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
  didPopRoute() {

  }

  @override
  Widget build(BuildContext context) {
    var formatter = new DateFormat('dd-MM-yyyy');

    final makeBody = Container(
        child: new FutureBuilder<TrackingSuratMasukModel>(
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
                      onChanged: (value) {

                      },
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
                        builder: (BuildContext context,LoadStatus mode){
                          Widget body ;
                          if(mode==LoadStatus.idle){
                            body =  Text("pull up load");
                          }
                          else if(mode==LoadStatus.loading){
                            body =  CupertinoActivityIndicator();
                          }
                          else if(mode == LoadStatus.failed){
                            body = Text("Load Failed!Click retry!");
                          }
                          else{
                            body = Text("No more Data");
                          }
                          return Container(
                            height: 55.0,
                            child: Center(child:body),
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
                            margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
                            child: Container(
                                child: new ListTile(
                                    contentPadding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
                                    leading: Container(
                                        padding: EdgeInsets.only(right: 12.0),
                                        decoration: new BoxDecoration(
                                            border: new Border(
                                                right: new BorderSide(width: 2.0, color: Colors.deepPurpleAccent))
                                        ),
                                        child: new InkWell(
                                          child: CircleAvatar(
                                              backgroundColor: Colors.greenAccent,
                                              radius: 16.0,
                                              child: new Icon(Icons.border_color, color: Colors.white, size: 16.0)
                                          ),
                                          onTap: () {
                                            Navigator.push(context, new MaterialPageRoute(builder: (BuildContext context) => new DetailTrackingHistory('${items[i].id}')));
                                          },
                                        )
                                    ),
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
                                              child: Text(noSurat, style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 12.0)),
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
                                              new Icon(Icons.arrow_forward, color: Colors.black, size: 16.0),
                                              new Container(
                                                width: 5.0,
                                              ),
                                              Expanded(
                                                child: Text('${items[i].disposisiList[0].satker_dari}', style: TextStyle(color: Colors.green, fontSize: 11.0)),
                                              )
                                            ],
                                          ),
                                          new Container(
                                            height: 5.0,
                                          ),
                                          new Row(
                                            children: <Widget>[
                                              new Icon(Icons.event_note, color: Colors.purple, size: 16.0),
                                              new Container(
                                                width: 5.0,
                                              ),
                                              new Expanded(
                                                child: Text('${items[i].perihal}', style: TextStyle(color: Colors.red, fontSize: 11.0)),
                                              )
                                            ],
                                          )
                                        ]
                                    ),
                                    trailing:
                                    Text(formatter.format(DateTime.parse('${items[i].batas_at}')), style: TextStyle(fontWeight: FontWeight.bold, color: Colors.brown, fontSize: 10.0)),
                                    onTap: () {
                                      Navigator.push(context, new MaterialPageRoute(builder: (BuildContext context) => new DetailSuratMasuk('${items[i].id}')));
                                      //_persistentBottomSheet(data.suratMasuk[i]);
                                    }
                                )
                            ),
                          );
                        },
                      ),
                    ),
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
                  padding: const EdgeInsets.all(8.0), child: Text('Tracking/History', style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 16.0, color: Colors.red)))
            ],

          ),
      ),
      body: makeBody,
    );
  }

}