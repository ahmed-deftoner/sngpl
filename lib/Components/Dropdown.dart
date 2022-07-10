import 'package:flutter/material.dart';
import 'package:flutter_holo_date_picker/flutter_holo_date_picker.dart';


class WidgetPage extends StatefulWidget {
  @override
  _WidgetPageState createState() => _WidgetPageState();
}

class _WidgetPageState extends State<WidgetPage> {
  DateTime _selectedDate;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Container(
          padding: const EdgeInsets.all( 10),
          child: DatePickerWidget(// default is not looping
            firstDate: DateTime(2019),
            lastDate: DateTime(2025, 1, 1),
            initialDate: DateTime(2020),
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
    );
  }
}