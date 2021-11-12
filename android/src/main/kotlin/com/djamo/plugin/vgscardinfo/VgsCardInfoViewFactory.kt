package com.djamo.plugin.vgscardinfo

import android.content.Context
import android.util.Log
import io.flutter.plugin.common.StandardMessageCodec
import io.flutter.plugin.platform.PlatformView
import io.flutter.plugin.platform.PlatformViewFactory

class VgsCardInfoViewFactory :  PlatformViewFactory(StandardMessageCodec.INSTANCE) {
    override fun create(context: Context, viewId: Int, args: Any?): PlatformView {
        val creationParams = args as Map<String?, Any?>?
        Log.d("creationParams" ,creationParams.toString())
        return VsCardInfoView(context, viewId, creationParams)
    }
}