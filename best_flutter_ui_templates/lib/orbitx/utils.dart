import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:intl/intl.dart';

Future<String> getCurrentTimezone() async {
  final timezone = await FlutterNativeTimezone.getLocalTimezone();

  return timezone;
}

GetCurrentDate() {
  return DateFormat('yyyy-MM-dd').format(DateTime.now());
}
