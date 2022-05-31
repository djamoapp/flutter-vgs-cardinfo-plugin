package com.djamo.plugin.vgscardinfo

import android.content.Context
import android.graphics.Typeface
import android.util.Log
import android.view.LayoutInflater
import android.view.View
import android.widget.Button
import android.widget.TextView
import androidx.core.content.res.ResourcesCompat
import com.verygoodsecurity.vgsshow.VGSShow
import com.verygoodsecurity.vgsshow.core.VGSEnvironment
import com.verygoodsecurity.vgsshow.core.listener.VGSOnResponseListener
import com.verygoodsecurity.vgsshow.core.network.client.VGSHttpMethod
import com.verygoodsecurity.vgsshow.core.network.model.VGSRequest
import com.verygoodsecurity.vgsshow.core.network.model.VGSResponse
import com.verygoodsecurity.vgsshow.widget.VGSTextView
import io.flutter.plugin.platform.PlatformView


internal class VsCardInfoView(context: Context?, id: Int, creationParams: Map<String?, Any?>?) : PlatformView {

    private val rootView: View = LayoutInflater.from(context).inflate(R.layout.vgs_card_info_layout, null)

    // Get Params
    private val vgsVaultId : String = creationParams!!.get("vgs_vault_id")!!.toString()
    private val vgsPath : String = creationParams!!.get("vgs_path")!!.toString()
    private val panToken : String = creationParams!!.get("pan_token")!!.toString()
    // private val nameToken : String = creationParams!!.get("name_token")!!.toString()
    private val cvvToken : String = creationParams!!.get("cvv_token")!!.toString()
    private val expiryDateToken : String = creationParams!!.get("expiry_date_token")!!.toString()
    private val env : String = creationParams!!.get("environment")!!.toString()

    // Get Vgs init
    private val vgsShow : VGSShow = VGSShow.Builder(context!!, vgsVaultId)
            .setEnvironment(
                    if(env == "live") VGSEnvironment.Live()
                    else
                    VGSEnvironment.Sandbox()
            )
            .build()

    // Get V
    private val panField = rootView.findViewById<VGSTextView>(R.id.PanField)
    // private val nameField = rootView.findViewById<VGSTextView>(R.id.NameField)
    private val cvvField = rootView.findViewById<VGSTextView>(R.id.CVVField)
    private val expiryDateField = rootView.findViewById<VGSTextView>(R.id.ExpiryDateField)
    private val copyPanButton= rootView.findViewById<Button>(R.id.CopyPanButton);

    // Get TextViews
    // private  val nameTextView = rootView.findViewById<TextView>(R.id.NameTextView)
    private  val panTextView = rootView.findViewById<TextView>(R.id.PanTextView)
    private  val expiryDateTextView = rootView.findViewById<TextView>(R.id.ExpiryDateTextView)
    private  val cvvTextView = rootView.findViewById<TextView>(R.id.CVVTextView)

    // Get TypeFaces
    private val futuraPTBook: Typeface = ResourcesCompat.getFont(context!!, R.font.futura_pt_book)!!;
    private val futuraPTMedium: Typeface = ResourcesCompat.getFont(context!!, R.font.futura_pt_medium)!!;

    override fun getView(): View {
        return rootView
    }

    override fun dispose() {
        vgsShow.onDestroy()
    }

    init {

        // Set TypeFace to VgsTextViews
        // nameTextView.typeface =  futuraPTBook
        panTextView.typeface = futuraPTBook
        expiryDateTextView.typeface = futuraPTBook
        cvvTextView.typeface = futuraPTBook
        copyPanButton.typeface = futuraPTBook

        // Set TypeFace to TextViews
        // nameField.setTypeface(futuraPTMedium)
        panField.setTypeface(futuraPTMedium)
        expiryDateField.setTypeface(futuraPTMedium)
        cvvField.setTypeface(futuraPTMedium)

        // Make VGS Show request
        vgsShow.requestAsync(
                VGSRequest.Builder(vgsPath, VGSHttpMethod.POST)
                        .body(mapOf(
                                "pan" to panToken,
                                // "name" to nameToken,
                                "expireDate" to expiryDateToken,
                                "cvv" to cvvToken
                        ))
                        .build()
        )

        // Data formatting
        panField.addTransformationRegex("(\\d{4})(\\d{4})(\\d{4})(\\d{4})".toRegex(), "$1 $2 $3 $4")
        expiryDateField.addTransformationRegex("(\\bJAN\\b)".toRegex(),"01")
        expiryDateField.addTransformationRegex("(\\bFEB\\b)".toRegex(),"02")
        expiryDateField.addTransformationRegex("(\\bMAR\\b)".toRegex(),"03")
        expiryDateField.addTransformationRegex("(\\bAPR\\b)".toRegex(),"04")
        expiryDateField.addTransformationRegex("(\\bMAY\\b)".toRegex(),"05")
        expiryDateField.addTransformationRegex("(\\bJUN\\b)".toRegex(),"06")
        expiryDateField.addTransformationRegex("(\\bJUL\\b)".toRegex(),"07")
        expiryDateField.addTransformationRegex("(\\bAUG\\b)".toRegex(),"08")
        expiryDateField.addTransformationRegex("(\\bSEP\\b)".toRegex(),"09")
        expiryDateField.addTransformationRegex("(\\bOCT\\b)".toRegex(),"10")
        expiryDateField.addTransformationRegex("(\\bNOV\\b)".toRegex(),"11")
        expiryDateField.addTransformationRegex("(\\bDEC\\b)".toRegex(),"12")
        expiryDateField.addTransformationRegex("(\\d{2})\\-(\\d{2})\\-(\\d{2})(\\d{2})".toRegex(),"$2/$4")

        // Subscribe view
        vgsShow.subscribe(panField)
        // vgsShow.subscribe(nameField)
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