import 'package:flutter/material.dart';

import '../wrapperClasses/dateTimeWrapper.dart';

class DateTimePicker extends StatefulWidget {
  const DateTimePicker({super.key, required this.dateTime});

  final DateTimeWrapper dateTime;

  @override
  State<DateTimePicker> createState() => _DateTimePickerState();
}

class _DateTimePickerState extends State<DateTimePicker> {
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
      child: Text(
          "${widget.dateTime.dateValue.year}/${widget.dateTime.dateValue.month}/${widget.dateTime.dateValue.day} ${widget.dateTime.timeValue.hour}:${widget.dateTime.timeValue.minute}"),
    );
  }
}