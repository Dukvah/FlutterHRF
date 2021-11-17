import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:mia_hfr/Model/KullaniciBilgileri.dart';
import 'package:mia_hfr/constanst/constant.dart';

Future<List<KullaniciBilgileri>> getAdmin() async {
  var response = await http.post(
    ("http://${Constants.apiBaseUrl}/api/yetkigiris/tbl_Kullanici/"),
  );
  if (response.statusCode == 200) {
    Iterable l = json.decode(response.body);
    List<KullaniciBilgileri> list = List<KullaniciBilgileri>.from(
        l.map((yetkiliListe) => KullaniciBilgileri.fromJson(yetkiliListe)));

    return list;
  }
  return null;
}
