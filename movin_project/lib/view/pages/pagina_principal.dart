import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:movin_project/model_view/model_view.dart';
import 'package:movin_project/utils/pagina_selecao_argumentos.dart';
import 'package:movin_project/view/pages/pagina_selecao_local.dart';
import 'package:movin_project/view/widgets/login/painel_carregamento.dart';
import 'package:movin_project/view/widgets/principal/painel_drawer.dart';
import 'package:movin_project/view/widgets/principal/painel_mapa.dart';
import 'package:movin_project/view/widgets/principal/painel_ocorrencias.dart';
import 'package:movin_project/view/widgets/principal/painel_perfil.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:movin_project/view/widgets/principal/painel_cria_ocorrencia.dart';
import 'package:movin_project/view/widgets/principal/selecao_local_box.dart';
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
  // List<Map<String, Object>> paineisPrincipais;
  ValueNotifier<Address> _enderecoApontado;
  Color primaryColor;
  Color accentColor;

  @override
  void didChangeDependencies() {
    // Cores
    primaryColor = Theme.of(context).primaryColor;
    accentColor = Theme.of(context).accentColor;

    // Endereço escolhido pelo usuario
    _enderecoApontado = widget.mv.enderecoApontadoListenable;

    // Paineis da página principal (Mapa, Ocorrencias e Perfil)
    widget.mv.paineisPrincipais = [
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
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.mv.deslogado) {
      // Remove a tela de login quando o usuário realiza o login
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context).pop();
        widget.mv.deslogado = false;
      });
    }

    final paginaPrincipal = DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(title: _buildTituloAppbar()),
        drawer: PainelDrawer(widget.mv),
        body: TabBarView(
          physics: NeverScrollableScrollPhysics(),
          children: widget.mv.paineisPrincipais.map((tab) {
            return Container(
              height: 300,
              child: Center(
                child: tab['pagina'],
              ),
            );
          }).toList(),
        ),
        bottomNavigationBar: Container(
          color: Theme.of(context).primaryColor,
          child: TabBar(
            // physics: NeverScrollableScrollPhysics(),
            dragStartBehavior: DragStartBehavior.down,
            onTap: (value) {
              widget.mv.selecionaPagina(value);
              print(
                  '[DEBUG] widget.mv.indexPainelPrincipal = ${widget.mv.indexPainelPrincipal}');
            },
            labelColor: Theme.of(context).accentColor,
            unselectedLabelColor: Colors.black,
            tabs: [
              Tab(
                icon: Icon(Icons.map),
                text: 'Mapa',
              ),
              Tab(
                icon: Icon(Icons.warning),
                text: 'Ocorrências',
              ),
              Tab(
                icon: Icon(Icons.person, size: 40),
                text: 'Perfil',
              ),
            ],
            labelStyle:
                Theme.of(context).textTheme.bodyText2.copyWith(fontSize: 17),
          ),
        ),
        floatingActionButton: _buildFloatingButton(),
      ),
      initialIndex: 0,
    );

    // final paginaPrincipal = ScopedModel<ModelView>(
    //   model: widget.mv,
    //   child: Scaffold(
    //     appBar: AppBar(
    //       title: _buildTituloAppbar(),
    //     ),
    //     body:
    //         ScopedModelDescendant<ModelView>(builder: (context, child, model) {
    //       // Painel
    //       return widget.mv.paineisPrincipais[model.indexPainelPrincipal]
    //           ['pagina'];
    //     }),
    //     drawer: PainelDrawer(widget.mv),
    //     bottomNavigationBar: ScopedModelDescendant<ModelView>(
    //       builder: (context, child, model) {
    //         // Barra de navegação inferior
    //         return BottomNavigationBar(
    //           onTap: model.selecionaPagina,
    //           backgroundColor: primaryColor,
    //           unselectedItemColor: Colors.white,
    //           selectedItemColor: accentColor,
    //           currentIndex: model.indexPainelPrincipal,
    //           type: BottomNavigationBarType.fixed,
    //           items: [
    //             _buildNavBarItem('Mapa', Icons.map),
    //             _buildNavBarItem('Ocorrências', Icons.warning),
    //             _buildNavBarItem('Perfil', Icons.person),
    //           ],
    //         );
    //       },
    //     ),
    //     floatingActionButton: _buildFloatingButton(),
    //   ),
    // );

    return ScopedModel<ModelView>(
      model: widget.mv,
      child: ScopedModelDescendant<ModelView>(
        builder: (context, child, model) {
          if (model.dbIniciado) {
            return StreamBuilder(
              // Verifica se o usuário está logado
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

  /* Functions */

  // Carrega o endereço de determinado local em LatLng na variavel _enderecoApontado
  void getEndereco(LatLng local) async {
    Address _retorno = await widget.mv.getEnderecoBD(
      local.latitude,
      local.longitude,
    );
    setState(() {
      _enderecoApontado.value = _retorno;
    });
  }

  /* Showers */

  // Mostra pagina de seleção de local
  void _showPaginaSelecao() {
    print('[DEBUG] _showPaginaSelecao()');
    print(
        '[DEBUG] _showPaginaSelecao() widget.mv.enderecoApontadoListenable = ${widget.mv.enderecoApontadoListenable}');
    print(
        '[DEBUG] _showPaginaSelecao() widget.mv.enderecoApontadoListenable.value = ${widget.mv.enderecoApontadoListenable.value}');

    Navigator.of(context).pushNamed(
      PaginaSelecaoLocal.nomeRota,
      arguments: PaginaSelecaoArgumentos(
        widget.mv,
        widget.mv.enderecoApontadoListenable,
        widget.mv.paineisPrincipais,
      ),
    );
    PaginaSelecaoLocal(
        widget.mv, _enderecoApontado, widget.mv.paineisPrincipais);
  }

  // Mostra o diálogo de criação de ocorrência
  void _showCriaOcorrencia(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return PainelCriaOcorrencia(widget.mv);
      },
    );
  }

  // Mostra painel das informações de uma ocorrência
  void _showPainelOcorrencia() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return PainelCriaOcorrencia(widget.mv);
      },
    );
  }

  /* Builders */

  // Retorna o item do menu de navegação inferior
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

  // Retorna o botão flutuante do painel do mapa
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
          onTap: _showPainelOcorrencia,
        ),
        SpeedDialChild(
          child: Icon(
            Icons.warning,
            color: Colors.white,
          ),
          label: 'Teste',
          backgroundColor: Colors.purple,
          onTap: _showPaginaSelecao, //widget.mv.mudaModo,
        ),
      ],
    );
  }

  // Retorna o botão flutuante do painel de ocorrencias
  Widget _buildBotaoOcorrencias() {
    return FloatingActionButton(
      onPressed: () {
        _showCriaOcorrencia(context);
      },
      child: Icon(
        Icons.add,
        size: 30,
        color: Colors.white,
      ),
      backgroundColor: Theme.of(context).primaryColor,
    );
  }

  // Retorna o botão flutuante
  Widget _buildFloatingButton() {
    return ValueListenableBuilder(
      valueListenable: widget.mv.indexPainelPrincipalListenable,
      child: SpeedDial(
        visible: false,
      ),
      builder: (context, value, child) {
        if (value == 0) return _buildBotaoMapa();
        if (value == 1) return _buildBotaoOcorrencias();
        return SpeedDial(
          visible: false,
        );
      },
    );
  }

  // Retorna o título a ser usado no AppBar
  Widget _buildTituloAppbar() {
    String texto;
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
    return Text(texto);
  }
}
