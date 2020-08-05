import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_full_pdf_viewer/full_pdf_viewer_scaffold.dart';
import 'package:path_provider/path_provider.dart';

class ResultPage extends StatefulWidget {
  final String file;
  ResultPage(this.file);
  @override
  _ResultPageState createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  String pathPDF = "";

  @override
  void initState() {
    super.initState();
    _createFileFromString();
  }

  _createFileFromString() async {
    Uint8List bytes = base64.decode(widget.file);
    String dir = (await getExternalStorageDirectory()).path;
    File file = File(
        "$dir/" + DateTime.now().millisecondsSinceEpoch.toString() + ".pdf");
    file.createSync(recursive: true);
    await file.writeAsBytes(bytes, flush: true);
    setState(() {
      pathPDF = file.path;
    });
  }

  @override
  Widget build(BuildContext context) {
    return pathPDF == ""
        ? Scaffold(
            body: Center(
                child: CircularProgressIndicator(
              backgroundColor: Colors.blueGrey,
            )),
          )
        : PDFViewerScaffold(
            appBar: AppBar(
              backgroundColor: Colors.blueGrey,
              title: Text("Your PDF"),
              centerTitle: true,
              automaticallyImplyLeading: false,
              leading: IconButton(
                icon: Icon(Icons.arrow_back_ios),
                color: Colors.white,
                onPressed: () {
                  setState(() {});
                  Navigator.pop(context);
                },
              ),
            ),
            path: pathPDF,

            // body: Center(
            //   child: RaisedButton(
            //     child: Text("Open PDF"),
            //     onPressed: () => Navigator.push(
            //       context,
            //       MaterialPageRoute(builder: (context) => PDFScreen(pathPDF)),
            //     ),
            //   ),
            // ),
          );
  }
}

// class PDFScreen extends StatelessWidget {
//   String pathPDF = "";
//   PDFScreen(this.pathPDF);

//   @override
//   Widget build(BuildContext context) {
//     return PDFViewerScaffold(
//         appBar: AppBar(
//           title: Text("Document"),
//           actions: <Widget>[
//             IconButton(
//               icon: Icon(Icons.share),
//               onPressed: () {},
//             ),
//           ],
//         ),
//         );
// }
// }
