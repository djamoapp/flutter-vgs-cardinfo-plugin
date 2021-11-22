import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:vgscardinfo/models/vgs_card_info_config.dart';

import '../constants.dart';

class VgscardInfoView extends StatelessWidget {
  final VgsCardInfoConfig vgsCardInfoConfig;
  final double viewHeight;
  const VgscardInfoView({
    Key? key,
    required this.vgsCardInfoConfig,
    this.viewHeight = 190,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: this.viewHeight,
      child: _showVgsInfoWidget(),
    );
  }

  Widget _showVgsInfoWidget() {
    // Pass parameters to the platform side.
    final Map<String, dynamic> creationParams = this.vgsCardInfoConfig.toMap();

    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return _vgsCardInfoWidgetAndroid(creationParams);
      case TargetPlatform.iOS:
        return _vgsCardInfoWidgetiOS(creationParams);
      default:
        throw UnsupportedError("Unsupported platform view");
    }
  }

  Widget _vgsCardInfoWidgetiOS(Map<String, dynamic> creationParams) {
    // This is used in the platform side to register the view.
    final String viewType = vgsCardInfoViewType;

    return UiKitView(
      viewType: viewType,
      layoutDirection: TextDirection.ltr,
      creationParams: creationParams,
      creationParamsCodec: const StandardMessageCodec(),
    );
  }

  Widget _vgsCardInfoWidgetAndroid(Map<String, dynamic> creationParams) {
    final String viewType = vgsCardInfoViewType;

    return PlatformViewLink(
      viewType: viewType,
      surfaceFactory:
          (BuildContext context, PlatformViewController controller) {
        return AndroidViewSurface(
          controller: controller as AndroidViewController,
          gestureRecognizers: const <Factory<OneSequenceGestureRecognizer>>{},
          hitTestBehavior: PlatformViewHitTestBehavior.opaque,
        );
      },
      onCreatePlatformView: (PlatformViewCreationParams params) {
        return PlatformViewsService.initSurfaceAndroidView(
          id: params.id,
          viewType: viewType,
          layoutDirection: TextDirection.ltr,
          creationParams: creationParams,
          creationParamsCodec: StandardMessageCodec(),
          onFocus: () {
            params.onFocusChanged(true);
          },
        )
          ..addOnPlatformViewCreatedListener(params.onPlatformViewCreated)
          ..create();
      },
    );
  }
}
