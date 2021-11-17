import 'package:flutter/material.dart';
import 'package:mia_hfr/Model/KullaniciBilgileri.dart';
import 'package:mia_hfr/View/Kullanici/KullaniciDetay.dart';

Widget buildListele(AsyncSnapshot<List<KullaniciBilgileri>> snapshot,
    BuildContext context, int yetki) {
  return Column(
    children: [
      _space(context),
      Expanded(
        child: ListView.builder(
          itemCount: snapshot.data.length,
          itemBuilder: (context, int index) {
            return Container(
              width: double.maxFinite,
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(10),
                    topRight: Radius.circular(40),
                    bottomLeft: Radius.circular(30),
                  ),
                ),
                margin: EdgeInsets.all(10),
                elevation: 20,
                color: Colors.blue,
                child: Column(
                  children: <Widget>[
                    new Align(
                      child: ListTile(
                        leading: CircleAvatar(
                          child: Icon(Icons.person),
                          radius: 15,
                          foregroundColor: Colors.blue[800],
                          backgroundColor: Colors.white,
                        ),
                        title: Center(
                          child: Text(
                            snapshot.data[index].kullaniciAdi,
                            style: new TextStyle(
                              fontSize: 22.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        trailing: Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.white,
                          size: 30,
                        ),
                        onTap: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => KullaniciDetay(
                                      id: snapshot.data[index].id,
                                      kullaniciAdi:
                                          snapshot.data[index].kullaniciAdi,
                                      yetki: yetki,
                                    )),
                          ); //
                        },
                      ),
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

Widget _space(BuildContext context) => SizedBox(height: 20);
