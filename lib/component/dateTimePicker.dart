import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../wrapperClasses/dateTimeWrapper.dart';

class DateTimePicker extends StatefulWidget {
  const DateTimePicker({super.key, required this.dateTime});

  final DateTimeWrapper dateTime;

  @override
  State<DateTimePicker> createState() => _DateTimePickerState();
}

class _DateTimePickerState extends State<DateTimePicker> {
  late DateTime newDateTime;
  final DateFormat formatter = DateFormat("MM-dd-yyyy H:m");

  @override
  void initState() {
    newDateTime = DateTime(
        widget.dateTime.dateValue.year,
        widget.dateTime.dateValue.month,
        widget.dateTime.dateValue.day,
        widget.dateTime.timeValue.hour,
        widget.dateTime.timeValue.minute);
    // TODO: implement initState
    super.initState();
  }

  Future pickDateTime() async {
    DateTime? date = await pickDate();
    if (date == null) {
      return;
    }

    TimeOfDay? time = await pickTime();
    if (time == null) {
      return;
    }

    setState(() {
      widget.dateTime.dateValue = date;
      widget.dateTime.timeValue = time;
      newDateTime = DateTime(
          widget.dateTime.dateValue.year,
          widget.dateTime.dateValue.month,
          widget.dateTime.dateValue.day,
          widget.dateTime.timeValue.hour,
          widget.dateTime.timeValue.minute);
    });
  }

  Future<DateTime?> pickDate() => showDatePicker(
        context: context,
        initialDate: widget.dateTime.dateValue,
        firstDate: DateTime(2010),
        lastDate: DateTime(2100),
      );

  Future<TimeOfDay?> pickTime() => showTimePicker(
        context: context,
        initialTime: widget.dateTime.timeValue,
      );
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: pickDateTime,
      child:
          //Text(
          //    "${widget.dateTime.dateValue.month}/${widget.dateTime.dateValue.day}/${widget.dateTime.dateValue.year} ${widget.dateTime.timeValue.hour}:${widget.dateTime.timeValue.minute}"),
          Text(formatter.format(newDateTime)),
    );
  }
}
