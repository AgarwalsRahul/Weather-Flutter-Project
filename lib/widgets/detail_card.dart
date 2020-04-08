import 'package:flutter/material.dart';
import 'package:weather_icons/weather_icons.dart';
import '../providers/weather_provider.dart';
import '../models/weather.dart' as w;
import 'package:provider/provider.dart';

class DetailCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final w.Weather data = Provider.of<WeatherProvider>(context).items;
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      elevation: 5,
      color: Colors.blue[800],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: const Text(
              'Details',
              textAlign: TextAlign.left,
              style: TextStyle(fontSize:18,color: Colors.white),
            ),
          ),
          Divider(color: Colors.white,thickness: 1,),
          Table(
            border: TableBorder.symmetric(
              inside: BorderSide(color: Colors.white),
            ),
            children: [
              TableRow(
                children: [
                  TableCell(
                    child: ListTile(
                      title: Text('${data.windSpeed.toStringAsFixed(2)}km/h',style: TextStyle(color: Colors.white),),
                      subtitle: Text('Wind Speed'),
                      trailing: Icon(WeatherIcons.strong_wind,size:25,color: Colors.white,),
                    ),
                  ),
                  TableCell(
                    child: ListTile(
                      title: Text('${data.realFeel.toStringAsFixed(0)}⁰C',style: TextStyle(color: Colors.white),),
                      subtitle: Text('Real Feel'),
                      trailing: BoxedIcon(WeatherIcons.thermometer,color: Colors.white),
                    ),
                  ),
                ],
              ),
              TableRow(
                children: [
                  TableCell(
                    child: ListTile(
                      title: Text('${data.pressure.toStringAsFixed(0)}hPa',style: TextStyle(color: Colors.white)),
                      subtitle: Text('Pressure'),
                      trailing: BoxedIcon(WeatherIcons.barometer,color: Colors.white),
                    ),
                  ),
                  TableCell(
                    child: ListTile(
                      title: Text('${data.description}',style: TextStyle(color: Colors.white)),
                      subtitle: Text('Description'),
                      trailing: BoxedIcon(WeatherIcons.day_sunny,color: Colors.white),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
