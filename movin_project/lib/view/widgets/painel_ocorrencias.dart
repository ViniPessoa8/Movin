import 'package:flutter/material.dart';
import 'package:loading/indicator/ball_pulse_indicator.dart';
import 'package:movin_project/model_view/model_view.dart';
import 'package:movin_project/view/widgets/item_ocorrencia.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:loading/loading.dart';

class PainelOcorrencias extends StatefulWidget {
  final ModelView mv;

  PainelOcorrencias(this.mv);

  @override
  _PainelOcorrenciasState createState() => _PainelOcorrenciasState();
}

class _PainelOcorrenciasState extends State<PainelOcorrencias> {
  @override
  void initState() {
    // widget.mv.fetchOcorrencias();
    super.initState();
  }

  testeCarregaOcorrencias() {}

  Widget _imprimeOcorrencias(ModelView mv) {
    if (mv.carregouOcorrencias && mv.carregouLocalUsuario) {
      if (mv.ocorrencias == null) {
        return Text('ocorrencias null');
      } else if (mv.ocorrencias.isEmpty) {
        return Container(
          alignment: Alignment.center,
          child: RefreshIndicator(
            onRefresh: mv.atualizaOcorrencias,
            child: ListView.builder(
              itemCount: 1,
              itemBuilder: (ctx, index) {
                return Align(
                  heightFactor: 30.0, // ?
                  child: Text(
                    'Não há ocorrências',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20),
                  ),
                );
              },
            ),
          ),
        );
      }

      return Container(
        child: Stack(
          children: [
            Container(
              child: RefreshIndicator(
                onRefresh: mv.atualizaOcorrencias,
                child: ListView.builder(
                  itemCount: mv.ocorrencias.length,
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                  itemBuilder: (context, index) {
                    print(mv.ocorrencias[index].descricao);
                    return ItemOcorrencia(
                      mv,
                      mv.ocorrencias[index],
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      );
    } else {
      print(
          '${widget.mv.carregouOcorrencias} && ${widget.mv.carregouLocalUsuario}');
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Loading(
              indicator: BallPulseIndicator(),
              size: 50.0,
              color: Theme.of(context).accentColor,
            ),
            Text('Carregando ocorrêncais...'),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<ModelView>(
      builder: (context, child, model) {
        return Center(
          child: _imprimeOcorrencias(model),
        );
      },
    );
  }
}
