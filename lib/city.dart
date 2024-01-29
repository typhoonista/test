import 'dart:convert';
import 'package:flutter/services.dart';
import 'dart:ui';

class MunicipalityData {
  final String munName;
  final String munCode;
  final String provName;
  final String provCode;
  final String regName;
  final String regCode;
  final String meanSlope;
  final String meanElevationM;
  final String ruggednessStdev;
  final String meanRuggedness;
  final String areaKm2;
  final String coastLength;
  final String povertyPerc;
  final String perimeter;
  final String glat;
  final String glon;
  final String slopeStdev;
  final String withCoast;
  final String ricePlanted;
  final String riceArea;
  final String yieldBefore;

  MunicipalityData(
      {required this.munName,
      required this.munCode,
      required this.provName,
      required this.provCode,
      required this.regName,
      required this.regCode,
      required this.meanSlope,
      required this.meanElevationM,
      required this.ruggednessStdev,
      required this.meanRuggedness,
      required this.areaKm2,
      required this.coastLength,
      required this.povertyPerc,
      required this.perimeter,
      required this.glat,
      required this.glon,
      required this.slopeStdev,
      required this.withCoast,
      required this.ricePlanted,
      required this.riceArea,
      required this.yieldBefore});

  factory MunicipalityData.fromJson(Map<String, dynamic> json) {
    return MunicipalityData(
      munName: json['mun_name'],
      munCode: json['mun_code'],
      provName: json['prov_name'],
      provCode: json['prov_code'],
      regName: json['reg_name'],
      regCode: json['reg_code'],
      meanSlope: json['mean_slope'],
      meanElevationM: json['mean_elevation_m'],
      ruggednessStdev: json['ruggedness_stdev'],
      meanRuggedness: json['mean_ruggedness'],
      areaKm2: json['area_km2'],
      coastLength: json['coast_length'],
      povertyPerc: json['poverty_perc'],
      perimeter: json['perimeter'],
      glat: json['glat'],
      glon: json['glon'],
      slopeStdev: json['slope_stdev'],
      withCoast: json['with_coast'],
      ricePlanted: json['rice_planted'],
      riceArea: json['rice_area'],
      yieldBefore: json['yield'],
    );
  }
}

Future<List<String>> getMunicipalNames() async {
  try {
    String jsonString = await rootBundle.loadString('output.json');
    List<dynamic> jsonData = jsonDecode(jsonString);

    List<String> munNames = [];

    for (var data in jsonData) {
      munNames.add(data['mun_name']);
    }

    print(munNames);
    return munNames;
  } catch (e) {
    print('Error reading or parsing the JSON file: $e');
    return [];
  }
}

Future<MunicipalityData> getCorrespondingData(String municipality) async {
  try {
    String jsonString = await rootBundle.loadString('output.json');
    List<dynamic> jsonData = jsonDecode(jsonString);

    for (var data in jsonData) {
      if (data['mun_name'] == municipality) {
        return MunicipalityData.fromJson(data);
      }
    }

    // If the municipality is not found
    return MunicipalityData(
      munName: 'Not Found',
      munCode: '',
      provName: '',
      provCode: '',
      regName: '',
      regCode: '',
      meanSlope: '',
      meanElevationM: '',
      ruggednessStdev: '',
      meanRuggedness: '',
      areaKm2: '',
      coastLength: '',
      povertyPerc: '',
      perimeter: '',
      glat: '',
      glon: '',
      slopeStdev: '',
      withCoast: '',
      ricePlanted: '',
      riceArea: '',
      yieldBefore: '',
    );
  } catch (e) {
    print('Error reading or parsing the JSON file: $e');
    // If an error occurs
    return MunicipalityData(
      munName: 'Not Found',
      munCode: '',
      provName: '',
      provCode: '',
      regName: '',
      regCode: '',
      meanSlope: '',
      meanElevationM: '',
      ruggednessStdev: '',
      meanRuggedness: '',
      areaKm2: '',
      coastLength: '',
      povertyPerc: '',
      perimeter: '',
      glat: '',
      glon: '',
      slopeStdev: '',
      withCoast: '',
      ricePlanted: '',
      riceArea: '',
      yieldBefore: '',
    );
  }
}
