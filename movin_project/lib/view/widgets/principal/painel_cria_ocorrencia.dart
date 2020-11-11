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
  final ModelView _mv;

  PainelCriaOcorrencia(this._mv);

  @override
  _PainelCriaOcorrenciaState createState() => _PainelCriaOcorrenciaState();
}

class _PainelCriaOcorrenciaState extends State<PainelCriaOcorrencia> {
  gp.GeoPoint _local;
  Address _endereco;
  List<String> _valores = DadosInternos.categorias;
  String _categoria;
  CollectionReference ocorrencias =
      FirebaseFirestore.instance.collection('ocorrencias');
  TextEditingController _tituloController = new TextEditingController();
  TextEditingController _descricaoController = new TextEditingController();
  ValueNotifier<bool> _formularioInvalido = ValueNotifier<bool>(false);

  @override
  void initState() {
    _getLocal();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModel<ModelView>(
      model: widget._mv,
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
                              value: _categoria,
                              items: _valores.map((elemento) {
                                return DropdownMenuItem(
                                  value: elemento,
                                  child: Text(elemento),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  _categoria = value;
                                });
                              },
                            ),
                          ],
                        ),
                        // Descrição
                        TextField(
                          controller: _descricaoController,
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
                                  widget._mv,
                                  widget._mv.enderecoApontadoListenable,
                                );
                              },
                            );
                          },
                          child: ValueListenableBuilder<Address>(
                              valueListenable:
                                  widget._mv.enderecoApontadoListenable,
                              builder: (context, value, child) {
                                if (widget
                                        ._mv.enderecoApontadoListenable.value !=
                                    null) {
                                  _getLocal(
                                    latitude: value.coordinates.latitude,
                                    longitude: value.coordinates.longitude,
                                  );
                                } else {
                                  _getLocal();
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
                                          _endereco == null
                                              ? '(Carregando endereço)'
                                              : '${_endereco.addressLine}',
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
                              onPressed: widget._mv.imgGaleria,
                            ),
                            FlatButton(
                              child: Icon(Icons.add_a_photo, size: 40),
                              onPressed: widget._mv.imgCamera,
                            ),
                          ],
                        ),
                        FlatButton(
                          onPressed: () {
                            for (File imagem in widget._mv.imagens) {
                              widget._mv.uploadImagem(imagem,
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
                  ValueListenableBuilder(
                    valueListenable: _formularioInvalido,
                    builder: (context, value, child) {
                      return _formularioInvalido.value
                          ? Text(
                              'Formulário inválido.',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText2
                                  .copyWith(
                                    color: Colors.redAccent,
                                  ),
                            )
                          : SizedBox();
                    },
                  ),
                  RaisedButton(
                    onPressed: _addOcorrencia,
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

  void _addOcorrencia() {
    if (!_validaFormulario()) {
      _formularioInvalido.value = true;
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Text('Formulário inválido.'),
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
    } else {
      widget._mv.addOcorrencia(
        Ocorrencia(
          descricao: _descricaoController.text,
          categoria: _categoria,
          data: DateTime.now(),
          local: _local,
          idUsuario: FirebaseAuth.instance.currentUser.uid,
          endereco: _endereco,
        ),
      );
      widget._mv.removeLocalApontado();
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
    }
  }

  bool _validaFormulario() {
    print('[debug] validaFormulario');
    if (_descricaoController.value == null ||
        _tituloController.value == null ||
        _endereco == null) {
      print('[debug] validaFormulario false');
      return false;
    }
    print('[debug] validaFormulario true');
    return true;
  }

  /* Functions */
  void _getLocal({double latitude, double longitude}) async {
    if (latitude == null || longitude == null) {
      LocationData localAtual = await Location().getLocation();
      _local = gp.GeoPoint(
        latitude: localAtual.latitude,
        longitude: localAtual.longitude,
      );
    } else {
      _local = gp.GeoPoint(
        latitude: latitude,
        longitude: longitude,
      );
    }

    var _enderecoLocal =
        await widget._mv.getEnderecoBD(_local.latitude, _local.longitude);
    if (this.mounted) {
      setState(() {
        _endereco = _enderecoLocal;
      });
    }
  }

  @override
  void dispose() {
    widget._mv.imagens = [];
    _tituloController.dispose();
    _descricaoController.dispose();
    super.dispose();
  }
}
