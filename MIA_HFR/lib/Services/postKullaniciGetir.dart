import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mia_hfr/constanst/constant.dart';
import 'package:mia_hfr/Model/KullaniciBilgileri.dart';

Future<KullaniciBilgileri> kullaniciGetir(
    String kullaniciAdi, String kullaniciParola) async {
  var response = await http.post(
    Uri.parse(
      'http://${Constants.apiBaseUrl}/api/kullaniciGiris/tbl_Kullanici/?KullaniciAdi=$kullaniciAdi&KullaniciParola=$kullaniciParola',
    ),
  );
  if (response.statusCode == 200) {
    return KullaniciBilgileri.fromJson(jsonDecode(response.body));
  }
  return null;
}
