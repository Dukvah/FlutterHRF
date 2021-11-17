import 'package:http/http.dart' as http;
import 'package:mia_hfr/constanst/constant.dart';

Future<void> faaliyetSil(int id) async {
  var request = http.Request(
      'DELETE',
      Uri.parse(
          'http://${Constants.apiBaseUrl}/api/faaliyetSil/tbl_Faaliyet/?ID=$id'));

  http.StreamedResponse response = await request.send();

  if (response.statusCode == 200) {}
}
