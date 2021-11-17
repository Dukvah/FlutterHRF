import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mia_hfr/Model/KullaniciFaaliyet.dart';
import 'package:mia_hfr/Services/postTariheGoreListeleme.dart';
import 'KullaniciHFR_widgets.dart';

class KullaniciHFR extends StatefulWidget {
  final int id;
  final String kullaniciAdi;
  final int yetki;
  final String tarih;
  final int hafta;

  KullaniciHFR(
      {Key key,
      @required this.id,
      @required this.kullaniciAdi,
      @required this.yetki,
      @required this.hafta,
      @required this.tarih})
      : super(key: key);
  @override
  KullaniciHFRState createState() => new KullaniciHFRState();
}

class KullaniciHFRState extends State<KullaniciHFR> {
    @override
  void initState() {
    super.initState();
  }
  int count = 0;

  Future<Null> _handleRefresh() async {
    await new Future.delayed(new Duration(seconds: 1));

    setState(() {
      count += 3;
    });

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
            title: Text(
              widget.kullaniciAdi,
              style: TextStyle(fontSize: 30.0),
            ),
            centerTitle: true,
            backgroundColor: Colors.blue[800]),
        body: RefreshIndicator(
          onRefresh: _handleRefresh,
          child: FutureBuilder<List<KullaniciFaaliyet>>(
              future:
                  tariheGoreListeleme(widget.tarih, widget.hafta, widget.id),
              builder:
                  (context, AsyncSnapshot<List<KullaniciFaaliyet>> snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data.length == 0) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Herhangi bir kayıt bulunamadı.",
                          style: TextStyle(fontSize: 25.0),
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        Center(
                          child: ElevatedButton.icon(
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all(Colors.blue[800]),
                              ),
                              label: Text(
                                "Listele",
                                style: TextStyle(fontSize: 20),
                              ),
                              icon: Icon(Icons.arrow_back),
                              onPressed: () {
                                // Navigator.of(context).pop(); // Eğer Boş İse Döndürme işlemi yapılacak.
                              }),
                        ),
                      ],
                    );
                  } else {
                    return listele(snapshot, context, widget.yetki, setState);
                  }
                }

                return Center(
                  child: CircularProgressIndicator(),
                );
              }),
        ),
      ),
    );
  }
}
