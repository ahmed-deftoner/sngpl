import 'dart:ffi';

class Data{
  var printing_manga;
  var printing_islu;
  var inventory_manga;
  var inventory_islu;
  var total_pending;
  var this_month_islu;
  var prev_month_islu;
  var this_month_manga;
  var prev_month_manga;
  var boxes;
  List<dynamic> week_islu= new List(7);
  var week_sum_islu;
  List<dynamic> week_manga= new List(7);
  var week_sum_manga;

}