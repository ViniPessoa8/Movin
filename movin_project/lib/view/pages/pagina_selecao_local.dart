import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoder/geocoder.dart';
import 'package:location/location.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:movin_project/model/ocorrencia.dart';
import 'package:movin_project/model_view/model_view.dart';
import 'package:movin_project/view/widgets/login/painel_carregamento.dart';
import 'package:movin_project/view/widgets/principal/item_ocorrencia_info.dart';
import 'package:movin_project/view/widgets/principal/selecao_local_box.dart';
import 'package:scoped_model/scoped_model.dart';

const String MAP_BOX_TOKEN =
    'pk.eyJ1IjoidmluaXBlc3NvYTgiLCJhIjoiY2tmNGN1d2Z2MGJzYjJ3bnNtOGtyMzM1eSJ9.7yJ8-KW8DYWRDBS-a8utzg';

class PaginaSelecaoLocal extends StatefulWidget {
  static final String nomeRota = '/selecao_local';
  final List<Map<String, Object>> _paineisPrincipais;
  final ModelView mv;
  final ValueNotifier<Address> _enderecoApontado;

  PaginaSelecaoLocal(this.mv, this._enderecoApontado, this._paineisPrincipais);

  @override
  _PaginaSelecaoLocalState createState() => _PaginaSelecaoLocalState();
}

class _PaginaSelecaoLocalState extends State<PaginaSelecaoLocal> {
  final double _ocorrenciaSelecionadaZoom = 16.0;
  final double _userLocationZoom = 14.0;

  MapboxMapController _mapBoxController;

  Symbol marcador;
  LatLng _centroMapa;

  @override
  void initState() {
    carregaDados();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // if (widget._enderecoApontado.value != null) {
    Coordinates local = widget.mv.enderecoUsuario.coordinates;
    return Scaffold(
      appBar: AppBar(
        title: Text('Escolha um local'),
      ),
      body: Column(
        children: [
          //Painel
          // _paineisPrincipais[mv.indexPainelPrincipal]['pagina'],
          buildMapBox(
            latitude: local.latitude,
            longitude: local.longitude,
            // height: 550,
          ),
          // Caixa de opções
          SelecaoLocalBox(widget._enderecoApontado, widget.mv),
        ],
      ),
    );
    // }
    return PainelCarregamento();
  }

  void carregaDados() async {
    await updateLocalizacao();
    marcadorCentralizado();
  }

  Widget buildMapBox(
      {@required double latitude,
      @required double longitude,
      double zoom,
      double height = 550.0}) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      marcadorCentralizado();
    });

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

    return Container(
      height: height,
      child: _mapSelecao,
    );
  }

  void getEndereco(LatLng local) async {
    Address _retorno = await widget.mv.getEnderecoBD(
      local.latitude,
      local.longitude,
    );
    setState(() {
      widget._enderecoApontado.value = _retorno;
    });
  }

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
      _centroMapa = LatLng(
        _locationData.latitude,
        _locationData.longitude,
      );
    });
  }

  @override
  void dispose() {
    // widget.mv.mudaModo();
    super.dispose();
  }
}
