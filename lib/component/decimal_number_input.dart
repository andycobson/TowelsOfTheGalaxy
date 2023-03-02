import 'package:flutter/material.dart';
import '../../constants/palette.dart';
import 'package:flutter/services.dart';

class DecimalInput extends StatefulWidget {
  const DecimalInput({super.key, required this.controller});

  final TextEditingController controller;

  @override
  State<DecimalInput> createState() => _DecimalInputState();
}

class _DecimalInputState extends State<DecimalInput> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 125,
      height: 50,
      child: TextField(
        style: const TextStyle(color: ColorPalette.backgroundRGB),
        controller: widget.controller,
        enableSuggestions: false,
        autocorrect: false,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        decoration: InputDecoration(
          hintText: '0.0',
          filled: true,
          fillColor: Colors.white,
          hintStyle: const TextStyle(color: ColorPalette.backgroundRGB),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20.0),
            borderSide: const BorderSide(
              color: Color.fromARGB(255, 92, 92, 94),
              width: 2,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20.0),
            borderSide: const BorderSide(
              color: Color.fromARGB(255, 92, 92, 94),
              width: 2,
            ),
          ),
        ),
        inputFormatters: <TextInputFormatter>[
          FilteringTextInputFormatter.allow(RegExp(r'[0-9]+[.]{0,1}[0-9]*')),
        ],
      ),
    );
  }
}
