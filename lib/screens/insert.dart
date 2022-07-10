import 'package:sngpl/Components/data.dart';
import 'package:flutter_holo_date_picker/flutter_holo_date_picker.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class insert extends StatefulWidget {
  @override
  _insertState createState() => _insertState();
}

class _insertState extends State<insert> with AutomaticKeepAliveClientMixin {


  @override
  bool get wantKeepAlive => true;

  final firestore = FirebaseFirestore.instance;
  String val;
  Data d=Data();

  void getData_islu() async{
   await firestore.collection("initial").doc('islu').get().then((value){
      print(value.get('1'));
      d.inventory_islu=value.get('1');
    });
  }

  void getData_manga() async{
    await firestore.collection("initial").doc('manga').get().then((value){
      print(value.get('1'));
      d.inventory_manga=value.get('1');
    });
  }

  void getData_total() async{
    await firestore.collection("initial").doc('total').get().then((value){
      print(value.get('1'));
      d.total_pending=value.get('1');
    });
  }


  @override
  void initState() {
    // TODO: implement initState
    getData_islu();
    getData_manga();
    getData_total();
    super.initState();
  }

  DateTime _selectedDate=DateTime.now();

  @override
  Widget build(BuildContext context) {
    d.printing_manga=0;d.printing_islu=0;
    String mangap="",islup="";
    var box;
    var previsb,prevmanga,prevtotal;


    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: ListView(
          children: <Widget>[
            SafeArea(
              child: Container(
                padding: const EdgeInsets.all( 10),
                child: DatePickerWidget(// default is not looping
                  firstDate: DateTime(2019),
                  lastDate: DateTime(2025, 1, 1),
                  initialDate: _selectedDate,
                  dateFormat: "dd-MMMM-yyyy",
                  locale: DateTimePickerLocale.en_us,
                  looping: false,
                  onChange: (DateTime newDate, _) => _selectedDate = newDate,
                  pickerTheme: DateTimePickerTheme(
                    backgroundColor: Colors.transparent,
                    itemTextStyle: TextStyle(color: Colors.black, fontSize: 19),
                    dividerColor: Colors.blue,
                  ),
                ),
              ),
            ),
            Center(
              child: Container(
                padding: EdgeInsets.all(10),
                child: Text(
                  'Printing',
                  style: TextStyle(
                      fontSize: 28,
                      color: Colors.white
                  ),
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.0),
                  color: Colors.green,
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Center(
              child: Container(
                padding: EdgeInsets.all(10),
                child: Text(
                  'These fields are required',
                  style: TextStyle(
                      fontSize: 28,
                      color: Colors.red[900]
                  ),
                ),
              ),
            ),
            Center(
              child: Container(
                child: Text(
                  'Manga',
                  style: TextStyle(
                    fontSize: 28,
                    color: Colors.deepOrange
                  ),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.all(20),
              child: TextField(
                onChanged: (value){
                  mangap=value;
                },
                style: TextStyle(
                  color: Colors.black
                ),
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.blueAccent,
                    ),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                )),
            ),
            Center(
              child: Container(
                child: Text(
                  'Islamabad',
                  style: TextStyle(
                      fontSize: 28,
                      color: Colors.cyan
                  ),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.all(20),
              child: TextField(
                  onChanged: (value){
                    islup=value;
                  },
                  style: TextStyle(
                      color: Colors.black
                  ),
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.deepPurple,
                      ),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  )),
            ),
            Center(
              child: FlatButton(
                color: Colors.blueAccent,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                child: Text(
                  'Insert',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 25
                  ),
                ),
                onPressed: () {
                  print(d.total_pending);
                  print(d.inventory_manga);
                  d.printing_islu=int.parse(islup);
                  d.printing_manga=int.parse(mangap);
                  if (mangap!="" && islup!="") {
                    var year = _selectedDate.year;
                    var month = _selectedDate.month;
                    var day = _selectedDate.day;
                    firestore.collection('islamabad_printing').
                    doc('$year-$month').update({
                      '$day': d.printing_islu
                    });
                    firestore.collection('manga-printing').
                    doc('$year-$month').update({
                      '$day': d.printing_manga
                    });
                    firestore.collection('islamabad_inventory').
                    doc('$year-$month').update({
                      '$day': d.inventory_islu
                    });
                    firestore.collection('manga_inventory').
                    doc('$year-$month').update({
                      '$day': d.inventory_manga
                    });
                    firestore.collection('total_pending').
                    doc('$year-$month').update({
                      '$day': d.total_pending
                    });
                    d.inventory_islu=d.inventory_islu-(d.printing_islu/2000);
                    d.inventory_manga=d.inventory_manga-(d.printing_manga/2000);
                    print(d.inventory_manga);
                    print(d.inventory_islu);
                    firestore.collection('initial').
                    doc('islu').update({
                      '1' : d.inventory_islu
                    });
                    firestore.collection('initial').
                    doc('manga').update({
                      '1' : d.inventory_manga
                    });
                    firestore.collection('initial').
                    doc('total').update({
                      '1' : d.total_pending
                    });
                  }
                }
              ),
            ),
            SizedBox(
              height: 40,
            ),
            Center(
              child: Container(
                padding: EdgeInsets.all(10),
                child: Text(
                  'Inventory',
                  style: TextStyle(
                      fontSize: 28,
                      color: Colors.white
                  ),
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.0),
                  color: Colors.lightBlue,
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.all(20),
              child: TextField(
                  onChanged: (value){
                    //prevmanga=d.inventory_manga;
                    prevmanga=value;
                  },
                  style: TextStyle(
                      color: Colors.black
                  ),
                  decoration: InputDecoration(
                    labelText: "Manga",
                    labelStyle: TextStyle(
                      color: Colors.blueAccent
                    ),
                    hintText: "Optional",
                    hintStyle: TextStyle(
                        color: Colors.blueGrey
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.black38,
                      ),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  )),
            ),
            Container(
              padding: EdgeInsets.all(20),
              child: TextField(
                  onChanged: (value){
                    //previsb=d.inventory_islu;
                    previsb=value;
                  },
                  style: TextStyle(
                      color: Colors.black
                  ),
                  decoration: InputDecoration(
                    labelText: "Islamabad",
                    labelStyle: TextStyle(
                        color: Colors.blueAccent
                    ),
                    hintText: "Optional",
                    hintStyle: TextStyle(
                      color: Colors.blueGrey
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.black38,
                      ),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  )),
            ),
            Container(
              padding: EdgeInsets.all(20),
              child: TextField(
                  onChanged: (value){
                    //prevtotal=d.total_pending;
                    prevtotal=value;
                  },
                  style: TextStyle(
                      color: Colors.black
                  ),
                  decoration: InputDecoration(
                    labelText: "Total Pending",
                    labelStyle: TextStyle(
                        color: Colors.blueAccent
                    ),
                    hintText: "Optional",
                    hintStyle: TextStyle(
                        color: Colors.blueGrey
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.black38,
                      ),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  )),
            ),
            Center(
              child: FlatButton(
                color: Colors.blueAccent,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                child: Text(
                  'Insert',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 25
                  ),
                ),
                onPressed: () {
                  d.inventory_islu=int.parse(previsb);
                  d.inventory_manga=int.parse(prevmanga);
                  d.total_pending=int.parse(prevtotal);
                  firestore.collection('initial').
                  doc('islu').update({
                    '1' : int.parse(previsb)
                  });
                  firestore.collection('initial').
                  doc('manga').update({
                    '1' : int.parse(prevmanga)
                  });
                  firestore.collection('initial').
                  doc('total').update({
                    '1' : int.parse(prevtotal)
                  });
                  print(d.total_pending);
                  print(d.inventory_manga);
                  d.printing_islu=int.parse(islup);
                  d.printing_manga=int.parse(mangap);
                  if (islup != "" && mangap != "") {
                    var year = _selectedDate.year;
                    var month = _selectedDate.month;
                    var day = _selectedDate.day;
                    firestore.collection('islamabad_printing').
                    doc('$year-$month').update({
                      '$day': d.printing_islu
                    });
                    firestore.collection('manga-printing').
                    doc('$year-$month').update({
                      '$day': d.printing_manga
                    });
                    firestore.collection('islamabad_inventory').
                    doc('$year-$month').update({
                      '$day': d.inventory_islu
                    });
                    firestore.collection('manga_inventory').
                    doc('$year-$month').update({
                      '$day': d.inventory_manga
                    });
                    firestore.collection('total_pending').
                    doc('$year-$month').update({
                      '$day': d.total_pending
                    });
                    d.inventory_islu=d.inventory_islu-(d.printing_islu/2000);
                    d.inventory_manga=d.inventory_manga-(d.printing_manga/2000);
                    print(d.inventory_manga);
                    print(d.inventory_islu);
                    firestore.collection('initial').
                    doc('islu').update({
                      '1' : d.inventory_islu
                    });
                    firestore.collection('initial').
                    doc('manga').update({
                      '1' : d.inventory_manga
                    });
                    firestore.collection('initial').
                    doc('total').update({
                      '1' : d.total_pending
                    });
                  }
                }
              ),
            )
          ],
        ),
      ),
    );
  }
}

