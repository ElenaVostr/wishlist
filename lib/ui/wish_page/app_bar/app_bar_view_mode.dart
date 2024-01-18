import 'package:flutter/material.dart';

class AppBarViewMode extends AppBar {
  AppBarViewMode({super.key}):super(
    title: const Text("Просмотр желания"),
    actions: [
      IconButton(
        icon: const Icon(Icons.edit),
        onPressed: () => null,
      ),
      IconButton(
        icon: const Icon(Icons.delete),
        onPressed: () => null,
      ),
    ],
  );
}