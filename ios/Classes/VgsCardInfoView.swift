//
//  FLNativeView.swift
//  Runner
//
//  Created by Nehemie Koffi on 05/11/2021.
//

import Foundation
import Flutter
import UIKit
import VGSShowSDK

let vgsCardviewBundleId = "org.cocoapods.vgscardinfo"

class VgsCardInfoView: NSObject, FlutterPlatformView {
    
    private var _view: UIView
    let argData : Dictionary<String, Any>
    let vgsShow : VGSShow
    private var _panLabel : VGSLabel
    let copyPanButton = UIButton()
    
    init(
        frame: CGRect,
        viewIdentifier viewId: Int64,
        arguments args: Any?,
        binaryMessenger messenger: FlutterBinaryMessenger?
    ) {
        // Get Args
        let _argData = args as? Dictionary<String, Any>
        self.argData = _argData!

        // Get VaultId
        let vgsVaultId = self.argData["vgs_vault_id"] as? String
       
        // Get Environment
        let env = self.argData["environment"] as? String
        
        // VGSShow instance.
        self.vgsShow = VGSShow(id: vgsVaultId!, environment: env == "live" ? .live : .sandbox)
        
        // Build View
        _view = UIView()
        _panLabel = VGSLabel()

        super.init()
        
        // iOS views can be created here
        createNativeView(view: _view)
    }

    func view() -> UIView {
        return _view
    }
    
    func createNativeView(view _view: UIView){
                
        UILabel.appearance(whenContainedInInstancesOf: [UIView.self]).textColor = .black
        UILabel.appearance(whenContainedInInstancesOf: [UIView.self]).font = UIFont.FuturaPT(.light, size: 15)

        // UI Text Widgets
        let nameText = UILabel()
        nameText.text = "Titulaire de la carte"
        nameText.textColor = AppColors.greyColor
        
        let panText = UILabel()
        panText.text = "Numéro de carte"
        panText.textColor = AppColors.greyColor
        
        copyPanButton.frame = CGRect(x: 15, y: 50, width: 300, height: 500)
        copyPanButton.setTitle("Copier", for: .normal)
        copyPanButton.titleLabel?.font = UIFont.FuturaPT(.medium, size: 15)
        copyPanButton.backgroundColor = UIColor.clear
        copyPanButton.semanticContentAttribute = .forceLeftToRight
        copyPanButton.setTitleColor(AppColors.blueColor, for: .normal)
        copyPanButton.setImage(UIImage(named: "IconCopy", in:Bundle.init(identifier: vgsCardviewBundleId), compatibleWith: nil), for: .normal)
        copyPanButton.addTarget(self, action: #selector(copyPan), for: .touchUpInside)

        let cvvText = UILabel()
        cvvText.text = "CVV"
        cvvText.textColor = AppColors.greyColor
        
        let expiryDateText = UILabel()
        expiryDateText.text = "Date d’expiration"
        expiryDateText.textColor = AppColors.greyColor
        
        _panLabel.contentPath = "pan"
        _panLabel.font = UIFont.FuturaPT(.medium, size: 18)
        _panLabel.widthAnchor.constraint(equalToConstant: 200).isActive = true
        
        do {
            let regex = try NSRegularExpression(pattern: "(\\d{4})(\\d{4})(\\d{4})(\\d{4})", options: [])
            _panLabel.addTransformationRegex(regex, template:  "$1 $2 $3 $4")
        } catch {
            assertionFailure("invalid regex, error: \(error)")
        }
                
        let nameLabel = VGSLabel()
        nameLabel.contentPath = "name"
        nameLabel.font = UIFont.FuturaPT(.medium, size: 18)
        
        let expireDateLabel = VGSLabel()
        expireDateLabel.contentPath = "expireDate"
        expireDateLabel.font = UIFont.FuturaPT(.medium, size: 18)
        
        let cvvLabel = VGSLabel()
        cvvLabel.contentPath = "cvv"
        cvvLabel.font = UIFont.FuturaPT(.medium, size: 18)

        (nameLabel.placeholder, _panLabel.placeholder, expireDateLabel.placeholder, cvvLabel.placeholder) = ("...", "...", "...", "...")
        (nameLabel.borderWidth, _panLabel.borderWidth, expireDateLabel.borderWidth, cvvLabel.borderWidth) = (0, 0, 0, 0)
        
        // Create payload
        let panToken = self.argData["pan_token"] as? String
        let nameToken = self.argData["name_token"] as? String
        let cvvToken = self.argData["cvv_token"] as? String
        let expireDateToken = self.argData["expiry_date_token"] as? String
        
        let payload = [
            "pan" : panToken,
            "name" : nameToken,
            "cvv" : cvvToken,
            "expireDate" : expireDateToken
        ]
        
        // Subscribe
        vgsShow.subscribe(_panLabel)
        vgsShow.subscribe(nameLabel)
        vgsShow.subscribe(expireDateLabel)
        vgsShow.subscribe(cvvLabel)

        // UI Arrange
        let nameStackView = UIStackView(arrangedSubviews: [nameText, nameLabel])
        nameStackView.spacing = 5
        nameStackView.axis = .vertical
        
        let panStackView = UIStackView(arrangedSubviews: [panText, _panLabel])
        nameStackView.spacing = 5
        panStackView.axis = .vertical
        
        let expiryDateStackView = UIStackView(arrangedSubviews: [expiryDateText, expireDateLabel])
        nameStackView.spacing = 5
        expiryDateStackView.axis = .vertical
        
        let cvvStackView = UIStackView(arrangedSubviews: [cvvText, cvvLabel])
        nameStackView.spacing = 5
        cvvStackView.axis = .vertical
        
        let rowPanAndCopyButton = UIStackView(arrangedSubviews: [panStackView, self.copyPanButton])
        rowPanAndCopyButton.axis = .horizontal
        rowPanAndCopyButton.spacing = 12
        rowPanAndCopyButton.distribution = .fillProportionally
        
        let rowExpiryDateAndCVV = UIStackView(arrangedSubviews: [expiryDateStackView, cvvStackView])
        rowExpiryDateAndCVV.axis = .horizontal
        rowExpiryDateAndCVV.spacing = 12
        rowExpiryDateAndCVV.distribution = .fillEqually

        let stackView = UIStackView.init(arrangedSubviews: [nameStackView, rowPanAndCopyButton, rowExpiryDateAndCVV])
                stackView.axis = .vertical
                stackView.spacing = 12
                stackView.distribution = .fillEqually
                stackView.translatesAutoresizingMaskIntoConstraints = false

        // Send Request
        self.revealData(payload: payload as Dictionary<String, Any>)
        _view.addSubview(stackView)
    }
    
    @objc func copyPan(){
        _panLabel.copyTextToClipboard(format: .raw)
        copyPanButton.setTitle("Copié", for: .normal)
    }
    
    func revealData(payload : Dictionary<String, Any>) {
        let vgsPath = self.argData["vgs_path"] as? String
        vgsShow.request(path: vgsPath!, method: .post, payload: payload) {
            (requestResult) in
            // Update your UI with corresponing result.
            switch requestResult {
            case .success(let code):
                // Update UI for success state.
                print("vgsshow success, code: \(code)")
            case .failure(let code, _):
                // Update UI for failed state.
                print("vgsshow failed, code: \(code)")
            }
        }
    }
}


