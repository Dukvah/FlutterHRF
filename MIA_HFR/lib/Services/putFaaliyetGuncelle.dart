import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:mia_hfr/constanst/constant.dart';

bool getGuncelle = false;
Future<void> faaliyetGuncelle(int id, int kullaniciID, String baslik,
    String faaliyet, String tarih, int hafta) async {
  DateTime tempDate = new DateFormat("dd-MM-yyyy").parse(tarih);
  var headers = {'Content-Type': 'application/json'};
  var request = http.MultipartRequest(
      'POST',
      Uri.parse(
          'http://${Constants.apiBaseUrl}/api/faaliyetGuncelle/tbl_Faaliyet/?id=$id&kullaniciID=$kullaniciID&tarih=$tempDate&hafta=$hafta&baslik=$baslik&faaliyet=$faaliyet'));
  request.fields.addAll({
    'ID': '$id',
    'Kullanici_ID': '$kullaniciID',
    'Tarih': '$tempDate',
    'Hafta': '$hafta',
    'Baslik': '$baslik',
    'Faaliyet': '$faaliyet'
  });
  http.StreamedResponse response = await request.send();

  request.headers.addAll(headers);

  if (response.statusCode == 200) {
    getGuncelle = true;
  } else {
    getGuncelle = false;
  }
}
