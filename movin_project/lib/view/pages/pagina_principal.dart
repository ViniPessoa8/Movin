import 'package:flutter/material.dart';
import 'package:movin_project/utils/dados_internos.dart';
import 'package:movin_project/view/widgets/painel_drawer.dart';
import 'package:movin_project/view/widgets/painel_mapa.dart';
import 'package:movin_project/view/widgets/painel_ocorrencias.dart';
import 'package:movin_project/view/widgets/painel_perfil.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:movin_project/view/widgets/painel_cria_ocorrencia.dart';

class PaginaPrincipal extends StatefulWidget {
  static final nomeRota = '/principal';
  final int indexPainelInicial;

  PaginaPrincipal({this.indexPainelInicial = 0});

  @override
  _PaginaPrincipalState createState() => _PaginaPrincipalState();
}

class _PaginaPrincipalState extends State<PaginaPrincipal> {
  List<Map<String, Object>> _paginas;
  int _indexPaginaInicial;

  @override
  void initState() {
    _indexPaginaInicial = widget.indexPainelInicial;
    _paginas = [
      {
        'pagina': PainelMapa(),
        'titulo': 'Mapa',
      },
      {
        'pagina': PainelOcorrencias(DadosInternos.OCORRENCIAS_EXEMPLO),
        'titulo': 'Ocorrências',
      },
      {
        'pagina': PainelPerfil(),
        'titulo': 'Perfil',
      },
    ];
    super.initState();
  }

  // Métodos
  void _mostraCriaOcorrencia(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return PainelCriaOcorrencia();
      },
    );
  }

  void _selecionaPagina(int index) {
    setState(() {
      _indexPaginaInicial = index;
    });
  }

  void criaOcorrencia() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return PainelCriaOcorrencia();
      },
    );
  }

  // Builders
  BottomNavigationBarItem _buildNavBarItem(String titulo, IconData icone) {
    return BottomNavigationBarItem(
      backgroundColor: Theme.of(context).primaryColor,
      icon: Icon(
        icone,
        size: 35,
      ),
      title: Text(titulo),
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
            Icons.filter,
            color: Colors.white,
          ),
          label: 'Filtro',
          backgroundColor: Colors.purple,
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
    if (_indexPaginaInicial == 0) return _buildBotaoMapa();
    if (_indexPaginaInicial == 1) return _buildBotaoOcorrencias();
    return SpeedDial(
      visible: false,
    );
  }

  Widget _buildTituloAppbar() {
    String texto;

    switch (_indexPaginaInicial) {
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

  @override
  Widget build(BuildContext context) {
    Color primaryColor = Theme.of(context).primaryColor;
    Color accentColor = Theme.of(context).accentColor;

    return Scaffold(
      appBar: AppBar(
        title: _buildTituloAppbar(),
      ),
      body: _paginas[_indexPaginaInicial]['pagina'],
      drawer: PainelDrawer(),
      bottomNavigationBar: BottomNavigationBar(
        onTap: _selecionaPagina,
        backgroundColor: primaryColor,
        unselectedItemColor: Colors.white,
        selectedItemColor: accentColor,
        currentIndex: _indexPaginaInicial,
        type: BottomNavigationBarType.fixed,
        items: [
          _buildNavBarItem('Mapa', Icons.map),
          _buildNavBarItem('Ocorrências', Icons.warning),
          _buildNavBarItem('Perfil', Icons.person),
        ],
      ),
      floatingActionButton: _buildFloatingButton(),
    );
  }
}
