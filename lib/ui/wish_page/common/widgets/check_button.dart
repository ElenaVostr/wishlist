import 'package:flutter/material.dart';

class CheckButton extends StatelessWidget {
  final bool isCheck;
  final String title;
  final Function()? onTap;

  const CheckButton(
      {super.key, required this.title, this.isCheck = false, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 40,
        decoration: BoxDecoration(
          color: isCheck ? Colors.amberAccent : Colors.black12,
          border: Border.all(
              color: Colors.grey, style: BorderStyle.solid, width: 0.5),
        ),
        child: Center(
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 11),
          ),
        ),
      ),
    );
  }
}