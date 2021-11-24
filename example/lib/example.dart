import 'package:flutter/material.dart';
import 'package:vgscardinfo/components/vgs_text_view.dart';
import 'package:vgscardinfo/components/vgscardinfo_view.dart';
import 'package:vgscardinfo/models/vgs_card_info_config.dart';

const VAULT_ID = 'tntzvk50vzt';
const DJAMO_VGS_PATH = '/webhooks/vgs-reveal/card-info';

class ExampleScreen extends StatelessWidget {
  const ExampleScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    VgsCardInfoConfig _vgsCardInfoConfig = VgsCardInfoConfig(
      cvvToken: 'tok_sandbox_poRYXoq3MpgL6VyKetZFWE',
      expiryDateToken: 'tok_sandbox_vYMvd7nXAEYXxX8DDNi1Pa',
      nameToken: 'tok_sandbox_4ormcufWdCVnEWveT79bdx',
      panToken: 'tok_sandbox_bgdYfeHCh5VFsuZM5HVthL',
      vgsPath: DJAMO_VGS_PATH,
      vgsVaultId: VAULT_ID,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text("Djamo VGS Card Info Example"),
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
            TextButton(
              onPressed: () {
                showModalBottomSheet(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                    ),
                    context: context,
                    builder: (_) {
                      return Container(
                        padding: EdgeInsets.symmetric(horizontal: 30),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              margin: EdgeInsets.only(bottom: 15),
                              height: 10,
                              width: 130,
                              color: Colors.grey,
                            ),
                            VgscardInfoView(
                              vgsCardInfoConfig: _vgsCardInfoConfig,
                            ),
                          ],
                        ),
                      );
                    });
              },
              child: Text("Open View"),
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
    );
  }
}
