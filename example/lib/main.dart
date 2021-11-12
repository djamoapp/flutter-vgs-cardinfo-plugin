import 'package:flutter/material.dart';
import 'package:vgscardinfo/components/vgscardinfo_view.dart';
import 'package:vgscardinfo/components/vgs_text_view.dart';
import 'package:vgscardinfo/models/vgs_card_info_config.dart';

const VAULT_ID = '<vgs_vauld_id>';
const DJAMO_VGS_PATH = '/post';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  VgsCardInfoConfig _vgsCardInfoConfig = VgsCardInfoConfig(
    cvvToken: '<cvvToken>',
    expiryDateToken: '<expiryDateToken>',
    nameToken: '<nameToken>',
    panToken: '<panToken>',
    vgsPath: DJAMO_VGS_PATH,
    vgsVaultId: VAULT_ID,
  );

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Djamo VGS Card Info'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("VgsTextView Example", textScaleFactor: 1.5),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                        margin: EdgeInsets.only(top: 15),
                        width: 180,
                        height: 20,
                        child: VgsTextView(
                          key: Key("<token_key>"),
                          id: "<token_key>",
                          token: "<pan_token>",
                          vaultId: VAULT_ID,
                          path: DJAMO_VGS_PATH,
                        )),
                    Container(
                        width: 80,
                        height: 50,
                        child: InkWell(
                          onTap: () {
                            VgsTextView.copyContent(id: "<token_key>");
                          },
                          child: Icon(Icons.copy_all_outlined),
                        )),
                  ],
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Text(
                "VgscardInfoView Example",
                textScaleFactor: 1.5,
              ),
              Container(
                margin: EdgeInsets.only(top: 15),
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: VgscardInfoView(
                  vgsCardInfoConfig: _vgsCardInfoConfig,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
