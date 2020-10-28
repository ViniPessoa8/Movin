import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:location/location.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:movin_project/model/ocorrencia.dart';
import 'package:movin_project/model_view/model_view.dart';
import 'package:movin_project/view/widgets/principal/item_ocorrencia_info.dart';

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
  final double _userLocationZoom = 14.0;

  @override
  void initState() {
    updateLocalizacao();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // widget.mv.deletaTodasOcorrencias();

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
    if (widget.mv.carregouDados) {
      widget.mv.ocorrencias.forEach((element) {
        addOcorrencia(element);
      });
    }
  }

  void addOcorrencia(Ocorrencia ocorrencia) async {
    LatLng _local = LatLng(
      ocorrencia.local.latitude,
      ocorrencia.local.longitude,
    );
    print('add ponto( ${_local.latitude}, ${_local.longitude})');

    final ByteData bytes = await rootBundle.load("assets/media/marker.png");
    final Uint8List list = bytes.buffer.asUint8List();
    _mapBoxController.addImage('marcador', list);
    _mapBoxController.addSymbol(
        SymbolOptions(
          geometry: _local,
          iconImage: 'marcador',
          iconSize: 0.5,
          iconOffset: Offset(0, -45),
        ),
        {'ocorrencia': ocorrencia});
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
        // onMapClick: (point, coordinates) => addPonto(coordinates),
      ),
    );
  }

  void onMapCreate(MapboxMapController controller) {
    setState(() {
      _mapBoxController = controller;
      _mapBoxController.onSymbolTapped.add((ocorrencia) {
        showDialog(
            context: context,
            builder: (context) {
              return ItemOcorrenciaInfo(
                widget.mv,
                ocorrencia.data['ocorrencia'],
                true,
              );
            });
      });
    });
    addOcorrencias();
  }
}
