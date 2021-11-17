import 'package:flutter/material.dart';
import 'package:mia_hfr/Model/KullaniciFaaliyet.dart';
import 'package:intl/intl.dart';
import 'package:mia_hfr/Services/dltFaaliyetSil.dart';
import 'KullaniciFaaliyetGuncelleme.dart';

Widget listele(
  AsyncSnapshot<List<KullaniciFaaliyet>> snapshot,
  BuildContext context,
  int yetki,
  void Function(VoidCallback fn) setState,
) {
  return Column(
    children: [
      SizedBox(
        height: 10,
      ),
      // buildForm(context),
      Expanded(
        child: ListView.builder(
          itemCount: snapshot.data.length,
          itemBuilder: (context, int index) {
            var formateddate =
                DateFormat('dd-MM-yyyy').format(snapshot.data[index].tarih) +
                    ' (' +
                    snapshot.data[index].hafta.toString() +
                    '.) Hafta';

            var localtarih = new Text(
              formateddate,
              style: new TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            );

            return Container(
              width: double.maxFinite,
              child: buildCard(
                  snapshot, index, localtarih, yetki, context, setState),
            );
          },
        ),
      ),
    ],
  );
}

Card buildCard(
  AsyncSnapshot<List<KullaniciFaaliyet>> snapshot,
  int index,
  Text localtarih,
  yetki,
  BuildContext context,
  void Function(VoidCallback fn) setState,
) {
  return Card(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        bottomRight: Radius.circular(20),
        topRight: Radius.circular(40),
        bottomLeft: Radius.circular(20),
      ),
    ),
    margin: EdgeInsets.all(10),
    elevation: 10,
    color:
        snapshot.data[index].durum == 0 ? Colors.blue[200] : Colors.green[200],
    child: Column(
      children: <Widget>[
        SizedBox(
          height: 20.0,
        ),
        new Align(
          child: localtarih,
        ),
        new SizedBox(
          height: 10.0,
          child: new Center(
            child: new Container(
              margin: new EdgeInsetsDirectional.only(start: 100.0, end: 100.0),
              height: 2.0,
              color: Colors.black,
            ),
          ),
        ),
        new Align(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: new Text(
              snapshot.data[index].baslik,
              style: new TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        new SizedBox(
          height: 5.0,
          child: new Center(
            child: new Container(
              margin: new EdgeInsetsDirectional.only(start: 15.0, end: 15.0),
              height: 2.0,
              color: Colors.black,
            ),
          ),
        ),
        SizedBox(
          height: 10.0,
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: new Align(
            child: new Text(
              snapshot.data[index].faaliyet,
              style: new TextStyle(fontSize: 20.0),
            ),
          ),
        ),
        SizedBox(
          height: 40.0,
        ),
        ButtonBar(
          children: <Widget>[
            snapshot.data[index].durum == 0 && yetki == 3

                // ignore: deprecated_member_use
                ? FlatButton.icon(
                    padding:
                        EdgeInsets.symmetric(horizontal: 40.0, vertical: 13.0),
                    icon: Icon(Icons.delete),
                    color: Colors.red,
                    textColor: Colors.white,
                    label: const Text('SİL'),
                    shape: StadiumBorder(),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          // return object of type Dialog
                          Widget sil = ElevatedButton.icon(
                            style: ButtonStyle(
                              alignment: Alignment.center,
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.red),
                            ),
                            label: Text("Sil"),
                            icon: Icon(Icons.delete),
                            onPressed: () async {
                              setState(() {
                                faaliyetSil(snapshot.data[index].id);
                                Navigator.of(context).pop();
                              });
                            },
                          );
                          Widget geridon = ElevatedButton.icon(
                            style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.blue[800]),
                            ),
                            label: Text("Geri dön"),
                            icon: Icon(Icons.arrow_forward_ios_outlined),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          );

                          return AlertDialog(
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20.0))),
                            actions: <Widget>[
                              sil,
                              geridon,
                            ],
                            title: Center(
                              child: new Text(
                                  "Silmek istediğinizde emin misiniz?"),
                            ),
                            content: new Text(
                              localtarih.data +
                                  " Tarihindeki işlem silinecektir.",
                            ),
                          );
                        },
                      );
                    },
                  )
                : null,
            snapshot.data[index].durum == 0 && yetki == 3

                // ignore: deprecated_member_use
                ? FlatButton.icon(
                    padding:
                        EdgeInsets.symmetric(horizontal: 20.0, vertical: 13.0),
                    icon: Icon(Icons.update),
                    color: Colors.blue[800],
                    textColor: Colors.white,
                    label: const Text('GÜNCELLE'),
                    shape: StadiumBorder(),
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => KullaniciFaaliyetGuncelleme(
                            id: snapshot.data[index].id,
                            kullaniciID: snapshot.data[index].kullaniciId,
                            tarih: snapshot.data[index].tarih,
                            baslik: snapshot.data[index].baslik,
                            faaliyet: snapshot.data[index].faaliyet,
                            hafta: snapshot.data[index].hafta,
                          ),
                        ),
                      );

                      //
                    },
                  )
                : null,
            SizedBox(
              width: 20,
            ),
          ],
        ),
      ],
    ),
  );
}
