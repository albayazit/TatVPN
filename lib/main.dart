import 'package:flutter/material.dart';
import 'package:tatvpn/screens/home.dart';
import 'utils/colors.dart';

void main() async {
  runApp(
    MaterialApp(
      title: 'TatVPN',
      theme: ThemeData(
        colorScheme: const ColorScheme.dark(),
        scaffoldBackgroundColor: mainDark,
        appBarTheme: const AppBarTheme(
          iconTheme: IconThemeData(color: white)
        )
      ),
      home: const Home(),
    ),
  );
}