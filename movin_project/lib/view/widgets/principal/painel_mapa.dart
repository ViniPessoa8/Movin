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
  final ModelView _mv;

  PainelMapa(this._mv);

  @override
  _PainelMapaState createState() => _PainelMapaState();
}

class _PainelMapaState extends State<PainelMapa>
    with AutomaticKeepAliveClientMixin<PainelMapa> {
  LocationData _localizacao;
  MapboxMapController _mapBoxController;
  final double _userLocationZoom = 14.0;
  final double _ocorrenciaSelecionadaZoom = 16.0;
  ByteData _bytes;
  Uint8List _marcadorUint8;
  LatLng _centroMapa;
  Symbol _marcador;
  Symbol _marcadorSelecionado;

  @override
  void initState() {
    super.initState();

    // carregaMarcador();
    _carregaDados();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    return _localizacao == null
        ? Center(
            child: Text('Carregando Mapa...'),
          )
        : Container(
            child: Stack(
              children: [
                _buildMapBox(
                  latitude: _localizacao.latitude,
                  longitude: _localizacao.longitude,
                ),
                Positioned(
                  bottom: 15,
                  child: FlatButton.icon(
                    onPressed: _moveUserLocation,
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

  // Builders

  Widget _buildMapBox(
      {@required double latitude,
      @required double longitude,
      double zoom,
      double height = 700.0}) {
    // Mapa normal da tela inicial
    MapboxMap _map = new MapboxMap(
      initialCameraPosition: widget._mv.ocorrenciaSelecionada != null
          ? new CameraPosition(
              target: LatLng(
                widget._mv.ocorrenciaSelecionada.local.latitude,
                widget._mv.ocorrenciaSelecionada.local.longitude,
              ),
              zoom: _ocorrenciaSelecionadaZoom)
          : new CameraPosition(
              target: LatLng(
                latitude,
                longitude,
              ),
              zoom: _userLocationZoom),
      accessToken: MAP_BOX_TOKEN,
      myLocationEnabled: true,
      zoomGesturesEnabled: true,
      myLocationRenderMode: MyLocationRenderMode.NORMAL,
      onStyleLoadedCallback: () {
        // carregaMarcador();
        _addOcorrencias();
      },
      onMapCreated: (controller) => _onMapCreate(controller),
    );

    if (widget._mv.ocorrenciaSelecionada != null &&
        _mapBoxController != null &&
        _mapBoxController.symbols.isNotEmpty) {
      _marcadorSelecionado = _mapBoxController.symbols.firstWhere((element) {
        return element.id == widget._mv.ocorrenciaSelecionada.idOcorrencia;
      });
    }

    return Container(
      height: height,
      child: _map,
    );
  }

  // Functions */

  void _carregaDados() async {
    if (!widget._mv.ocorrenciaCarregaLocal) {
      widget._mv.ocorrenciaSelecionada = null;
      widget._mv.ocorrenciaCarregaLocal = false;
    }
    await _carregaMarcador();
    // addOcorrencias();
    await _updateLocalizacao();
  }

  Future<void> _carregaMarcador() async {
    _bytes = await rootBundle.load("assets/media/marker.png");
    setState(() {
      _marcadorUint8 = _bytes.buffer.asUint8List();
    });
  }

  // Carrega a localização do usuario
  Future<void> _updateLocalizacao() async {
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
      _centroMapa = LatLng(_localizacao.latitude, _localizacao.longitude);
    });
    // setState(() {});
  }

  // Move o foco do mapa para o local da ocorrência selecionada
  void _moveOcorrenciaSelecionada() {
    if (widget._mv.ocorrenciaSelecionada != null) {
      LatLng _local = LatLng(
        widget._mv.ocorrenciaSelecionada.local.latitude,
        widget._mv.ocorrenciaSelecionada.local.longitude,
      );
      _mapBoxController.animateCamera(
        CameraUpdate.newLatLngZoom(
          LatLng(
            _local.latitude,
            _local.longitude,
          ),
          _ocorrenciaSelecionadaZoom,
        ),
      );
      widget._mv.ocorrenciaSelecionada = null;
    }
  }

  // Move o foco do mapa para o local atual do usuário
  void _moveUserLocation() {
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

  // Adiciona as ocorrências do banco de dados no mapa
  void _addOcorrencias() {
    print('addOcorrencias()');
    if (widget._mv.carregouOcorrencias) {
      widget._mv.ocorrencias.forEach((element) {
        _addOcorrencia(element);
      });
    }
  }

  // Adiciona uma ocorrência individual no mapa
  void _addOcorrencia(Ocorrencia ocorrencia) async {
    if (_mapBoxController != null) {
      LatLng _local = LatLng(
        ocorrencia.local.latitude,
        ocorrencia.local.longitude,
      );

      await _mapBoxController.addImage('marcador', _marcadorUint8);
      await _mapBoxController.addSymbol(
          SymbolOptions(
            geometry: _local,
            iconImage: 'marcador',
            iconSize: 0.5,
            iconOffset: Offset(0, -45),
          ),
          {'ocorrencia': ocorrencia});
    }
  }

  // Atualiza o local selecionado pelo usuario
  void _updateLocalCentro() {
    print('[DEBUG] UpdateLocalCentro()');
    if (_mapBoxController != null) {
      LatLng posCamera = _mapBoxController.cameraPosition.target;
      _centroMapa = _mapBoxController.cameraPosition.target;
      print('[DEBUG] updateCentroMapa updateLocalApontado($_centroMapa)');
      widget._mv.updateLocalApontado(LatLng(
        _centroMapa.latitude,
        _centroMapa.longitude,
      ));
      debugPrint(
          'add ponto( ${_centroMapa.latitude}, ${_centroMapa.longitude})');
    }
  }

  // Função passada na criação do mapa
  void _onMapCreate(MapboxMapController controller) {
    print('[DEBUG] onMapCreate() controller = $controller');
    controller.onSymbolTapped.add((argument) {
      var _map = argument.data.cast();
      // Carrega a ocorrência
      Ocorrencia _ocorrencia = _map['ocorrencia'];
      widget._mv.ocorrenciaSelecionada = _ocorrencia;
      // Move o foco para a ocorrência
      _moveOcorrenciaSelecionada();
      // Mostra o painel de informações da ocorrência
      showDialog(
        context: context,
        builder: (context) {
          return ItemOcorrenciaInfo(widget._mv, _ocorrencia, true);
        },
      );
      widget._mv.ocorrenciaSelecionada = null;
    });
    setState(() {
      _mapBoxController = controller;
    });
  }
}
