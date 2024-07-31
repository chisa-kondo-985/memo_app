import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/material.dart';
import 'package:memo_app/my_app.dart';

void main() async {
  await dotenv.load(fileName: '.env');
  runApp(const MyApp());
}
