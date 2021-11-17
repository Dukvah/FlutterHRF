import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../Login/Login.dart';
import 'KullaniciFaaliyetEkle_widgets.dart';

class KullaniciFaaliyetEkle extends StatefulWidget {
  final String kullaniciAdi;
  final int id;
  final int yetki;

  KullaniciFaaliyetEkle(
      {Key key,
      @required this.kullaniciAdi,
      @required this.id,
      @required this.yetki})
      : super(key: key);

  @override
  _KAnasayfaState createState() => _KAnasayfaState();
}

class _KAnasayfaState extends State<KullaniciFaaliyetEkle> {
  var formKey = GlobalKey<FormState>();
  var scaffoldKey = GlobalKey<ScaffoldState>();
  String faaliyet = "";
  String baslik = "";
  int hafta = 1;
  var _controllerBaslik = TextEditingController();
  var _controllerFaaliyet = TextEditingController();
  var _controllerTarih = TextEditingController();
  @override
  void initState() {
    _controllerTarih.text = DateFormat('dd-MM-yyyy').format(DateTime.now());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => showDialog(
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
              child: Text("Çıkış Yapmak İstediğinize Emin misiniz?"),
            ),
          );
        },
      ),
      child: SafeArea(
        child: Scaffold(
          appBar: buildAppbar(
              context, widget.id, widget.kullaniciAdi, widget.yetki),
          body: SingleChildScrollView(
            child: SafeArea(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  image: DecorationImage(
                    image: AssetImage("images/AnaBack.png"),
                    fit: BoxFit.fill,
                  ),
                ),
                padding: EdgeInsets.all(20.0),
                child: Column(
                  children: <Widget>[
                    buildForm(
                        context,
                        setState,
                        _controllerTarih,
                        formKey,
                        _controllerBaslik,
                        baslik,
                        _controllerFaaliyet,
                        faaliyet,
                        hafta),
                    buildSaveButton(formKey, widget.id, _controllerBaslik,
                        _controllerFaaliyet, _controllerTarih, context),
                    SizedBox(
                      height: 69,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
