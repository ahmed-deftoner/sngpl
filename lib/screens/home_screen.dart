
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sngpl/Components/card.dart';
import 'package:pie_chart/pie_chart.dart' as pi;
import 'package:fl_chart/fl_chart.dart' ;
import 'package:sngpl/screens/islamabad.dart';
import 'package:sngpl/screens/manga.dart';
import 'package:sngpl/screens/starting_page.dart';
import 'package:sngpl/Components/data.dart';
import 'package:flutter_holo_date_picker/flutter_holo_date_picker.dart';

const kActiveCardColour = Color(0xFF1D1E33);
const kInactiveCardColour = Color(0xFF111328);



const kLabelTextStyle = TextStyle(
  fontSize: 18.0,
  color: Color(0xFF8D8E98),
);

const kNumberTextStyle = TextStyle(
  fontSize: 30.0,
  fontWeight: FontWeight.w900,
);

const kLargeButtonTextStyle = TextStyle(
  fontSize: 25.0,
  fontWeight: FontWeight.bold,
);

const kTitleTextStyle = TextStyle(
  fontSize: 50.0,
  fontWeight: FontWeight.bold,
);

const kResultTextStyle = TextStyle(
  color: Color(0xFF24D876),
  fontSize: 22.0,
  fontWeight: FontWeight.bold,
);

const kBMITextStyle = TextStyle(
  fontSize: 100.0,
  fontWeight: FontWeight.bold,
);

const kBodyTextStyle = TextStyle(
  fontSize: 22.0,
);

class Home extends StatefulWidget {
  Data initial=Data();
  var year,month,day;
  Home(
      {@required this.initial,@required this.day,@required this.month,@required this.year});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with AutomaticKeepAliveClientMixin{

  @override
  bool get wantKeepAlive => true;


  final Color leftBarColor = const Color(0xff53fdd7);
  final Color rightBarColor = const Color(0xffff5182);
  final double width = 7;

  List<BarChartGroupData> rawBarGroups;
  List<BarChartGroupData> showingBarGroups;

  int touchedGroupIndex;

  bool toggle = false;
  Map<String, double> dataMap = Map();
  Map<String, double> dataMap1 = Map();
  List<Color> colorList = [
    Color(0xFF4E4376),
    Color(0xFFF9D423),
  ];

  List<Color> colorList1 = [
    Color(0xFFCC2B5E),
    Color(0xFF799F0C)
  ];

  BarChartGroupData makeGroupData(int x, double y1, double y2) {
    return BarChartGroupData(barsSpace: 4, x: x, barRods: [
      BarChartRodData(
        y: y1,
        color: leftBarColor,
        width: width,
      ),
      BarChartRodData(
        y: y2,
        color: rightBarColor,
        width: width,
      ),
    ]);
  }

  Widget makeTransactionsIcon() {
    const double width = 4.5;
    const double space = 3.5;
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
          width: width,
          height: 10,
          color: Colors.white.withOpacity(0.4),
        ),
        const SizedBox(
          width: space,
        ),
        Container(
          width: width,
          height: 28,
          color: Colors.white.withOpacity(0.8),
        ),
        const SizedBox(
          width: space,
        ),
        Container(
          width: width,
          height: 42,
          color: Colors.white.withOpacity(1),
        ),
        const SizedBox(
          width: space,
        ),
        Container(
          width: width,
          height: 28,
          color: Colors.white.withOpacity(0.8),
        ),
        const SizedBox(
          width: space,
        ),
        Container(
          width: width,
          height: 10,
          color: Colors.white.withOpacity(0.4),
        ),
      ],
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

  final firestore = FirebaseFirestore.instance;
  Future<dynamic> getData(var year,var month,var day) async {
    _state=false;
    widget.initial.this_month_islu=0;
    widget.initial.this_month_manga=0;

    final DocumentReference islp = firestore.collection(
        "islamabad_printing").doc('$year-$month');

    await islp.get().then<dynamic>((DocumentSnapshot snapshot) async {
      setState(() {
        try {
          widget.initial.printing_islu = snapshot.get('$day');
        }catch(e){
          widget.initial.printing_islu=0;
        }
        var x;
        for(var i=1;i<=day;++i) {
          try {
            x = snapshot.get('$i');
          }catch(e){
            x=0;
          }
          widget.initial.this_month_islu+=x;
        }
        x=6;
        widget.initial.week_sum_islu=0;
        for(var i=day;i>day-7;--i) {
          try {
            widget.initial.week_islu[x]=  snapshot.get('$i');
          }catch(e){
            widget.initial.week_islu[x] = 0;
          }
          widget.initial.week_sum_islu+= widget.initial.week_islu[x];
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
        widget.initial.prev_month_islu=0;
        for(var i=1;i<=31;++i){
          try{
            x=snapshot.get('$i');
          }catch(e){
            x=0;
          }
          widget.initial.prev_month_islu+=x;
        }
      });
    });


    final DocumentReference mangap = firestore.collection(
        "manga-printing").doc('$year-$month');

    await mangap.get().then<dynamic>((DocumentSnapshot snapshot) async {
      setState(() {
        try {
          widget.initial.printing_manga = snapshot.get('$day');
        }catch(e){
          widget.initial.printing_manga=0;
        }
        var x;
        for(var i=1;i<=day;++i) {
          try {
            x = snapshot.get('$i');
          }catch(e){
            x=0;
          }
          widget.initial.this_month_manga+=x;
        }
        x=6;
        widget.initial.week_sum_manga=0;
        for(var i=day;i>day-7;--i) {
          try {
            widget.initial.week_manga[x] = snapshot.get('$i');
          } catch (e) {
            widget.initial.week_manga[x] = 0;
          }
          widget.initial.week_sum_manga += widget.initial.week_manga[x];
          x--;
        }
      });
    });

    final DocumentReference mangapr = firestore.collection(
        "manga-printing").doc('$year-$z');
    await mangapr.get().then<dynamic>((DocumentSnapshot snapshot) async {
      setState(() {
        var x=0;
        widget.initial.prev_month_manga=0;
        for(var i=1;i<=31;++i){
          try{
            x=snapshot.get('$i');
          }catch(e){
            x=0;
          }
          widget.initial.prev_month_manga+=x;
        }
      });
    });


    final DocumentReference isli = firestore.collection(
        "islamabad_inventory").doc('$year-$month');

    await isli.get().then<dynamic>((DocumentSnapshot snapshot) async {
      setState(() {
        try {
          widget.initial.inventory_islu = snapshot.get('$day');
        }catch(e){
          widget.initial.inventory_islu=0;
        }
      });
    });

    final DocumentReference mangai = firestore.collection(
        "manga_inventory").doc('$year-$month');

    await mangai.get().then<dynamic>((DocumentSnapshot snapshot) async {
      setState(() {
        try {
          widget.initial.inventory_manga = snapshot.get('$day');
        }catch(e){
          widget.initial.inventory_manga=0;
        }
      });
    });

    final DocumentReference total = firestore.collection(
        "total_pending").doc('$year-$month');

    await total.get().then<dynamic>((DocumentSnapshot snapshot) async {
      setState(() {
        try {
          widget.initial.total_pending = snapshot.get('$day');
        }catch(e){
          widget.initial.total_pending=0;
        }
      });
    });
    setState(() {
      var x=widget.initial.this_month_islu;
      var y=widget.initial.this_month_manga;
      dataMap.update("In hand", (dynamic) => x.toDouble());
      dataMap.update("Processed", (dynamic) => 2500000);
      dataMap1.update("In hand", (dynamic) => y.toDouble());
      dataMap1.update("Processed", (dynamic) => 4200000);
      barGroup1 = makeGroupData(0, widget.initial.week_islu[0].toDouble()/10000, widget.initial.week_manga[0].toDouble()/10000);
      barGroup2 = makeGroupData(1, widget.initial.week_islu[1].toDouble()/10000, widget.initial.week_manga[1].toDouble()/10000);
      barGroup3 = makeGroupData(2, widget.initial.week_islu[2].toDouble()/10000, widget.initial.week_manga[2].toDouble()/10000);
      barGroup4 = makeGroupData(3, widget.initial.week_islu[3].toDouble()/10000, widget.initial.week_manga[3].toDouble()/10000);
      barGroup5 = makeGroupData(4, widget.initial.week_islu[4].toDouble()/10000, widget.initial.week_manga[4].toDouble()/10000);
      barGroup6 = makeGroupData(5, widget.initial.week_islu[5].toDouble()/10000, widget.initial.week_manga[5].toDouble()/10000);
      barGroup7 = makeGroupData(6, widget.initial.week_islu[6].toDouble()/10000, widget.initial.week_manga[6].toDouble()/10000);
      var items = [
        barGroup1,
        barGroup2,
        barGroup3,
        barGroup4,
        barGroup5,
        barGroup6,
        barGroup7,
      ];
      rawBarGroups = items.cast<BarChartGroupData>();
      showingBarGroups = rawBarGroups;
    });
    _state=true;
  }

  var barGroup1;
  var barGroup2;
  var barGroup3;
  var barGroup4;
  var barGroup5;
  var barGroup6;
  var barGroup7;

  void initState() {
    super.initState();
    _selectedDate=DateTime(widget.year,widget.month,widget.day);
    var x=widget.initial.this_month_islu.toDouble();
    var y=widget.initial.this_month_manga.toDouble();
    dataMap.putIfAbsent("In hand", () => x);
    dataMap.putIfAbsent("Processed", () => 2500000);
    dataMap1.putIfAbsent("In hand", () => y);
    dataMap1.putIfAbsent("Processed", () => 4200000);

    barGroup1 = makeGroupData(0, widget.initial.week_islu[0].toDouble()/10000, widget.initial.week_manga[0].toDouble()/10000);
    barGroup2 = makeGroupData(1, widget.initial.week_islu[1].toDouble()/10000, widget.initial.week_manga[1].toDouble()/10000);
    barGroup3 = makeGroupData(2, widget.initial.week_islu[2].toDouble()/10000, widget.initial.week_manga[2].toDouble()/10000);
    barGroup4 = makeGroupData(3, widget.initial.week_islu[3].toDouble()/10000, widget.initial.week_manga[3].toDouble()/10000);
    barGroup5 = makeGroupData(4, widget.initial.week_islu[4].toDouble()/10000, widget.initial.week_manga[4].toDouble()/10000);
    barGroup6 = makeGroupData(5, widget.initial.week_islu[5].toDouble()/10000, widget.initial.week_manga[5].toDouble()/10000);
    barGroup7 = makeGroupData(6, widget.initial.week_islu[6].toDouble()/10000, widget.initial.week_manga[6].toDouble()/10000);

    var items = [
      barGroup1,
      barGroup2,
      barGroup3,
      barGroup4,
      barGroup5,
      barGroup6,
      barGroup7,
    ];
    rawBarGroups = items.cast<BarChartGroupData>();
    showingBarGroups = rawBarGroups;
  }
  String x="3456";
  DateTime _selectedDate;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
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
                  itemTextStyle: TextStyle(color: Colors.white, fontSize: 19),
                  dividerColor: Colors.blue,
                ),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(20),
            child: FlatButton(
              padding: EdgeInsets.only(left: 20,top: 10,bottom: 10,right: 20),
              onPressed: (){
               getData(_selectedDate.year, _selectedDate.month, _selectedDate.day);
              },
              child: Text('Refresh', style: TextStyle(
                  fontSize: 30.0,
                  color: Colors.white
              )
              ),
              shape: RoundedRectangleBorder(side: BorderSide(
                  color: Colors.indigoAccent,
                  width: 1,
                  style: BorderStyle.solid
              ), borderRadius: BorderRadius.circular(15)),
            ),
          ),
          Center(
            child:  setUpButtonChild(),
          ),
          SizedBox(
            height: 20,
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                FlatButton(
                  padding: EdgeInsets.only(left: 20,top: 10,bottom: 10,right: 20),
                  onPressed: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Manga(initial: widget.initial),
                      ),
                    );
                  },
                  child: Text('Manga', style: TextStyle(
                      fontSize: 30.0,
                      color: Colors.orange
                  )
                  ),
                  shape: RoundedRectangleBorder(side: BorderSide(
                      color: Colors.deepOrangeAccent,
                      width: 1,
                      style: BorderStyle.solid
                  ), borderRadius: BorderRadius.circular(30)),
                ),
                FlatButton(
                  padding: EdgeInsets.only(left: 20,top: 10,bottom: 10,right: 20),
                  onPressed: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Islamabad(initial: widget.initial),
                      ),
                    );
                  },
                  child: Text('Islamabad', style: TextStyle(
                      fontSize: 30.0,
                      color: Colors.green
                  )
                  ),
                  shape: RoundedRectangleBorder(side: BorderSide(
                      color: Colors.lightGreen,
                      width: 1,
                      style: BorderStyle.solid
                  ), borderRadius: BorderRadius.circular(30)),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: 20,
              ),
              Container(
                child: Center(
                  child: Container(
                    padding: EdgeInsets.all(10),
                    child: Text(
                      "Inventory",
                      style: TextStyle(
                          fontSize: 20,
                          color: kActiveCardColour
                      ),
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.0),
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Row(
                children: <Widget>[
                  Container(
                    child: Expanded(
                      child: ReusableCard(
                        colour: kActiveCardColour,
                        cardChild: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.only(top: 20),
                              child: Text("Manga",
                                  style: kBodyTextStyle),
                            ),

                            Container(
                              padding: EdgeInsets.only(bottom: 20),
                              child: Text(
                                  widget.initial.inventory_manga.toInt().toString(),
                                  style: TextStyle(
                                    color: Colors.orange,
                                    fontSize: 30.0,
                                    fontWeight: FontWeight.w900,
                                  )),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: 3,
                    height: 100,
                    color: Colors.white,
                  ),
                  Container(
                    child: Expanded(
                      child: ReusableCard(
                        colour: kActiveCardColour,
                        cardChild: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.only(top: 20),
                              child: Text("Islamabad",
                                  style: kBodyTextStyle),
                            ),

                            Container(
                              padding: EdgeInsets.only(bottom: 20),
                              child: Text(
                                  widget.initial.inventory_islu.toInt().toString(),
                                  style: TextStyle(
                                    color: Colors.green,
                                    fontSize: 30.0,
                                    fontWeight: FontWeight.w900,
                                  )),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          Expanded(
            child: ReusableCard(
            colour: kActiveCardColour,
            cardChild: Center(
              child: Text(
                  'Total Pending',
                  style: TextStyle(
                    fontSize: 30,
                    color: Color(0xFF8D8E98),
                  )
                ),
            )
          ),
          ),
          Container(
            padding: EdgeInsets.all(30),
            //margin: EdgeInsets.only(left: 40),
            child: Center(
              child: Text(
              widget.initial.total_pending.toString(),
              style: kNumberTextStyle,
              )
            ),
            decoration: BoxDecoration(
                color: kActiveCardColour,
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.deepPurple, //                   <--- border color
                  width: 10.0,
                ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: 20,
              ),
              Container(
                child: Center(
                  child: Container(
                    padding: EdgeInsets.all(10),
                    child: Text(
                      "Printing",
                      style: TextStyle(
                          fontSize: 20,
                          color: kActiveCardColour
                      ),
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.0),
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Row(
                children: <Widget>[
                  Container(
                    child: Expanded(
                      child: ReusableCard(
                        colour: kActiveCardColour,
                        cardChild: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.only(top: 20),
                              child: Text("Manga",
                                  style: kBodyTextStyle),
                            ),

                            Container(
                              padding: EdgeInsets.only(bottom: 20),
                              child: Text(
                                  widget.initial.printing_manga.toString(),
                                  style: TextStyle(
                                    color: Colors.orange,
                                    fontSize: 30.0,
                                    fontWeight: FontWeight.w900,
                                  )),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: 3,
                    height: 100,
                    color: Colors.white,
                  ),
                  Container(
                    child: Expanded(
                      child: ReusableCard(
                        colour: kActiveCardColour,
                        cardChild: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.only(top: 20),
                              child: Text("Islamabad",
                                  style: kBodyTextStyle),
                            ),

                            Container(
                              padding: EdgeInsets.only(bottom: 20),
                              child: Text(
                                  widget.initial.printing_islu.toString(),
                                  style: TextStyle(
                                    color: Colors.green,
                                    fontSize: 30.0,
                                    fontWeight: FontWeight.w900,
                                  )),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: 30
              ),
              Container(
                  child: Center(
                    child: Container(
                      padding: EdgeInsets.all(10),
                      child: Text(
                        "Monthly Performance",
                        style: TextStyle(
                          fontSize: 20,
                          color: kActiveCardColour
                        ),
                      ),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.0),
                        color: Colors.white,
                    ),
                  ),
                 ),
              ),
              SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Container(
                    child: pi.PieChart(
                      dataMap: dataMap,
                      //animationDuration: Duration(milliseconds: 800),
                      chartLegendSpacing: 32.0,
                      chartRadius: MediaQuery.of(context).size.width / 2.7,
                      showChartValuesInPercentage: true,
                      showChartValues: true,
                      showChartValuesOutside: true,
                      chartValueBackgroundColor: Colors.grey[200],
                      colorList: colorList,
                      showLegends: false,
                      legendPosition: pi.LegendPosition.bottom,
                      decimalPlaces: 1,
                      showChartValueLabel: true,
                      initialAngle: 0,
                      chartValueStyle: pi.defaultChartValueStyle.copyWith(
                        color: Colors.blueGrey[900].withOpacity(0.9),
                      ),
                      chartType: pi.ChartType.disc,
                    ),
                  ),
                  Container(
                    width: 3,
                    height: 200,
                    color: Colors.white,
                  ),
                  Container(
                    child: pi.PieChart(
                      dataMap: dataMap1,
                      //animationDuration: Duration(milliseconds: 800),
                      chartLegendSpacing: 32.0,
                      chartRadius: MediaQuery.of(context).size.width / 2.7,
                      showChartValuesInPercentage: true,
                      showChartValues: true,
                      showChartValuesOutside: true,
                      chartValueBackgroundColor: Colors.grey[200],
                      colorList: colorList1,
                      showLegends: false,
                      legendPosition: pi.LegendPosition.bottom,
                      decimalPlaces: 1,
                      showChartValueLabel: true,
                      initialAngle: 0,
                      chartValueStyle: pi.defaultChartValueStyle.copyWith(
                        color: Colors.blueGrey[900].withOpacity(0.9),
                      ),
                      chartType: pi.ChartType.disc,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: 20,
              ),
              Container(
                child: Center(
                  child: Container(
                    padding: EdgeInsets.all(10),
                    child: Text(
                      "Previous Month",
                      style: TextStyle(
                          fontSize: 20,
                          color: kActiveCardColour
                      ),
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.0),
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Row(
                children: <Widget>[
                  Container(
                    child: Expanded(
                      child: ReusableCard(
                        colour: kActiveCardColour,
                        cardChild: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.only(top: 20),
                              child: Text("Manga",
                                  style: kBodyTextStyle),
                            ),
                            Container(
                              padding: EdgeInsets.only(bottom: 20),
                              child: Text(
                                  widget.initial.prev_month_manga.toInt().toString(),
                                  style: TextStyle(
                                    color: Colors.orange,
                                    fontSize: 30.0,
                                    fontWeight: FontWeight.w900,
                                  )),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: 3,
                    height: 100,
                    color: Colors.white,
                  ),
                  Container(
                    child: Expanded(
                      child: ReusableCard(
                        colour: kActiveCardColour,
                        cardChild: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.only(top: 20),
                              child: Text("Islamabad",
                                  style: kBodyTextStyle),
                            ),
                            Container(
                              padding: EdgeInsets.only(bottom: 20),
                              child: Text(
                                  widget.initial.prev_month_islu.toInt().toString(),
                                  style: TextStyle(
                                    color: Colors.green,
                                    fontSize: 30.0,
                                    fontWeight: FontWeight.w900,
                                  )),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          AspectRatio(
          aspectRatio: 1,
            child:  Card(
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
              color: kActiveCardColour,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,

                  mainAxisAlignment: MainAxisAlignment.start,

                  mainAxisSize: MainAxisSize.max,

                  children: <Widget>[

                    Row(

                      crossAxisAlignment: CrossAxisAlignment.center,

                      mainAxisSize: MainAxisSize.min,

                      mainAxisAlignment: MainAxisAlignment.start,

                      children: <Widget>[

                        makeTransactionsIcon(),

                        const SizedBox(

                          width: 38,

                        ),

                        const Text(

                          'This Week',

                          style: TextStyle(color: Colors.white, fontSize: 22),

                        ),

                        const SizedBox(

                          width: 4,

                        ),

                        const Text(

                          'state',

                          style: TextStyle(color: Color(0xff77839a), fontSize: 16),

                        ),

                      ],

                    ),

                    const SizedBox(

                      height: 38,

                    ),

                    Expanded(
                      child: Padding(

                        padding: const EdgeInsets.symmetric(horizontal: 8.0),

                        child: BarChart(

                          BarChartData(

                            maxY: 30,

                            barTouchData: BarTouchData(

                                touchTooltipData: BarTouchTooltipData(

                                  tooltipBgColor: Colors.grey,

                                  getTooltipItem: (_a, _b, _c, _d) => null,

                                ),

                                touchCallback: (response) {

                                  if (response.spot == null) {

                                    setState(() {

                                      touchedGroupIndex = -1;

                                      showingBarGroups = List.of(rawBarGroups);

                                    });

                                    return;

                                  }



                                  touchedGroupIndex = response.spot.touchedBarGroupIndex;

                                  setState(() {

                                    if (response.touchInput is FlLongPressEnd ||

                                        response.touchInput is FlPanEnd) {

                                      touchedGroupIndex = -1;

                                      showingBarGroups = List.of(rawBarGroups);

                                    } else {

                                      showingBarGroups = List.of(rawBarGroups);

                                      if (touchedGroupIndex != -1) {

                                        double sum = 0;

                                        for (BarChartRodData rod

                                        in showingBarGroups[touchedGroupIndex].barRods) {

                                          sum += rod.y;

                                        }

                                        final avg =

                                            sum / showingBarGroups[touchedGroupIndex].barRods.length;



                                        showingBarGroups[touchedGroupIndex] =

                                            showingBarGroups[touchedGroupIndex].copyWith(

                                              barRods: showingBarGroups[touchedGroupIndex].barRods.map((rod) {

                                                return rod.copyWith(y: avg);

                                              }).toList(),

                                            );

                                      }

                                    }

                                  });

                                }),

                            titlesData: FlTitlesData(

                              show: true,

                              bottomTitles: SideTitles(

                                showTitles: true,

                                textStyle: TextStyle(

                                    color: const Color(0xff7589a2),

                                    fontWeight: FontWeight.bold,

                                    fontSize: 14),

                                margin: 20,

                                getTitles: (double value) {

                                  switch (value.toInt()) {

                                    case 0:

                                      return '1';

                                    case 1:

                                      return '2';

                                    case 2:

                                      return '3';

                                    case 3:

                                      return '4';

                                    case 4:

                                      return '5';

                                    case 5:

                                      return '6';

                                    case 6:

                                      return '7';

                                    default:

                                      return '';

                                  }

                                },

                              ),

                              leftTitles: SideTitles(

                                showTitles: true,

                                textStyle: TextStyle(

                                    color: const Color(0xff7589a2),

                                    fontWeight: FontWeight.bold,

                                    fontSize: 14),

                                margin: 32,

                                reservedSize: 14,

                                getTitles: (value) {

                                  if (value == 0) {

                                    return '0';

                                  } else if (value == 10) {

                                    return '100K';

                                  } else if (value == 19) {

                                    return '200K';

                                  }
                                  else if (value == 29) {

                                    return '300K';

                                  }else {

                                    return '';

                                  }

                                },

                              ),

                            ),

                            borderData: FlBorderData(

                              show: false,

                            ),
                            barGroups: showingBarGroups,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                  ],
                ),
              ),
            ),
          ),
           ]
          )
    );

  }


}
