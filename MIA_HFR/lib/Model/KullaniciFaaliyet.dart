import 'dart:convert';

List<KullaniciFaaliyet> kullaniciFaaliyetFromJson(String str) =>
    List<KullaniciFaaliyet>.from(
        json.decode(str).map((x) => KullaniciFaaliyet.fromJson(x)));

String kullaniciFaaliyetToJson(List<KullaniciFaaliyet> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class KullaniciFaaliyet {
  KullaniciFaaliyet({
    this.id,
    this.kullaniciId,
    this.baslik,
    this.faaliyet,
    this.tarih,
    this.hafta,
    this.durum,
  });

  int id;
  int kullaniciId;
  String baslik;
  String faaliyet;
  DateTime tarih;
  int hafta;
  int durum;

  factory KullaniciFaaliyet.fromJson(Map<String, dynamic> json) =>
      KullaniciFaaliyet(
        id: json["ID"],
        kullaniciId: json["Kullanici_ID"],
        baslik: json["Baslik"],
        faaliyet: json["Faaliyet"],
        tarih: DateTime.parse(json["Tarih"]),
        hafta: json["Hafta"],
        durum: json["Durum"],
      );

  Map<String, dynamic> toJson() => {
        "ID": id,
        "Kullanici_ID": kullaniciId,
        "Baslik": baslik,
        "Faaliyet": faaliyet,
        "Tarih": tarih.toIso8601String(),
        "Hafta": hafta,
        "Durum": durum,
      };
}
