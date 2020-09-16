import 'package:flutter/material.dart';
import 'package:movin_project/views/widgets/login/painel_boas_vindas.dart';
import 'package:movin_project/views/widgets/login/painel_cadastro.dart';
import 'package:movin_project/views/widgets/login/painel_carregamento.dart';
import 'package:movin_project/views/widgets/login/painel_login.dart';

class PaginaLogin extends StatefulWidget {
  static final String nomeRota = '/PaginaLogin';

  @override
  _PaginaLoginState createState() => _PaginaLoginState();
}

class _PaginaLoginState extends State<PaginaLogin> {
  List<Map<String, Object>> _paginas;
  int _indexPaginaSelecionada = 1;

  @override
  void initState() {
    _paginas = [
      {'pagina': PainelCarregamento(), 'titulo': 'Carregamento'},
      {'pagina': PainelBoasVindas(), 'titulo': 'BoasVindas'},
      {'pagina': PainelLogin(), 'titulo': 'Login'},
      {'pagina': PainelCadastro(), 'titulo': 'Cadastro'},
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
    );
  }
}
