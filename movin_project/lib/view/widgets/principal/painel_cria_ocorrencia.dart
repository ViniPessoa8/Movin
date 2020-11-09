import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:location/location.dart';
import 'package:movin_project/model/ocorrencia.dart';
import 'package:movin_project/model_view/model_view.dart';
import 'package:movin_project/utils/dados_internos.dart';
import 'package:geopoint/geopoint.dart' as gp;
import 'package:movin_project/view/pages/pagina_selecao_local.dart';
import 'package:scoped_model/scoped_model.dart';

class PainelCriaOcorrencia extends StatefulWidget {
  static String nomeRota = '/ocorrencia/criar';
  final ModelView mv;

  PainelCriaOcorrencia(this.mv);

  @override
  _PainelCriaOcorrenciaState createState() => _PainelCriaOcorrenciaState();
}

class _PainelCriaOcorrenciaState extends State<PainelCriaOcorrencia> {
  gp.GeoPoint local;
  Address endereco;
  List<String> valores = DadosInternos.categorias;
  String categoria;
  CollectionReference ocorrencias =
      FirebaseFirestore.instance.collection('ocorrencias');
  TextEditingController tituloController = new TextEditingController();
  TextEditingController descricaoController = new TextEditingController();

  @override
  void initState() {
    getLocal();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModel<ModelView>(
      model: widget.mv,
      child: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(10),
          child: Column(
            children: [
              Text(
                'Criar Ocorrência',
                style: Theme.of(context).textTheme.headline6,
              ),
              Divider(
                color: Colors.black,
              ),
              Column(
                children: [
                  Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Categoria
                            DropdownButton<String>(
                              autofocus: true,
                              hint: Text(
                                'Selecione a Categoria',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1
                                    .copyWith(
                                      fontSize: 20,
                                    ),
                              ),
                              value: categoria,
                              items: valores.map((elemento) {
                                return DropdownMenuItem(
                                  value: elemento,
                                  child: Text(elemento),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  categoria = value;
                                });
                              },
                            ),
                          ],
                        ),
                        // Descrição
                        TextField(
                          controller: descricaoController,
                          decoration: InputDecoration(
                            labelText: 'Descrição',
                            labelStyle:
                                Theme.of(context).textTheme.bodyText1.copyWith(
                                      color: Colors.black54,
                                      fontSize: 20,
                                    ),
                          ),
                        ),
                        // Localização
                        FlatButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return PaginaSelecaoLocal(
                                    widget.mv,
                                    widget.mv.enderecoApontadoListenable,
                                    widget.mv.paineisPrincipais);
                              },
                            );
                          },
                          child: ValueListenableBuilder<Address>(
                              valueListenable:
                                  widget.mv.enderecoApontadoListenable,
                              builder: (context, value, child) {
                                if (widget
                                        .mv.enderecoApontadoListenable.value !=
                                    null) {
                                  getLocal(
                                    latitude: value.coordinates.latitude,
                                    longitude: value.coordinates.longitude,
                                  );
                                } else {
                                  getLocal();
                                }

                                return Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(),
                                  ),
                                  margin: EdgeInsets.all(10),
                                  padding: EdgeInsets.all(10),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Container(
                                        child: Icon(Icons.add_location),
                                      ),
                                      Container(
                                        width: 260,
                                        child: Text(
                                          endereco == null
                                              ? '(Carregando endereço)'
                                              : '${endereco.addressLine}',
                                          overflow: TextOverflow.clip,
                                          maxLines: 2,
                                          softWrap: true,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText1
                                              .copyWith(
                                                fontSize: 20,
                                              ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }),
                        ),
                        Divider(
                          height: 1,
                          color: Colors.black,
                        ),
                        ScopedModelDescendant<ModelView>(
                          builder: (context, child, model) {
                            return Container(
                              margin: EdgeInsets.symmetric(vertical: 20),
                              child: model.imagens.isEmpty
                                  ? Text(
                                      '(Sem imagens)',
                                      style:
                                          Theme.of(context).textTheme.headline6,
                                    )
                                  : Container(
                                      width: 300,
                                      height: 100,
                                      child: Center(
                                        child: ListView.builder(
                                          shrinkWrap: true,
                                          scrollDirection: Axis.horizontal,
                                          itemCount: model.imagens.length,
                                          itemBuilder: (context, index) {
                                            return Container(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 5),
                                              child: InkWell(
                                                onTap: () {
                                                  showDialog(
                                                    context: context,
                                                    builder: (context) {
                                                      return Container(
                                                        child: Image.file(
                                                          model.imagens[index],
                                                          height: 400,
                                                          width: 300,
                                                          fit: BoxFit.contain,
                                                        ),
                                                      );
                                                    },
                                                  );
                                                },
                                                child: Image.file(
                                                  model.imagens[index],
                                                  height: 80,
                                                  width: 80,
                                                  fit: BoxFit.fitHeight,
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                            );
                          },
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            FlatButton(
                              child: Icon(Icons.image, size: 40),
                              onPressed: widget.mv.imgGaleria,
                            ),
                            FlatButton(
                              child: Icon(Icons.add_a_photo, size: 40),
                              onPressed: widget.mv.imgCamera,
                            ),
                          ],
                        ),
                        FlatButton(
                          onPressed: () {
                            for (File imagem in widget.mv.imagens) {
                              widget.mv.uploadImagem(imagem,
                                  'imagens/ocorrencias/${imagem.hashCode}.jpg');
                            }
                          },
                          child: Text('Enviar imagem'),
                        ),
                      ],
                    ),
                  ),
                  Divider(
                    height: 1,
                    color: Colors.black,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  RaisedButton(
                    onPressed: () {
                      widget.mv.addOcorrencia(
                        Ocorrencia(
                          descricao: descricaoController.text,
                          categoria: categoria,
                          data: DateTime.now(),
                          local: local,
                          idUsuario: FirebaseAuth.instance.currentUser.uid,
                          endereco: endereco,
                        ),
                      );
                      widget.mv.removeLocalApontado();
                      Navigator.of(context).pop();
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            content: Text('Ocorrência criada com sucesso.'),
                            actions: [
                              RaisedButton(
                                child: Text('OK'),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              )
                            ],
                          );
                        },
                      );
                    },
                    child: Text(
                      'Criar Ocorrência',
                      style: Theme.of(context).textTheme.bodyText1.copyWith(
                            fontSize: 25,
                          ),
                    ),
                  ),
                  FlatButton(
                    onPressed: () {
                      if (Navigator.of(context).canPop())
                        Navigator.of(context).pop();
                    },
                    child: Text(
                      'Cancelar',
                      style: Theme.of(context)
                          .textTheme
                          .bodyText2
                          .copyWith(color: Colors.red[200]),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /* Functions */
  getLocal({double latitude, double longitude}) async {
    if (latitude == null || longitude == null) {
      LocationData localAtual = await Location().getLocation();
      local = gp.GeoPoint(
        latitude: localAtual.latitude,
        longitude: localAtual.longitude,
      );
    } else {
      local = gp.GeoPoint(
        latitude: latitude,
        longitude: longitude,
      );
    }

    var _endereco =
        await widget.mv.getEnderecoBD(local.latitude, local.longitude);
    if (this.mounted) {
      setState(() {
        endereco = _endereco;
      });
    }
  }

  @override
  void dispose() {
    widget.mv.imagens = [];
    tituloController.dispose();
    descricaoController.dispose();
    super.dispose();
  }
}
