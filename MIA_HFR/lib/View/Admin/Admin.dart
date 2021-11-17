import 'package:flutter/material.dart';
import 'package:mia_hfr/View/Login/Login.dart';
import 'package:mia_hfr/Model/KullaniciBilgileri.dart';
import 'package:mia_hfr/Services/postAdminPanel.dart';
import 'Admin_widgets.dart';

class Admin extends StatefulWidget {
  final String kullaniciAdi;
  final int yetki;

  Admin({Key key, @required this.kullaniciAdi, @required this.yetki})
      : super(key: key);
  @override
  _AdminState createState() => new _AdminState();
}

class _AdminState extends State<Admin> {
  // ignore: missing_return

  @override
  void initState() {
    super.initState();
  }

  //

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => showDialog(
        context: context,
        builder: (BuildContext context) {
          // return object of type Dialog
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
                    builder: (context) => Login(),
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
              child: new Text("Çıkış Yapmak İstediğinize Emin misiniz?"),
            ),
          );
        },
      ),
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            centerTitle: true,
            backgroundColor: Colors.blue[800],
          ),
          body: FutureBuilder<List<KullaniciBilgileri>>(
              future: getAdmin(),
              builder:
                  (context, AsyncSnapshot<List<KullaniciBilgileri>> snapshot) {
                if (snapshot.hasData) {
                  return buildListele(snapshot, context, widget.yetki);
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
