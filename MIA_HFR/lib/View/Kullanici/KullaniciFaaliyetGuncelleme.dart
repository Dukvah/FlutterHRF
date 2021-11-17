import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'KullaniciFaaliyetGuncelleme_widgets.dart';

class KullaniciFaaliyetGuncelleme extends StatefulWidget {
  final int hafta;
  final DateTime tarih;
  final String baslik;
  final String faaliyet;
  final int id;
  final int kullaniciID;

  KullaniciFaaliyetGuncelleme(
      {Key key,
      @required this.hafta,
      @required this.tarih,
      @required this.id,
      @required this.baslik,
      @required this.faaliyet,
      @required this.kullaniciID})
      : super(key: key);

  @override
  _KullaniciFaaliyetGuncellemeState createState() =>
      _KullaniciFaaliyetGuncellemeState();
}

class _KullaniciFaaliyetGuncellemeState
    extends State<KullaniciFaaliyetGuncelleme> {
  var formKey = GlobalKey<FormState>();
  var scaffoldKey = GlobalKey<ScaffoldState>();

  // int _value;
  var _controllerBaslik = TextEditingController();
  var _controllerFaaliyet = TextEditingController();
  var _controllerTarih = TextEditingController();
  @override
  void initState() {
    super.initState();
    _controllerTarih.text = DateFormat('dd-MM-yyyy').format(widget.tarih);
  }

  Future<void> _datePicker(BuildContext context) async {
    context = context;
    bool _decideWhichDayToEnable(DateTime day) {
      if ((day.isAfter(DateTime.now().subtract(Duration(days: 3))) &&
          day.isBefore(DateTime.now().add(Duration(days: 0))))) {
        return true;
      }
      return false;
    }

    DateTime _datetime = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(DateTime.now().year - 5),
      lastDate: DateTime(DateTime.now().year + 5),
      selectableDayPredicate: _decideWhichDayToEnable,
    );

    setState(() {
      if (_datetime != null) {
        _controllerTarih.text =
            DateFormat('dd-MM-yyyy').format(_datetime); //yyyy-MM-dd HH:mm:ss
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppbar(context, widget.tarih),
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
            padding: EdgeInsets.all(16.0),
            child: Column(
              children: <Widget>[
                buildForm(
                  context,
                  _controllerBaslik,
                  widget.baslik,
                  _controllerFaaliyet,
                  widget.faaliyet,
                  formKey,
                  _controllerTarih,
                  _datePicker,
                  widget.hafta,
                  setState,
                ),
                buildSaveButton(
                  formKey,
                  widget.hafta,
                  widget.kullaniciID,
                  _controllerTarih,
                  widget.id,
                  context,
                  setState,
                ),
                SizedBox(
                  height: 69,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
