import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:mia_hfr/Model/KullaniciFaaliyet.dart';
import 'package:mia_hfr/constanst/constant.dart';

Future<List<KullaniciFaaliyet>> tariheGoreListeleme(
    String tarih, int hafta, int id) async {
  var response = await http.post(
    Uri.parse(
      'http://${Constants.apiBaseUrl}/api/kullaniciFaaliyetlerListeleme/tbl_Faaliyet/?tarih=$tarih&hafta=$hafta&id=$id',
    ),
  );
  if (response.statusCode == 200) {
    Iterable l = json.decode(response.body);
    List<KullaniciFaaliyet> list = List<KullaniciFaaliyet>.from(
        l.map((oneKullFal) => KullaniciFaaliyet.fromJson(oneKullFal)));

    return list;
  }
  return null;
}
