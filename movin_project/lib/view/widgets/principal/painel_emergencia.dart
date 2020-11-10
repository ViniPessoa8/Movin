import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class PainelEmergencia extends StatelessWidget {
  static final String nomeRota = '/emergencias';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Números de Emergência'),
        ),
        body: Container(
          padding: EdgeInsets.all(5),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  'Principais números de emergência de Manaus',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headline5.copyWith(
                        fontSize: 28,
                      ),
                ),
                Column(
                  children: [
                    Text(
                      'Polícia Militar: 190',
                      style: Theme.of(context).textTheme.bodyText2.copyWith(
                            fontSize: 20,
                          ),
                    ),
                    Text(
                      'Polícia Civil: 147',
                      style: Theme.of(context).textTheme.bodyText2.copyWith(
                            fontSize: 20,
                          ),
                    ),
                    Text(
                      'Polícia Federal: 3655-1517',
                      style: Theme.of(context).textTheme.bodyText2.copyWith(
                            fontSize: 20,
                          ),
                    ),
                    Text(
                      'Corpo de Bombeiros: 193',
                      style: Theme.of(context).textTheme.bodyText2.copyWith(
                            fontSize: 20,
                          ),
                    ),
                    Text(
                      'Defesa Civil: 199',
                      style: Theme.of(context).textTheme.bodyText2.copyWith(
                            fontSize: 20,
                          ),
                    ),
                    Text(
                      'SAMU: 192',
                      style: Theme.of(context).textTheme.bodyText2.copyWith(
                            fontSize: 20,
                          ),
                    ),
                  ],
                ),
                InkWell(
                  child: Text(
                    'Para mais números de Manaus, clique aqui',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyText2.copyWith(
                          color: Colors.blue,
                          fontSize: 20,
                        ),
                  ),
                  onTap: () {
                    launch(
                        'https://manausonline.com/servicos-telefones-uteis.asp');
                  },
                ),
                // RichText(
                //   textAlign: TextAlign.center,
                //   text: TextSpan(
                //     text: 'Para mais números de Manaus, clique aqui',
                //     style: Theme.of(context).textTheme.bodyText2.copyWith(
                //           color: Colors.blue,
                //           fontSize: 24,
                //         ),
                //     recognizer: TapGestureRecognizer()
                //       ..onTap = () {
                //         _launchURL();
                //       },
                //   ),
                // ),
              ],
            ),
          ),
        ));
  }

  void _launchURL() async {
    const url = 'https://manausonline.com/servicos-telefones-uteis.asp';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
