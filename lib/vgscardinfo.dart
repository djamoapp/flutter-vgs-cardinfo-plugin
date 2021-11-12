import 'package:flutter/services.dart';
import 'package:vgscardinfo/constants.dart';

class VgscardInfo {
  static const MethodChannel _channel =
      const MethodChannel(vgsCardInfoViewType);

  static Future<String?> get platformVersion async {
    final String? version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
}
