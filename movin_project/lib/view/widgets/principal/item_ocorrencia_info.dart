import 'dart:io';

import 'package:flutter/material.dart';
import 'package:movin_project/model/ocorrencia.dart';
import 'package:movin_project/model/usuario.dart';
import 'package:movin_project/model_view/model_view.dart';

class ItemOcorrenciaInfo extends StatefulWidget {
  final Ocorrencia ocorrencia;
  final ModelView mv;
  final bool doMapa;

  ItemOcorrenciaInfo(
    this.mv,
    this.ocorrencia,
    this.doMapa,
  );

  @override
  _ItemOcorrenciaInfoState createState() => _ItemOcorrenciaInfoState();
}

class _ItemOcorrenciaInfoState extends State<ItemOcorrenciaInfo> {
  Image imagem;
  bool imagemCarregada = false;
  String _nomeUsuario = '(sem nome)';

  @override
  void initState() {
    carregaDados();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SimpleDialog(
        contentPadding: EdgeInsets.all(10),
        children: [
          Text(
            widget.ocorrencia.categoria,
            style: Theme.of(context).textTheme.headline6.copyWith(fontSize: 40),
            overflow: TextOverflow.fade,
            maxLines: 1,
            softWrap: false,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.mv.formatData(widget.ocorrencia.data),
                style: Theme.of(context)
                    .textTheme
                    .bodyText1
                    .copyWith(fontSize: 18),
              ),
              Text(
                'Autor: \n$_nomeUsuario',
                style: Theme.of(context)
                    .textTheme
                    .bodyText1
                    .copyWith(fontSize: 20),
                overflow: TextOverflow.ellipsis,
                maxLines: 3,
                softWrap: false,
              ),
            ],
          ),
          SizedBox(
            height: 15,
          ),
          Text(
            widget.ocorrencia.descricao,
            style: Theme.of(context).textTheme.bodyText1.copyWith(fontSize: 25),
            overflow: TextOverflow.ellipsis,
            maxLines: 3,
            softWrap: false,
          ),
          widget.doMapa
              ? SizedBox()
              : InkWell(
                  onTap: () => print('Mostrar local no mapa'),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(),
                      borderRadius: BorderRadius.all(Radius.circular(25.0)),
                    ),
                    margin: EdgeInsets.symmetric(vertical: 10),
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: 260,
                          child: Text(
                            widget.mv
                                .formatEndereco(widget.ocorrencia.endereco),
                            style:
                                Theme.of(context).textTheme.bodyText2.copyWith(
                                      fontSize: 20,
                                      color: Colors.grey[600],
                                    ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 3,
                            softWrap: false,
                          ),
                        ),
                        Icon(Icons.location_on),
                      ],
                    ),
                  ),
                ),
          SizedBox(
            height: 15,
          ),
          SizedBox(height: 15),
          Divider(thickness: 1, color: Colors.black),
          Container(
            height: 100,
            child: _mostraImagem(),
          ),
        ],
      ),
    );
  }

  void carregaDados() {
    carregaUsuario();
    downloadImagem();
  }

  void downloadImagem() async {
    Image img = await widget.mv.downloadImagem();
    imagemCarregada = true;

    setState(() {
      imagem = img;
    });
  }

  Widget _mostraImagem() {
    if (imagemCarregada && imagem != null) {
      return imagem;
    } else if (imagemCarregada) {
      return Center(
        child: Text('(Sem Imagem)'),
      );
    } else {
      return Center(child: Text("Carregando Imagem..."));
    }
  }

  void carregaUsuario() async {
    print('[DEBUG] carregaUsuario(${widget.ocorrencia.idUsuario})');
    Usuario _usuario = await widget.mv.getUsuario(widget.ocorrencia.idUsuario);
    if (_usuario == null) {
      print('[ERRO] getAutor = NULL');
    } else {
      setState(() {
        _nomeUsuario = _usuario.nome;
      });
    }
  }
}
