import 'package:flutter/material.dart';
import 'package:weather1/providers/weather_provider.dart';
import 'package:weather1/screens/daily_forecast_screen.dart';
import 'package:weather1/screens/manage_cities_screen.dart';
import 'package:weather1/screens/select_location.dart';
import 'package:weather1/screens/weather_detail_screen.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: WeatherProvider(),
      child: Consumer<WeatherProvider>(
        builder: (ctx, data, _) => MaterialApp(
          title: 'Weather',
          theme: ThemeData(
            primarySwatch: Colors.blue,
            backgroundColor: Colors.lightBlueAccent,
            accentColor: Colors.amberAccent,
          ),
          color: Colors.lightBlueAccent,
          themeMode: ThemeMode.dark,
          darkTheme: ThemeData.dark(),
          home: data.items!=null
              ? WeatherDetailScreen()
              : FutureBuilder(
                  future: data.manageHomeScreen(),
                  builder: (ctx, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else {
                      if (snapshot.hasError) {
                        return AlertDialog(
                          title: Text("An Error Occured!"),
                          content: Text("Something Went Wrong. Try Again!"),
                          actions: <Widget>[
                            FlatButton(
                              child: Text("Okay"),
                              onPressed: () {
                                Navigator.of(ctx).pushReplacementNamed('/');
                              },
                            ),
                          ],
                        );
                      }else{
                        return SelectLocationScreen();
                      }
                    }
                  },
                ),
          routes: {
            WeatherDetailScreen.routeName: (ctx) => WeatherDetailScreen(),
            DailyForecastScreen.routeName: (ctx) => DailyForecastScreen(),
            SelectLocationScreen.routeName: (ctx) => SelectLocationScreen(),
            ManagedCitiesScreen.routeName: (ctx) => ManagedCitiesScreen(),
          },
        ),
      ),
    );
  }
}
