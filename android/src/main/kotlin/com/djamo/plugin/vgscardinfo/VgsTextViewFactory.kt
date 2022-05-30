package com.djamo.plugin.vgscardinfo
import android.content.Context
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.StandardMessageCodec
import io.flutter.plugin.platform.PlatformView
import io.flutter.plugin.platform.PlatformViewFactory

class VgsTextViewFactory(private val messenger: BinaryMessenger? = null) :
        PlatformViewFactory(StandardMessageCodec.INSTANCE) {

    override fun create(context: Context?, id: Int, args: Any?): PlatformView {
        val vgsParams = args as Map<String?, Any?>?
        return VgsTextView(context, messenger, id, vgsParams)
    }
}