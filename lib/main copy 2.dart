import 'dart:io';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:test/typhoonista.dart';
import 'city.dart';

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
  String selectedCity = '';
  List<String> municipalNames = [];

  @override
  void initState() {
    super.initState();
    fetchWeatherData(selectedCity);
    getMunicipalNames();
  }

  Future<void> fetchWeatherData(String selectedCity) async {
    if (selectedCity.isEmpty) {
      // Default to the first municipality if none is selected
      selectedCity = municipalNames.isNotEmpty ? municipalNames.first : '';
    }

    try {
      final Uri uri = Uri.parse(
          "https://api.openweathermap.org/data/2.5/forecast?q=$selectedCity&PH&appid=5b0d11ec7d5a0162d3a9559e944c079e");
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

  Future<List<String>> fetchMunicipalNames() async {
    List<String> names = await getMunicipalNames();
    List<String> list =
        names.map((String city) => city.replaceAll(' ', '')).toList();
    print(list);
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Weather Forecast'),
        actions: [
          FutureBuilder<List<String>>(
            future: fetchMunicipalNames(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else if (snapshot.hasError) {
                print('naa diri: $municipalNames');
                return Text('Error: ${snapshot.error}');
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Text('No Data');
              } else {
                return DropdownButton<String>(
                  value: selectedCity,
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedCity = newValue!;
                    });
                    fetchWeatherData(
                        selectedCity); // Call fetchWeatherData when the selected city changes
                  },
                  items: snapshot.data!
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                );
              }
            },
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
                              // Format the time
                              Text(
                                DateFormat('h a').format(
                                    DateTime.parse(forecastData['dt_txt'])),
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              // Format the date
                              Text(
                                DateFormat('E, MMM d').format(
                                    DateTime.parse(forecastData['dt_txt'])),
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Image.network(
                                  "https://openweathermap.org/img/wn/${forecastData['weather'][0]['icon']}.png"),
                              Text(
                                  "Temperature: ${forecastData['main']['temp']}"),
                              Text(
                                  "${forecastData['weather'][0]['description']}"),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => TyphoonistaPage()),
          );
        },
        child: const Icon(Icons.navigate_next),
      ),
    );
  }
}
