import 'package:flutter/material.dart';

class WidgetWithTitle extends StatelessWidget{

  final String? _title;
  final Widget _child;

  const WidgetWithTitle({super.key, required Widget child, String? title}) : _child = child, _title = title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _title != null ? Text(_title, style: const TextStyle(fontSize: 12, color: Colors.grey)) : const SizedBox(),
          _child
        ],
      ),
    );
  }

}