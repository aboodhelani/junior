import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class Api {
  Api._() {}
  static final Api apiClient = Api._();
  static final http.Client _httpClient = http.Client();

  static const BaseUrl = "http://192.168.43.200:5001/";

  Future<String> sendData(String lang, int isImage, File file) async {
    try {
      final response = await _httpClient.post(
        BaseUrl + "recive/mobile",
        body: {
          "Language": lang,
          "flag": isImage.toString(),
          "base64File": base64Encode(file.readAsBytesSync())
        },
      );
      if (response.statusCode == 200) {
        final json = (jsonDecode(response.body));

        return json["file"];
      } else {
        return Future.error("error");
      }
    } on SocketException {
      //this in case internet problems
      return Future.value("check your internet connection");
    } on http.ClientException {
      //this in case internet problems
      return Future.value("check your internet connection");
    } catch (e) {
      return Future.value(e.toString());
    }
  }
}
