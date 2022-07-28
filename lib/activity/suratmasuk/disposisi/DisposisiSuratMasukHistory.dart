import 'package:flutter/material.dart';
import 'package:eoffice/activity/suratmasuk/disposisi/EditDisposisiSuratMasukHistory.dart';
import 'package:eoffice/activity/main/home.dart';
import 'package:eoffice/library/src/indicator/custom_indicator.dart';
import 'package:eoffice/library/src/indicator/waterdrop_header.dart';
import 'package:eoffice/library/src/smart_refresher.dart';
import 'package:eoffice/util/beauty_textfield.dart';
import 'package:eoffice/util/constants.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:eoffice/model/suratmasuk/DisposisiSuratModel.dart';
import 'package:eoffice/util/separator.dart';
import 'package:eoffice/activity/suratmasuk/masuk/DetailSuratMasuk.dart';
import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class DisposisiSuratMasukHistoryRoute extends CupertinoPageRoute {
  DisposisiSuratMasukHistoryRoute()
      : super(builder: (BuildContext context) => new DisposisiSuratMasukHistory());


  // OPTIONAL IF YOU WISH TO HAVE SOME EXTRA ANIMATION WHILE ROUTING
  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return new FadeTransition(opacity: animation, child: new DisposisiSuratMasukHistory());
  }
}

class DisposisiSuratMasukHistory extends StatefulWidget {
  static const String routeName = "/DisposisiSuratMasukHistory";

  @override
  DisposisiSuratMasukHistoryState createState() => DisposisiSuratMasukHistoryState();

}

class DisposisiSuratMasukHistoryState extends State<DisposisiSuratMasukHistory> with WidgetsBindingObserver {
  static SharedPreferences sharedPreferences;
  String url;
  static String loginToken;
  static String satkerLogin;

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  FirebaseMessaging _firebaseMessaging = new FirebaseMessaging();

  static Future<DisposisiSuratModel> _future;

  static int tot = 0;

  TextEditingController editingController = TextEditingController();

  static List<DisposisiSurat> items = new List();
  static List<DisposisiSurat> itemss = new List();

  static int refreshList = 0;
  static String query = "";

  static RefreshController _refreshController = RefreshController(initialRefresh: false);
  static bool rfrsh = true;

  @override
  initState() {
    super.initState();
    _future = makeRequest();
    WidgetsBinding.instance.addObserver(this);
  }

  static Future<DisposisiSuratModel> makeRequest() async {

    sharedPreferences = await SharedPreferences.getInstance();
    loginToken = sharedPreferences.getString("loginToken");
    satkerLogin = sharedPreferences.getString("satker");

    final response =
    await http.get(URL_DOMAIN + '/api/masuk/disposisi?page=' + refreshList.toString() + '&q=' + query + '&history=1&token=' + loginToken);

    if (response.statusCode == 200) {
      itemss.clear();
      itemss.addAll(DisposisiSuratModel.fromJson(jsonDecode(response.body)).disposisiSurat);
      items.clear();
      items.addAll(itemss);

      if (!rfrsh) {
        _refreshController.loadComplete();
      } else {
        _refreshController.refreshCompleted();
      }

      return DisposisiSuratModel.fromJson(jsonDecode(response.body));
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
  Widget build(BuildContext context) {
    var formatter = new DateFormat('dd-MM-yyyy');

    final makeBody = Container(
        child: new FutureBuilder<DisposisiSuratModel>(
          future: _future,
          builder: (context, snapshot) {
            if (snapshot.hasData) {

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
                          Widget child;
                          String stat;
                          String no_surat;
                          String perihal;

                          Color colorCard;

                          if ('${items[i].read_at}' == "null") {
                            colorCard = Colors.red;
                          } else {
                            colorCard = Colors.white;
                          }

                          if ('${items[i].status}' == 'null') {
                            stat = "Belum Menanggapi";
                            child = new InkWell(
                              child: CircleAvatar(
                                  backgroundColor: Colors.greenAccent,
                                  radius: 16.0,
                                  child: new Icon(Icons.search, color: Colors.white, size: 16.0)
                              ),
                              onTap: () {
                                Navigator.push(context, new MaterialPageRoute(builder: (BuildContext context) => new DetailSuratMasuk('${items[i].masuk_id}')));
                              },
                            );
                          } else if ('${items[i].status}' == "selesai") {
                            stat = "selesai";
                            child = new InkWell(
                              child: CircleAvatar(
                                  backgroundColor: Colors.greenAccent,
                                  radius: 16.0,
                                  child: new Icon(Icons.search, color: Colors.white, size: 16.0)
                              ),
                              onTap: () {
                                Navigator.push(context, new MaterialPageRoute(builder: (BuildContext context) => new DetailSuratMasuk('${items[i].masuk_id}')));
                              },
                            );
                          } else {
                            stat = '${items[i].status}';
                            child = new InkWell(
                              child: CircleAvatar(
                                  backgroundColor: Colors.greenAccent,
                                  radius: 16.0,
                                  child: new Icon(Icons.search, color: Colors.white, size: 16.0)
                              ),
                              onTap: () {
                                Navigator.push(context, new MaterialPageRoute(builder: (BuildContext context) => new DetailSuratMasuk('${items[i].masuk_id}')));
                              },
                            );
                          }

                          if ('${items[i].masuk.no_surat}' == 'null') {
                            no_surat = "-";
                          } else {
                            no_surat = '${items[i].masuk.no_surat}';
                          }

                          if ('${items[i].masuk.perihal}' == 'null') {
                            perihal = "-";
                          } else {
                            perihal = '${items[i].masuk.perihal}';
                          }

                          return new Card(
                            elevation: 8.0,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0)),
                            color: colorCard,
                            margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
                            child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.0),
                                    gradient: LinearGradient(
                                      begin: Alignment.topRight,
                                      end: Alignment.bottomLeft,
                                      stops: [0.1, 0.5, 0.7, 0.9],
                                      colors: [
                                        new Color(0xFFFFFFFF),
                                        new Color(0xE6FFFFFF),
                                        new Color(0xCCFFFFFF),
                                        new Color(0x99FFFFFF),
                                      ],
                                    )),
                                child: new ListTile(
                                    contentPadding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
                                    leading: Container(
                                        padding: EdgeInsets.only(right: 12.0),
                                        decoration: new BoxDecoration(
                                            border: new Border(
                                                right: new BorderSide(width: 2.0, color: Colors.deepPurpleAccent))
                                        ),
                                        child: child
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
                                              child: Text(no_surat, style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 12.0)),
                                            )
                                          ],
                                        ),
                                        Container(
                                          height: 5.0,
                                        ),
                                        Row(
                                          children: <Widget>[
                                            Text(stat, style: TextStyle(color: Colors.black, fontWeight: FontWeight.normal, fontSize: 11.0)),
                                          ],
                                        ),
                                        new Separators(),
                                      ],
                                    ),
                                    subtitle: Column(
                                        children: <Widget> [
                                          new Row(
                                            children: <Widget>[
                                              Expanded(
                                                child: Text('${items[i].satker_dari}', style: TextStyle(color: Colors.green, fontSize: 11.0)),
                                              )
                                            ],
                                          ),
                                          new Container(
                                            height: 5.0,
                                          ),
                                          new Row(
                                            children: <Widget>[
                                              new Icon(Icons.arrow_forward, color: Colors.black, size: 16.0),
                                              new Container(
                                                width: 5.0,
                                              ),
                                              new Expanded(
                                                child:Text('${items[i].satker_penerima}', style: TextStyle(color: Colors.red, fontSize: 11.0)),
                                              )
                                            ],
                                          ),
                                          new Separators(),
                                          new Row(
                                            children: <Widget>[
                                              new Icon(Icons.speaker_notes, color: Colors.purple, size: 16.0),
                                              new Container(
                                                width: 5.0,
                                              ),
                                              new Expanded(
                                                child:Text(perihal, style: TextStyle(color: Colors.black, fontSize: 11.0)),
                                              )
                                            ],
                                          )
                                        ]
                                    ),
                                    trailing:
                                    Text(formatter.format(DateTime.parse('${items[i].batas_at}')), style: TextStyle(fontWeight: FontWeight.bold, color: Colors.brown, fontSize: 10.0)),
                                    onTap: () {
                                      if ('${items[i].satker_penerima}' == satkerLogin) {
                                        if ('${items[i].read_at}' == 'null') {
                                          setState(() {
                                            itemss.clear();
                                            HomeScreenState.refreshing();
                                            _future = makeRequest();
                                          });
                                        } else {

                                        }
                                        Navigator.push(context, new MaterialPageRoute(builder: (BuildContext context) => new EditDisposisiSuratMasukHistory('${items[i].id}')));
                                      } else {
                                        Navigator.push(context, new MaterialPageRoute(builder: (BuildContext context) => new DetailSuratMasuk('${items[i].masuk_id}')));
                                      }
                                    }
                                )
                            ),
                          );
                        },
                      ),
                    ),
                  ),
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
                  padding: const EdgeInsets.all(8.0), child: Text('Disposisi Surat Masuk', style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 16.0, color: Colors.red)))
            ],

          ),
      ),
      floatingActionButtonLocation:
      FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.red,
          child: const Icon(Icons.history),
          onPressed: () {
            Navigator.of(context).push(new DisposisiSuratMasukHistoryRoute());
          }
      ),
      body: makeBody,
    );
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

  static void refreshing() {
    _future = makeRequest();
  }

}