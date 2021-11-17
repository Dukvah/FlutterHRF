import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:mia_hfr/constanst/constant.dart';

bool postFaaliyetEkle = false;
Future<void> faaliyetEkle(
    int id, String baslik, String faaliyet, String tarih, int hafta) async {
  DateTime tempDate = new DateFormat("dd-MM-yyyy").parse(tarih);
  var headers = {'Content-Type': 'application/json'};
  var request = http.MultipartRequest(
      'POST',
      Uri.parse(
          'http://${Constants.apiBaseUrl}/api/faaliyetEkle/tbl_Faaliyet/?id=$id&tarih=$tempDate&hafta=$hafta&baslik=$baslik&faaliyet=$faaliyet'));
  request.fields.addAll({
    'Kullanici_ID': '$id',
    'Baslik': '$baslik',
    'Faaliyet': '$faaliyet',
    'Tarih': '$tempDate',
    'Hafta': '$hafta'
  });
  http.StreamedResponse response = await request.send();

  request.headers.addAll(headers);

  if (response.statusCode == 200) {
    postFaaliyetEkle = true;
  } else {
    postFaaliyetEkle = false;
  }
}
