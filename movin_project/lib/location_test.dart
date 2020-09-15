import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:mapbox_gl/mapbox_gl.dart';

const String MAP_BOX_TOKEN =
    'pk.eyJ1IjoidmluaXBlc3NvYTgiLCJhIjoiY2tmNGN1d2Z2MGJzYjJ3bnNtOGtyMzM1eSJ9.7yJ8-KW8DYWRDBS-a8utzg';

class LocationTest extends StatefulWidget {
  @override
  _LocationTestState createState() => _LocationTestState();
}

class _LocationTestState extends State<LocationTest> {
  LocationData _localizacao;
  MapboxMapController _mapBoxController;
  double _mapLatitude = 0.0;
  double _mapLongitude = 0.0;

  @override
  void initState() {
    updateLocalizacao();
    super.initState();
  }

  // Future<void> createMapBoxController() async {
  //   await MapboxMapController.init(
  //     0,
  //     CameraPosition(
  //       target: LatLng(
  //         _mapLatitude,
  //         _mapLongitude,
  //       ),
  //       zoom: _mapZoom,
  //     ),
  //   ).then((value) {
  //     print('fooooi');
  //     setState(() {
  //       _mapBoxController = value;
  //     });
  //   });
  // }

  void onMapCreate(MapboxMapController controller) {
    _mapBoxController = controller;
  }

  Future<void> updateLocalizacao() async {
    Location location = new Location();
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return null;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return null;
      }
    }

    _locationData = await location.getLocation();

    setState(() {
      _localizacao = _locationData;
      _mapLatitude = _localizacao.latitude;
      _mapLongitude = _localizacao.longitude;
    });
  }

  void aumentarZoom() {
    _mapBoxController.animateCamera(CameraUpdate.zoomIn());
  }

  void move() {
    setState(() {
      _mapLatitude += 1.0;
    });
    _mapBoxController.animateCamera(
      CameraUpdate.newLatLng(
        LatLng(_mapLatitude, _mapLongitude),
      ),
    );
  }

  Widget buildMapBox(
      {@required double latitude,
      @required double longitude,
      double zoom,
      double height = 300.0}) {
    return Container(
      height: height,
      child: new MapboxMap(
        trackCameraPosition: true,
        initialCameraPosition: new CameraPosition(
            target: LatLng(
              latitude,
              longitude,
            ),
            zoom: 14.0),
        accessToken: MAP_BOX_TOKEN,
        myLocationEnabled: true,
        zoomGesturesEnabled: true,
        myLocationRenderMode: MyLocationRenderMode.NORMAL,
        // myLocationTrackingMode: MyLocationTrackingMode.Tracking,
        onMapCreated: onMapCreate,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      child: _localizacao == null
          ? Center(
              child: Text('Carregando localização...'),
            )
          : Column(
              children: [
                Text(
                  'informações sobre a localização.',
                  style: Theme.of(context).textTheme.headline6,
                ),
                Text(
                  'Latitude: ${_localizacao.latitude}',
                  style: Theme.of(context).textTheme.bodyText1,
                ),
                Text(
                  'Longitude: ${_localizacao.longitude}',
                  style: Theme.of(context).textTheme.bodyText1,
                ),
                Text(
                  'Heading: ${_localizacao.heading}',
                  style: Theme.of(context).textTheme.bodyText1,
                ),
                Text(
                  'Altitude: ${_localizacao.time}',
                  style: Theme.of(context).textTheme.bodyText1,
                ),
                buildMapBox(
                  latitude: _localizacao.latitude,
                  longitude: _localizacao.longitude,
                ),
                Row(
                  children: [
                    FlatButton(
                      onPressed: move, //aumentarZoom,
                      child: Row(
                        children: [
                          Icon(Icons.add),
                          Text('Zoom'),
                        ],
                      ),
                    )
                  ],
                )
              ],
            ),
    );
  }
}
