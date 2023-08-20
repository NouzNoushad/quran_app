import 'package:flutter/material.dart';

List<String> editions = ['English', 'Malayalam', 'Hindi', 'Tamil'];

print(String msg, dynamic debug) {
  debugPrint(
      '/////////// ------------->>>>>>>>${msg.toString()} ${debug.toString()}');
}
