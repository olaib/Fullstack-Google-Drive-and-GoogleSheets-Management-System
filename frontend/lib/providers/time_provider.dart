import 'dart:async';

import 'package:flutter/material.dart';

class TimeProvider extends ChangeNotifier {
  String _time = DateTime.now().toString();
  Timer? _timer;

  TimeProvider() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      updateTime();
    });
  }
  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String get time => _time;

  void updateTime() {
    _time = DateTime.now().toString();
    notifyListeners();
  }
}
