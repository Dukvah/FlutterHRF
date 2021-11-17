import 'package:http/http.dart' as http;
import 'package:mia_hfr/constanst/constant.dart';

bool getDurumBool;

Future<void> getDurum(String yil, int hafta, int id, int deger) async {
  List<String> tarihParse = yil.split('-');
  var request = http.Request(
      'GET',
      Uri.parse(
          "http://${Constants.apiBaseUrl}/api/faaliyetDurumGuncelleme/tbl_Faaliyet/?yil=${tarihParse[0]}&ay=${tarihParse[1]}&hafta=$hafta&id=$id&deger=$deger"));
  http.StreamedResponse response;
  response = await request.send();

  if (response.statusCode == 200) {
    getDurumBool = true;
  } else {
    getDurumBool = false;
  }
}
