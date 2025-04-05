import 'package:logger/logger.dart';

// ignore: non_constant_identifier_names
Logger Log = Logger(
  printer: PrettyPrinter(
    errorMethodCount: 8,
    lineLength: 120,
    colors: true,
    printEmojis: true,
    dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart,
  ),
);
