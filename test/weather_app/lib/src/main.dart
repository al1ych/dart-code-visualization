import 'package:weather_app/services/weather_repository.dart';
import 'package:weather_app/utilities/error_handler.dart';

void main() async {
  WeatherRepository weatherRepository = WeatherRepository();
  try {
    Weather weather = await weatherRepository.getWeather('London');
    print('Temperature: ${weather.temperature}');
    print('Humidity: ${weather.humidity}');
    print('Description: ${weather.description}');
  } catch (e) {
    handleError(e);
  }
}
