import 'dart:convert';

class VgsCardInfoConfig {
  final String vgsVaultId;
  final String vgsPath;
  final String nameToken;
  final String panToken;
  final String cvvToken;
  final String environment;
  final String expiryDateToken;
  VgsCardInfoConfig({
    required this.vgsVaultId,
    required this.vgsPath,
    required this.nameToken,
    required this.panToken,
    required this.cvvToken,
    this.environment = 'sandbox',
    required this.expiryDateToken,
  });

  Map<String, dynamic> toMap() {
    return {
      'vgs_vault_id': vgsVaultId,
      'vgs_path': vgsPath,
      'name_token': nameToken,
      'pan_token': panToken,
      'cvv_token': cvvToken,
      'environment': environment,
      'expiry_date_token': expiryDateToken,
    };
  }

  String toJson() => json.encode(toMap());
}
