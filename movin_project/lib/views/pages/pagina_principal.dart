import 'package:flutter/material.dart';
import 'package:movin_project/views/widgets/painel_drawer.dart';
import 'package:movin_project/views/widgets/painel_mapa.dart';
import 'package:movin_project/views/widgets/painel_ocorrencias.dart';
import 'package:movin_project/views/widgets/painel_perfil.dart';

class PaginaPrincipal extends StatefulWidget {
  @override
  _PaginaPrincipalState createState() => _PaginaPrincipalState();
}

class _PaginaPrincipalState extends State<PaginaPrincipal> {
  List<Map<String, Object>> _paginas;
  int _indexPaginaSelecionada = 0;

  @override
  void initState() {
    _paginas = [
      {'pagina': PainelMapa(), 'titulo': 'Mapa'},
      {'pagina': PainelOcorrencias(), 'titulo': 'Ocorrências'},
      {'pagina': PainelPerfil(), 'titulo': 'Perfil'},
    ];
    super.initState();
  }

  void _selecionaPagina(int index) {
    setState(() {
      _indexPaginaSelecionada = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    Color primaryColor = Theme.of(context).primaryColor;
    Color accentColor = Theme.of(context).accentColor;

    return Scaffold(
      appBar: AppBar(
        title: Text('Movin'),
      ),
      body: _paginas[_indexPaginaSelecionada]['pagina'],
      drawer: PainelDrawer(),
      bottomNavigationBar: BottomNavigationBar(
        onTap: _selecionaPagina,
        backgroundColor: primaryColor,
        unselectedItemColor: Colors.white,
        selectedItemColor: accentColor,
        currentIndex: _indexPaginaSelecionada,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            backgroundColor: primaryColor,
            icon: Icon(Icons.map),
            title: Text('Mapa'),
          ),
          BottomNavigationBarItem(
            backgroundColor: primaryColor,
            icon: Icon(Icons.warning),
            title: Text('Ocorrências'),
          ),
          BottomNavigationBarItem(
            backgroundColor: primaryColor,
            icon: Icon(Icons.person),
            title: Text('Perfil'),
          )
        ],
      ),
    );
  }
}
