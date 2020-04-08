import 'package:flutter/material.dart';
import 'package:weather1/providers/weather_provider.dart';
import '../models/weather.dart' as w;
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../screens/daily_forecast_screen.dart';

class ForecastCard extends StatelessWidget {
  final AppBar appbar;
  ForecastCard(this.appbar);
  Widget builderContainer(Widget child, AppBar appbar, BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          color: Colors.blue[800],
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15), topRight: Radius.circular(15)),
        ),
        // margin: EdgeInsets.all(10),
        padding: EdgeInsets.all(5),
        height: (MediaQuery.of(context).size.height -
                MediaQuery.of(context).padding.top -
                appbar.preferredSize.height) *
            0.45,
        width: MediaQuery.of(context).size.width * 1,
        child: child);
  }

  @override
  Widget build(BuildContext context) {
    final List<w.Weather> forecastData =
        Provider.of<WeatherProvider>(context).forecastList;
    return Column(
      children: <Widget>[
        builderContainer(
            forecastData.length <= 0
                ? Text(
                    'Data Unavailable',textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white, fontSize: 25),
                  )
                : ListView.builder(
                    itemBuilder: (ctx, index) => ListTile(
                      leading: CircleAvatar(
                          child: Image.network(
                        'http://openweathermap.org/img/w/${forecastData[index].weatherIcon}.png',
                        fit: BoxFit.cover,
                      )),
                      title: Text(
                        DateFormat.EEEE()
                            .format(DateTime.now().add(Duration(days: index))),
                        style: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 22,
                            color: Colors.white),
                      ),
                      subtitle: Text(
                        forecastData[index].description,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      trailing: Text(
                        '${forecastData[index].maxTemp.toStringAsFixed(0)}⁰/${forecastData[index].minTemp.toStringAsFixed(0)}⁰',
                        style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.normal,
                            color: Colors.white),
                      ),
                    ),
                    itemCount: forecastData.length - 4,
                  ),
            appbar,
            context),
        InkWell(
          onTap: () {
            if (forecastData.length > 0) {
              Navigator.of(context).pushNamed(DailyForecastScreen.routeName);
            }
          },
          child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.blue[800],
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(15),
                    bottomRight: Radius.circular(15)),
              ),
              // margin: EdgeInsets.all(10),
              padding: EdgeInsets.all(5),
              child: Text(
                '7-day Forecast',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.normal),
              ),
              width: MediaQuery.of(context).size.width * 1),
        ),
        SizedBox(
          height: 5,
        ),
      ],
    );
  }
}
