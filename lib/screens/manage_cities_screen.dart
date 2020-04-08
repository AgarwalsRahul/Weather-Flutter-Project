import 'dart:io';
import '../models/weather.dart'as w;
import 'package:flutter/material.dart';
import './select_location.dart';
import 'package:provider/provider.dart';
import '../providers/weather_provider.dart';
import './weather_detail_screen.dart';

class ManagedCitiesScreen extends StatefulWidget {
  static const routeName = '/manage-cities';

  @override
  _ManagedCitiesScreenState createState() => _ManagedCitiesScreenState();
}

class _ManagedCitiesScreenState extends State<ManagedCitiesScreen> {
  var _isLoading = false;
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

  
  @override
  Future<void> didChangeDependencies() async {
    setState(() {
      _isLoading = true;
    });
    try {
      await Provider.of<WeatherProvider>(context,listen: false).fetchAndSetManagedCities();
    
    } on SocketException catch (_) {
      await showDialog(
          context: context,
          builder: (ctx) => _showDailog('Cannot Connect to Network', ctx));
    } on Exception catch(error){
      await showDialog(
          context: context, builder: (ctx) => _showDailog(error.toString(), ctx));
    }
     catch (error) {
      await showDialog(
          context: context, builder: (ctx) => _showDailog(error.toString(), ctx));
    }
    setState(() {
      _isLoading = false;
    });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final data = Provider.of<WeatherProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(title: Text('Manage Cities'), centerTitle: true),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context)
              .pushReplacementNamed(SelectLocationScreen.routeName);
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.amberAccent,
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemBuilder: (ctx, i) => Dismissible(
                    key: ValueKey(data.managedCityWeather[i].name),
                    direction: DismissDirection.endToStart,
                    background: Container(
                      color: Colors.red[200],
                      alignment: Alignment.centerRight,
                      padding: EdgeInsets.only(right: 20),
                      child: Icon(
                        Icons.delete,
                        size: 40,
                        color: Colors.white,
                      ),
                    ),
                    onDismissed: (direction) {
                      data.removeManagedCity(data.managedCityWeather[i].name);
                    },
                    confirmDismiss: (direction) {
                      return showDialog(
                          context: context,
                          builder: (ctx) => AlertDialog(
                                title: Text('Are you sure ?'),
                                content:
                                    Text("Do you want to remove this City ?"),
                                actions: <Widget>[
                                  FlatButton(
                                    child: Text('No'),
                                    onPressed: () {
                                      Navigator.of(ctx).pop(false);
                                    },
                                  ),
                                  FlatButton(
                                      onPressed: () {
                                        Navigator.of(ctx).pop(true);
                                      },
                                      child: Text("Yes"))
                                ],
                              ));
                    },
                    child: Card(
                      child: ListTile(
                        leading: Image.network(
                          'http://openweathermap.org/img/wn/${data.managedCityWeather[i].weatherIcon}@2x.png',
                          fit: BoxFit.cover,
                          height: 100,
                          width: 100,
                        ),
                        onTap: () async {
                          setState(() {
                              _isLoading = true;
                            });
                          try {
                            await data.onTapManagedCities(
                                data.managedCityWeather[i].name,data.managedCityWeather[i]);
                          } catch (error) {
                            await showDialog(
                                context: context,
                                builder: (ctx) => _showDailog(error.toString(), ctx));
                          }
                          setState(() {
                            _isLoading = false;
                          });
                          Navigator.of(context).pushReplacementNamed(
                                WeatherDetailScreen.routeName);
                        },
                        subtitle: Text(
                          data.managedCityWeather[i].description,
                          style: TextStyle(fontSize: 18),
                        ),
                        title: Text(
                          data.managedCityWeather[i].name,
                          style: TextStyle(fontSize: 22),
                        ),
                        trailing: Text(
                          '${data.managedCityWeather[i].temperature.toStringAsFixed(0)}⁰',
                          style: TextStyle(fontSize: 35),
                        ),
                      ),
                    ),
                  ),
              itemCount: data.managedCityWeather.length),
    );
  }
}
