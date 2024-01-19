import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:test/boeke.dart';

class TyphoonistaPage extends StatefulWidget {
  @override
  _TyphoonistaPageState createState() => _TyphoonistaPageState();
}

class _TyphoonistaPageState extends State<TyphoonistaPage> {
  TextEditingController inputController1 = TextEditingController();
  TextEditingController inputController2 = TextEditingController();
  TextEditingController inputController3 = TextEditingController();
  TextEditingController inputController4 = TextEditingController();
  TextEditingController inputController5 = TextEditingController();
  TextEditingController inputController6 = TextEditingController();
  TextEditingController inputController7 = TextEditingController();

  String predictionResult = '';

  Future<void> sendPredictionRequest() async {
    try {
      final response = await http.post(
        Uri.parse('https://typhoonista.onrender.com/typhoonista/predict'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'features': [
            int.parse(inputController1.text),
            int.parse(inputController2.text),
            int.parse(inputController3.text),
            int.parse(inputController4.text),
            int.parse(inputController5.text),
            int.parse(inputController6.text),
            int.parse(inputController7.text),
          ],
        }),
      );

      if (response.statusCode == 200) {
        print('Nigana');
        setState(() {
          predictionResult =
              'Prediction: ${jsonDecode(response.body)['prediction']}';
        });
      } else {
        print("failed");
        predictionResult = 'Failed to get prediction';
      }
    } catch (error) {
      setState(() {
        print("nag error: $error");
        predictionResult = 'Error: $error';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Typhoonista Model'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: inputController1,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Input 1'),
            ),
            TextField(
              controller: inputController2,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Input 2'),
            ),
            TextField(
              controller: inputController3,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Input 3'),
            ),
            TextField(
              controller: inputController4,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Input 4'),
            ),
            TextField(
              controller: inputController5,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Input 5'),
            ),
            TextField(
              controller: inputController6,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Input 6'),
            ),
            TextField(
              controller: inputController7,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Input 7'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                sendPredictionRequest();
              },
              child: const Text('Predict'),
            ),
            const SizedBox(height: 20),
            Text(
              'Prediction: $predictionResult',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: predictionResult.startsWith('Prediction')
                    ? Colors.green
                    : Colors.red,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => BoekePage()),
          );
        },
        child: const Icon(Icons.navigate_next),
      ),
    );
  }
}
