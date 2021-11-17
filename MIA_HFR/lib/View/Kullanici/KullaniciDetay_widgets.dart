import 'package:mia_hfr/Model/KullaniciDetaylar.dart';
import 'package:flutter/material.dart';
import 'package:mia_hfr/Services/getDurumKontrol.dart';
import 'KullaniciHFR.dart';

Widget buildListele(
    AsyncSnapshot<List<KullaniciDetaylar>> snapshot,
    BuildContext context,
    int yetki,
    int id,
    bool getDurumBool,
    String kullaniciAdi,
    setState) {
  return Column(
    children: [
      Expanded(
        child: ListView.builder(
          itemCount: snapshot.data.length,
          itemBuilder: (context, int index) {
            return Container(
              width: double.maxFinite,
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(30),
                    topRight: Radius.circular(10),
                    topLeft: Radius.circular(10),
                    bottomLeft: Radius.circular(30),
                  ),
                ),
                margin: EdgeInsets.all(10),
                elevation: 20,
                color: Colors.blue,
                child: Column(
                  children: <Widget>[
                    new Align(
                      child: buildListTile(snapshot, index, yetki, context, id,
                          getDurumBool, kullaniciAdi, setState),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    ],
  );

}
ListTile buildListTile(
  AsyncSnapshot<List<KullaniciDetaylar>> snapshot,
  int index,
  int yetki,
  BuildContext context,
  int id,
  bool getDurumBool,
  String kullaniciAdi,
  void Function(VoidCallback fn) setState,

) 
{


  return ListTile(
    leading: CircleAvatar(
      child: Icon(Icons.assignment_outlined),
      radius: 15,
      foregroundColor: Colors.blue[800],
      backgroundColor: Colors.white,
    ),
    title: Center(
      child: Text(
        snapshot.data[index].tarih.toString() +
            '  ' +
            snapshot.data[index].hafta.toString() +
            '. Haftası ',
        style: new TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
      ),
    ),
    trailing: IconButton(
      icon: Icon(
        Icons.check_circle,
        color: snapshot.data[index].durum == 1
            ? Colors.greenAccent[700]
            : Colors.white,
        size: 35,
      ),
      tooltip: 'Check',
      onPressed: () {
        setState(() {
          yetki == 1
              ? buildShowDialogAdmin(
                  context, snapshot, index, id, getDurumBool, setState)
              : buildShowDialogUser(context);
        });
      },
    ),
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => KullaniciHFR(
                  id: snapshot.data[index].id,
                  kullaniciAdi: kullaniciAdi,
                  yetki: yetki,
                  tarih: snapshot.data[index].tarih,
                  hafta: snapshot.data[index].hafta,
                )),
      ); //
    },
  );
}

buildShowDialogUser(BuildContext context) {
  return showDialog(
    context: context,
    builder: (BuildContext context) {
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
          Center(child: geridon),
        ],
        title: Center(child: new Text('Yetkisiz giriş')),
        content: new Text(
          'Onaylamak veya onayı kaldırmak için yetkiniz yetmemektedir.',
        ),
      );
    },
  );
}

buildShowDialogAdmin(
  BuildContext context,
  AsyncSnapshot<List<KullaniciDetaylar>> snapshot,
  int index,
  int id,
  bool getDurumBool,
  void Function(VoidCallback fn) setState,
) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      // return object of type Dialog
      Widget onay = ElevatedButton.icon(
        style: ButtonStyle(
            backgroundColor: snapshot.data[index].durum == 0
                ? MaterialStateProperty.all(Colors.green)
                : MaterialStateProperty.all(Colors.red)),
        label:
            snapshot.data[index].durum == 0 ? Text("Onayla") : Text("Kaldır"),
        icon: Icon(Icons.check_sharp),
        onPressed: () {
          setState(() {
            getDurum(snapshot.data[index].tarih.toString(),
                snapshot.data[index].hafta, id, snapshot.data[index].durum);
            Navigator.of(context).pop();
          });
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
        actions: <Widget>[onay, geridon],
        title: Center(
            child: new Text(snapshot.data[index].durum == 0
                ? 'Onaylamak İstediğinize emin misiniz ?'
                : 'Onayı Kaldırmak İstediğinize emin misiniz ?')),
        content: new Text(
          snapshot.data[index].durum == 0
              ? snapshot.data[index].tarih.toString() +
                  ' ' +
                  snapshot.data[index].hafta.toString() +
                  '. Haftası, Onaylıyorsunuz.'
              : snapshot.data[index].tarih.toString() +
                  ' ' +
                  snapshot.data[index].hafta.toString() +
                  '. Haftasını, Kaldırıyorsunuz.',
        ),
      );
    },
  );
}
