// To parse this JSON data, do
//
//     final kullaniciDetaylar = kullaniciDetaylarFromJson(jsonString);

import 'dart:convert';

List<KullaniciDetaylar> kullaniciDetaylarFromJson(String str) =>
    List<KullaniciDetaylar>.from(
        json.decode(str).map((x) => KullaniciDetaylar.fromJson(x)));

String kullaniciDetaylarToJson(List<KullaniciDetaylar> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class KullaniciDetaylar {
  KullaniciDetaylar({
    this.id,
    this.kullaniciAdi,
    this.tarih,
    this.hafta,
    this.durum,
  });

  int id;
  String kullaniciAdi;
  String tarih;
  int hafta;
  int durum;

  factory KullaniciDetaylar.fromJson(Map<String, dynamic> json) =>
      KullaniciDetaylar(
        id: json["ID"],
        kullaniciAdi: json["KullaniciAdi"],
        tarih: json["Tarih"],
        hafta: json["Hafta"],
        durum: json["Durum"],
      );

  Map<String, dynamic> toJson() => {
        "ID": id,
        "KullaniciAdi": kullaniciAdi,
        "Tarih": tarih,
        "Hafta": hafta,
        "Durum": durum,
      };
}
