import Flutter
import UIKit

public class SwiftVgscardinfoPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let vgsCardInfoChannel = FlutterMethodChannel(name: "vgscardinfo", binaryMessenger: registrar.messenger())
    
    let vgsTextViewChannel = FlutterMethodChannel(name: "vgstextview", binaryMessenger: registrar.messenger())
    
    let instance = SwiftVgscardinfoPlugin()
    
    registrar.addMethodCallDelegate(instance, channel: vgsCardInfoChannel)
    registrar.addMethodCallDelegate(instance, channel: vgsTextViewChannel)

    let vgsCardInfoFactory = VgsCardInfoViewFactory(messenger: registrar.messenger())
    registrar.register(vgsCardInfoFactory, withId: "vgscardinfo")

    let vgsTextViewfactory = VgsTextViewFactory(messenger: registrar.messenger())
    registrar.register(vgsTextViewfactory, withId: "vgstextview")
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    result("iOS " + UIDevice.current.systemVersion)
  }
}
