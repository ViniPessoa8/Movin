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

  Widget _imprimeOcorrencias() {
    if (widget.mv.carregouOcorrencias) {
      if (widget.mv.ocorrencias == null) {
        return Text('ocorrencias null');
      } else if (widget.mv.ocorrencias.isEmpty) {
        return Text('Não há ocorrências');
      }

      return Container(
        child: Stack(
          children: [
            Container(
              child: ListView.builder(
                itemCount: widget.mv.ocorrencias.length,
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                itemBuilder: (context, index) {
                  print(widget.mv.ocorrencias[index].descricao);
                  return ItemOcorrencia(
                    widget.mv,
                    widget.mv.ocorrencias[index],
                  );
                },
              ),
            ),
          ],
        ),
      );
    } else {
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
          child: _imprimeOcorrencias(),
        );
      },
    );
  }
}
