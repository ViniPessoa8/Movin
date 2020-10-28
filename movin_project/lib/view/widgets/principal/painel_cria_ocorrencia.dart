import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';
import 'package:movin_project/model/ocorrencia.dart';
import 'package:movin_project/model_view/model_view.dart';
import 'package:movin_project/utils/dados_internos.dart';
import 'package:geopoint/geopoint.dart' as gp;
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

  getLocal({double latitude, double longitude}) async {
    LocationData localAtual = await Location().getLocation();
    if (latitude == null || longitude == null) {
      local = gp.GeoPoint(
        latitude: localAtual.latitude,
        longitude: localAtual.longitude,
      );

      var _endereco = await widget.mv.getEnderecoBD(local.latitude, longitude);
      setState(() {
        endereco = _endereco;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // getLocal();
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
                            DropdownButton<String>(
                              autofocus: true,
                              hint: Text('Selecione a Categoria'),
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
                        TextField(
                          controller: descricaoController,
                          decoration: InputDecoration(
                            labelText: 'Descrição',
                            labelStyle:
                                Theme.of(context).textTheme.bodyText1.copyWith(
                                      color: Colors.black54,
                                    ),
                          ),
                        ),
                        FlatButton(
                          onPressed: null,
                          child: Row(
                            children: [
                              Icon(Icons.add_location),
                              Text('Adicionar Localização'),
                            ],
                          ),
                        ),
                        ScopedModelDescendant<ModelView>(
                          builder: (context, child, model) {
                            return Container(
                              margin: EdgeInsets.symmetric(vertical: 20),
                              child: widget.mv.imagens.isEmpty
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
                                          itemCount: widget.mv.imagens.length,
                                          itemBuilder: (context, index) {
                                            return Container(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 5),
                                              child: Image.file(
                                                widget.mv.imagens[index],
                                                height: 80,
                                                width: 80,
                                                fit: BoxFit.fitHeight,
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
                              widget.mv.uploadImagem(imagem);
                            }
                          },
                          child: Text('Enviar imagem'),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  RaisedButton(
                    onPressed: () {
                      widget.mv.addOcorrencia(Ocorrencia(
                        descricao: descricaoController.text,
                        categoria: categoria,
                        data: DateTime.now(),
                        local: local,
                        idAutor: FirebaseAuth.instance.currentUser.uid,
                        endereco: endereco,
                      ));
                      widget.mv.atualizaOcorrencias();
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
                    child: Text('Criar Ocorrência'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
