import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:mia_hfr/Model/KullaniciDetaylar.dart';
import 'package:mia_hfr/Services/getDurumKontrol.dart';
import 'package:mia_hfr/Services/getKullaniciDetay.dart';
import 'package:mia_hfr/View/Admin/Admin.dart';
import 'package:mia_hfr/View/Kullanici/KullaniciAyalar.dart';
import 'package:mia_hfr/View/Kullanici/KullaniciDetay_widgets.dart';
import '../Login/Login.dart';

// ignore: unused_import
class KullaniciDetay extends StatefulWidget {
  final int id;
  final String kullaniciAdi;
  final int yetki;

  KullaniciDetay(
      {Key key,
      @required this.id,
      @required this.kullaniciAdi,
      @required this.yetki})
      : super(key: key);
  @override
  _KullaniciDetayState createState() => new _KullaniciDetayState();
}

bool getid = false;
bool ref = false;

class _KullaniciDetayState extends State<KullaniciDetay> {
  @override
  void initState() {
    super.initState();
  }

  Future onDidReceiveLocalNotification(
      int id, String title, String body, String payload) async {
    return CupertinoAlertDialog(
      title: Text(title),
      content: Text(body),
      actions: <Widget>[
        CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: () {
              print("");
            },
            child: Text("Okay")),
      ],
    );
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
    return WillPopScope(
      // ignore: missing_return
      onWillPop: () {
        setState(() {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              Widget cikis = ElevatedButton.icon(
                style: ButtonStyle(
                  alignment: Alignment.center,
                  backgroundColor: MaterialStateProperty.all(Colors.red),
                ),
                label: Text("Çıkış Yap"),
                icon: Icon(Icons.power_settings_new),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => widget.yetki == 1
                            ? Admin(
                                kullaniciAdi: widget.kullaniciAdi,
                                yetki: widget.yetki,
                              )
                            : Login(),
                      ));
                },
              );
              Widget geridon = ElevatedButton.icon(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.blue[800]),
                ),
                label: Text("Geri dön"),
                icon: Icon(Icons.arrow_forward_ios_outlined),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              );

              return AlertDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20.0))),
                actions: <Widget>[
                  cikis,
                  geridon,
                ],
                title: Center(
                    child: widget.yetki == 3
                        ? Text("Çıkış Yapmak İstediğinize Emin misiniz?")
                        : Text(
                            "Kullanıcı Profilinden Çıkış Yapmak İstediğinize Emin misiniz?")),
              );
            },
          );
        });
      },
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
              automaticallyImplyLeading: false,
              title: Text(
                widget.kullaniciAdi,
                style: TextStyle(fontSize: 30),
              ),
              centerTitle: true,
              backgroundColor: Colors.blue[800],
              actions: <Widget>[
                widget.yetki == 3
                    ? Padding(
                        padding: EdgeInsets.only(right: 20.0),
                        child: GestureDetector(
                          child: IconButton(
                              icon: Icon(Icons.settings),
                              iconSize: 30,
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => KullaniciAyarlar()),
                                );
                              }),
                        ))
                    : Padding(
                        padding: EdgeInsets.only(),
                        )
              ]),
          body: RefreshIndicator(
            onRefresh: _handleRefresh,
            child: FutureBuilder<List<KullaniciDetaylar>>(
                key: ValueKey<Object>(RecognizerCallback),
                future: getData(widget.id),
                builder:
                    (context, AsyncSnapshot<List<KullaniciDetaylar>> snapshot) {
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
                          // ignore: unrelated_type_equality_checks
                          getData(widget.id) == 1
                              ? Center(
                                  child: ElevatedButton.icon(
                                      style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all(
                                                Colors.blue[800]),
                                      ),
                                      label: Text(
                                        "Geri Dön",
                                        style: TextStyle(fontSize: 20),
                                      ),
                                      icon: Icon(Icons.arrow_back),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      }),
                                )
                              : Center(
                                  child: Text("HFR Girişi yapmalısınız."),
                                )
                        ],
                      );
                    } else {
                      return buildListele(
                          snapshot,
                          context,
                          widget.yetki,
                          widget.id,
                          getDurumBool,
                          widget.kullaniciAdi,
                          setState);
                    }
                  }

                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }),
          ),
        ),
      ),
    );
  }
}
