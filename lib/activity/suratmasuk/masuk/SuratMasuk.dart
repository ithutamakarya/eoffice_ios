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
import 'package:eoffice/model/suratmasuk/SuratMasukModel.dart';
import 'package:eoffice/util/separator.dart';
import 'package:eoffice/activity/suratmasuk/masuk/DetailSuratMasuk.dart';
import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';

class SuratMasukRoute extends CupertinoPageRoute {
  SuratMasukRoute()
      : super(builder: (BuildContext context) => new SuratMasuk());


  // OPTIONAL IF YOU WISH TO HAVE SOME EXTRA ANIMATION WHILE ROUTING
  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return new FadeTransition(opacity: animation, child: new SuratMasuk());
  }
}

class SuratMasuk extends StatefulWidget {
  static const String routeName = "/SuratMasuk";

  @override
  SuratMasukState createState() => SuratMasukState();

}

class SuratMasukState extends State<SuratMasuk> with WidgetsBindingObserver {
  SharedPreferences sharedPreferences;
  String url;
  String loginToken;

  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = new GlobalKey<RefreshIndicatorState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  Future<SuratMasukModel> _future;

  TextEditingController editingController = TextEditingController();

  List<SuratMasukList> items = new List();
  List<SuratMasukList> itemss = new List();
  int refreshList = 0;
  String query = "";

  RefreshController _refreshController = RefreshController(initialRefresh: false);
  bool rfrsh = true;

  Future<SuratMasukModel> makeRequest() async {

    sharedPreferences = await SharedPreferences.getInstance();
    loginToken = sharedPreferences.getString("loginToken");



    final response =
    await http.get(URL_DOMAIN + '/api/masuk?page=' + refreshList.toString() + '&q=' + query + '&token=' +loginToken);

    if (response.statusCode == 200) {
      itemss.clear();
      itemss.addAll(SuratMasukModel.fromJson(jsonDecode(response.body)).suratMasuk);
      items.clear();
      items.addAll(itemss);

      if (!rfrsh) {
        _refreshController.loadComplete();
      } else {
        _refreshController.refreshCompleted();
      }

      return SuratMasukModel.fromJson(jsonDecode(response.body));
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
  void initState() {
    super.initState();
    _future = makeRequest();
    WidgetsBinding.instance.addObserver(this);
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
        child: new FutureBuilder<SuratMasukModel>(
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
                                          child: CircleAvatar(
                                              backgroundColor: Colors.greenAccent,
                                              radius: 16.0,
                                              child: new InkWell(
                                                child: new Text('${items[i].disposisiList.length.toString()}', style: TextStyle(color: Colors.white, fontSize: 12.0, fontWeight: FontWeight.bold)),
                                                onTap: () {

                                                },
                                              )
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
                                                child: Text('${items[i].no_surat}', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 12.0)),
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
                                                Expanded(
                                                  child: Text('${items[i].mailer_name}' + " (" + '${items[i].mail_type}' + ")", style: TextStyle(color: Colors.green, fontSize: 11.0)),
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
                                                Expanded(
                                                    child: Text('${items[i].untuk}', style: TextStyle(color: Colors.red, fontSize: 11.0))
                                                ),
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
                      )
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
                  padding: const EdgeInsets.all(8.0), child: Text('Surat Masuk', style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 16.0, color: Colors.red)))
            ],

          ),
      ),
      body: makeBody,
    );
  }

}