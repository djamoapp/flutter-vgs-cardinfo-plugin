package com.djamo.plugin.vgscardinfo

import android.content.Context
import android.util.Log
import android.view.View
import com.verygoodsecurity.vgsshow.VGSShow
import com.verygoodsecurity.vgsshow.core.VGSEnvironment
import com.verygoodsecurity.vgsshow.core.network.client.VGSHttpMethod
import com.verygoodsecurity.vgsshow.core.network.model.VGSRequest
import com.verygoodsecurity.vgsshow.widget.VGSTextView
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.platform.PlatformView
import android.graphics.Color

internal class VgsTextView(
        context: Context,
        messenger: BinaryMessenger?,
        id: Int,
        vgsParams: Map<String?, Any?>?
) : PlatformView, MethodCallHandler {
    var vaultId = vgsParams!!.get("vaultId")!!.toString()
    var environment = vgsParams!!.get("environment")!!.toString()
    var path = vgsParams!!.get("path")!!.toString()
    var fieldId = vgsParams!!.get("id")!!.toString()

    private val vgsShow: VGSShow =
            VGSShow.Builder(context, vaultId)
                    .setEnvironment(
                            if (environment == "live") VGSEnvironment.Live()
                            else VGSEnvironment.Sandbox()
                    )
                    .build()
    private val vgsTextView: VGSTextView

    protected val methodChannel =
            MethodChannel(
                    messenger,
                    "vgstextview_$fieldId".also { Log.d("Test", it) }
            )

    override fun getView(): View {
        return vgsTextView
    }

    override fun dispose() {
        vgsShow.onDestroy()
    }

    init {
        var id = vgsParams!!.get("id")!!.toString()
        vgsTextView = VGSTextView(context)
        vgsTextView.setContentPath(id)
        vgsTextView.setHint("...")
        vgsTextView.setBackgroundColor(Color.parseColor("#ffffff"));
        //vgsTextView.setHintTextColor(Color.rgb(255, 255, 255))

        if(id == "pan"){
            // format data in 'XXXX XXXX XXXX XXXX' format
            vgsTextView.addTransformationRegex("(\\d{4})(\\d{4})(\\d{4})(\\d{4})".toRegex(), "$1 $2 $3 $4")
        }
        else if (id == "expireDate"){
            // format data in 'DD/YY' format
            vgsTextView.addTransformationRegex("(\\bJAN\\b)".toRegex(),"01")
            vgsTextView.addTransformationRegex("(\\bFEB\\b)".toRegex(),"02")
            vgsTextView.addTransformationRegex("(\\bMAR\\b)".toRegex(),"03")
            vgsTextView.addTransformationRegex("(\\bAPR\\b)".toRegex(),"04")
            vgsTextView.addTransformationRegex("(\\bMAY\\b)".toRegex(),"05")
            vgsTextView.addTransformationRegex("(\\bJUN\\b)".toRegex(),"06")
            vgsTextView.addTransformationRegex("(\\bJUL\\b)".toRegex(),"07")
            vgsTextView.addTransformationRegex("(\\bAUG\\b)".toRegex(),"08")
            vgsTextView.addTransformationRegex("(\\bSEP\\b)".toRegex(),"09")
            vgsTextView.addTransformationRegex("(\\bOCT\\b)".toRegex(),"10")
            vgsTextView.addTransformationRegex("(\\bNOV\\b)".toRegex(),"11")
            vgsTextView.addTransformationRegex("(\\bDEC\\b)".toRegex(),"12")
            vgsTextView.addTransformationRegex("(\\d{2})\\-(\\d{2})\\-(\\d{2})(\\d{2})".toRegex(),"$2/$4")
        }
        vgsShow.subscribe(vgsTextView)
        methodChannel.setMethodCallHandler(this)
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {

        when (call.method) {
            "revealVGSText" -> revealVGSText(call, result)
            "copyVGSText" -> copyVGSText(call, result)
            "getPlatformVersion" -> result.success("Android ${android.os.Build.VERSION.RELEASE}")
        }
    }
    private fun copyVGSText(call: MethodCall, result: MethodChannel.Result)  {
        try {
            vgsTextView.copyToClipboard(VGSTextView.CopyTextFormat.RAW)
            result.success(true)
        }
        catch(e:Exception) {
            throw e
        }
    }
    private fun revealVGSText(call: MethodCall, result: MethodChannel.Result) {
        var id: String? = call.argument<String>("id")
        var token: String? = call.argument<String>("token")
        var path: String? = call.argument<String>("path")
        if (path !== null) {
            vgsShow.requestAsync(
                    VGSRequest.Builder(path, VGSHttpMethod.POST)
                            .body(mapOf(id.toString() to token.toString()))
                            .build()
            )
            result.success(null)
        }
    }
}