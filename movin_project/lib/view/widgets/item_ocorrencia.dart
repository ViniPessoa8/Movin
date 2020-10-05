import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:movin_project/model/ocorrencia.dart';
import 'package:intl/intl.dart';
import 'package:movin_project/model_view/model_view.dart';

class ItemOcorrencia extends StatefulWidget {
  final Ocorrencia ocorrencia;
  final ModelView mv;

  ItemOcorrencia(this.mv, this.ocorrencia);

  @override
  _ItemOcorrenciaState createState() => _ItemOcorrenciaState();
}

class _ItemOcorrenciaState extends State<ItemOcorrencia> {
  final DateFormat formatadorData = DateFormat('dd/MM/yyyy');

  Address endereco;

  @override
  void initState() {
    carregaEndereco();
    super.initState();
  }

  carregaEndereco() async {
    print('carregaEndereco()');
    double latitude = widget.ocorrencia.local.latitude;
    double longitude = widget.ocorrencia.local.longitude;

    Address localEnd = await widget.mv.fc.fetchEndereco(latitude, longitude);
    setState(() {
      endereco = localEnd;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      padding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
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
                    widget.ocorrencia.categoria,
                    style: Theme.of(context).textTheme.headline6.copyWith(
                          fontSize: 25,
                        ),
                    overflow: TextOverflow.fade,
                    maxLines: 1,
                    softWrap: false,
                  ),
                  Text(
                    widget.ocorrencia.descricao,
                    style: Theme.of(context).textTheme.bodyText1.copyWith(
                          fontSize: 20,
                        ),
                    overflow: TextOverflow.fade,
                    maxLines: 1,
                    softWrap: false,
                  ),
                  Text(
                    formatadorData.format(widget.ocorrencia.data),
                    style: Theme.of(context).textTheme.bodyText1.copyWith(
                          fontSize: 20,
                        ),
                    overflow: TextOverflow.fade,
                    maxLines: 1,
                    softWrap: false,
                  ),
                  Text(
                    endereco == null
                        ? '(Sem Endereço)'
                        : widget.mv.formatEndereco(endereco),
                    style: Theme.of(context).textTheme.bodyText1.copyWith(
                          fontSize: 17,
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
