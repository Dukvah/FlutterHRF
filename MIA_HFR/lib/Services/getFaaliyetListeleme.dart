import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:mia_hfr/Model/KullaniciFaaliyet.dart';
import 'package:mia_hfr/constanst/constant.dart';

Future<List<KullaniciFaaliyet>> getFaaliyet(int id) async {
  var response = await http.get(
    ("http://${Constants.apiBaseUrl}/api/kullaniciIdFaaliyetListele/tbl_Faaliyet/?Kullanici_ID=$id"),
  );
  if (response.statusCode == 200) {
    Iterable l = json.decode(response.body);
    List<KullaniciFaaliyet> list = List<KullaniciFaaliyet>.from(
        l.map((oneKullFal) => KullaniciFaaliyet.fromJson(oneKullFal)));

    return list;
  }
  return null;
}
