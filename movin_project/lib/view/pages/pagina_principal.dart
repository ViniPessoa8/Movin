import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:movin_project/db/firebase_controller.dart';
import 'package:movin_project/main.dart';
import 'package:movin_project/model_view/model_view.dart';
import 'package:movin_project/utils/dados_internos.dart';
import 'package:movin_project/view/widgets/login/painel_cadastro.dart';
import 'package:movin_project/view/widgets/login/painel_carregamento.dart';
import 'package:movin_project/view/widgets/login/painel_login.dart';
import 'package:movin_project/view/widgets/login/painel_boas_vindas.dart';
import 'package:movin_project/view/widgets/principal/painel_drawer.dart';
import 'package:movin_project/view/widgets/principal/painel_mapa.dart';
import 'package:movin_project/view/widgets/principal/painel_ocorrencias.dart';
import 'package:movin_project/view/widgets/principal/painel_perfil.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:movin_project/view/widgets/principal/painel_cria_ocorrencia.dart';
import 'package:scoped_model/scoped_model.dart';

// PRINCIPAL

class PaginaPrincipal extends StatefulWidget {
  static final nomeRota = '/principal';
  final ModelView mv;

  PaginaPrincipal(this.mv);

  @override
  _PaginaPrincipalState createState() => _PaginaPrincipalState();
}

class _PaginaPrincipalState extends State<PaginaPrincipal> {
  List<Map<String, Object>> paginas;
  ValueNotifier<LatLng> _localApontado;

  @override
  void initState() {
    _localApontado = widget.mv.localApontadoListenable;
    paginas = [
      {
        'pagina': PainelMapa(widget.mv),
        'titulo': 'Mapa',
      },
      {
        'pagina': PainelOcorrencias(context, widget.mv),
        'titulo': 'Ocorrências',
      },
      {
        'pagina': PainelPerfil(widget.mv),
        'titulo': 'Perfil',
      },
    ];
    super.initState();
  }

  void _mostraCriaOcorrencia(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return PainelCriaOcorrencia(widget.mv);
      },
    );
  }

  void criaOcorrencia() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return PainelCriaOcorrencia(widget.mv);
      },
    );
  }

  BottomNavigationBarItem _buildNavBarItem(String titulo, IconData icone) {
    return BottomNavigationBarItem(
      backgroundColor: Theme.of(context).primaryColor,
      icon: Icon(
        icone,
        size: 35,
      ),
      label: titulo,
    );
  }

  Widget _buildBotaoMapa() {
    return SpeedDial(
      animatedIcon: AnimatedIcons.menu_close,
      animatedIconTheme: IconThemeData(size: 22),
      curve: Curves.bounceIn,
      overlayColor: Colors.black,
      overlayOpacity: 0.5,
      tooltip: 'Opções',
      elevation: 8.0,
      child: Icon(
        Icons.add,
        size: 30,
      ),
      children: [
        SpeedDialChild(
          child: Icon(Icons.warning),
          label: 'Criar Ocorrência',
          backgroundColor: Colors.yellow,
          onTap: criaOcorrencia,
        ),
        SpeedDialChild(
          child: Icon(
            Icons.warning,
            color: Colors.white,
          ),
          label: 'Teste',
          backgroundColor: Colors.purple,
          onTap: widget.mv.mudaModo,
        ),
      ],
    );
  }

  Widget _buildBotaoOcorrencias() {
    return FloatingActionButton(
      onPressed: () {
        _mostraCriaOcorrencia(context);
      },
      child: Icon(
        Icons.add,
        size: 30,
        color: Colors.white,
      ),
      backgroundColor: Theme.of(context).primaryColor,
    );
  }

  Widget _buildFloatingButton() {
    if (widget.mv.indexPainelPrincipal == 0) return _buildBotaoMapa();
    if (widget.mv.indexPainelPrincipal == 1) return _buildBotaoOcorrencias();
    return SpeedDial(
      visible: false,
    );
  }

  Widget _buildTituloAppbar() {
    String texto;
    if (widget.mv.modoSelecao) {
      return Text('Escolha um local');
    } else {
      switch (widget.mv.indexPainelPrincipal) {
        case 0:
          texto = 'Home';
          break;
        case 1:
          texto = 'Ocorrências';
          break;
        case 2:
          texto = 'Perfil';
          break;
        default:
          texto = 'Movin';
          break;
      }
    }
    return Text(texto);
  }

  // void teste() {
  //   widget.mv.localApontadoListenable.value = a;
  // }

  void updateLocalApontado() {
    print('UPDATE LOCAL APONTADO');
    _localApontado.value = widget.mv.localApontado;
  }

  @override
  Widget build(BuildContext context) {
    Color primaryColor = Theme.of(context).primaryColor;
    Color accentColor = Theme.of(context).accentColor;

    // popTelaLogin();
    print('[DEBUG] widget.mv.deslogado = ${widget.mv.deslogado}');
    if (widget.mv.deslogado) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context).pop();
        widget.mv.deslogado = false;
      });
    }

    final paginaPrincipal = ScopedModel<ModelView>(
      model: widget.mv,
      child: widget.mv.modoSelecao
          ? Scaffold(
              appBar: AppBar(
                title: _buildTituloAppbar(),
              ),
              body: ScopedModelDescendant<ModelView>(
                  builder: (context, child, model) {
                updateLocalApontado();
                return Column(
                  children: [
                    paginas[model.indexPainelPrincipal]['pagina'],
                    Container(
                      child: Column(
                        children: [
                          ValueListenableBuilder<LatLng>(
                            valueListenable: _localApontado,
                            child: Text('(Carregando...)'),
                            builder: (context, value, child) {
                              print('[DEBUG] ValueListenableBuilder');
                              if (value != null &&
                                  model.enderecoApontado != null) {
                                model.getEnderecoBD(
                                    value.latitude, value.longitude);
                                Address _endereco = model.enderecoApontado;
                                return Text(
                                    '${model.formatEndereco(_endereco)}');
                              }
                              return Text('(Carregando)');
                            },
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              FlatButton(
                                  onPressed: model.mudaModo,
                                  child: Text('Cancelar')),
                              RaisedButton(
                                onPressed: () => print('aceitar'),
                                child: Text('Aceitar'),
                              ),
                            ],
                          )
                        ],
                      ),
                    )
                  ],
                );
              }),
            )
          : Scaffold(
              appBar: AppBar(
                title: _buildTituloAppbar(),
              ),
              body: ScopedModelDescendant<ModelView>(
                  builder: (context, child, model) {
                return paginas[model.indexPainelPrincipal]['pagina'];
              }),
              drawer: PainelDrawer(widget.mv),
              bottomNavigationBar: ScopedModelDescendant<ModelView>(
                builder: (context, child, model) {
                  return BottomNavigationBar(
                    onTap: model.selecionaPagina,
                    backgroundColor: primaryColor,
                    unselectedItemColor: Colors.white,
                    selectedItemColor: accentColor,
                    currentIndex: model.indexPainelPrincipal,
                    type: BottomNavigationBarType.fixed,
                    items: [
                      _buildNavBarItem('Mapa', Icons.map),
                      _buildNavBarItem('Ocorrências', Icons.warning),
                      _buildNavBarItem('Perfil', Icons.person),
                    ],
                  );
                },
              ),
              floatingActionButton: _buildFloatingButton(),
            ),
    );

    return ScopedModel<ModelView>(
      model: widget.mv,
      child: ScopedModelDescendant<ModelView>(
        builder: (context, child, model) {
          if (model.dbIniciado) {
            return StreamBuilder(
              initialData: PainelCarregamento(),
              stream: FirebaseAuth.instance.authStateChanges(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return PainelCarregamento();
                }
                return paginaPrincipal;
              },
            );
          }
          return PainelCarregamento();
        },
      ),
    );
  }
}
