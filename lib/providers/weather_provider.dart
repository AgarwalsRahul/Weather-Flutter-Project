import 'dart:io';

import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:weather/weather.dart';
import '../models/weather.dart' as w;
import 'package:geocoder/geocoder.dart';
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WeatherProvider with ChangeNotifier {
  w.Weather _item;
  List<w.Weather> forecasts = [];
  List<String> _cities = [];
  List<w.Weather> _managedCityWeather = [];

  List<String> get managedCities {
    return [..._cities];
  }

  w.Weather get items {
    return _item;
  }

  List<w.Weather> get forecastList {
    return [...forecasts];
  }

  List<w.Weather> get managedCityWeather {
    return [..._managedCityWeather];
  }

  Future<void> getCurrentLocationWeather() async {
    final WeatherStation weatherStation = WeatherStation(
      "5f4c114fda0db0af152f8c22201445d6",
    );
    try {
      final Weather weather = await weatherStation.currentWeather();
      final newWeather = w.Weather(
          id: weather.hashCode,
          name: weather.areaName,
          pressure: weather.pressure,
          temperature: weather.temperature.celsius,
          windDegree: weather.windDegree,
          weatherIcon: weather.weatherIcon,
          description: weather.weatherMain,
          windSpeed: weather.windSpeed,
          realFeel: weather.temperature.celsius);
      _item = newWeather;
      if (!_cities.contains(weather.areaName)) {
        _cities.add(weather.areaName);
        _managedCityWeather.add(_item);
      }
      Location location = new Location();
      LocationData locationData = await location.getLocation();
      await getForecast(
        locationData.latitude,
        locationData.longitude,
        weather.areaName,
      );
      await storingData();
    } on OpenWeatherAPIException catch (_) {
      throw OpenWeatherAPIException("Unable to fetch data.Please TryAgain!");
    } on LocationPermissionException catch (_) {
      throw LocationPermissionException('Location Permission not granted!');
    } catch (error) {
      throw error;
    }
    notifyListeners();
  }

  Future<void> getWeather(String city) async {
    final String url =
        'http://api.openweathermap.org/data/2.5/weather?q=$city&appid=5f4c114fda0db0af152f8c22201445d6';
    try {
      final response = await http.get(url);
      final responseData = json.decode(response.body) as Map<String, dynamic>;
      if (responseData == null) {
        return;
      }
      final String icon =
          responseData['weather'].map((item) => item['icon']).toList()[0];
      final newWeather = w.Weather(
        name: responseData['name'],
        temperature: Temperature(responseData['main']['temp']).celsius,
        id: responseData['id'],
        pressure: double.parse((responseData['main']['pressure']).toString()),
        realFeel: Temperature(responseData['main']['feels_like']).celsius,
        weatherIcon: icon,
        windDegree: double.parse((responseData['wind']['deg']).toString()),
        windSpeed: double.parse((responseData['wind']['speed']).toString()),
        description:
            responseData['weather'].map((item) => item['main']).toList()[0],
      );
      _item = newWeather;
    } catch (error) {
      throw error;
    }
    notifyListeners();
  }

  Future<void> storingData()async{
    final prefs = await SharedPreferences.getInstance();
      final userData = json.encode({
        'city': _cities,
      });
     final List<Map<String,dynamic>> managedCityList=[];
     _managedCityWeather.forEach((item){
        final Map<String,dynamic> weatheritem = {
          'name':item.name,
          'description':item.description,
          'windDegree':item.windDegree,
          'windSpeed':item.windSpeed,
          'temperature':item.temperature,
          'realFeel':item.realFeel,
          'pressure':item.pressure,
          'weatherIcon':item.weatherIcon,
          'id':item.id,
        };
      managedCityList.add(weatheritem);
      });
      final managedCityData = json.encode({'weather': managedCityList});
      prefs.setString('userData', userData);
      prefs.setString('managedCity', managedCityData);
  }

  Future<void> getCurrentWeather(String city) async {
    try {
      await getWeather(city);
      if (!_cities.contains(city)) {
        _cities.add(city);
        _managedCityWeather.add(_item);
      }
      final query = city;
      var addresses = await Geocoder.local.findAddressesFromQuery(query);
      var first = addresses.first;
      final double latitude = first.coordinates.latitude;
      final double longitude = first.coordinates.longitude;
      await getForecast(latitude, longitude, first.featureName);
      await storingData();
      
    } catch (error) {
      throw error;
    }
    notifyListeners();
  }

  Future<void> getForecast(double lat, double lon, String city) async {
    final url =
        'https://api.openweathermap.org/data/2.5/onecall?lat=$lat&lon=$lon&appid=5f4c114fda0db0af152f8c22201445d6';
    try {
      final forecastResponse = await http.get(url);
      final forecastData = json.decode(forecastResponse.body);
      final List<dynamic> dailyForecast = forecastData['daily'];
      final List<w.Weather> loadedForecast = [];
      dailyForecast.forEach((item) {
        loadedForecast.add(w.Weather(
          name: city,
          pressure: double.parse((item['pressure']).toString()),
          windSpeed: double.parse((item['wind_speed']).toString()),
          windDegree: double.parse((item['wind_deg']).toString()),
          temperature: Temperature(item['temp']['day']).celsius,
          maxTemp: Temperature(item['temp']['max']).celsius,
          minTemp: Temperature(item['temp']['min']).celsius,
          description: item['weather'][0]['main'],
          id: item['weather'].forEach((index) => index['id']),
          weatherIcon: item['weather'][0]['icon'],
        ));
      });
      forecasts = loadedForecast;
    } catch (error) {
      throw error;
    }

    notifyListeners();
  }

  Future<void> fetchAndSetManagedCities() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      if (!prefs.containsKey('userData') || !prefs.containsKey('managedCity')) {
        return;
      }
      final extractedData =
          json.decode(prefs.getString('userData')) as Map<String, dynamic>;
      final managedCities =
          json.decode(prefs.getString('managedCity')) as Map<String, dynamic>;
      final List<String> cities = (extractedData['city'] as List<dynamic>)
          .map((city) => city.toString())
          .toList();
      _cities = cities;
      _managedCityWeather = (managedCities['weather'] as List<dynamic>)
          .map((city) => w.Weather(
                id: city['id'],
                description: city['description'],
                name: city['name'],
                pressure: city['pressure'],
                weatherIcon: city['weatherIcon'],
                temperature: city['temperature'],
                realFeel: city['realFeel'],
                windDegree: city['windDegree'],
                windSpeed: city['windSpeed'],
              ))
          .toList();
    } catch (error) {
      throw error;
    }

    notifyListeners();
  }

  Future<void> managedCityInformation(String city) async {
    try {
      await fetchAndSetManagedCities();
      // await getWeather(city);
      // if (_managedCityWeather.any((item) => _item.name == item.name)) {
      //   final int index =
      //       _managedCityWeather.indexWhere((item) => item.name == _item.name);
      //   _managedCityWeather[index] = _item;
      // } else {
      //   _managedCityWeather.add(_item);
      // }
      notifyListeners();
    } on SocketException catch (_) {
      throw SocketException("Can't connect to network");
    } catch (error) {
      throw error;
    }
  }

  Future<void> onTapManagedCities(String cityName,w.Weather weatherItem) async {
    try {
      _item=weatherItem;
      final query = cityName;
      var addresses = await Geocoder.local.findAddressesFromQuery(query);
      var first = addresses.first;
      final double latitude = first.coordinates.latitude;
      final double longitude = first.coordinates.longitude;
      await getForecast(latitude,longitude,cityName);
    } catch (error) {
      throw error;
    }
    notifyListeners();
  }

  Future<void> removeManagedCity(String city) async {
    try {
      _cities.remove(city);
      _managedCityWeather.removeWhere((item) => item.name == city);
      notifyListeners();
      final prefs = await SharedPreferences.getInstance();
      prefs.clear();
      final userData = json.encode({
        'city': _cities,
      });
      prefs.setString('userData', userData);
    } catch (error) {
      throw error;
    }
  }

  Future<void> manageHomeScreen() async {
    await fetchAndSetManagedCities();
    if (_cities.length <= 0) {
      return;
    }
    await getWeather(_cities[0]);
    final query = _cities[0];
    var addresses = await Geocoder.local.findAddressesFromQuery(query);
    var first = addresses.first;
    final double latitude = first.coordinates.latitude;
    final double longitude = first.coordinates.longitude;
    await getForecast(latitude, longitude, first.featureName);
    notifyListeners();
  }
}
