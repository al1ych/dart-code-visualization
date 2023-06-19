import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/weather.dart';

class Constants {
  static const weatherApiUrl = 'api.weatherapi.com/v1/current.json';
  static const weatherApiKey = 'YOUR_WEATHER_API_KEY';
}

class WeatherApiClient {
  Future<Weather> fetchWeather(String city) async {
    final response = await http.get(
      Uri.parse(
        '${Constants.weatherApiUrl}?city=$city&apiKey=${Constants.weatherApiKey}',
      ),
    );
    if (response.statusCode == 200) {
      return Weather.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load weather data');
    }
  }
}
