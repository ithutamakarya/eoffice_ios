import 'package:flutter/material.dart';
import 'package:flutter_full_pdf_viewer/full_pdf_viewer_scaffold.dart';

class ShowPDF extends StatefulWidget {
  final dataId;

  final bool horizontal;

  ShowPDF(this.dataId, {this.horizontal = true});

  ShowPDF.vertical(this.dataId): horizontal = false;

  ShowPDFState createState() => new ShowPDFState(dataId);
}

class ShowPDFState extends State<ShowPDF> {

  final dataId;
  final bool horizontal;

  bool _isLoading = true;

  ShowPDFState(this.dataId, {this.horizontal = true});

  ShowPDFState.vertical(this.dataId) : horizontal = false;

  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PDFViewerScaffold(
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
                    padding: const EdgeInsets.all(8.0), child: Text('PDF File', style: TextStyle(fontFamily: 'Source Code Pro', fontSize: 16.0, color: Colors.red)))
              ],

            )
        ),
        path: dataId.toString());
  }

}