import 'package:flutter/material.dart';
import 'dart:io';
import 'package:provider/provider.dart';
import 'package:weather/weather.dart';
import '../providers/weather_provider.dart';
import './weather_detail_screen.dart';

class SelectLocationScreen extends StatefulWidget {
  static const routeName = '/select-location';
  @override
  _SelectLocationScreenState createState() => _SelectLocationScreenState();
}

class _SelectLocationScreenState extends State<SelectLocationScreen> {
  final _locationController = TextEditingController();
  String cityName;
  var _isLoading = false;

  Widget cityWidgetBuilder(String city) {
    return FlatButton(
      onPressed: () async {
        cityName = city;
        setState(() {
          _isLoading = true;
        });
        try {
          await Provider.of<WeatherProvider>(context, listen: false)
              .getCurrentWeather(cityName);
        } on LocationPermissionException catch (_) {
          await showDialog(
              context: context,
              builder: (ctx) =>
                  _showDailog('Location Permission is not granted!', ctx));
        } catch (error) {
          await showDialog(
              context: context,
              builder: (ctx) => _showDailog(error.toString(), ctx));
        }
        setState(() {
          _isLoading = false;
        });
        Navigator.of(context).pushReplacementNamed(
          WeatherDetailScreen.routeName,
        );
      },
      child: Text(
        city,
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.white),
      ),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      color: Colors.blueGrey,
      colorBrightness: Brightness.light,
    );
  }

  Widget _showDailog(String error, BuildContext ctx) {
    return AlertDialog(
      title: Text("An Error Occured!"),
      content: Text(error),
      actions: <Widget>[
        FlatButton(
          child: Text("Okay"),
          onPressed: () {
            Navigator.of(ctx).pop();
          },
        ),
      ],
    );
  }

  // @override
  // void dispose() {
  //   _locationController.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Weather'),
        backgroundColor: Colors.blue[800],
      ),
      backgroundColor: Colors.blue[800],
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(
                semanticsLabel: 'Getting Weather Information',
              ),
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Container(
                      height: 50,
                      padding: EdgeInsets.only(left: 10, top: 10),
                      width: MediaQuery.of(context).size.width * 0.75,
                      child: TextField(
                        controller: _locationController,
                        textAlign: TextAlign.left,
                        onSubmitted: (city) async {
                          cityName = _locationController.text;
                          setState(() {
                            _isLoading = true;
                          });
                          try {
                            await Provider.of<WeatherProvider>(context,
                                    listen: false)
                                .getCurrentWeather(cityName);
                          } on LocationPermissionException catch (_) {
                            await showDialog(
                                context: context,
                                builder: (ctx) => _showDailog(
                                    'Location Permission is not granted!',
                                    ctx));
                          } catch (error) {
                            await showDialog(
                                context: context,
                                builder: (ctx) =>
                                    _showDailog(error.toString(), ctx));
                          }
                          setState(() {
                            _isLoading = false;
                          });
                          Navigator.of(context).pushReplacementNamed(
                            WeatherDetailScreen.routeName,
                          );
                        },
                        decoration: InputDecoration(
                          labelText: 'Enter Location',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20)),
                          prefixIcon: Icon(Icons.search),
                        ),
                      ),
                    ),
                    FlatButton(
                        onPressed: () {
                          exit(0);
                        },
                        materialTapTargetSize: MaterialTapTargetSize.padded,
                        child: Text(
                          'Cancel',
                          softWrap: true,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        )),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: Text('Popular Cities'),
                ),
                Divider(),
                SizedBox(
                  height: 10,
                ),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      FlatButton.icon(
                        onPressed: () async {
                          setState(() {
                            _isLoading = true;
                          });
                          try {
                            await Provider.of<WeatherProvider>(context,
                                    listen: false)
                                .getCurrentLocationWeather();
                          } on LocationPermissionException catch (_) {
                            await showDialog(
                                context: context,
                                builder: (ctx) => _showDailog(
                                    'Location Permission is not granted!',
                                    ctx));
                          } on SocketException {
                            await showDialog(
                                context: context,
                                builder: (ctx) => _showDailog(
                                    'Something went wrong.Please TryAgain!',
                                    ctx));
                          } catch (error) {
                            await showDialog(
                                context: context,
                                builder: (ctx) => _showDailog(
                                    'Something went wrong.Please TryAgain!',
                                    ctx));
                          }
                          setState(() {
                            _isLoading = false;
                          });
                          Navigator.of(context).pushReplacementNamed(
                            WeatherDetailScreen.routeName,
                          );
                        },
                        icon: Icon(Icons.location_on),
                        label: Text(
                          'Locate',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white),
                        ),
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        color: Colors.blueGrey,
                        colorBrightness: Brightness.light,
                      ),
                      cityWidgetBuilder('Jaipur'),
                      cityWidgetBuilder('Mumbai'),
                    ]),
                SizedBox(
                  height: 10,
                ),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      cityWidgetBuilder('London'),
                      cityWidgetBuilder('Vellore'),
                      cityWidgetBuilder('Chennai'),
                    ]),
                SizedBox(
                  height: 10,
                ),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      cityWidgetBuilder('Bhopal'),
                      cityWidgetBuilder('Rome'),
                      cityWidgetBuilder('Chicago'),
                    ]),
              ],
            ),
    );
  }
}
