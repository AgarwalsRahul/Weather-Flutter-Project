import 'package:flutter/material.dart';
import 'package:weather1/screens/select_location.dart';
import 'package:weather1/widgets/detail_card.dart';
import '../providers/weather_provider.dart';
import '../widgets/forecast_card.dart';
import 'package:provider/provider.dart';
import '../models/weather.dart' as w;
import './manage_cities_screen.dart';

class WeatherDetailScreen extends StatelessWidget {
  static const routeName = '/weather-detail';
  @override
  Widget build(BuildContext context) {
    final w.Weather weatheritems =
        Provider.of<WeatherProvider>(context, listen: false).items;
    // final String city = ModalRoute.of(context).settings.arguments;
    final AppBar appBar = AppBar(
      title: Text(
        weatheritems.name,
        textAlign: TextAlign.center,
      ),
      centerTitle: true,
      leading: IconButton(icon: Icon(Icons.dehaze), onPressed: () async {
        Navigator.of(context).pushNamed(ManagedCitiesScreen.routeName);
      }),
      actions: <Widget>[
        IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              Navigator.of(context)
                  .pushReplacementNamed(SelectLocationScreen.routeName);
            }),
      ],
    );
    return Scaffold(
      appBar: appBar,
      body: SingleChildScrollView(
          child: Column(
        children: <Widget>[
          Container(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              '${weatheritems.temperature.toStringAsFixed(0)}',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontWeight: FontWeight.normal,
                                fontSize: 80,
                              ),
                            ),
                            Text(
                              '⁰C',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 40),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: 100,
                        width: 100,
                        child: Image.network(
                          'http://openweathermap.org/img/wn/${weatheritems.weatherIcon}@2x.png',
                          fit: BoxFit.cover,
                        ),
                      )
                    ],
                  ),
                  Text(
                    weatheritems.description == null
                        ? 'Clear'
                        : weatheritems.description,
                    textAlign: TextAlign.left,
                    style: TextStyle(fontSize: 30),
                  ),
                  SizedBox(height: 150),
                  ForecastCard(appBar),
                  SizedBox(
                    height: 10,
                  ),
                  DetailCard(),
                ],
              )),
        ],
      )),
    );
  }
}
