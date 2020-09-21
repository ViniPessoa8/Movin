import 'package:flutter/material.dart';
import 'package:movin_project/models/ocorrencia.dart';

class ItemOcorrencia extends StatelessWidget {
  final Ocorrencia ocorrencia;

  ItemOcorrencia(this.ocorrencia);

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 200,
      margin: EdgeInsets.symmetric(vertical: 10),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
          border: Border.all(), color: Theme.of(context).accentColor),
      child: FittedBox(
        child: Row(
          children: [
            Icon(
              Icons.warning,
              size: 50,
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Wrap(
                spacing: 2,
                runSpacing: 20,
                direction: Axis.vertical,
                children: [
                  Text(
                    ocorrencia.titulo,
                    style: Theme.of(context)
                        .textTheme
                        .headline6
                        .copyWith(fontSize: 25),
                    overflow: TextOverflow.fade,
                  ),
                  Text(
                    ocorrencia.descricao,
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1
                        .copyWith(fontSize: 20),
                  ),
                  Text(
                    ocorrencia.data.toIso8601String(),
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1
                        .copyWith(fontSize: 20),
                    overflow: TextOverflow.fade,
                    softWrap: true,
                  ),
                  Text(
                    ocorrencia.categoria,
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1
                        .copyWith(fontSize: 20),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
