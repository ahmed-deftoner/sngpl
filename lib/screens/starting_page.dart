import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:sngpl/screens/insert.dart';
import 'package:sngpl/screens/home_screen.dart';
import 'package:sngpl/Components/data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_holo_date_picker/flutter_holo_date_picker.dart';
import 'package:sngpl/screens/login.dart';

class start extends StatefulWidget {
  @override
  _startState createState() => _startState();
}

class _startState extends State<start> {
  Data s= Data();
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  final firestore = FirebaseFirestore.instance;

  Future<dynamic> getData(var year,var month,var day) async {
    _state=false;
    s.this_month_islu=0;
    s.this_month_manga=0;

    final DocumentReference islp = firestore.collection(
        "islamabad_printing").doc('$year-$month');

    await islp.get().then<dynamic>((DocumentSnapshot snapshot) async {
      setState(() {
        try {
          s.printing_islu = snapshot.get('$day');
        }catch(e){
          s.printing_islu=0;
        }
        var x;
          for(var i=1;i<=day;++i) {
            try {
              x = snapshot.get('$i');
            }catch(e){
              x=0;
            }
            s.this_month_islu+=x;
          }
          x=6;
          s.week_sum_islu=0;
          for(var i=day;i>day-7;--i) {
            try {
              s.week_islu[x]=  snapshot.get('$i');
            }catch(e){
              s.week_islu[x] = 0;
            }
            s.week_sum_islu+= s.week_islu[x];
            x--;
          }
      });
    });

    var z=month-1;
    final DocumentReference islpr = firestore.collection(
        "islamabad_printing").doc('$year-$z');
    await islpr.get().then<dynamic>((DocumentSnapshot snapshot) async {
      setState(() {
        var x=0;
        s.prev_month_islu=0;
         for(var i=1;i<=31;++i){
           try{
             x=snapshot.get('$i');
           }catch(e){
             x=0;
           }
           s.prev_month_islu+=x;
         }
         print(s.prev_month_islu);
      });
    });


    final DocumentReference mangap = firestore.collection(
        "manga-printing").doc('$year-$month');

    await mangap.get().then<dynamic>((DocumentSnapshot snapshot) async {
      setState(() {
        try {
          s.printing_manga = snapshot.get('$day');
        }catch(e){
          s.printing_manga=0;
        }
        var x;
        for(var i=1;i<=day;++i) {
          try {
            x = snapshot.get('$i');
          }catch(e){
            x=0;
          }
          s.this_month_manga+=x;
        }
        x=6;
        s.week_sum_manga=0;
        for(var i=day;i>day-7;--i) {
          try {
            s.week_manga[x] = snapshot.get('$i');
          } catch (e) {
            s.week_manga[x] = 0;
          }
          s.week_sum_manga += s.week_manga[x];
          x--;
        }
      });
    });

    final DocumentReference mangapr = firestore.collection(
        "manga-printing").doc('$year-$z');
    await mangapr.get().then<dynamic>((DocumentSnapshot snapshot) async {
      setState(() {
        var x=0;
        s.prev_month_manga=0;
        for(var i=1;i<=31;++i){
          try{
            x=snapshot.get('$i');
          }catch(e){
            x=0;
          }
          s.prev_month_manga+=x;
        }
        print(s.prev_month_manga);
      });
    });


    final DocumentReference isli = firestore.collection(
        "islamabad_inventory").doc('$year-$month');

    await isli.get().then<dynamic>((DocumentSnapshot snapshot) async {
      setState(() {
        try {
          s.inventory_islu = snapshot.get('$day');
        }catch(e){
          s.inventory_islu=0;
        }
      });
    });

    final DocumentReference mangai = firestore.collection(
        "manga_inventory").doc('$year-$month');

    await mangai.get().then<dynamic>((DocumentSnapshot snapshot) async {
      setState(() {
        try {
          s.inventory_manga = snapshot.get('$day');
        }catch(e){
          s.inventory_manga=0;
        }
      });
    });

    final DocumentReference total = firestore.collection(
        "total_pending").doc('$year-$month');

    await total.get().then<dynamic>((DocumentSnapshot snapshot) async {
      setState(() {
        try {
          s.total_pending = snapshot.get('$day');
        }catch(e){
          s.total_pending=0;
        }
      });
    });
    _state=true;
    return Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Home(
          initial: s,
          day: _selectedDate.day,
          month: _selectedDate.month,
          year: _selectedDate.year,
        ),
      ),
    );
  }

  bool _state=true;
  Widget setUpButtonChild() {
   if (_state == false) {
      return CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
      );
    }
   else{
     return SizedBox(
       height: 2,
     );
   }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(
          children: <Widget>[
            SizedBox(
              height: 40,
            ),
            SafeArea(
              child: Container(
                padding: const EdgeInsets.all( 10),
                child: DatePickerWidget(// default is not looping
                  firstDate: DateTime(2019),
                  lastDate: DateTime(2025, 1, 1),
                  initialDate: DateTime.now(),
                  dateFormat: "dd-MMMM-yyyy",
                  locale: DateTimePickerLocale.en_us,
                  looping: false,
                  onChange: (DateTime newDate, _) => _selectedDate = newDate,
                  pickerTheme: DateTimePickerTheme(
                    backgroundColor: Colors.transparent,
                    itemTextStyle: TextStyle(color: Colors.white, fontSize: 19),
                    dividerColor: Colors.blue,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 140.0,
            ),
            FlatButton(
              padding: EdgeInsets.only(left: 50,top: 10,bottom: 10,right: 50),
              child: Text('Go',
                  style: TextStyle(
                  fontSize: 30,fontWeight: FontWeight.bold
              )),
              color: Colors.white,
              textColor: Color(0xFF2B5876),
              onPressed: () {
                var year = _selectedDate.year;
                var month = _selectedDate.month;
                var day = _selectedDate.day;
                getData(year, month, day);
              },
              shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50)
              ),
            ),
            SizedBox(
              height: 15.0,
            ),
            FlatButton(
              padding: EdgeInsets.only(left: 20,top: 10,bottom: 10,right: 20),
              onPressed: (){
                //getData();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Login(),
                  ),
                );
              },
              child: Text('Update', style: TextStyle(
                fontSize: 30.0,
                  color: Colors.white
              )
              ),
              shape: RoundedRectangleBorder(side: BorderSide(
                  color: Colors.white,
                  width: 1,
                  style: BorderStyle.solid
              ), borderRadius: BorderRadius.circular(50)),
            ),
            SizedBox(
              height: 15,
            ),
            setUpButtonChild()
          ],
        ),
      ),
      decoration:  BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment(0.8, 0.0), // 10% of the width, so there are ten blinds.
            colors: [const Color(0xFF2B5876), const Color(0xFF4E4376)], // whitish to gray
          ),
      )
    );
  }
}
