import 'package:flutter/foundation.dart';

class Weather {
  final int id;
  final double temperature;
  final String weatherIcon;
  final double windDegree;
  final double windSpeed;
  final double pressure;
  final double realFeel;
  final String description;
  final String name;
  final double minTemp;
  final double maxTemp;

  Weather(
      {@required this.name,
      @required this.id,
      @required this.temperature,
      @required this.weatherIcon,
      @required this.windDegree,
      @required this.windSpeed,
      @required this.pressure,
      this.realFeel,
      this.maxTemp,
      this.minTemp,
      @required this.description});
}
