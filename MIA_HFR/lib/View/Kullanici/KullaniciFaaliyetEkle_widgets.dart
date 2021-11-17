import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mia_hfr/Services/postFaaliyetEkle.dart';

int _value = 1;

AppBar buildAppbar(BuildContext context, id, kullaniciAdi, yetki) {
  return AppBar(
    automaticallyImplyLeading: false,
    backgroundColor: Colors.blue[800],
    title: Text(
      kullaniciAdi,
      style: TextStyle(fontSize: 30.0),
    ),
    centerTitle: true,
  );
}

Form buildForm(
    BuildContext context,
    dynamic setState,
    TextEditingController _controllerTarih,
    dynamic formKey,
    TextEditingController _controllerBaslik,
    String baslik,
    TextEditingController _controllerFaaliyet,
    String faaliyet,
    int value) {
  Future<void> _datePicker(BuildContext context) async {
    context = context;
    DateTime _datetime = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(DateTime.now().year - 1),
      lastDate: DateTime(DateTime.now().year + 5),
    );
    setState(() {
      if (_datetime != null) {
        _controllerTarih.text =
            DateFormat('dd-MM-yyyy').format(_datetime); //yyyy-MM-dd HH:mm:ss
      }
    });
  }

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
                padding: const EdgeInsets.only(
                  left: 10.0,
                  right: 10.0,
                ),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(20.0)),
                  border: Border.all(
                    color: Colors.black,
                    width: 1,
                  ),
                ),
                child: DropdownButton(
                    icon: Icon(
                      Icons.arrow_circle_down,
                      size: 30,
                      color: Colors.blue[800],
                    ),
                    value: _value,
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
                      });
                    }),
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
            //BAŞLIK
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
                baslik = bdatalar;
              });
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextFormField(
            //FAALİYET
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
                faaliyet = datalar;
              });
            },
          ),
        ),
      ],
    ),
  );
}

Row buildSaveButton(formKey, id, _controllerBaslik, _controllerFaaliyet,
    _controllerTarih, context) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: <Widget>[
      MaterialButton(
        onPressed: () async {
          if (formKey.currentState.validate()) {
            formKey.currentState.save();
            FocusManager.instance.primaryFocus.unfocus();
            await faaliyetEkle(id, _controllerBaslik.text,
                _controllerFaaliyet.text, _controllerTarih.text, _value);
            _controllerBaslik.clear();
            _controllerFaaliyet.clear();
          }

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
                      child: postFaaliyetEkle == true
                          ? Text("Başarıyla Kayıt Edildi.")
                          : Text("Bir Hata Oluştu.")),
                  content: postFaaliyetEkle == true
                      ? Text("Girmiş olduğunuz işlem kayıt edildi.")
                      : Text(
                          "İşlem Kayıt Edilemedi. Onaylı Tarihe Faaliyet Giremezsiniz."));
            },
          );
        },
        shape: StadiumBorder(),
        child: Text(
          "Kaydet",
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20.0),
        ),
        color: Colors.green,
        padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 50.0),
      ),
    ],
  );
}
