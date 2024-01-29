import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'city.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController windspeedController = TextEditingController();
  TextEditingController rainfall24hController = TextEditingController();
  TextEditingController rainfall6hController = TextEditingController();
  TextEditingController areaController = TextEditingController();
  TextEditingController yieldController = TextEditingController();
  TextEditingController priceController = TextEditingController();

  List<String> municipalNames = [];
  String? selectedMunicipalName;
  String? selectedTyphoonLocation;
  String? distancetoTyphoon = '';
  String coordinates1 = '';
  String distance = '';
  String predictionResult = '';
  String prediction = '';

  Future<void> sendPredictionRequest() async {
    try {
      final response = await http.post(
        Uri.parse('https://typhoonista.onrender.com/typhoonista/predict'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'features': [
            double.parse(windspeedController.text),
            double.parse(rainfall24hController.text),
            double.parse(rainfall6hController.text),
            double.parse(areaController.text),
            double.parse(yieldController.text),
            double.parse(coordinates1),
            double.parse(priceController.text),
          ],
        }),
      );

      if (response.statusCode == 200) {
        print('Nigana');
        setState(() {
          prediction = 'Prediction: ${jsonDecode(response.body)['prediction']}';
        });
      } else {
        print("failed");
        predictionResult = 'Failed to get prediction';
      }
    } catch (error) {
      setState(() {
        print("prediction nag error: $error");
        predictionResult = 'Error: $error';
      });
    }
  }

  Future<void> sendCoordinatesRequest() async {
    try {
      final response = await http.post(
        Uri.parse('https://typhoonista.onrender.com/get_coordinates'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'predictionLocation': "$selectedMunicipalName, Philippines",
          'typhoonLocation': "$selectedTyphoonLocation, Philippines",
        }),
      );

      if (response.statusCode == 200) {
        print('Nigana');
        setState(() {
          coordinates1 = jsonDecode(response.body)['distance'].toString();
          coordinates1 = coordinates1.replaceAll(" km", "");
          print(coordinates1);
        });
      } else {
        print("failed");
        print(selectedMunicipalName);
        print(coordinates1);
        coordinates1 = 'Failed to get coordinates';
      }
    } catch (error) {
      setState(() {
        print("coordinates nag error: $error");
        coordinates1 = 'Error: $error';
      });
    }
  }

  @override
  void initState() {
    super.initState();
    loadMunicipalNames();
  }

  Future<void> loadMunicipalNames() async {
    try {
      List<String> names = await getMunicipalNames();
      setState(() {
        municipalNames = names;
        print(municipalNames);
      });
    } catch (e) {
      print('Error loading municipal names: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Column(
        children: <Widget>[
          TextField(
            controller: windspeedController,
            decoration: const InputDecoration(
              labelText: 'Enter Windspeed',
            ),
          ),
          TextField(
            controller: rainfall24hController,
            decoration: const InputDecoration(
              labelText: 'Enter Rainfall (24hrs)',
            ),
          ),
          TextField(
            controller: rainfall6hController,
            decoration: const InputDecoration(
              labelText: 'Enter Rainfall (6hrs)',
            ),
          ),
          TextField(
            controller: areaController,
            decoration: const InputDecoration(
              labelText: 'Area',
            ),
          ),
          TextField(
            controller: yieldController,
            decoration: const InputDecoration(
              labelText: 'Yield',
            ),
          ),
          TextField(
            controller: priceController,
            decoration: const InputDecoration(
              labelText: 'Price',
            ),
          ),
          const Align(
            alignment: Alignment.centerLeft,
            child: Text("Select Location"),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: DropdownButton<String>(
              value: selectedMunicipalName,
              items: municipalNames.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  selectedMunicipalName = newValue;
                });
              },
            ),
          ),
          const Align(
            alignment: Alignment.centerLeft,
            child: Text("Select Location of Typhoon"),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: DropdownButton<String>(
              value: selectedTyphoonLocation,
              items: municipalNames.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  selectedTyphoonLocation = newValue;
                });
              },
            ),
          ),
          Align(
              alignment: Alignment.centerLeft, child: Text(distancetoTyphoon!)),
          Align(alignment: Alignment.centerLeft, child: Text(predictionResult)),
          ElevatedButton(
              onPressed: () async {
                await sendCoordinatesRequest();
                setState(() {
                  distancetoTyphoon = coordinates1.trim();
                  distance = distancetoTyphoon!;
                });
                await sendPredictionRequest();
                setState(() {
                  predictionResult = prediction;
                });
              },
              child: const Text('Predict'))
        ],
      ),
    );
  }
}
