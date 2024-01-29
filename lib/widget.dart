import 'package:flutter/material.dart';
import 'city.dart';

class MyDropDownWidget extends StatefulWidget {
  @override
  _MyDropDownWidgetState createState() => _MyDropDownWidgetState();
}

class _MyDropDownWidgetState extends State<MyDropDownWidget> {
  List<String> municipalNames = [];
  String? selectedValue;
  MunicipalityData selectedMunicipalityData = MunicipalityData(
    munName: '',
    munCode: '',
    provName: '',
    provCode: '',
    regName: '',
    regCode: '',
    glat: '',
    glon: '',
    meanSlope: '',
    meanElevationM: '',
    ruggednessStdev: '',
    meanRuggedness: '',
    slopeStdev: '',
    areaKm2: '',
    povertyPerc: '',
    withCoast: '',
    coastLength: '',
    perimeter: '',
    ricePlanted: '',
    riceArea: '',
    yieldBefore: '',
  );

  @override
  void initState() {
    super.initState();
    _loadMunicipalNames();
  }

  Future<void> _loadMunicipalNames() async {
    municipalNames = await getMunicipalNames();
    setState(() {
      selectedValue = municipalNames.isNotEmpty ? municipalNames[0] : null;
      selectedMunicipalityData = MunicipalityData(
        munName: '',
        munCode: '',
        provName: '',
        provCode: '',
        regName: '',
        regCode: '',
        glat: '',
        glon: '',
        meanSlope: '',
        meanElevationM: '',
        ruggednessStdev: '',
        meanRuggedness: '',
        slopeStdev: '',
        areaKm2: '',
        povertyPerc: '',
        withCoast: '',
        coastLength: '',
        perimeter: '',
        ricePlanted: '',
        riceArea: '',
        yieldBefore: '',
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        const Text(
          'Select Municipal Name:',
          style: TextStyle(fontSize: 16),
        ),
        const SizedBox(height: 10),
        DropdownButton<String>(
          value: selectedValue,
          items: municipalNames.map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: (String? newValue) async {
            setState(() {
              selectedValue = newValue;
            });

            selectedMunicipalityData =
                await getCorrespondingData(selectedValue!);
          },
        ),
        const SizedBox(height: 20),
        const Text(
          'Selected Municipality Data:',
          style: TextStyle(fontSize: 16),
        ),
        const SizedBox(height: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Municipality Name: ${selectedMunicipalityData.munName}'),
          ],
        ),
      ],
    );
  }
}
