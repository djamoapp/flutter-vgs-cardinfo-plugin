//
//  VgsTextViewFactory.swift
//  vgscardinfo
//
//  Created by Nehemie Koffi on 12/11/2021.
//

import Foundation
import Flutter
import UIKit

class VgsTextViewFactory: NSObject, FlutterPlatformViewFactory {
    private var messenger: FlutterBinaryMessenger

    init(messenger: FlutterBinaryMessenger) {
        self.messenger = messenger
        super.init()
    }

    func create(
        withFrame frame: CGRect,
        viewIdentifier viewId: Int64,
        arguments args: Any?
    ) -> FlutterPlatformView {
        return VgsTextView(
            frame: frame,
            binaryMessenger: messenger,
            viewIdentifier: viewId,
            arguments: args as Any
            )
    }
    public func createArgsCodec() -> FlutterMessageCodec & NSObjectProtocol {
            return FlutterStandardMessageCodec.sharedInstance()
        }
}
