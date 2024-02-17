import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController wsController = TextEditingController();
  TextEditingController rf24Controller = TextEditingController();
  TextEditingController rf6Controller = TextEditingController();
  TextEditingController areaController = TextEditingController();
  TextEditingController yieldController = TextEditingController();
  TextEditingController distanceController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController daysController = TextEditingController();

  String result = '';

  Future<void> forecast() async {
    double initial_ws = double.parse(wsController.text);
    double initial_rf24 = double.parse(rf24Controller.text);
    double initial_rf6 = double.parse(rf6Controller.text);
    double initial_area = double.parse(areaController.text);
    double initial_yield = double.parse(yieldController.text);
    double initial_distance = double.parse(distanceController.text);
    double price = double.parse(priceController.text);
    int days = int.parse(daysController.text);

    double next_ws = initial_ws;
    double next_rf24 = initial_rf24;
    double next_rf6 = initial_rf6;
    double next_area = initial_area;
    double next_yield = initial_yield;
    double next_distance = initial_distance;
    double rice_price = price;
    List<dynamic> costs = [];

    var typhoonista_input = {
      "features": [
        initial_ws,
        initial_rf24,
        initial_rf6,
        initial_area,
        initial_yield,
        initial_distance,
        rice_price
      ]
    };
    var typhoonista_response = await http.post(
        Uri.parse("http://127.0.0.1:5000/typhoonista/predict"),
        body: json.encode(typhoonista_input));
    var typhoonista_response_data = json.decode(typhoonista_response.body);
    var predicted_cost = typhoonista_response_data;
    costs.add(predicted_cost);

    for (int day = 1; day < days; day++) {
      var area_input = {
        "features": [
          next_ws,
          next_rf24,
          next_rf6,
          next_area,
          next_yield,
          next_distance,
          predicted_cost
        ]
      };
      var area_response = await http.post(
          Uri.parse("http://127.0.0.1:5000/damaged-area/predict"),
          body: json.encode(area_input));
      var area_response_data = json.decode(area_response.body);

      var yield_input = {
        "features": [
          next_ws,
          next_rf24,
          next_rf6,
          next_area,
          next_yield,
          next_distance,
          predicted_cost
        ]
      };
      var yield_response = await http.post(
          Uri.parse("http://127.0.0.1:5000/damaged-yield/predict"),
          body: json.encode(yield_input));
      var yield_response_data = json.decode(yield_response.body);

      print(
          '$next_rf24 $next_rf6 $next_distance $next_area $next_yield $predicted_cost');
      var windspeed_input = {
        "features": [
          next_rf24,
          next_rf6,
          next_distance,
          next_area,
          next_yield,
          predicted_cost
        ]
      };

      var windspeed_response = await http.post(
          Uri.parse("http://127.0.0.1:5000/windspeed/predict"),
          body: json.encode(windspeed_input));
      var windspeed_response_data = json.decode(windspeed_response.body);
      print(windspeed_response_data);

      var rainfall24_input = {
        "features": [
          next_ws,
          next_rf6,
          next_distance,
          next_area,
          next_yield,
          predicted_cost
        ]
      };
      var rainfall24_response = await http.post(
          Uri.parse("http://127.0.0.1:5000/rainfall24/predict"),
          body: json.encode(rainfall24_input));
      var rainfall24_response_data = json.decode(rainfall24_response.body);

      var rainfall6_input = {
        "features": [
          next_ws,
          next_rf24,
          next_distance,
          next_area,
          next_yield,
          predicted_cost
        ]
      };
      var rainfall6_response = await http.post(
          Uri.parse("http://127.0.0.1:5000/rainfall6h/predict"),
          body: json.encode(rainfall6_input));
      var rainfall6_response_data = json.decode(rainfall6_response.body);

      var distance_input = {
        "features": [
          next_ws,
          next_rf24,
          next_rf6,
          next_area,
          next_yield,
          predicted_cost
        ]
      };
      var distance_response = await http.post(
          Uri.parse("http://127.0.0.1:5000/distance/predict"),
          body: json.encode(distance_input));
      var distance_response_data = json.decode(distance_response.body);

      next_ws = windspeed_response_data;
      next_rf24 = rainfall24_response_data;
      next_rf6 = rainfall6_response_data;
      next_distance = distance_response_data;
      next_yield = yield_response_data;
      next_area = area_response_data;

      var next_day_input = {
        "features": [
          next_ws,
          next_rf24,
          next_rf6,
          next_area,
          next_yield,
          next_distance,
          rice_price
        ]
      };
      var day2_response = await http.post(
          Uri.parse("http://127.0.0.1:5000/typhoonista/predict"),
          body: json.encode(next_day_input));
      var day2_response_data = json.decode(day2_response.body);
      var next_day_cost = day2_response_data;
      predicted_cost = next_day_cost;
      costs.add(next_day_cost);
    }
    print(costs);
    setState(() {
      result = costs.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Typhoonista Forecast'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: wsController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Initial Wind Speed'),
            ),
            TextField(
              controller: rf24Controller,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Initial Rainfall (24h)'),
            ),
            TextField(
              controller: rf6Controller,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Initial Rainfall (6h)'),
            ),
            TextField(
              controller: areaController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Area'),
            ),
            TextField(
              controller: yieldController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Yield'),
            ),
            TextField(
              controller: distanceController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Distance'),
            ),
            TextField(
              controller: priceController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Price'),
            ),
            TextField(
              controller: daysController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Number of Days'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: forecast,
              child: Text('Calculate Forecast'),
            ),
            SizedBox(height: 20),
            Text(result),
          ],
        ),
      ),
    );
  }
}
