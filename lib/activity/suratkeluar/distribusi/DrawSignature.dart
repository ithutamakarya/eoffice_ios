import 'package:flutter/material.dart';
import 'package:eoffice/activity/suratkeluar/distribusi/DistribusiSurat.dart';
import 'package:eoffice/util/constants.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:eoffice/activity/main/home.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:simple_permissions/simple_permissions.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:progress_dialog/progress_dialog.dart';

const directoryName = 'Signature';

class DrawSignatureRoute extends CupertinoPageRoute {
  final dataId, dataCatatan;

  final bool horizontal;

  DrawSignatureRoute(this.dataId, this.dataCatatan, this.horizontal)
      : super(
            builder: (BuildContext context) =>
                new DrawSignature(dataId, dataCatatan));

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return new FadeTransition(
        opacity: animation, child: new DrawSignature(dataId, dataCatatan));
  }
}

class DrawSignature extends StatefulWidget {
  static const String routeName = "/DrawSignature";

  final dataId, dataCatatan;
  final bool horizontal;

  DrawSignature(this.dataId, this.dataCatatan, {this.horizontal = true});

  DrawSignature.vertical(this.dataId, this.dataCatatan) : horizontal = false;
  @override
  DrawSignatureState createState() => DrawSignatureState(dataId, dataCatatan);
}

class DrawSignatureState extends State<DrawSignature>
    with WidgetsBindingObserver {
  SharedPreferences sharedPreferences;
  String url;
  String loginToken;
  String satkerLogin, userNameUser;

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  GlobalKey<SignatureState> signatureKey = GlobalKey();
  var image;
  String _platformVersion = 'Unknown';
  Permission _permission = Permission.WriteExternalStorage;

  final dataId, dataCatatan;
  final bool horizontal;

  String filePath;
  File files;

  FirebaseMessaging _firebaseMessaging = new FirebaseMessaging();

  DrawSignatureState(this.dataId, this.dataCatatan, {this.horizontal = true});

  DrawSignatureState.vertical(this.dataId, this.dataCatatan)
      : horizontal = false;

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    initPlatformState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  didPopRoute() {}

  initPlatformState() async {
    String platformVersion;

    sharedPreferences = await SharedPreferences.getInstance();
    loginToken = sharedPreferences.getString("loginToken");
    satkerLogin = sharedPreferences.getString("satker");
    userNameUser = sharedPreferences.getString("userNameUser");
    try {
      platformVersion = await SimplePermissions.platformVersion;
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Signature(key: signatureKey),
      persistentFooterButtons: <Widget>[
        FlatButton(
          child: Text('Kembali'),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        FlatButton(
          child: Text('Hapus'),
          onPressed: () {
            signatureKey.currentState.clearPoints();
          },
        ),
        FlatButton(
          child: Text('Simpan'),
          onPressed: () async {
            ui.Image renderedImage = await signatureKey.currentState.rendered;
            setState(() {
              image = renderedImage;
            });
            showImage(context);
          },
        )
      ],
    );
  }

  Future<Null> showImage(BuildContext context) async {
    var pngBytes = await image.toByteData(format: ui.ImageByteFormat.png);
    if (!(await checkPermission())) await requestPermission();
    // Use plugin [path_provider] to export image to storage
    Directory directory = await getExternalStorageDirectory();
    String path = directory.path;

    filePath = '$path/$directoryName/ttd.png';
    files = File(filePath);
    await Directory('$path/$directoryName').create(recursive: true);
    File(filePath).writeAsBytesSync(pngBytes.buffer.asInt8List());
    return showDialog<Null>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              'Tanda tangan ini tersimpan dalam folder Signature',
              style: TextStyle(
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w300,
                  color: Theme.of(context).primaryColor,
                  letterSpacing: 1.1),
            ),
            content: Image.memory(Uint8List.view(pngBytes.buffer)),
            actions: <Widget>[
              // usually buttons at the bottom of the dialog
              new FlatButton(
                child: new Text("Submit"),
                onPressed: () {
                  Navigator.of(context, rootNavigator: true).pop();
                  UploadAll();
                },
              ),
              new FlatButton(
                child: new Text("Batalkan"),
                onPressed: () {
                  Navigator.of(context, rootNavigator: true).pop();
                },
              ),
            ],
          );
        });
  }

  String formattedDate() {
    DateTime dateTime = DateTime.now();
    String dateTimeString = 'Signature_' +
        satkerLogin +
        " " +
        dateTime.year.toString() +
        dateTime.month.toString() +
        dateTime.day.toString() +
        dateTime.hour.toString() +
        dateTime.minute.toString() +
        dateTime.second.toString();
    return dateTimeString;
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

  void UploadAll() async {
    HomeScreenState.dialogNotif = "TTD";
    ProgressDialog pr = new ProgressDialog(context, ProgressDialogType.Normal);
    pr.setMessage('Menunggu..');
    pr.show();

    String base64Image = base64Encode(files.readAsBytesSync());

    Map dataSaveToken = {'token': loginToken, 'ttd': base64Image};

    print("Approve app");

    var urlSaveToken =
        URL_EDIT_DISTRIBUSI_SURAT_UPDATE + dataId.toString() + "/approve";
    http.post(
      urlSaveToken,
      body: dataSaveToken,
      headers: {
        'Accept-Language': 'id',
        'Connection': 'keep-alive',
        'Content-Type': 'application/x-www-form-urlencoded',
        'Accept': 'application/json',
        'Charset': 'utf-8',
      },
    ).then((response) {
      final data = json.decode(response.body);
      bool successSaveToken = data['success'];

      if (successSaveToken) {
        pr.hide();

        setState(() {
          DistribusiSuratState.refreshing();
          HomeScreenState.dialogNotif = "";
        });
        // Navigator.of(context).push(new DistribusiSuratRoute());
        Navigator.pushReplacement(
            context,
            new MaterialPageRoute(
                builder: (BuildContext context) =>
                    new HomeScreen(userNameUser, satkerLogin)));
      } else {
        pr.hide();
        _scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text('Approve Gagal'),
          duration: Duration(seconds: 3),
        ));
      }
    });
  }
}

class Signature extends StatefulWidget {
  Signature({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return SignatureState();
  }
}

class SignatureState extends State<Signature> {
  // [SignatureState] responsible for receives drag/touch events by draw/user
  // @_points stores the path drawn which is passed to
  // [SignaturePainter]#contructor to draw canvas
  List<Offset> _points = <Offset>[];

  Future<ui.Image> get rendered {
    ui.PictureRecorder recorder = ui.PictureRecorder();
    Canvas canvas = Canvas(recorder);
    SignaturePainter painter = SignaturePainter(points: _points);
    var size = context.size;
    painter.paint(canvas, size);
    return recorder
        .endRecording()
        .toImage(size.width.floor(), size.height.floor());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: GestureDetector(
          onPanUpdate: (DragUpdateDetails details) {
            setState(() {
              RenderBox _object = context.findRenderObject();
              Offset _locationPoints =
                  _object.localToGlobal(details.globalPosition);
              _points = new List.from(_points)..add(_locationPoints);
            });
          },
          onPanEnd: (DragEndDetails details) {
            setState(() {
              _points.add(null);
            });
          },
          child: CustomPaint(
            painter: SignaturePainter(points: _points),
            size: Size.infinite,
          ),
        ),
      ),
    );
  }

  // clearPoints method used to reset the canvas
  // method can be called using
  //   key.currentState.clearPoints();
  void clearPoints() {
    setState(() {
      _points.clear();
    });
  }
}

class SignaturePainter extends CustomPainter {
  // [SignaturePainter] receives points through constructor
  // @points holds the drawn path in the form (x,y) offset;
  // This class responsible for drawing only
  // It won't receive any drag/touch events by draw/user.
  List<Offset> points = <Offset>[];

  SignaturePainter({this.points});
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = Color(0xff0000ff)
      ..strokeCap = StrokeCap.square
      ..strokeWidth = 5.0;

    for (int i = 0; i < points.length - 1; i++) {
      if (points[i] != null && points[i + 1] != null) {
        canvas.drawLine(points[i], points[i + 1], paint);
      }
    }
  }

  @override
  bool shouldRepaint(SignaturePainter oldDelegate) {
    return oldDelegate.points != points;
  }
}
