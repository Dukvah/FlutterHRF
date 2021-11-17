import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mia_hfr/Services/putFaaliyetGuncelle.dart';

AppBar buildAppbar(
  BuildContext context,
  tarih,
) {
  return AppBar(
    backgroundColor: Colors.blue[800],
    title: Text(
      DateFormat('dd-MM-yyyy').format(tarih),
      style: TextStyle(fontSize: 25.0),
    ),
    centerTitle: true,
  );
}

String _faaliyet = "";
String _baslik = "";
int _value;
bool _valueHafta = false;
Row buildSaveButton(
  formKey,
  int hafta,
  int kullaniciID,
  TextEditingController _controllerTarih,
  int id,
  context,
  void Function(VoidCallback fn) setState,
) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: <Widget>[
      MaterialButton(
        onPressed: () async {
          if (_value == null) {
            _value = hafta;
          }

          if (formKey.currentState.validate()) {
            formKey.currentState.save();
            await faaliyetGuncelle(id, kullaniciID, _baslik, _faaliyet,
                _controllerTarih.text, _value);
            _valueHafta = false;
            showDialog(
              context: context,
              builder: (BuildContext context) {
                // return object of type Dialog

                return AlertDialog(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20.0))),
                    actions: <Widget>[
                      // usually buttons at the bottom of the dialog
                      Center(
                        child: ElevatedButton.icon(
                          label: Text('Geri Dön'),
                          icon: Icon(Icons.arrow_forward_ios),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      )
                    ],
                    title: Center(
                        child: getGuncelle == true
                            ? Text("Başarıyla Güncellendi")
                            : Text("Bir Sorun Oluştu")),
                    content: getGuncelle == true
                        ? Text("Girmiş olduğunuz işlem kayıt edildi.")
                        : Text(
                            "Girmiş olduğunuz işlem güncellenemedi, Onaylı tarihi güncelliyor olabilirsiniz."));
              },
            );
          }
        },
        shape: StadiumBorder(),
        child: Text(
          "Güncelle",
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15.0),
        ),
        color: Colors.blue[400],
        padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 30.0),
      ),
    ],
  );
}

Form buildForm(
  BuildContext context,
  TextEditingController _controllerBaslik,
  String baslik,
  TextEditingController _controllerFaaliyet,
  String faaliyet,
  formKey,
  TextEditingController _controllerTarih,
  _datePicker,
  int hafta,
  void Function(VoidCallback fn) setState,
) {
  _controllerBaslik.text = baslik;
  _controllerFaaliyet.text = faaliyet;

  return Form(
    key: formKey,
    child: Column(
      children: <Widget>[
        Row(children: <Widget>[
          SizedBox(
            width: 20,
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.only(left: 10.0, right: 10.0),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(20.0)),
                border: Border.all(
                  color: Colors.black,
                  width: 1,
                ),
              ),
              child: TextFormField(
                controller: _controllerTarih,
                readOnly: true,
                decoration: InputDecoration(
                  suffixIcon: Icon(
                    Icons.calendar_today,
                    color: Colors.blue[800],
                    size: 25,
                  ),
                ),
                onTap: () {
                  {
                    _datePicker(context);
                  }
                },
                validator: (value) {
                  if (value.isEmpty) {
                    return "Tarih giriniz.";
                  }
                  return null;
                },
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: Container(
                padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(20.0)),
                  border: Border.all(
                    color: Colors.black,
                    width: 1,
                  ),
                ),
                child: DropdownButton(
                  icon: Icon(
                    Icons.arrow_circle_down_outlined,
                    size: 30,
                    color: Colors.blue[800],
                  ),
                  elevation: 16,
                  value: _valueHafta ? _value : hafta,
                  items: [
                    DropdownMenuItem(
                      child: Text("1. Hafta"),
                      value: 1,
                    ),
                    DropdownMenuItem(
                      child: Text("2. Hafta"),
                      value: 2,
                    ),
                    DropdownMenuItem(child: Text("3. Hafta"), value: 3),
                    DropdownMenuItem(child: Text("4. Hafta"), value: 4),
                    DropdownMenuItem(child: Text("5. Hafta"), value: 5)
                  ],
                  onChanged: (value) {
                    setState(() {
                      _value = value;
                      _valueHafta = true;
                    });
                  },
                ),
              ),
            ),
          ),
        ]),
        SizedBox(
          height: 20,
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextFormField(
            maxLines: 3,
            maxLength: 130,
            controller: _controllerBaslik,
            decoration: new InputDecoration(
              labelText: "Başlık Giriniz.",
              border: new OutlineInputBorder(
                borderRadius: const BorderRadius.all(
                  const Radius.circular(20.0),
                ),
              ),
            ),
            validator: (baslik) {
              if (baslik.length < 3) {
                return "En az 3 karakter giriniz.";
              }
              return null;
            },
            onSaved: (bdatalar) {
              setState(() {
                _baslik = bdatalar;
              });
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextFormField(
            maxLines: 8,
            maxLength: 350,
            controller: _controllerFaaliyet,
            decoration: InputDecoration(
              labelText: "Faaliyet Giriniz.",
              border: OutlineInputBorder(
                borderRadius: const BorderRadius.all(
                  const Radius.circular(20.0),
                ),
              ),
            ),
            validator: (fdeger) {
              if (fdeger.length < 3) {
                return "En az 3 karakter giriniz.";
              }
              return null;
            },
            onSaved: (datalar) {
              setState(() {
                _faaliyet = datalar;
              });
            },
          ),
        ),
      ],
    ),
  );
}
