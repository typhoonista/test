// main.dart
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:test/cities.dart';
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyCustomScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
      };
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Map<String, dynamic>> weatherData = [];
  String selectedCity =
      CitiesData.getCities().first; // Default to the first city

  @override
  void initState() {
    super.initState();
    fetchWeatherData();
  }

  Future<void> fetchWeatherData() async {
    try {
      final Uri uri = Uri.parse(
          "https://api.openweathermap.org/data/2.5/forecast?q=$selectedCity&appid=5b0d11ec7d5a0162d3a9559e944c079e");
      final http.Response response = await http.get(uri);

      if (response.statusCode == 200) {
        print("API Response: ${response.body}");
        setState(() {
          final Map<String, dynamic> data = json.decode(response.body);
          weatherData = List<Map<String, dynamic>>.from(data['list']);
        });
      } else {
        print("Error: ${response.statusCode} - ${response.body}");
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  final ScrollController controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Weather Forecast'),
        actions: [
          DropdownButton<String>(
            value: selectedCity,
            onChanged: (String? newValue) {
              setState(() {
                selectedCity = newValue!;
                fetchWeatherData(); // Fetch data when city changes
              });
            },
            items: CitiesData.getCities()
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
        ],
      ),
      body: weatherData.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ScrollConfiguration(
              behavior: MyCustomScrollBehavior(),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    for (final forecastData in weatherData)
                      Card(
                        margin: EdgeInsets.all(8.0),
                        child: Container(
                          height: 200.0,
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.network(
                                  "https://openweathermap.org/img/wn/${forecastData['weather'][0]['icon']}.png"),
                              Text("Date/Time: ${forecastData['dt_txt']}"),
                              Text(
                                  "Temperature: ${forecastData['main']['temp']}"),
                              Text(
                                  "Description: ${forecastData['weather'][0]['description']}"),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
    );
  }
}
