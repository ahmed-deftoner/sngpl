import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:sngpl/Components/card.dart';
import 'package:sngpl/Components/data.dart';


const color_back = Color(0xff894b00);
const color_card = Color(0xFF623600);

const color_label = Color(0xffef6c00);
const color_number = Color(0xffffea00);

class Manga extends StatefulWidget {
  Data initial=Data();
  Manga({@required this.initial});

  @override
  _MangaState createState() => _MangaState();
}

class _MangaState extends State<Manga> {


  List<Color> gradientColors = [
    const Color(0xffef6c00),
    const Color(0xffffea00),
  ];

  bool showAvg = false;
  var efficiency;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    efficiency=(widget.initial.printing_manga/400000)*100;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: color_back,
        appBar: AppBar(
          title: Padding(
            padding: EdgeInsets.only(left: 60),
              child: Text('Manga')),
          backgroundColor: color_card,
        ),
        body: ListWheelScrollView(
            itemExtent: 200,
            physics: FixedExtentScrollPhysics(),
            diameterRatio: 1.5,
            squeeze: 1,
            children: <Widget>[
              
              Expanded(
                child: Stack(
                  children: <Widget>[
                    AspectRatio(
                      aspectRatio: 1.70,
                      child: Container(
                        decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(
                              Radius.circular(18),
                            ),
                            color: Color(0xff271600)),
                        child: Padding(
                          padding: const EdgeInsets.only(right: 18.0, left: 12.0, top: 24, bottom: 12),
                          child: LineChart(
                            showAvg ? avgData() : mainData(),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 60,
                      height: 34,
                      child: FlatButton(
                        onPressed: () {
                          setState(() {
                            showAvg = !showAvg;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
              ReusableCard(
                colour: color_card,
                cardChild: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: color_card,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: color_back, //                   <--- border color
                          width: 10.0,
                        ),
                      ),
                      //margin: EdgeInsets.only(left: 40),
                      child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                efficiency.toInt().toString()+'%',
                                style: TextStyle(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                              Text(
                                "Efficiency",
                                style: TextStyle(
                                  fontSize: 15.0,
                                ),
                              ),
                            ],
                          )
                      ),
                    ),
                    Container(
                      width: 3,
                      height: 200,
                      color: Colors.white,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          child: Text(
                            "Today",
                            style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                                color: color_label
                            ),
                          ),
                        ),
                        Container(
                          child: Text(
                            widget.initial.printing_manga.toInt().toString(),
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w900,
                                color: color_number
                            ),
                          ),
                        ),
                        Container(
                          child: Text(
                            "This week",
                            style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                                color: color_label
                            ),
                          ),
                        ),
                        Container(
                          child: Text(
                            widget.initial.week_sum_manga.toInt().toString(),
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w900,
                                color: color_number
                            ),
                          ),
                        ),
                        Container(
                          child: Text(
                            "This month",
                            style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                                color: color_label
                            ),
                          ),
                        ),
                        Container(
                          child: Text(
                            widget.initial.this_month_manga.toInt().toString(),
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w900,
                                color: color_number
                            ),
                          ),
                        )
                      ],
                    ),

                  ],
                ),
              ),
            ]
        )
    );
  }

  LineChartData mainData() {

    return LineChartData(

      gridData: FlGridData(

        show: true,

        drawVerticalLine: true,

        getDrawingHorizontalLine: (value) {

          return FlLine(

            color: const Color(0xff37434d),

            strokeWidth: 1,

          );

        },

        getDrawingVerticalLine: (value) {

          return FlLine(

            color: const Color(0xff37434d),

            strokeWidth: 1,

          );

        },

      ),

      titlesData: FlTitlesData(

        show: true,

        bottomTitles: SideTitles(

          showTitles: true,

          reservedSize: 22,

          textStyle:

          const TextStyle(color: Color(0xff68737d), fontWeight: FontWeight.bold, fontSize: 16),

          getTitles: (value) {

            switch (value.toInt()) {
              case 0:

                return '1';

              case 2:

                return '2';

              case 4:

                return '3';
              case 6:

                return '4';
              case 8:

                return '5';
              case 10:

                return '6';
              case 12:

                return '7';

            }

            return '';

          },

          margin: 8,

        ),

        leftTitles: SideTitles(

          showTitles: true,

          textStyle: const TextStyle(

            color: Color(0xff67727d),

            fontWeight: FontWeight.bold,

            fontSize: 15,

          ),

          getTitles: (value) {

            switch (value.toInt()) {

              case 2:

                return '10k';

              case 4:

                return '20k';

              case 6:

                return '30k';
              case 8:

                return '40k';

            }

            return '';

          },

          reservedSize: 28,

          margin: 12,

        ),

      ),

      borderData:

      FlBorderData(show: true, border: Border.all(color: const Color(0xff37434d), width: 1)),

      minX: 0,

      maxX: 12,

      minY: 0,

      maxY: 8,

      lineBarsData: [

        LineChartBarData(

          spots: [

            FlSpot(0, widget.initial.week_manga[0]/53500.toDouble()),

            FlSpot(2, widget.initial.week_manga[1]/53500.toDouble()),

            FlSpot(4, widget.initial.week_manga[2]/53500.toDouble()),

            FlSpot(6, widget.initial.week_manga[3]/53500.toDouble()),

            FlSpot(8, widget.initial.week_manga[4]/53500.toDouble()),

            FlSpot(10, widget.initial.week_manga[5]/53500.toDouble()),

            FlSpot(12, widget.initial.week_manga[6]/53500.toDouble()),

          ],

          isCurved: true,

          colors: gradientColors,

          barWidth: 5,

          isStrokeCapRound: true,

          dotData: FlDotData(

            show: true,

          ),

          belowBarData: BarAreaData(

            show: true,

            colors: gradientColors.map((color) => color.withOpacity(0.3)).toList(),

          ),

        ),

      ],

    );

  }

  LineChartData avgData() {

    return LineChartData(

      lineTouchData: LineTouchData(enabled: false),

      gridData: FlGridData(

        show: true,

        drawHorizontalLine: true,

        getDrawingVerticalLine: (value) {

          return FlLine(

            color: const Color(0xff37434d),

            strokeWidth: 1,

          );

        },

        getDrawingHorizontalLine: (value) {

          return FlLine(

            color: const Color(0xff37434d),

            strokeWidth: 1,

          );

        },

      ),

      titlesData: FlTitlesData(

        show: true,

        bottomTitles: SideTitles(

          showTitles: true,

          reservedSize: 22,

          textStyle:

          const TextStyle(color: Color(0xff68737d), fontWeight: FontWeight.bold, fontSize: 16),

          getTitles: (value) {

            switch (value.toInt()) {

              case 2:

                return 'MAR';

              case 5:

                return 'JUN';

              case 8:

                return 'SEP';

            }

            return '';

          },

          margin: 8,

        ),

        leftTitles: SideTitles(

          showTitles: true,

          textStyle: const TextStyle(

            color: Color(0xff67727d),

            fontWeight: FontWeight.bold,

            fontSize: 15,

          ),

          getTitles: (value) {

            switch (value.toInt()) {

              case 1:

                return '10k';

              case 3:

                return '30k';

              case 5:

                return '50k';

            }

            return '';

          },

          reservedSize: 28,

          margin: 12,

        ),

      ),

      borderData:

      FlBorderData(show: true, border: Border.all(color: const Color(0xff37434d), width: 1)),

      minX: 0,

      maxX: 11,

      minY: 0,

      maxY: 6,

      lineBarsData: [

        LineChartBarData(

          spots: [

            FlSpot(widget.initial.week_manga[0]/10000, 3.44),

            FlSpot(widget.initial.week_manga[1]/10000, 3.44),

            FlSpot(widget.initial.week_manga[2]/10000, 3.44),

            FlSpot(widget.initial.week_manga[3]/10000, 3.44),

            FlSpot(widget.initial.week_manga[4]/10000, 3.44),

            FlSpot(widget.initial.week_manga[5]/10000, 3.44),

            FlSpot(widget.initial.week_manga[6]/10000, 3.44),

          ],

          isCurved: true,

          colors: [

            ColorTween(begin: gradientColors[0], end: gradientColors[1]).lerp(0.2),

            ColorTween(begin: gradientColors[0], end: gradientColors[1]).lerp(0.2),

          ],

          barWidth: 5,

          isStrokeCapRound: true,

          dotData: FlDotData(

            show: false,

          ),

          belowBarData: BarAreaData(show: true, colors: [

            ColorTween(begin: gradientColors[0], end: gradientColors[1]).lerp(0.2).withOpacity(0.1),

            ColorTween(begin: gradientColors[0], end: gradientColors[1]).lerp(0.2).withOpacity(0.1),

          ]),

        ),

      ],
    );
  }

}
