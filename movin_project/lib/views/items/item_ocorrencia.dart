import 'package:flutter/material.dart';
import 'package:movin_project/models/ocorrencia.dart';
import 'package:intl/intl.dart';

class ItemOcorrencia extends StatelessWidget {
  final Ocorrencia ocorrencia;
  final DateFormat formatadorData = DateFormat('dd/MM/yyyy');

  ItemOcorrencia(this.ocorrencia);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 130,
      margin: EdgeInsets.symmetric(vertical: 10),
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
        border: Border.all(),
        borderRadius: BorderRadius.circular(10.0),
        color: Theme.of(context).accentColor,
      ),
      child: Row(
        children: [
          Icon(
            Icons.warning,
            size: 50,
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: 269,
                maxHeight: 100,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    ocorrencia.titulo,
                    style: Theme.of(context).textTheme.headline6.copyWith(
                          fontSize: 25,
                        ),
                    overflow: TextOverflow.fade,
                    maxLines: 1,
                    softWrap: false,
                  ),
                  Text(
                    ocorrencia.descricao,
                    style: Theme.of(context).textTheme.bodyText1.copyWith(
                          fontSize: 20,
                        ),
                    overflow: TextOverflow.fade,
                    maxLines: 1,
                    softWrap: false,
                  ),
                  Text(
                    formatadorData.format(ocorrencia.data),
                    style: Theme.of(context).textTheme.bodyText1.copyWith(
                          fontSize: 20,
                        ),
                    overflow: TextOverflow.fade,
                    maxLines: 1,
                    softWrap: false,
                  ),
                  Text(
                    ocorrencia.categoria,
                    style: Theme.of(context).textTheme.bodyText1.copyWith(
                          fontSize: 20,
                        ),
                    overflow: TextOverflow.fade,
                    maxLines: 1,
                    softWrap: false,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
