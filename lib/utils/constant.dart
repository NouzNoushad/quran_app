import 'package:flutter/material.dart';

List<String> editions = ['English', 'Malayalam', 'Hindi', 'Tamil'];

print(dynamic msg, dynamic debug) {
  debugPrint(
      '/////////// ------------->>>>>>>>${msg.toString()} ${debug.toString()}');
}
