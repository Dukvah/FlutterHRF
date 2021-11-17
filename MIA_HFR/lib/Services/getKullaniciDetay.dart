import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:mia_hfr/Model/KullaniciDetaylar.dart';
import 'package:mia_hfr/constanst/constant.dart';

Future<List<KullaniciDetaylar>> getData(int id) async {
  var response = await http.get(
    ("http://${Constants.apiBaseUrl}/api/kullaniciDetay/tbl_Faaliyet?Kullanici_ID=$id"),
  );
  if (response.statusCode == 200) {
    Iterable l = json.decode(response.body);
    List<KullaniciDetaylar> list = List<KullaniciDetaylar>.from(
        l.map((detay) => KullaniciDetaylar.fromJson(detay)));

    return list;
  }
  return null;
}
