import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_document_picker/flutter_document_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:junior/Api/Api.dart';
import 'package:junior/Screen/ResultPage.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Size bottomSize;
  bool isloaded = false;
  File imagefileUpload;
  File fileUpload;
  String finalFile;
  bool isSend = false;

  selectImageType() async {
    showModalBottomSheet(
        context: context,
        builder: (context) => Container(
              height: bottomSize.height * 0.1222,
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      IconButton(
                        icon: Icon(Icons.photo_library),
                        onPressed: () async {
                          await pickImage(ImageSource.gallery);
                          Navigator.pop(context);
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.photo_camera),
                        onPressed: () async {
                          await pickImage(ImageSource.camera);
                          Navigator.pop(context);
                        },
                      )
                    ],
                  ),
                ],
              ),
            ));
  }

  cropImage(String filePath) async {
    return await ImageCropper.cropImage(
        aspectRatio: CropAspectRatio(ratioX: 4, ratioY: 3),
        sourcePath: filePath,
        aspectRatioPresets: [
          CropAspectRatioPreset.ratio4x3,
        ],
        androidUiSettings: AndroidUiSettings(
            toolbarTitle: 'Crop',
            toolbarColor: Theme.of(context).primaryColor,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.ratio4x3,
            lockAspectRatio: true),
        iosUiSettings: IOSUiSettings(
            aspectRatioPickerButtonHidden: true, aspectRatioLockEnabled: true));
  }

  Future pickImage(ImageSource source) async {
    imagefileUpload = await ImagePicker.pickImage(source: source);

    imagefileUpload = await cropImage(imagefileUpload.path);

    setState(() {
      if (imagefileUpload != null) {
        isloaded = true;
      }
    });
  }

  String result = "English";
  bool isimage = true;
  _pickDocument() async {
    String res;
    try {
      FlutterDocumentPickerParams params = FlutterDocumentPickerParams(
        allowedFileExtensions: ["pdf", "docx"],
        allowedMimeTypes: ["*/*"],
      );

      res = await FlutterDocumentPicker.openDocument(params: params);
    } catch (e) {
      print(e);
      res = 'Error: $e';
    } finally {}

    setState(() {
      _path = res;
      if (_path.substring(0, 1) != "E") {
        fileUpload = File.fromUri(Uri.parse(_path));
      } else {
        fileUpload = null;
        print("error");
      }
    });
  }

  String _path = '';

  @override
  Widget build(BuildContext context) {
    final Size sizeAware = MediaQuery.of(context).size;
    bottomSize = sizeAware;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        title: Center(child: Text("Welcome")),
      ),
      body: Column(
        children: <Widget>[
          DropdownButton(
            value: result,
            hint: new Text('Language'),
            //  value: result,
            items: <DropdownMenuItem>[
              new DropdownMenuItem(
                child: new Text('English'),
                value: "English",
              ),
              new DropdownMenuItem(
                child: new Text('Arabic'),
                value: "Arabic",
              ),
              new DropdownMenuItem(
                child: new Text('German'),
                value: "German",
              ),
              new DropdownMenuItem(
                child: new Text('French'),
                value: "French",
              ),
            ],
            onChanged: (value) => setState(() {
              result = value;
            }),
          ),
          DropdownButton(
            value: isimage,
            hint: new Text('type'),
            //  value: result,
            items: <DropdownMenuItem>[
              new DropdownMenuItem(
                child: new Text('File'),
                value: false,
              ),
              new DropdownMenuItem(
                child: new Text('image'),
                value: true,
              ),
            ],
            onChanged: (value) => setState(() {
              isimage = value;
            }),
          ),
          SizedBox(
            height: sizeAware.height * 0.05,
          ),
          isimage
              ? GestureDetector(
                  onTap: isloaded
                      ? null
                      : () {
                          selectImageType();
                        },
                  child: Container(
                    margin: EdgeInsets.only(
                      top: sizeAware.width * 0.015,
                      bottom: sizeAware.width * 0.015,
                    ),
                    height: sizeAware.height * 0.333,
                    width: sizeAware.width * 0.79999,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: Theme.of(context).textTheme.subhead.color,
                        )),
                    child: Stack(
                      children: <Widget>[
                        isloaded
                            ? SizedBox(
                                height: sizeAware.height * 0.333,
                                width: sizeAware.width * 0.79999,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.file(
                                    imagefileUpload,
                                    fit: BoxFit.cover,
                                    height: sizeAware.height * 0.333,
                                    width: sizeAware.width * 0.79999,
                                  ),
                                ),
                              )
                            : Center(
                                child: Icon(
                                  Icons.photo_library,
                                  size: sizeAware.width * 0.1888,
                                  color:
                                      Theme.of(context).textTheme.subhead.color,
                                ),
                              ),
                        isloaded
                            ? Align(
                                alignment: Alignment.bottomRight,
                                child: IconButton(
                                  onPressed: () {
                                    selectImageType();
                                  },
                                  icon: Container(
                                    padding: EdgeInsets.all(2),
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border:
                                            Border.all(color: Colors.white)),
                                    child: Icon(
                                      Icons.edit,
                                      color: Colors.white,
                                      size: sizeAware.width * 0.04,
                                    ),
                                  ),
                                ),
                              )
                            : Container()
                      ],
                    ),
                  ),
                )
              : Container(
                  width: sizeAware.width * 0.45,
                  height: sizeAware.height * 0.05777,
                  child: FlatButton(
                    color: Colors.blueGrey,
                    onPressed: _pickDocument,
                    child: Text(
                      "Choose File",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: sizeAware.width * 0.0555),
                    ),
                  ),
                ),
          !isimage
              ? Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Picked file path:',
                        style: Theme.of(context).textTheme.title,
                      ),
                      Text(fileUpload != null ? '$_path' : 'Error'),
                    ],
                  ),
                )
              : Container(),
          Expanded(
            child: Container(),
          ),
          isSend
              ? Center(
                  child: CircularProgressIndicator(
                  backgroundColor: Colors.blueGrey,
                ))
              : Container(
                  width: sizeAware.width,
                  height: sizeAware.height * 0.07777,
                  child: FlatButton(
                    color: Colors.blueGrey,
                    onPressed: () async {
                      setState(() {
                        isSend = true;
                      });

                      if (isimage && imagefileUpload != null)
                        finalFile = await Api.apiClient
                            .sendData(result, 0, imagefileUpload);
                      else {
                        if (fileUpload.path.split('.')[
                                    fileUpload.path.split('.').length - 1] ==
                                'docx' &&
                            fileUpload != null)
                          finalFile = await Api.apiClient
                              .sendData(result, 1, fileUpload);
                        else if (fileUpload != null)
                          finalFile = await Api.apiClient
                              .sendData(result, 2, fileUpload);
                      }
                      if (finalFile == "check your internet connection")
                        setState(() {
                          isSend = false;
                        });
                      else if (finalFile != null)
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ResultPage(finalFile)));
                      setState(() {
                        isSend = false;
                      });
                    },
                    child: Text(
                      "Send",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: sizeAware.width * 0.0555),
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}
