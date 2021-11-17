import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../Model/KullaniciBilgileri.dart';
import '../Kullanici/KullaniciDetay.dart';
import '../Kullanici/KullaniciFaaliyetEkle.dart';

class NavigationBar extends StatefulWidget {
  final KullaniciBilgileri user;
  NavigationBar({this.user});
  @override
  _NavigationBarState createState() => _NavigationBarState();
}

class _NavigationBarState extends State<NavigationBar> {
  int _page = 0;

  GlobalKey _bottomNavigationKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: buildBody(_page),
      bottomNavigationBar: CurvedNavigationBar(
        height: 50.0,
        key: _bottomNavigationKey,
        color: Colors.grey[300],
        backgroundColor: Colors.blue[800],
        items: <Widget>[
          Icon(
            Icons.article_sharp,
            size: 30,
          ),
          Icon(Icons.add_box_outlined, size: 30),
        ],
        animationCurve: Curves.decelerate,
        animationDuration: Duration(milliseconds: 600),
        onTap: (index) {
          setState(() {
            _page = index;
          });
        },
      ),
    );
  }

  buildBody(int _page) {
    switch (_page) {
      case 0:
        return KullaniciDetay(
            id: widget.user.id,
            kullaniciAdi: widget.user.kullaniciAdi,
            yetki: widget.user.yetkiGrupId);
        break;
      case 1:
        return KullaniciFaaliyetEkle(
          id: widget.user.id,
          kullaniciAdi: widget.user.kullaniciAdi,
          yetki: widget.user.yetkiGrupId,
        );
        break;
    }
  }
}
