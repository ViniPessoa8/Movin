import 'package:flutter/material.dart';
import 'package:movin_project/model_view/model_view.dart';
import 'package:movin_project/view/widgets/filter_box.dart';
import 'package:movin_project/view/widgets/painel_drawer.dart';
import 'package:movin_project/view/widgets/painel_mapa.dart';
import 'package:movin_project/view/widgets/painel_ocorrencias.dart';
import 'package:movin_project/view/widgets/painel_perfil.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:movin_project/view/widgets/painel_cria_ocorrencia.dart';
import 'package:scoped_model/scoped_model.dart';

class PaginaPrincipal extends StatefulWidget {
  static final nomeRota = '/principal';
  final ModelView mv;

  PaginaPrincipal(this.mv);

  @override
  _PaginaPrincipalState createState() => _PaginaPrincipalState();
}

class _PaginaPrincipalState extends State<PaginaPrincipal> {
  List<Map<String, Object>> paginas;

  @override
  void initState() {
    paginas = [
      {
        'pagina': PainelMapa(),
        'titulo': 'Mapa',
      },
      {
        'pagina': PainelOcorrencias(context, widget.mv),
        'titulo': 'Ocorrências',
      },
      {
        'pagina': PainelPerfil(),
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
    if (widget.mv.indexPainelPrincipal == 0) return _buildBotaoMapa();
    if (widget.mv.indexPainelPrincipal == 1) return _buildBotaoOcorrencias();
    return SpeedDial(
      visible: false,
    );
  }

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

  void _buildFilterBox() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: SingleChildScrollView(
            child: FilterBox(context, widget.mv),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Color primaryColor = Theme.of(context).primaryColor;
    Color accentColor = Theme.of(context).accentColor;

    return ScopedModel<ModelView>(
      model: widget.mv,
      child: Scaffold(
        appBar: AppBar(
          title: _buildTituloAppbar(),
          actions: [
            widget.mv.indexPainelPrincipal == 1
                ? ScopedModelDescendant<ModelView>(
                    builder: (context, child, model) {
                    return IconButton(
                        icon: Icon(Icons.filter), onPressed: _buildFilterBox);
                  })
                : IconButton(
                    icon: Icon(null),
                    onPressed: null,
                  )
          ],
        ),
        body:
            ScopedModelDescendant<ModelView>(builder: (context, child, model) {
          return paginas[model.indexPainelPrincipal]['pagina'];
        }),
        drawer: PainelDrawer(),
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
  }
}
