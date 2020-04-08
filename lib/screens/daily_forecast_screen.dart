import 'package:flutter/material.dart';
import '../models/weather.dart' as w;
import 'package:provider/provider.dart';
import '../providers/weather_provider.dart';
import 'package:intl/intl.dart';

class DailyForecastScreen extends StatelessWidget {
  static const routeName = '/daily-forecast';
  @override
  Widget build(BuildContext context) {
    final List<w.Weather> forecastData =
        Provider.of<WeatherProvider>(context).forecasts;
    return Scaffold(
      appBar: AppBar(
        title: Text('7-Days Forecast'),
      ),
      backgroundColor: Colors.blue[800],
      body: ListView.builder(
        itemBuilder: (ctx, index) => Padding(
          padding: const EdgeInsets.all(8.0),
          child: Card(
            color: Colors.blue[600],
            elevation: 5,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: ListTile(
              leading: Image.network(
                'http://openweathermap.org/img/w/${forecastData[index].weatherIcon}.png',
                fit: BoxFit.cover,
              ),
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    DateFormat.EEEE()
                        .format(DateTime.now().add(Duration(days: index))),
                    style: TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 22,
                        color: Colors.white),
                  ),
                  Text(
                    'Wind Speed ${forecastData[index].windSpeed.toStringAsFixed(1)}km/h',
                    style: TextStyle(fontSize:15, color: Colors.white),
                  )
                ],
              ),
              subtitle: Text(
                forecastData[index].description,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              trailing: Text(
                '${forecastData[index].maxTemp.toStringAsFixed(0)}⁰/${forecastData[index].minTemp.toStringAsFixed(0)}⁰',
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.normal,
                    color: Colors.white),
              ),
              isThreeLine: true,
            ),
          ),
        ),
        itemCount: forecastData.length,
      ),
    );
  }
}
