import 'dart:async';
import 'dart:convert';

import 'package:amplify_common/amplify_common.dart';
import 'package:amplify_geo/amplify_geo.dart';
import 'package:amplify_geo_example/amplifyconfiguration.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:maplibre_gl/maplibre_gl.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Amplify Geo Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Amplify Geo Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _isLoadingPosition = false;
  Coordinates _coordinates = const Coordinates(
    lat: 47.6159,
    lon: -122.3394,
  );

  @override
  void initState() {
    super.initState();
  }

  Future<void> _getPosition() async {
    setState(() {
      _isLoadingPosition = true;
    });
    final location = Location();
    try {
      var servicesEnabled = await location.serviceEnabled();
      if (!servicesEnabled) {
        servicesEnabled = await location.requestService();
        if (!servicesEnabled) {
          return;
        }
      }

      var permissionGranted = await location.hasPermission();
      if (permissionGranted == PermissionStatus.denied) {
        permissionGranted = await location.requestPermission();
        if (permissionGranted != PermissionStatus.granted &&
            permissionGranted != PermissionStatus.grantedLimited) {
          return;
        }
      }

      final userLocation = await location.getLocation();
      final latitude = userLocation.latitude;
      final longitude = userLocation.longitude;
      if (latitude == null || longitude == null) {
        return;
      }
      setState(() => _coordinates = Coordinates(lat: latitude, lon: longitude));
      return;
    } on Exception catch (e) {
      print('Error retrieving location: $e');
      return;
    } finally {
      setState(() {
        _isLoadingPosition = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
              onPressed: _isLoadingPosition ? null : _getPosition,
              icon: const Icon(Icons.my_location)),
        ],
      ),
      body: Center(
        child: AmplifyGeoMap(
          config: AmplifyConfig.fromJson(jsonDecode(amplifyconfig)),
          center: _coordinates,
          zoom: 12,
        ),
      ),
    );
  }
}
