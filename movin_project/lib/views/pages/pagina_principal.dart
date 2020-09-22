import 'package:flutter/material.dart';
import 'package:movin_project/utils/dados_internos.dart';
import 'package:movin_project/views/widgets/painel_drawer.dart';
import 'package:movin_project/views/widgets/painel_mapa.dart';
import 'package:movin_project/views/widgets/painel_ocorrencias.dart';
import 'package:movin_project/views/widgets/painel_perfil.dart';

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

  void _selecionaPagina(int index) {
    setState(() {
      _indexPaginaInicial = index;
    });
  }

  BottomNavigationBarItem _buildNavBarItem(String titulo, IconData icone) {
    return BottomNavigationBarItem(
      backgroundColor: Theme.of(context).primaryColor,
      icon: Icon(icone),
      title: Text(titulo),
    );
  }

  @override
  Widget build(BuildContext context) {
    Color primaryColor = Theme.of(context).primaryColor;
    Color accentColor = Theme.of(context).accentColor;

    return Scaffold(
      appBar: AppBar(
        title: Text('Movin'),
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
    );
  }
}
