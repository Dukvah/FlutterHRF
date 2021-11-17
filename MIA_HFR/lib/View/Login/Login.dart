import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mia_hfr/Model/KullaniciBilgileri.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Widgets/NavigationBar.dart';
import '../../Services/postKullaniciGetir.dart';
import '../Admin/Admin.dart';
import 'package:encrypt/encrypt.dart' as a;

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

final key = a.Key.fromUtf8("32 karakter"); //32 chars
final iv = a.IV.fromUtf8('put16characters!'); //16 chars

class _LoginState extends State<Login> with SingleTickerProviderStateMixin {
  AnimationController _controller;
  TextEditingController kullaniciAdiController = new TextEditingController();
  TextEditingController kullaniciParolaController = new TextEditingController();
  KullaniciBilgileri userObject;
  @override
  void initState() {
    super.initState();
    sharedGetir();

    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  void sharedKayit(String kadi, String pass) async {
    final shared = await SharedPreferences.getInstance();
    shared.setString("KullaniciAdi", kadi);
    shared.setString("KullaniciPass", pass);
  }

  void sharedGetir() async {
    final shared = await SharedPreferences.getInstance();
    kullaniciAdiController.text = shared.getString("KullaniciAdi");
    kullaniciParolaController.text = shared.getString("KullaniciPass");
    if (shared.getString("KullaniciAdi") != null) {
      setState(() {
        _hatirla = true;
      });
    }
  }

  void sharedSil() async {
    final shared = await SharedPreferences.getInstance();
    shared.clear();
  }

  ProgressDialog pr;

  bool _hatirla = false;
  String _kAdi;
  String _pass;
  bool _passGizle = true;
  final _formkey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    pr = new ProgressDialog(context);
    pr.style(
        message: 'Giriş Yapılıyor...',
        borderRadius: 10.0,
        backgroundColor: Colors.white,
        progressWidget: CircularProgressIndicator(),
        elevation: 10.0,
        insetAnimCurve: Curves.easeInOut,
        progress: 0.0,
        maxProgress: 100.0,
        progressTextStyle: TextStyle(
            color: Colors.black, fontSize: 13.0, fontWeight: FontWeight.w400),
        messageTextStyle: TextStyle(
            color: Colors.black, fontSize: 19.0, fontWeight: FontWeight.w600));
    return WillPopScope(
      onWillPop: () => exit(0),
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Form(
              key: _formkey,
              child: Container(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height,
                  maxWidth: MediaQuery.of(context).size.width,
                ),
                decoration: BoxDecoration(
                  color: Colors.blue[800],
                ),
                child: Column(
                  children: <Widget>[
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image(
                            width: 300,
                            height: 300,
                            alignment: Alignment.topCenter,
                            image: AssetImage("images/logo-Mia.png"),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(100),
                            bottomRight: Radius.circular(100),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: Column(
                            children: [
                              Text(
                                "MİA-HFR",
                                style: TextStyle(
                                  fontSize: 30.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue[800],
                                ),
                              ),
                              SizedBox(
                                height: 50.0,
                              ),
                              TextFormField(
                                style: TextStyle(fontSize: 15),
                                controller: kullaniciAdiController,
                                keyboardType: TextInputType.text,
                                maxLength: 20,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                    borderSide: BorderSide.none,
                                  ),
                                  filled: true,
                                  fillColor: Color(0XFFe7edeb),
                                  hintText: "Kullanıcı Adı",
                                  prefixIcon: Icon(
                                    Icons.person,
                                    color: Colors.grey[600],
                                  ),
                                ),
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return "Kullanıcı Adınızı Giriniz.";
                                  }
                                  return null;
                                },
                                onSaved: (value) {
                                  _kAdi = value;
                                },
                              ),
                              SizedBox(
                                height: 20.0,
                              ),
                              TextFormField(
                                style: TextStyle(fontSize: 15),
                                obscureText: _passGizle,
                                controller: kullaniciParolaController,
                                maxLength: 20,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                    borderSide: BorderSide.none,
                                  ),
                                  filled: true,
                                  fillColor: Color(0XFFe7edeb),
                                  hintText: "Parola",
                                  prefixIcon: Icon(
                                    Icons.lock,
                                    color: Colors.grey[600],
                                  ),
                                  suffixIcon: IconButton(
                                      icon: _passGizle == true
                                          ? Icon(
                                              Icons.visibility_off,
                                              color: Colors.grey[600],
                                            )
                                          : Icon(
                                              Icons.visibility,
                                              color: Colors.grey[600],
                                            ),
                                      onPressed: () {
                                        setState(() {
                                          if (_passGizle == false) {
                                            _passGizle = false;
                                          }
                                          if (_passGizle == true) {
                                            _passGizle = false;
                                          } else
                                            _passGizle = true;
                                        });
                                      }),
                                ),
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return "Parolanızı Giriniz.";
                                  }
                                  return null;
                                },
                                onSaved: (value) {
                                  _pass = value;
                                },
                              ),
                              SwitchListTile(
                                  title: Text(
                                    "Beni Hatırla",
                                    style: TextStyle(fontSize: 15),
                                  ),
                                  value: _hatirla,
                                  onChanged: (value) {
                                    setState(() {
                                      _hatirla = value;
                                      if (value == false) {
                                        sharedSil();
                                      }
                                    });
                                  }),
                              Container(
                                width: double.infinity,
                                // ignore: deprecated_member_use
                                child: RaisedButton(
                                  onPressed: () async {
                                    pr.show();
                                    if (_formkey.currentState.validate()) {
                                      _formkey.currentState.save();
                                      FocusManager.instance.primaryFocus
                                          .unfocus();
                                      if (_hatirla == true &&
                                          kullaniciAdiController.text != "" &&
                                          kullaniciParolaController.text !=
                                              "") {
                                        sharedKayit(kullaniciAdiController.text,
                                            kullaniciParolaController.text);
                                      }
 
                                      if (_kAdi != null && _pass != null) {
                                        userObject = await kullaniciGetir(
                                            kullaniciAdiController.text,
                                            kullaniciParolaController.text);
                                        if (userObject != null) {
                                          if (userObject.yetkiGrupId == 1 ||
                                              userObject.yetkiGrupId == 2) {
                                            Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => Admin(
                                                  kullaniciAdi: _kAdi,
                                                  yetki: userObject.yetkiGrupId,
                                                ),
                                              ),
                                            ); //
                                          } else {
                                            Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      NavigationBar(
                                                          user: userObject)),
                                            );
                                          }
                                        } else {
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              // return object of type Dialog

                                              return AlertDialog(
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                20.0))),
                                                actions: <Widget>[
                                                  // usually buttons at the bottom of the dialog
                                                  Center(
                                                    child: ElevatedButton.icon(
                                                      label: Text('Geri Dön'),
                                                      style: ButtonStyle(
                                                        backgroundColor:
                                                            MaterialStateProperty
                                                                .all(Colors
                                                                    .blue[800]),
                                                      ),
                                                      icon: Icon(Icons
                                                          .arrow_forward_ios),
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                    ),
                                                  )
                                                ],
                                                title: Center(
                                                  child:
                                                      new Text("Hatalı Giriş"),
                                                ),
                                                content: new Text(
                                                  "Kullanıcı adınız veya parolanız yanlış, lütfen tekrar deneyiniz.",
                                                ),
                                              );
                                            },
                                          );
                                        }
                                      }
                                    }
                                  },
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20)),
                                  color: Colors.blue[800],
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 16.0),
                                    child: Text(
                                      "Giriş",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20.0,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
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
