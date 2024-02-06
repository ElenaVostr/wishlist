import 'package:flutter/material.dart';

class PriceTextFormField extends StatelessWidget {
  final TextEditingController? controller;
  final String? hintText;

  const PriceTextFormField(
      {super.key, required this.controller, this.hintText});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.number,
      //inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      decoration: InputDecoration(
        filled: true,
        contentPadding:
        const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
        hintText: hintText,
        fillColor: Colors.black12,
        border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}