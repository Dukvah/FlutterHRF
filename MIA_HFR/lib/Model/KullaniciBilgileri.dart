// To parse this JSON data, do
//
//     final kullaniciBilgileri = kullaniciBilgileriFromJson(jsonString);

import 'dart:convert';

KullaniciBilgileri kullaniciBilgileriFromJson(String str) =>
    KullaniciBilgileri.fromJson(json.decode(str));

String kullaniciBilgileriToJson(KullaniciBilgileri data) =>
    json.encode(data.toJson());

class KullaniciBilgileri {
  KullaniciBilgileri({
    this.id,
    this.kullaniciAdi,
    this.kullaniciParola,
    this.yetkiGrupId,
  });

  int id;
  String kullaniciAdi;
  String kullaniciParola;
  int yetkiGrupId;

  factory KullaniciBilgileri.fromJson(Map<String, dynamic> json) =>
      KullaniciBilgileri(
        id: json["ID"],
        kullaniciAdi: json["KullaniciAdi"],
        kullaniciParola: json["KullaniciParola"],
        yetkiGrupId: json["YetkiGrup_ID"],
      );

  Map<String, dynamic> toJson() => {
        "ID": id,
        "KullaniciAdi": kullaniciAdi,
        "KullaniciParola": kullaniciParola,
        "YetkiGrup_ID": yetkiGrupId,
      };
}
