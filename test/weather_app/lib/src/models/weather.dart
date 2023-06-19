class Weather {
  final double temperature;
  final int humidity;
  final String description;

  Weather({required this.temperature, required this.humidity, required this.description});

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      temperature: json['temperature'],
      humidity: json['humidity'],
      description: json['description'],
    );
  }
}
