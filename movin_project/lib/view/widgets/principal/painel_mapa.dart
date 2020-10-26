import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:location/location.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:movin_project/model_view/model_view.dart';

const String MAP_BOX_TOKEN =
    'pk.eyJ1IjoidmluaXBlc3NvYTgiLCJhIjoiY2tmNGN1d2Z2MGJzYjJ3bnNtOGtyMzM1eSJ9.7yJ8-KW8DYWRDBS-a8utzg';

class PainelMapa extends StatefulWidget {
  final ModelView mv;

  PainelMapa(this.mv);

  @override
  _PainelMapaState createState() => _PainelMapaState();
}

class _PainelMapaState extends State<PainelMapa> {
  LocationData _localizacao;
  MapboxMapController _mapBoxController;
  double _mapLatitude = 0.0;
  double _mapLongitude = 0.0;
  final double _userLocationZoom = 14.0;

  @override
  void initState() {
    updateLocalizacao();
    super.initState();
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

  void moveUserLocation() {
    _mapBoxController.animateCamera(
      CameraUpdate.newLatLngZoom(
        LatLng(
          _localizacao.latitude,
          _localizacao.longitude,
        ),
        _userLocationZoom,
      ),
    );
  }

  void addOcorrencias() {
    widget.mv.ocorrencias.forEach((element) {
      LatLng _local = LatLng(element.local.latitude, element.local.longitude);
      addPonto(_local);
    });
  }

  void addPonto(LatLng local) async {
    print('add ponto( ${local.latitude}, ${local.longitude})');

    final ByteData bytes = await rootBundle.load("assets/media/marker.png");
    final Uint8List list = bytes.buffer.asUint8List();
    _mapBoxController.addImage('marcador', list);
    _mapBoxController.addSymbol(SymbolOptions(
      geometry: local,
      iconImage: 'marcador',
      iconSize: 0.5,
      iconOffset: Offset(0, -45),
    ));
  }

  Widget buildMapBox(
      {@required double latitude,
      @required double longitude,
      double zoom,
      double height = 700.0}) {
    return Container(
      height: height,
      child: new MapboxMap(
        // trackCameraPosition: true,
        initialCameraPosition: new CameraPosition(
            target: LatLng(
              latitude,
              longitude,
            ),
            zoom: _userLocationZoom),
        accessToken: MAP_BOX_TOKEN,
        myLocationEnabled: true,
        zoomGesturesEnabled: true,
        myLocationRenderMode: MyLocationRenderMode.NORMAL,
        // myLocationTrackingMode: MyLocationTrackingMode.Tracking,
        onMapCreated: onMapCreate,
        onMapClick: (point, coordinates) => addPonto(coordinates),
      ),
    );
  }

  void onMapCreate(MapboxMapController controller) {
    setState(() {
      _mapBoxController = controller;
    });
    addOcorrencias();
    // addPonto(LatLng(_localizacao.latitude, _localizacao.longitude));
  }

  @override
  Widget build(BuildContext context) {
    return _localizacao == null
        ? Center(
            child: Text('Carregando Mapa...'),
          )
        : Container(
            child: Stack(
              children: [
                buildMapBox(
                  latitude: _localizacao.latitude,
                  longitude: _localizacao.longitude,
                ),
                Positioned(
                  bottom: 15,
                  child: FlatButton.icon(
                    onPressed: moveUserLocation,
                    icon: Icon(
                      Icons.my_location,
                      size: 40,
                    ),
                    label: Text(''),
                  ),
                )
              ],
            ),
          );
  }
}
