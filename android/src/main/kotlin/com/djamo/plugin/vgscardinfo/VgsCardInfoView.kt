package com.djamo.plugin.vgscardinfo

import android.content.Context
import android.util.Log
import android.view.LayoutInflater
import android.view.View
import android.widget.Button
import io.flutter.plugin.platform.PlatformView
import com.verygoodsecurity.vgsshow.VGSShow
import com.verygoodsecurity.vgsshow.core.VGSEnvironment
import com.verygoodsecurity.vgsshow.core.listener.VGSOnResponseListener
import com.verygoodsecurity.vgsshow.core.network.client.VGSHttpMethod
import com.verygoodsecurity.vgsshow.core.network.model.VGSRequest
import com.verygoodsecurity.vgsshow.core.network.model.VGSResponse
import com.verygoodsecurity.vgsshow.widget.VGSTextView

internal class VsCardInfoView(context: Context, id: Int, creationParams: Map<String?, Any?>?) : PlatformView {
    private val rootView: View = LayoutInflater.from(context).inflate(R.layout.vgs_card_info_layout, null)

    // Get Vgs Config
    private val vgsVaultId : String = creationParams!!.get("vgs_vault_id")!!.toString()
    private val vgsPath : String = creationParams!!.get("vgs_path")!!.toString()
    private val panToken : String = creationParams!!.get("pan_token")!!.toString()
    private val nameToken : String = creationParams!!.get("name_token")!!.toString()
    private val cvvToken : String = creationParams!!.get("cvv_token")!!.toString()
    private val expiryDateToken : String = creationParams!!.get("expiry_date_token")!!.toString()
    private val env : String = creationParams!!.get("environment")!!.toString()

    private val vgsShow : VGSShow = VGSShow.Builder(context, vgsVaultId)
            .setEnvironment(
                    if(env == "live") VGSEnvironment.Live()
                    else
                    VGSEnvironment.Sandbox()
            )
            .build()

    // Get Widgets
    private val panField = rootView.findViewById<VGSTextView>(R.id.PanField)
    private val nameField = rootView.findViewById<VGSTextView>(R.id.NameField)
    private val cvvField = rootView.findViewById<VGSTextView>(R.id.CVVField)
    private val expiryDateField = rootView.findViewById<VGSTextView>(R.id.ExpiryDateField)
    private val copyPanButton= rootView.findViewById<Button>(R.id.CopyPanButton);


    override fun getView(): View {
        return rootView
    }

    override fun dispose() {
        vgsShow.onDestroy()
    }

    init {

        // Make request
        vgsShow.requestAsync(
                VGSRequest.Builder(vgsPath, VGSHttpMethod.POST)
                        .body(mapOf(
                                "pan" to panToken,
                                "name" to nameToken,
                                "expireDate" to expiryDateToken,
                                "cvv" to cvvToken
                        ))
                        .build()
        )

        // Data formatting
        panField.addTransformationRegex("(\\d{4})(\\d{4})(\\d{4})(\\d{4})".toRegex(), "$1 $2 $3 $4")

        // Subscribe view
        vgsShow.subscribe(panField)
        vgsShow.subscribe(nameField)
        vgsShow.subscribe(cvvField)
        vgsShow.subscribe(expiryDateField)

        // Handle response
        vgsShow.addOnResponseListener(object : VGSOnResponseListener {
            override fun onResponse(response: VGSResponse) {
                Log.d("addOnResponseListener" , response.toString())
            }
        })

        copyPanButton.setOnClickListener{
            panField.copyToClipboard(VGSTextView.CopyTextFormat.RAW)
        }

        panField?.addOnCopyTextListener(object : VGSTextView.OnTextCopyListener {
            override fun onTextCopied(view: VGSTextView, format: VGSTextView.CopyTextFormat) {
                copyPanButton.text = "Copié"
            }
        })

    }
}