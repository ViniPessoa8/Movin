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
  final double _ocorrenciaSelecionadaZoom = 16.0;

  LatLng _centroMapa;
  Symbol marcador;
  Symbol marcadorSelecionado;

  @override
  void initState() {
    updateLocalizacao();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.mv.modoSelecao) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        marcadorCentralizado();
      });
    } else {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        addOcorrencias();
      });
    }

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

  // Builders

  Widget buildMapBox(
      {@required double latitude,
      @required double longitude,
      double zoom,
      double height = 700.0}) {
    // Mapa de seleção de um local
    MapboxMap _mapSelecao = new MapboxMap(
      initialCameraPosition: new CameraPosition(
          target: LatLng(
            latitude,
            longitude,
          ),
          zoom: _userLocationZoom),
      accessToken: MAP_BOX_TOKEN,
      zoomGesturesEnabled: true,
      trackCameraPosition: true,
      myLocationTrackingMode: MyLocationTrackingMode.Tracking,
      onMapCreated: (controller) => onMapCreate(controller),
    );

    // Mapa normal da tela inicial
    MapboxMap _mapNormal = new MapboxMap(
      initialCameraPosition: widget.mv.ocorrenciaSelecionada != null
          ? new CameraPosition(
              target: LatLng(
                widget.mv.ocorrenciaSelecionada.local.latitude,
                widget.mv.ocorrenciaSelecionada.local.longitude,
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
      onMapCreated: (controller) => onMapCreate(controller),
    );

    if (widget.mv.ocorrenciaSelecionada != null &&
        _mapBoxController != null &&
        _mapBoxController.symbols.isNotEmpty) {
      marcadorSelecionado = _mapBoxController.symbols.firstWhere((element) {
        return element.id == widget.mv.ocorrenciaSelecionada.idOcorrencia;
      });
    }

    return Container(
      height: widget.mv.modoSelecao ? 550.0 : height,
      child: widget.mv.modoSelecao ? _mapSelecao : _mapNormal,
    );
  }

  // Functions */

  // Carrega a localização do usuario
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
      _centroMapa = LatLng(_localizacao.latitude, _localizacao.longitude);
    });
  }

  // Move o foco do mapa para o local da ocorrência selecionada
  void moveOcorrenciaSelecionada() {
    LatLng _local = LatLng(
      widget.mv.ocorrenciaSelecionada.local.latitude,
      widget.mv.ocorrenciaSelecionada.local.longitude,
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
  }

  // Move o foco do mapa para o local atual do usuário
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

  // Adiciona as ocorrências do banco de dados no mapa
  void addOcorrencias() {
    print('[DEBUG] addOcorrencias()');
    if (widget.mv.carregouOcorrencias) {
      print('[DEBUG] addOcorrencias() carregouDados');
      widget.mv.ocorrencias.forEach((element) {
        print('[DEBUG] addOcorrencia(${element.idOcorrencia})');
        addOcorrencia(element);
      });
    }
  }

  // Adiciona uma ocorrência individual no mapa
  void addOcorrencia(Ocorrencia ocorrencia) async {
    if (_mapBoxController != null) {
      LatLng _local = LatLng(
        ocorrencia.local.latitude,
        ocorrencia.local.longitude,
      );
      print('add ponto( ${_local.latitude}, ${_local.longitude})');

      final ByteData bytes = await rootBundle.load("assets/media/marker.png");
      final Uint8List list = bytes.buffer.asUint8List();
      await _mapBoxController.addImage('marcador', list);
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

  // Mostra um marcador no meio do mapa
  void marcadorCentralizado() async {
    if (_mapBoxController != null) {
      LatLng _local = _mapBoxController.cameraPosition.target;
      debugPrint('add ponto( ${_local.latitude}, ${_local.longitude})');

      if (marcador == null) {
        final ByteData bytes = await rootBundle.load("assets/media/marker.png");
        final Uint8List list = bytes.buffer.asUint8List();
        _mapBoxController.addImage('marcador', list);
        var _symbol = await _mapBoxController.addSymbol(
          SymbolOptions(
            geometry: _centroMapa,
            iconImage: 'marcador',
            iconSize: 0.5,
            iconOffset: Offset(0, -45),
          ),
        );
        setState(() {
          marcador = _symbol;
        });
      }
      _mapBoxController.addListener(() {
        print('_mapBoxController LISTENED');
        _mapBoxController.isCameraMoving
            ? updateMarcadorCentral()
            : updateLocalCentro();
      });
    }
  }

  // Atualiza a posição do marcador central
  void updateMarcadorCentral() {
    print('[DEBUG] UpdateMarcadorCentral()');
    if (_mapBoxController != null) {
      LatLng posCamera = _mapBoxController.cameraPosition.target;
      if (posCamera != _centroMapa) {
        _centroMapa = _mapBoxController.cameraPosition.target;
        SymbolOptions _mudancas = marcador.options.copyWith(
          SymbolOptions(
            geometry: _centroMapa,
          ),
        );
        _mapBoxController.updateSymbol(marcador, _mudancas);
      }
    }
  }

  // Atualiza o local selecionado pelo usuario
  void updateLocalCentro() {
    print('[DEBUG] UpdateLocalCentro()');
    if (_mapBoxController != null) {
      LatLng posCamera = _mapBoxController.cameraPosition.target;
      _centroMapa = _mapBoxController.cameraPosition.target;
      print('[DEBUG] updateCentroMapa updateLocalApontado($_centroMapa)');
      widget.mv.updateLocalApontado(LatLng(
        _centroMapa.latitude,
        _centroMapa.longitude,
      ));
      debugPrint(
          'add ponto( ${_centroMapa.latitude}, ${_centroMapa.longitude})');
    }
  }

  // Função passada na criação do mapa
  void onMapCreate(MapboxMapController controller) {
    print('[DEBUG] onMapCreate() controller = $controller');
    controller.onSymbolTapped.add((argument) {
      var _map = argument.data.cast();
      // Carrega a ocorrência
      Ocorrencia _ocorrencia = _map['ocorrencia'];
      widget.mv.ocorrenciaSelecionada = _ocorrencia;
      // Move o foco para a ocorrência
      moveOcorrenciaSelecionada();
      // Mostra o painel de informações da ocorrência
      showDialog(
        context: context,
        builder: (context) {
          return ItemOcorrenciaInfo(widget.mv, _ocorrencia, true);
        },
      );
      widget.mv.ocorrenciaSelecionada = null;
    });
    setState(() {
      _mapBoxController = controller;
    });
  }
}
