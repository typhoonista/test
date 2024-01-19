import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class BoekePage extends StatefulWidget {
  @override
  _BoekePageState createState() => _BoekePageState();
}

class _BoekePageState extends State<BoekePage> {
  TextEditingController inputController1 = TextEditingController();
  TextEditingController inputController2 = TextEditingController();
  TextEditingController inputController3 = TextEditingController();
  TextEditingController inputController4 = TextEditingController();
  TextEditingController inputController5 = TextEditingController();
  TextEditingController inputController6 = TextEditingController();
  TextEditingController inputController7 = TextEditingController();
  TextEditingController inputController8 = TextEditingController();
  TextEditingController inputController9 = TextEditingController();
  TextEditingController inputController10 = TextEditingController();
  TextEditingController inputController11 = TextEditingController();
  TextEditingController inputController12 = TextEditingController();
  TextEditingController inputController13 = TextEditingController();
  TextEditingController inputController14 = TextEditingController();
  TextEditingController inputController15 = TextEditingController();

  String predictionResult = '';

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Boeke Model'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        _buildTextField(inputController1, 'Input 1'),
                        _buildTextField(inputController3, 'Input 3'),
                        _buildTextField(inputController5, 'Input 5'),
                        _buildTextField(inputController7, 'Input 7'),
                        _buildTextField(inputController9, 'Input 9'),
                        _buildTextField(inputController11, 'Input 11'),
                        _buildTextField(inputController13, 'Input 13'),
                        _buildTextField(inputController15, 'Input 15'),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        _buildTextField(inputController2, 'Input 2'),
                        _buildTextField(inputController4, 'Input 4'),
                        _buildTextField(inputController6, 'Input 6'),
                        _buildTextField(inputController8, 'Input 8'),
                        _buildTextField(inputController10, 'Input 10'),
                        _buildTextField(inputController12, 'Input 12'),
                        _buildTextField(inputController14, 'Input 14'),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    sendPredictionRequest();
                  }
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
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String labelText) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(labelText: labelText),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter a value';
          }
          return null;
        },
      ),
    );
  }

  Future<void> sendPredictionRequest() async {
    try {
      final response = await http.post(
        Uri.parse('https://typhoonista.onrender.com/boeke/predict'),
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
            int.parse(inputController8.text),
            int.parse(inputController9.text),
            int.parse(inputController10.text),
            int.parse(inputController11.text),
            int.parse(inputController12.text),
            int.parse(inputController13.text),
            int.parse(inputController14.text),
            int.parse(inputController15.text),
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
        setState(() {
          predictionResult = 'Failed to get prediction';
        });
      }
    } catch (error) {
      setState(() {
        print("nag error: $error");
        predictionResult = 'Error: $error';
      });
    }
  }
}
